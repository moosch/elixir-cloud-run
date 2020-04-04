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



#### Google Cloud

You will need the following:

**Google Cloud account**
**Billing setup on Google Cloud account**
**Enable Cloud Run API**
**Enable Google Container Registry (GCR) API**


#### Buildkite

In this example our Agent will be running on our local machine (super low cost).
To do this, set up a [local agent](https://buildkite.com/docs/agent/v3/installation) with Buildkite

Agent requirements:

**Bash**
**Docker**
**gcloud CLI**

Firstly [login](https://cloud.google.com/sdk/gcloud/reference/auth/login) to your Google Cloud account with the gcloud CLI
`gcloud auth login`

First configure docker to use the gcloud command-line tool as a credential helper (only need to run once)
`gcloud auth configure-docker`

Set any Agent environment variables required for build (Mac OS)
`vim /usr/local/etc/buildkite-agent/hooks/environment`
Add env vars
```
export DOCKER_LOGIN_PASSWORD=supersecretpassword
export GCLOUD_PROJECT_ID=project-id
```

Start the local agent:
`buildkite-agent start`



#### Local Docker Dev

Build image version
`docker build -t moosch/elixir-phx-container:1.0 .`

Deploy image version
`docker push moosch/elixir-phx-container:1.0`

Pull version
`docker pull moosch/elixir-phx-container:1.0`
