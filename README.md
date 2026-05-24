# Лабораторная работа №5: Деплой приложения в Kubernetes

## Описание проекта
Данная лабораторная работа демонстрирует процесс контейнеризации и деплоя микросервисного приложения (Telegram-бот с бэкендом) в кластер Kubernetes. Реализованы манифесты для развёртывания компонентов приложения (`Deployment`, `Service`, `ConfigMap`) и инфраструктуры базы данных (`StatefulSet`, `PersistentVolumeClaim`). Управление конфигурациями осуществляется через Kustomize и Helm.

## Структура проекта

├── app/ # Исходный код приложения
│ ├── src/
│ └── tests/
├── k8s/ # Манифесты Kubernetes
│ ├── kustomization/ # Конфигурация через Kustomize
│ │ ├── base/
│ │ └── overlays/
│ │ ├── dev/
│ │ └── prod/
│ └── helm/ # Конфигурация через Helm
│ └── telegram-bot/
│ ├── Chart.yaml
│ ├── values.yaml
│ └── templates/
├── docker-compose.yml # Локальный запуск для разработки
├── Dockerfile # Образ приложения
├── .gitignore
└── README.md

## Быстрый старт

### 1. Сборка образа приложения
```bash
docker build -t telegram-bot:latest .
```
## Развёртывание через Kustomize
### Применение конфигурации для окружения dev
```bash
kubectl apply -k k8s/kustomization/overlays/dev
```
### Проверка статуса подов
```bash
kubectl get pods -l app=telegram-bot
```

## Развёртывание через Helm
### Установка релиза
```bash
helm upgrade --install telegram-bot ./k8s/helm/telegram-bot \
  --namespace default \
  -f ./k8s/helm/telegram-bot/values-dev.yaml \
  --set bot.token="YOUR_BOT_TOKEN"
```
### Проверка релиза
```bash
helm list
```

## Проверка ресурсов
### Все ресурсы приложения
```bash
kubectl get all -l app=telegram-bot
```
# Логи пода
```bash
kubectl logs -l app=telegram-bot --tail=50
```
# Описание сервиса
```bash
kubectl describe svc telegram-bot
```

## Взаимодействие с API
```bash
curl http://localhost:<PORT>/health
curl http://localhost:<PORT>/api/stats
```

## Обновление конфигурации
### Kustomize:
```bash
kubectl apply -k k8s/kustomization/overlays/dev
```
### Helm:
```bash
helm upgrade telegram-bot ./k8s/helm/telegram-bot \
  -f ./k8s/helm/telegram-bot/values-dev.yaml \
  --set bot.token="NEW_TOKEN"
```
## Откат изменений (Helm)
```bash
helm history telegram-bot
helm rollback telegram-bot 1
```

## Очистка ресурсов
### Kustomize:
```bash
kubectl delete -k k8s/kustomization/overlays/dev
```
### Helm:
```bash
helm uninstall telegram-bot
```