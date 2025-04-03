# dbt with Snowflake on Docker

This is a quick guide on how to setup dbt with Snowflake on Docker.

**Note:** We are going to use username and password authentication method

- Create a directory with the name of your choosing.
  ```
  mkdir <dir-name>
  ```
- cd into the directory
  ```
  cd <dir-name>
  ```
- Copy this [Dockerfile](Dockerfile) in your directory borrowed from the official dbt git [here](https://github.com/dbt-labs/dbt-core/blob/main/docker/Dockerfile)
- Create `docker-compose.yaml` [file](docker-compose.yaml).
  ```yaml
  version: '3'
  services:
    dbt-bq-dtc:
      build:
        context: .
        target: dbt-snowflake
      image: dbt/snowflake
      volumes:
        - .:/usr/app
        - ~/.dbt/:/root/.dbt/
        - ~/.aws:/.aws
      network_mode: host
  ```
  -   Name the service as you deem right or `dbt-snowflake-dtc`.
  -   Use the `Dockerfile` in the current directory to build the image by passing `.` in the context.
  -   `target` specifies that we want to install the `dbt-snowflake` plugin in addition to `dbt-core`.
  -  Mount 3 volumes -
     - for persisting dbt data
     - path to the dbt `profiles.yml`
     - path to the `./aws` folder which should be in the `~/.aws/credentials/` path

- Create `profiles.yml` file in `~/.dbt/` in your local machine or add the following code in your existing `profiles.yml` - 
  ```yaml
  dbt_snowflake_workshop:
  outputs:
    dev:
      account: [YOUR-ACCOUNT-NAME]
      database: ECOMMERCE
      password: [YOUR-PASSWORD]
      role: [YOUR-ROLE-NAME]
      schema: PUBLIC
      threads: 1
      type: snowflake
      user: [YOUR-SNOWFLAKE-USER-NAME]
      warehouse: [YOUR-USERNAME]
  target: dev

  ```
  - Name the profile. `dbt_snowflake_workshop` in my case. This will be used in the `dbt_project.yml` file to refer and initiate dbt.
  - Replace with your values

- Run the following commands -
  - ```bash 
    docker compose build 
    ```
  - ```bash 
    docker compose run dbt-snowflake-dtc init
    ``` 
    - **Note:** We are essentially running `dbt init` above because the `ENTRYPOINT` in the [Dockerfile](Dockerfile) is `['dbt']`.
    - Input the required values. Project name will be `ecommerce`
    - This should create `dbt/ecommerce/` and you should see `dbt_project.yml` in there.
    - In `dbt_project.yml`, replace `profile: 'ecommerce'` with `profile: 'dbt_snowflake_workshop'` as we have a profile with the later name in our `profiles.yml`
  - ```bash
    docker compose run --workdir="//usr/app/dbt/ecommerce" dbt-snowflake-dtc debug
     ``` 
    - to test your connection. This should output `All checks passed!` in the end.
    - Also, we change the working directory to the dbt project because the `dbt_project.yml` file should be in the current directory. Else it will throw `1 check failed: Could not load dbt_project.yml`