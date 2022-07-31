FROM alpine:3.15.5 as settings

RUN mkdir -p "/opt"
WORKDIR "/opt"

FROM settings as download

# To correctly get target platform for both build and buildx
# See: https://github.com/docker/buildx/issues/510
ARG TARGETPLATFORM
ENV TARGETPLATFORM=${TARGETPLATFORM:-linux/amd64}
# Define mavp2p version
ARG MAVP2P_TAG

RUN apk add --no-cache curl

# Download proper binnaries for the current target platform:
COPY download.sh /tmp/download.sh
RUN chmod +x /tmp/download.sh && \
    /tmp/download.sh && rm -f /tmp/download.sh

RUN echo "platform=${TARGETPLATFORM}, tag=${MAVP2P_TAG}" > /tmp/build-info

FROM settings as final

COPY --from=download /opt/mavp2p /opt/mavp2p

ENTRYPOINT [ "/opt/mavp2p" ]
