# Hello Elixir

Simple test Phoenix app to deploy in a container.


## Prerequisites

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
export GCLOUD_SERVICE_NAME=cloud-run-service-name
```

Start the local agent:
`buildkite-agent start`


## Local development

### Compile steps

#### Set environment

Set the project secret

```bash
mix phx.gen.secret
> REALLY_LONG_SECRET
```
```bash
export SECRET_KEY_BASE=REALLY_LONG_SECRET
```

#### Initial setup

```bash
mix deps.get --only prod
MIX_ENV=prod mix compile
```

#### Compile assets

```bash
npm run deploy --prefix ./assets
mix phx.digest
```

#### Create release

`MIX_ENV=prod mix release`


#### Build image
- `docker build -t elixir-container .`


#### Run the app in the container

`docker run --publish 4000:4000 --env COOL_TEXT='ELIXIR ROCKS!!!!' --env SECRET_KEY_BASE=SECRET_KEY_BASE --env APP_PORT=4000 elixir-container:latest`



## CI/CD Process

- [x] Push to Github
- [x] -> Run tests with BuildKite
- [x] -> Build Docker Image in BuildKite
- [x] -> Push image to Google Cloud Run
- [x] -> Run image deployment from GCR to Cloud Run



### TODO

- [ ] Secure deployment from GCR to Cloud Run rather than an `--allow-unauthenticated`
- [ ] Split this into steps within a bash/make script
- [ ] Get runtime env vars working


### Elixir Dockerfile Reference

[https://akoutmos.com/post/multipart-docker-and-elixir-1.9-releases/](https://akoutmos.com/post/multipart-docker-and-elixir-1.9-releases/)


### License

MIT Licensed. Use all you like at your own risky fun. Go nuts.

Happy coding λ
