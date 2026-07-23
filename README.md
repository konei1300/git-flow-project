# Greeting API

Service HTTP minimal développé pour mettre en pratique un workflow Git Flow complet.

## Fonctionnalités

- réponse JSON sur le point d’entrée principal ;
- message personnalisé avec le paramètre `name` ;
- réponse HTTP 404 pour les routes inconnues ;
- exécution locale ou dans un conteneur ;
- conteneur exécuté avec un utilisateur non-root ;
- contrôle de santé intégré à l’image.

## Prérequis

L’application peut être exécutée avec :

- Python 3.10 ou une version ultérieure ;
- ou Docker.

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

## Exécution avec Docker

Construire l’image :

```bash
docker build --tag greeting-api:1.0.0 .
```

Démarrer le conteneur :

```bash
docker run --rm --name greeting-api --publish 8000:8000 greeting-api:1.0.0
```

## Structure du projet

```text
.
├── .dockerignore
├── .gitignore
├── Dockerfile
├── README.md
├── VERSION
└── app.py
```

## Version

Version actuelle : `1.0.0`

## Auteur

KONE Ibrahim
