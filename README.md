# Greeting API

Service HTTP minimal développé pour mettre en pratique un workflow Git Flow complet et le déploiement automatisé d’environnements de revue dynamiques.

## Fonctionnalités

- réponse JSON sur le point d’entrée principal ;
- message personnalisé avec le paramètre `name` ;
- normalisation des espaces autour du nom ;
- réponse HTTP 404 pour les routes inconnues ;
- tests unitaires automatisés ;
- exécution locale ou dans un conteneur ;
- conteneur exécuté avec un utilisateur non-root ;
- contrôle de santé intégré à l’image ;
- création d’un environnement de revue isolé pour chaque branche de travail ;
- nettoyage automatique des ressources après la fermeture de l’environnement.

## Prérequis

L’application peut être exécutée avec :

- Python 3.10 ou une version ultérieure ;
- ou Docker avec un moteur actif.

## Exécution locale

```bash
python3 app.py
```

Le service écoute par défaut sur le port `8000`.

Un autre port peut être défini avec la variable `PORT` :

```bash
PORT=8080 python3 app.py
```

## Utilisation de l’API

Message par défaut :

```bash
curl 'http://127.0.0.1:8000/'
```

Réponse :

```json
{"message": "Welcome to the Git Flow project!"}
```

Message personnalisé :

```bash
curl 'http://127.0.0.1:8000/?name=Ibrahim'
```

Réponse :

```json
{"message": "Hello, Ibrahim! Welcome to the Git Flow project."}
```

Les espaces inutiles autour du nom sont automatiquement supprimés.

## Tests

Exécuter les tests unitaires :

```bash
python3 -m unittest discover --start-directory tests --verbose
```

## Exécution avec Docker

Construire l’image :

```bash
docker build --tag greeting-api:1.1.0 .
```

Démarrer le conteneur :

```bash
docker run --rm --name greeting-api --publish 8000:8000 greeting-api:1.1.0
```

## Environnements de revue dynamiques

La chaîne CI/CD crée automatiquement un environnement isolé pour chaque branche de travail.

Le cycle comprend :

1. l’exécution des tests unitaires ;
2. la construction d’une image propre à la branche et au commit ;
3. le déploiement d’un conteneur sur un réseau dédié ;
4. l’exposition du service avec une URL dynamique ;
5. la suppression du conteneur et de son image à la fermeture de l’environnement.

Le routage HTTP est assuré par Traefik. La résolution dynamique des sous-domaines repose sur sslip.io, ce qui permet de tester les environnements sans acheter de nom de domaine.

Le format d’une URL de revue est :

```text
http://<branch-slug>.<base-domain>:<port>/
```

## Structure principale du projet

```text
.
├── .dockerignore
├── .gitignore
├── Dockerfile
├── README.md
├── VERSION
├── app.py
├── scripts
│   ├── deploy-review.sh
│   └── stop-review.sh
└── tests
    └── test_app.py
```

## Version

Version actuelle : `1.1.0`

## Auteur

KONE Ibrahim
