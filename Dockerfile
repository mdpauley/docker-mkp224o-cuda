FROM nvidia/cuda:11.4.0-base-ubuntu20.04

RUN apt-get update

RUN apt-get install -y git build-essential curl \
 && RUN curl https://sh.rustup.rs -sSf | bash -s -- -y \
 && echo 'source $HOME/.cargo/env' >> $HOME/.bashrc \
 && rustup install nightly \
 && rustup target add nvptx64-nvidia-cuda \
 && cargo install ptx-linker \
 && git clone https://github.com/dr-bonez/tor-v3-vanity \
 && cd tor-v3-vanity \
 && cargo +nightly install --path . \
 && mkdir mykeys

FROM nvidia/cuda:11.4.0-base-ubuntu20.04
COPY --from=builder /t3v /bin/t3v
VOLUME /result
CMD sh -c '[ ! -z "$FILTERS" ] && cd /result && exec t3v $FILTERS'
