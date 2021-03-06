# docker-mysql
Its an effort to dockerize mysql 5.7 on a Ubuntu 14.04 setup.

### Start a MySQL Server Instance
`docker run --name mysql_container -v /var/lib/mysql -e MYSQL_ROOT_PASSWORD=foobar -d ymnoor21/mysql5.7`

`docker run --name mysql_container -e MYSQL_ROOT_PASSWORD=foobar -d ymnoor21/mysql5.7`

### Connect to MySQL from an Application in Another Docker Container
`docker run -p 8080:80 --name app_container --link mysql_container:mysql -d ymnoor21/ap`

### Connect to MySQL from the MySQL Command Line Client
`docker run -it --link mysql_container:mysql --rm ymnoor21/mysql5.7 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD"'`

if it throws error like this: 
"ERROR 1130 (HY000): Host '172.17.0.3' is not allowed to connect to this MySQL server"

Run these mysql commands:

1. `CREATE USER 'root'@'%' IDENTIFIED BY 'foobar';`
2. `GRANT ALL PRIVILEGES ON database.* TO 'root'@'%';`

### Create data only container:
Create a container with 2 volume (one from host - Replace ~ below with user's home directory)

`docker create --name mysql_data -v /var/lib/mysql -v ~/Docker_boxes/mysql-5.7/dump:/dump ymnoor21/mysql5.7`
	
Now create a MySQL Server container using the previous container as volumes-from
	
`docker run -d -it --name mysql_container --volumes-from mysql_data -e MYSQL_ROOT_PASSWORD=foobar ymnoor21/mysql5.7 /bin/bash`
	
(Note: Passing MySQL password is a security risk. Check this article [here](http://datacharmer.blogspot.com/2016/02/a-safer-mysql-box-in-docker.html) on how to mitigate this issue. 
	
