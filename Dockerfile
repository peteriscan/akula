FROM docker.io/library/rust:1.62-bullseye as build
RUN apt-get update -qq && apt-get install -y clang cmake pkg-config libext2fs-dev
WORKDIR /build
COPY . .
RUN cargo build --all --profile=production

FROM docker.io/library/debian:bullseye
COPY --from=build \
  /build/target/production/akula \
  /build/target/production/akula-rpc \
  /build/target/production/akula-sentry \
  /build/target/production/akula-toolbox \
  /usr/local/bin/

CMD akula
