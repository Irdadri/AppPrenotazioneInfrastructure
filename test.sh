#!/bin/bash

set -e

# ============================================================
# CONFIG
# ============================================================

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SERVICES_DIR="$BASE_DIR/services"

echo ""
echo "=============================================="
echo "       APP PRENOTAZIONE - START"
echo "=============================================="
echo ""

# ============================================================
# CHECK DOCKER
# ============================================================

if ! command -v docker &> /dev/null
then
    echo "❌ Docker non è installato."
    exit 1
fi

if ! docker info > /dev/null 2>&1
then
    echo "❌ Docker non è in esecuzione."
    echo "   Avvia Docker Desktop e riprova."
    exit 1
fi

echo "✅ Docker disponibile"

# ============================================================
# CHECK GIT
# ============================================================

if ! command -v git &> /dev/null
then
    echo "❌ Git non è installato."
    exit 1
fi

echo "✅ Git disponibile"

# ============================================================
# CREATE SERVICES DIRECTORY
# ============================================================

mkdir -p "$SERVICES_DIR"

# ============================================================
# FUNCTION: CLONE / UPDATE
# ============================================================

clone_or_update() {

    REPO="$1"
    DIRECTORY="$2"
    BRANCH="$3"

    TARGET="$SERVICES_DIR/$DIRECTORY"

    echo ""
    echo "----------------------------------------------"
    echo "Repository: $REPO"
    echo "Directory : $DIRECTORY"
    echo "Branch    : $BRANCH"
    echo "----------------------------------------------"

    if [ ! -d "$TARGET/.git" ]; then

        echo "📥 Repository non presente."
        echo "   Clono repository..."

        if [ -n "$BRANCH" ]; then
            git clone \
                --branch "$BRANCH" \
                --single-branch \
                "https://github.com/$REPO.git" \
                "$TARGET"
        else
            git clone \
                "https://github.com/$REPO.git" \
                "$TARGET"
        fi

        echo "✅ Clone completato"

    else

        echo "🔄 Repository già presente."
        echo "   Aggiorno repository..."

        cd "$TARGET"

        git fetch --all --prune

        if [ -n "$BRANCH" ]; then
            git checkout "$BRANCH"
            git pull origin "$BRANCH"
        else
            CURRENT_BRANCH=$(git branch --show-current)
            git pull origin "$CURRENT_BRANCH"
        fi

        cd "$BASE_DIR"

        echo "✅ Repository aggiornato"
    fi
}

# ============================================================
# CLONE / UPDATE REPOSITORIES
# ============================================================

clone_or_update \
    "Irdadri/UserService" \
    "UserService" \
    "revision"

clone_or_update \
    "Irdadri/NotificationService" \
    "NotificationService" \
    ""

clone_or_update \
    "Irdadri/AppPrenotazioneSpringBoot" \
    "AppPrenotazioneSpringBoot" \
    "redis"

clone_or_update \
    "Irdadri/AppPrenotazioneFrontEnd" \
    "AppPrenotazioneFrontEnd" \
    "jwt"

# ============================================================
# CREATE ENV FILE
# ============================================================

if [ ! -f "$BASE_DIR/.env" ]; then

    echo ""
    echo "⚙️  Creo .env..."

    cat > "$BASE_DIR/.env" <<EOF

# ============================================================
# MYSQL
# ============================================================

MYSQL_ROOT_PASSWORD=root

MYSQL_USER=app
MYSQL_PASSWORD=app

MYSQL_PORT=3306

APP_DB_NAME=app_prenotazione

USER_DB_NAME=user_service

NOTIFICATION_DB_NAME=notification_service


# ============================================================
# APPLICATION PORTS
# ============================================================

APP_PORT=8080

USER_SERVICE_PORT=8081

NOTIFICATION_SERVICE_PORT=8082

FRONTEND_PORT=4200


# ============================================================
# KAFKA
# ============================================================

KAFKA_PORT=29092

KAFKA_UI_PORT=8085


# ============================================================
# MAIL
# ============================================================

MAIL_HOST=

MAIL_PORT=587

MAIL_USERNAME=

MAIL_PASSWORD=

EOF

    echo "✅ .env creato"

else

    echo "✅ .env già presente"

fi

# ============================================================
# BUILD + START
# ============================================================

echo ""
echo "=============================================="
echo "       BUILD DOCKER IMAGES"
echo "=============================================="
echo ""

docker compose build --no-cache

echo ""
echo "=============================================="
echo "       START INFRASTRUCTURE"
echo "=============================================="
echo ""

docker compose up -d

echo ""
echo "=============================================="
echo "       APPLICATION STARTED"
echo "=============================================="
echo ""

docker compose ps

echo ""
echo "Frontend:"
echo "   http://localhost:4200"

echo ""
echo "Backend:"
echo "   http://localhost:8080"

echo ""
echo "User Service:"
echo "   http://localhost:8081"

echo ""
echo "Notification Service:"
echo "   http://localhost:8082"

echo ""
echo "Kafka UI:"
echo "   http://localhost:8085"

echo ""
echo "=============================================="
echo "       READY 🚀"
echo "=============================================="
echo ""