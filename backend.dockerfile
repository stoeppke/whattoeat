FROM rust
RUN apt-get update && apt-get dist-upgrade -y \
    && apt-get install libssl-dev -y \
    && git clone https://github.com/kmein/menstruation-server.rs \
    && rustup default nightly
WORKDIR /menstruation-server.rs
RUN cargo build --release
# RUN sed -ie "s;49080;443;g" Rocket.toml
RUN sed -ie "s;49080;80;g" Rocket.toml
EXPOSE 80
CMD [ "./target/release/menstruation-server" ]