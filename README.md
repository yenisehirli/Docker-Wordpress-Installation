<div align="center">
    <img src="https://mariadb.com/wp-content/uploads/2018/10/partners-docker.png" alt="Docker Logo" width="250" style="margin-right: 20px;">
    <img src="https://s.w.org/style/images/about/WordPress-logotype-simplified.png" alt="WordPress Logo" width="150">
</div>

# Docker - Wordpress Installation

### 1. Docker Installation

If Docker is not installed on your system, install Docker with the following steps:

```
sudo apt-get update
sudo apt-get install -y docker.io
```

#### To check if Docker is installed properly:

`docker --version`

### 2. Creating a Docker Network

Create a private Docker network for WordPress and MySQL containers to communicate:

`docker network create wordpress-network
`

### 3. Running MySQL Container

Start a MySQL container using the official Docker image of MySQL:

```
docker run -d \
--name mysql-container \
--network wordpress-network \
-e MYSQL_ROOT_PASSWORD=your_password \
-e MYSQL_DATABASE=your_db \
-e MYSQL_USER=your_user \
-e MYSQL_PASSWORD=your_password \
mysql:5.7
```

### 4. Creating WordPress Image

We will use the Dockerfile to create the WordPress image. First, make sure to place the Dockerfile in the root directory of the project and then run the following command:

`docker build -t my-wordpress-image .
`

### 5. Running WordPress Container

Start the WordPress container by connecting it to the created Docker network:

```
docker run -d \
--name wordpress-container \
--network wordpress-network \
-p 80:80 \
my-wordpress-image
```

### 6. Editing Apache Configuration File

The necessary configurations have already been made in the Dockerfile to configure the Apache settings of the WordPress container. However, make sure that these settings work correctly:

```
<VirtualHost *:80>
    ServerName <your_domain_address>
    DocumentRoot /var/www/html

    <Directory /var/www/html>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

### You can access your site as follows:

`http://<your_ip>:80`
or
`http://<your_domain>`
