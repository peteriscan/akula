# builder
FROM rust:1.62-bullseye AS builder
RUN apt-get update -qq && apt-get install -y clang cmake pkg-config libext2fs-dev
WORKDIR /build
COPY . .
RUN cargo build --all --profile=production

# final image
FROM debian:bullseye-slim

COPY --from=builder \
  /build/target/production/akula \
  /build/target/production/akula-rpc \
  /build/target/production/akula-sentry \
  /build/target/production/akula-toolbox \
  /usr/local/bin/

RUN useradd --create-home akula
USER akula
RUN mkdir -p ~/.local/share/akula

CMD akula

EXPOSE 30303 30303/udp 8545 7545 8000
