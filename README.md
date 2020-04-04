# Hello Elixir

Simple test Phoenix app to deploy in a container

## Compile steps

### Set environment

Set the project secret

`mix phx.gen.secret`
`REALLY_LONG_SECRET`
`export SECRET_KEY_BASE=REALLY_LONG_SECRET`

### Initial setup

`mix deps.get --only prod`
`MIX_ENV=prod mix compile`

### Compile assets

`npm run deploy --prefix ./assets`
`mix phx.digest`

### Create release

`MIX_ENV=prod mix release`


### Build image
- `docker build -t elixir-container .`


### Run the app in the container

`docker run --publish 4000:4000 --env COOL_TEXT='ELIXIR ROCKS!!!!' --env SECRET_KEY_BASE=$(mix phx.gen.secret) --env APP_PORT=4000 elixir-container:latest`


### TODO

[ ] - Split this into steps within a bash/make script
[ ] - Get runtime env vars working


### Reference

[https://akoutmos.com/post/multipart-docker-and-elixir-1.9-releases/](https://akoutmos.com/post/multipart-docker-and-elixir-1.9-releases/)



#### Buildkite

Trigger a pipeline with BK REST api:
```bash
curl -H "Authorization: Bearer $TOKEN" "https://api.buildkite.com/v2/organizations/moosch/pipelines/elixir-cloud-run/builds" \
  -X "POST" \
  -F "commit=HEAD" \
  -F "branch=master" \
  -F "message=First build :rocket:"
```
