Build the docker container:
```
$ git clone git@.../postgres
$ cd postgres
$ docker build -t psql .
```

Run the docker container:
```
$ sudo docker run -e POSTGRES_PASSWORD=abc123 -e POSTGRES_DB=commune -v /<host system data location>:/var/lib/postgresql/data -p 5432:5432 psql
```
Because you're using the `-v` option, you can stop and restart the docker container and the data stays

example:
```
$ sudo docker run -e POSTGRES_PASSWORD=abc123 -e POSTGRES_DB=commune -v /Users/theolincke/Development/events/postgres-ci/data/:/var/lib/postgresql/data -p 5432:5432 psql
```

Access the psql database:
```
$  psql -U postgres -h localhost -p 5432 commune
```

Reset the container:
```
$ rm -rf <host system data location>
```
