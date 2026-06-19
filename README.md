## Setup

If you do not need to recreate the entire environment from a Docker image, focus on the `.py` and `.sql` files, which contain the core database creation logic, schema definitions, and test data generation scripts.

Otherwise, you can deploy the full environment:

```bash
docker build -t postgres-with-data .
docker run -d -p 5432:5432 postgres-with-data

psql -h localhost -p 5432 -U myuser -d mydatabase

cd datalens
docker compose up -d
```

After starting DataLens, create a new database connection and connect it to the PostgreSQL instance.

## Database Validation

Constraints and default values are implemented and validated correctly.

For example, the `youtube_video` table contains the following column:

```sql
duration INT CHECK (duration >= 0) DEFAULT NULL
```

Supported behaviors:

1. The field can be omitted, resulting in a `NULL` value.
2. `NULL` can be explicitly inserted.
3. Numeric values are validated by the `CHECK` constraint (`duration >= 0`).

For example, attempting to insert `-1` will produce an error:

```sql
ERROR: new row for relation "youtube_video"
violates check constraint "youtube_video_duration_check"
```

This demonstrates that both default values and integrity constraints are enforced as expected.
