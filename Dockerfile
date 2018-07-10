FROM alpine:edge as stage1

RUN tar -cpf /installed_files.tar $(apk manifest $(apk info) | awk -F "  " '{print $2;}') \
 && tar -xpf /installed_files.tar -C /rootfs/
 
FROM scratch

COPY --from=stage1 /rootfs /

RUN /bin/mkdir /tillf \
 && /usr/bin/find /* > /tillf/test
