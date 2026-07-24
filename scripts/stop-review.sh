#!/usr/bin/env bash

set -Eeuo pipefail

if [[ -z "${CI_COMMIT_REF_SLUG:-}" ]]; then
  printf 'Required variable CI_COMMIT_REF_SLUG is not set.\n' >&2
  exit 1
fi

container_name="review-${CI_COMMIT_REF_SLUG}"

if ! docker container inspect "$container_name" >/dev/null 2>&1; then
  printf 'Review environment %s is already stopped.\n' \
    "$CI_COMMIT_REF_SLUG"
  exit 0
fi

app_image="$(
  docker container inspect \
    --format '{{.Config.Image}}' \
    "$container_name"
)"

docker container rm --force "$container_name"

case "$app_image" in
  greeting-api:*)
    docker image rm "$app_image" || true
    ;;
  *)
    printf 'Image %s was preserved because it is not a review image.\n' \
      "$app_image"
    ;;
esac

printf 'Review environment %s has been stopped.\n' \
  "$CI_COMMIT_REF_SLUG"
