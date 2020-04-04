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



#### CI/CD Process

[x] - Push to Github
[ ] - -> Run tests with BuildKite
[x] - -> Build Docker Image in BuildKite
[x] - -> Login to Docker Hub in BuildKite
[x] - -> Push image to Docker Hub
<!-- [ ] - -> Pull image from Docker Hub or use local artifact? -->
[ ] - -> Pull image from Docker Hub or use local artifact?
[ ] - -> Login to Google Cloud Run in BuildKite
[ ] - -> Push image to Google Cloud Run



#### Google Cloud Registry

Create and get key
```
gcloud iam service-accounts create ${KEY_NAME} — display-name ${KEY_DISPLAY_NAME}
gcloud iam service-accounts list
gcloud iam service-accounts keys create — iam-account ${KEY_NAME}@${PROJECT}.iam.gserviceaccount.com key.json
```

This outputs a file `key.json` which is used as input for docker login cmd. This file should be present where push is needed.





<!--  -->
Configure docker to use the gcloud command-line tool as a credential helper (only need to run once)
`gcloud auth configure-docker`

Tag image
`docker tag [PROJECT_NAME] gcr.io/[PROJECT-ID]/[PROJECT_NAME]:tag1`

Push image to GCR
`docker push gcr.io/[PROJECT-ID]/[PROJECT_NAME]:tag1`





Host GCR images on asia.gcr.io

docker tag moosch/elixir-phx-container asia.gcr.io:1.0
gcloud docker — push gcr.io/your-project-id/<project-id>/<sample-image-name>:1.0



#### Docker

Build image version
`docker build -t moosch/elixir-phx-container:1.0 .`

Deploy image version
`docker push moosch/elixir-phx-container:1.0`

Pull version
`docker pull moosch/elixir-phx-container:1.0`


#### Buildkite

Trigger a pipeline with BK REST api:
```bash
curl -H "Authorization: Bearer $TOKEN" "https://api.buildkite.com/v2/organizations/moosch/pipelines/elixir-cloud-run/builds" \
  -X "POST" \
  -F "commit=HEAD" \
  -F "branch=master" \
  -F "message=First build :rocket:"
```



Set any Agent environment variables required for build
`vim /usr/local/etc/buildkite-agent/hooks/environment`

Add `export DOCKER_LOGIN_PASSWORD=supersecretpassword`

Start the local agent:
`buildkite-agent start`
