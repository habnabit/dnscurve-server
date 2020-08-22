FROM alpine
RUN apk --no-cache add build-base bash libev-dev libsodium-dev

ADD src /src
WORKDIR /src
RUN ./configure.nacl
RUN ./configure.curvedns
RUN make

FROM alpine
RUN apk --no-cache add tinydns libev jq cpulimit
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.22.1.0/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzvf /tmp/s6-overlay-amd64.tar.gz -C /

RUN mkdir -p /package/curvedns/bin
COPY --from=0 /src/curvedns /src/curvedns-keygen /package/curvedns/bin/

ADD fix-attrs-vault-fetch /etc/fix-attrs.d/
ADD cont-init-setup-env.sh /etc/cont-init.d/
ADD curvedns-service /etc/services.d/curvedns
ADD tinydns-service /etc/services.d/tinydns
ADD vault-fetch-service /etc/services.d/vault-fetch
RUN mkdir -p /etc/tinydns/root && cd /etc/tinydns/root && touch data && tinydns-data && chown -R tinydns: .
EXPOSE 5300/udp
EXPOSE 5300/tcp
ENTRYPOINT ["/init"]
