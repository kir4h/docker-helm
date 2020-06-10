FROM alpine:3.12 as build
LABEL maintainer="Mario Siegenthaler <mario.siegenthaler@linkyard.ch>"

RUN apk add --update --no-cache ca-certificates git

ENV VERSION=v2.16.8
ENV FILENAME=helm-${VERSION}-linux-amd64.tar.gz
ENV SHA256SUM=67ea2cabc7c9acf1d26c6a72068582f577874cd84295bfaaba93fb40b849c092

WORKDIR /

RUN apk add --update -t deps curl tar gzip
RUN curl -L https://get.helm.sh/${FILENAME} > ${FILENAME} && \
    echo "${SHA256SUM}  ${FILENAME}" > helm_${VERSION}_SHA256SUMS && \
    sha256sum -cs helm_${VERSION}_SHA256SUMS && \
    tar zxv -C /tmp -f ${FILENAME} && \
    rm -f ${FILENAME}


# The image we keep
FROM alpine:3.12

RUN apk add --update --no-cache git ca-certificates

COPY --from=build /tmp/linux-amd64/helm /bin/helm

ENTRYPOINT ["/bin/helm"]
