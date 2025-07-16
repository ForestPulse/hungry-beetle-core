FROM davidfrantz/base:latest AS builder

# disable interactive frontends
ENV DEBIAN_FRONTEND=noninteractive 

# Environment variables
ENV SOURCE_DIR $HOME/src/hungry-beetle
ENV INSTALL_DIR $HOME/bin

# Copy src to SOURCE_DIR
RUN mkdir -p $SOURCE_DIR
WORKDIR $SOURCE_DIR
COPY --chown=docker:docker . .

# Build, install
RUN echo "building hungry-beetle" && \
  make && \
  make install

FROM ghcr.io/forestpulse/hungry-beetle-core:latest AS final

COPY --chown=docker:docker --from=builder $HOME/bin $HOME/bin

WORKDIR /home/docker

CMD ["disturbance_detection"]
