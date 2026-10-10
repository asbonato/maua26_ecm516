docker run --name mysql-terrarios \
 -e MYSQL_ROOT_PASSWORD=root-dev-2026 \
 -e MYSQL_DATABASE=terrarios \
 -e MYSQL_USER=terrario_app \
 -e MYSQL_PASSWORD=terrario-dev-2026 \
 -v "$(pwd)/docker/mysql/init:/docker-entrypoint-initdb.d:ro" \
 -p 3307:3306 \
 -d mysql:8.4