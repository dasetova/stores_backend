FROM elixir:latest

RUN apt-get update && \
  apt-get install -y postgresql-client

RUN mkdir /app

WORKDIR /app

ENV MIX_ENV prod
EXPOSE 4000

RUN mix local.hex --force
RUN mix local.rebar --force 
COPY mix.* ./

RUN mix deps.get --only prod
RUN mix deps.compile
COPY . .

RUN mix compile

ENTRYPOINT ["/app/entrypoint.sh"]
CMD mix phx.server