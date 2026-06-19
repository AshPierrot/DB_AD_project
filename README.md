# Data Platform Infrastructure

Infrastructure-as-Code project for deploying a complete analytics database environment with Docker, DDL migrations, synthetic test data generation, and BI integration.

### Features

* Database deployment using HCL-based infrastructure definitions
* Dockerized setup for local and reproducible environments
* DDL scripts for building the database from scratch
* Automated generation of realistic test data
* Preconfigured integration with DataLens dashboards
* ETL and database initialization scripts

### Tech Stack

* HCL (Terraform)
* Shell
* Jinja
* Python
* PostgreSQL / PLpgSQL
* Docker

Apply infrastructure, initialize the database, and load test data.

### Data Model

The generated dataset simulates:

* YouTube channels and videos
* Advertisement anchors and click tracking
* Telegram bots and users
* Telegram channels and subscriptions
* User acquisition and conversion funnels

### Test Data

A Python generator creates realistic synthetic data, including thousands of videos, users, subscriptions, views, clicks, and engagement metrics for development and analytics testing.

### Purpose

This project provides a reproducible analytics environment that can be deployed from scratch and immediately connected to DataLens for reporting and BI visualization.
