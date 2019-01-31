FROM rust
RUN apt-get update && apt-get dist-upgrade -y \
    && apt-get install libssl-dev -y \
    && git clone https://github.com/kmein/menstruation-server.rs \
    && rustup default nightly
WORKDIR /menstruation-server.rs
RUN cargo build --release
CMD [ "./target/release/menstruation-server" ]