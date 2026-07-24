#!/usr/bin/env bash

set -Eeuo pipefail

required_variables=(
  CI_COMMIT_REF_SLUG
  CI_COMMIT_SHORT_SHA
  CI_PROJECT_PATH_SLUG
  CI_ENVIRONMENT_SLUG
  REVIEW_BASE_DOMAIN
  REVIEW_NETWORK
  REVIEW_PORT
)

for variable_name in "${required_variables[@]}"; do
  if [[ -z "${!variable_name:-}" ]]; then
    printf 'Required variable %s is not set.\n' "$variable_name" >&2
    exit 1
  fi
done

app_image="greeting-api:${CI_COMMIT_REF_SLUG}-${CI_COMMIT_SHORT_SHA}"
container_name="review-${CI_COMMIT_REF_SLUG}"
router_name="review-${CI_COMMIT_REF_SLUG}"
review_host="${CI_COMMIT_REF_SLUG}.${REVIEW_BASE_DOMAIN}"
previous_image=""

docker network inspect "$REVIEW_NETWORK" >/dev/null
docker image inspect "$app_image" >/dev/null

if docker container inspect "$container_name" >/dev/null 2>&1; then
  previous_image="$(
    docker container inspect \
      --format '{{.Config.Image}}' \
      "$container_name"
  )"

  docker container rm --force "$container_name"
fi

docker run \
  --detach \
  --name "$container_name" \
  --restart unless-stopped \
  --network "$REVIEW_NETWORK" \
  --label "traefik.enable=true" \
  --label "traefik.http.routers.${router_name}.rule=Host(\`${review_host}\`)" \
  --label "traefik.http.routers.${router_name}.entrypoints=web" \
  --label "traefik.http.services.${router_name}.loadbalancer.server.port=8000" \
  --label "com.gitlab.project=${CI_PROJECT_PATH_SLUG}" \
  --label "com.gitlab.environment=${CI_ENVIRONMENT_SLUG}" \
  "$app_image"

for ((attempt = 1; attempt <= 30; attempt++)); do
  health_status="$(
    docker container inspect \
      --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}{{.State.Status}}{{end}}' \
      "$container_name"
  )"

  case "$health_status" in
    healthy)
      break
      ;;
    unhealthy|exited|dead)
      docker container logs "$container_name"
      exit 1
      ;;
  esac

  if ((attempt == 30)); then
    docker container logs "$container_name"
    printf 'Container did not become healthy in time.\n' >&2
    exit 1
  fi

  sleep 1
done

curl \
  --noproxy '*' \
  --fail \
  --silent \
  --show-error \
  "http://${review_host}:${REVIEW_PORT}/"

printf '\nReview environment available at http://%s:%s/\n' \
  "$review_host" \
  "$REVIEW_PORT"

if [[ -n "$previous_image" && "$previous_image" != "$app_image" ]]; then
  docker image rm "$previous_image" || true
fi
