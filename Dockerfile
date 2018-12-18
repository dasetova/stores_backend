FROM elixir:latest

RUN mkdir /app
COPY . /app
WORKDIR /app

ENV PORT 8080
ENV MIX_ENV dev

RUN mix local.hex --force
RUN mix do compile

EXPOSE 4000

CMD mix ecto.migrate; mix phx.server