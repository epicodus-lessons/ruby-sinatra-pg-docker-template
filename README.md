## Description

This repository provides the necessary Docker configuration to use Sinatra and Postgres for Ruby and Rails Week 3 at Epicodus. In addition to running a Sinatra server and being able to use Pry, RSpec, and Capybara, you'll also be able to do the following:

* Run a Postgres server (which your Sinatra server can access)
* Run psql to access and manage databases
* Back up and restore a Postgres database

This is a template repository, which means you should create a new repository using `ruby-sinatra-pg-docker-template` as a template. Once you've done so, clone the repository on your desktop and `cd` into the repository via the command line.

This project also includes most of the basic scaffolding for a Sinatra project, including `app.rb`, `lib` and `spec` directories, and other necessary configuration such as a `Gemfile` and `config.ru` file.

### Running Sinatra and Postgres

**Note:** If you spin up Sinatra and Postgres servers without first creating a database, the Sinatra application will not work properly. That's because `app.rb` includes a connection to a database that doesn't exist yet. We will describe setting up a database in the next section of this README.

To run both Sinatra and Postgres, type the following into the command line (you must be in the root directory of the project):

```
$ docker-compose up --build
```

If you nagivate to `http://localhost:4567/` without setting up a database, though, you'll get a `PG::ConnectionBad` error. Once again, that's because you need to manually set up a database first.

### Using psql

To do any database management, including creating, deleting, and altering databases, you need to use psql, a command line tool. That means you need to interactively connect to the running Postgres container.

You can run the Postgres container on its own with the command:

```
$ docker-compose run db
```

Alternatively, you can use `$ docker-compose up --build` - while the Sinatra container won't work correctly without a database, both the Sinatra and Postgres containers will be running and you will be able to access them.

Once you have a Postgres container running, get the container ID with `$ docker ps`.

Next, you can run psql with the following command:

```
$ docker exec -it -u postgres [CONTAINER_ID] psql
```

At this point, you can create and alter databases as needed. If you want to see the database connection in action with the current Sinatra application, just do the following in psql:

```
CREATE DATABASE record_store;
```

Once you've created the database, you can run the local Sinatra server and see the following string at `http://localhost:4567/`:

```
This is connected to the database record_store.
```

When you're done running the server, you should always type in `docker-compose down` to gracefully stop the container.

### Running Tests and Using Pry

There are no changes to running tests and using Pry for week 3.

To run tests, use the following command:

```
$ docker-compose run --rm web bundle exec rspec
```

Pry will work with this command.

To use Pry while you are navigating through your application using `localhost`, you need to attach to the running Sinatra container. Get the Sinatra container's ID with `$ docker ps` and then do the following:

```
$ docker attach [CONTAINER_ID]
```

Then, when your application hits a `binding.pry`, you will have an interactive terminal in the terminal where you attached to the Sinatra container.

### Backing Up and Restoring a Database

You will need to back up a database for your independent project. You also might want to back up and restore a database for multi-day projects as well. To back up or restore the database, the Postgres server must be running (either with `$ docker-compose up --build` or `$ docker-compose run db`). Use `$ docker ps` to get the container ID. You will likely not use the following commands enough for it to be worth aliasing them.

#### Backing Up a Database

To back up the database in a file called `database_backup.sql` in the root directory of the project, run the following command. Make sure to change `[CONTAINER_ID]` to the appropriate container ID and `[DATABASE_NAME]` to the name of the database you are backing up.

```
docker exec -i [CONTAINER_ID] pg_dump --username postgres [DATABASE_NAME] > database_backup.sql
```

#### Restoring a Database

If you want to restore a database, you'll first need to create a database to dump data into. You can do this by using the `CREATE DATABASE` command in psql. Then, assuming you have a database backup named `database_backup.sql` in the root directory of your project, you can restore it with this command:

```
docker exec -i [CONTAINER_ID] psql --username postgres [DATABASE_NAME] < database_backup.sql
```

Make sure to replace `[CONTAINER_ID ]` with the container ID and the `[DATABASE_NAME]` with the name of the database you want to dump data into. For instance, if you just created a new database called `record_store` and you wanted to dump data into it, `[DATABASE_NAME]` would be replaced with record store.

### `tmp` Directory

Note that the Postgres container will automatically create a `tmp` directory in your project. This is from `docker-compose.yaml`:

```
volumes:
      - ./tmp/db:/var/lib/postgresql/data
```

This will allow you to persist databases on your local machine. However, this `tmp` directory will cause problems if it's pushed to GitHub and then the repo is used again. For that reason, `tmp` is added to `.gitignore`.