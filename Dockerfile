# ---- Build Stage ----
FROM elixir:1.9.4-alpine as build

# Set environment variables for building the application
ENV MIX_ENV=prod \
    TEST=1 \
    LANG=C.UTF-8

# Install hex and rebar, and create the application build directory
RUN mix local.hex --force && \
    mix local.rebar --force
RUN mkdir /app

WORKDIR /app

# Copy over all the necessary application files and directories
COPY . .

# Fetch the application dependencies and build the application
RUN mix deps.get
RUN mix deps.compile
RUN mix phx.digest
RUN mix release


# ---- Application Stage ----
FROM alpine:3.9 AS app

ENV LANG=C.UTF-8
RUN apk add --update bash openssl

RUN mkdir /app
WORKDIR /app

COPY --from=build /app/_build/prod/rel/hello_elixir ./
RUN chown -R nobody: /app
USER nobody

ENV HOME=/app

CMD [ "bin/hello_elixir", "start" ]
