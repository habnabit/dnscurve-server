FROM alpine
RUN apk --no-cache add build-base bash libev-dev libsodium-dev

ADD src /src
WORKDIR /src
RUN ./configure.nacl
RUN ./configure.curvedns
RUN make

FROM alpine
RUN apk --no-cache add runit tinydns libev jq

RUN mkdir -p /package/curvedns/bin /service
COPY --from=0 /src/curvedns /src/curvedns-keygen /package/curvedns/bin/

ADD launch.sh /
ADD curvedns-service /service/curvedns
ADD tinydns-service /service/tinydns
ADD vault-fetch-service /service/vault-fetch
RUN cd /service/tinydns/root && tinydns-data
STOPSIGNAL SIGHUP
ENTRYPOINT ["/launch.sh"]
EXPOSE 5300/udp
EXPOSE 5300/tcp
