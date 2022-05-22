# DFK CHAIN DBT Project

Curated SQL Views and Metrics for the dfkchain Blockchain.

What's dfkchain? Learn more [here](https://info.defikingdoms.com/)

## Setup

1. [PREREQUISITE] Download [Docker for Desktop](https://www.docker.com/products/docker-desktop).
2. Create a `.env` file with the following contents (note `.env` will not be commited to source):

```
DB_USERNAME=<your_metrics_dao_snowflake_username>
DB_PASWORD=<your_metrics_dao_snowflake_password>
```

3. New to DBT? It's pretty dope. Read up on it [here](https://www.getdbt.com/docs/)

## Getting Started Commands

Run the follow commands from inside the dfkchain directory (**you must complete the Getting Started steps above^^**)

### DBT Environment

`make dbt-console`
This will mount your local dfkchain directory into a dbt console where dbt is installed.

### DBT Project Docs

`make dbt-docs`
This will compile your dbt documentation and launch a web-server at http://localhost:8080

## Project Overview

`/models` - this directory contains SQL files as Jinja templates. DBT will compile these templates and wrap them into create table statements. This means all you have to do is define SQL select statements, while DBT handles the rest. The snowflake table name will match the name of the sql model file.

`/macros` - these are helper functions defined as Jinja that can be injected into your SQL models.

`/tests` - custom SQL tests that can be attached to tables.

## Background on Data

https://github.com/blockchain-etl/ethereum-etl

## Branching / PRs

When conducting work please branch off of main with a description branch name and generate a pull request. At least one other individual must review the PR before it can be merged into main. Once merged into main DBT Cloud will run the new models and output the results into the `public` schema.

When creating a PR please include the following details in the PR description:

1. List of Tables Created or Modified
2. Description of changes.
3. Implication of changes (if any).

## More DBT Resources:

- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
