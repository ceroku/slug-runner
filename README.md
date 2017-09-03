
## Run slug.tgz in a Docker container

```
docker run --rm -id \
  -p 9005:5000 \
  -e "PORT=5000" \
  -v #{MAIN_PATH}/#{repo_name}/builds/#{build_id}:/tmp/slugs \
  slugr:dev bash -c "tar -xzf /tmp/slugs/slug.tgz && /start web"
```

## Attaching to the container (heroku exec)

```
docker exec -it [CONTAINER_ID] /exec bash
```

> INPUT: slug.tgz is the output of running the slug-compiler

### TODO:
- 9005 should be a random available port on the host
- More environment variables (from database)
