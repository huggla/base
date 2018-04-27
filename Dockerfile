FROM alpine:3.7

ENV BIN_DIR="/usr/local/bin" \
    LANG="en_US.UTF-8" \
    SUDOERS_DIR="/etc/sudoers.d"

COPY ./bin ${BIN_DIR}

RUN addgroup -S sudoer \
 && adduser -D -S -H -s /bin/false -u 101 -G sudoer sudoer \
 && chmod go= /bin /sbin /usr/bin /usr/sbin "$BIN_DIR" \
 && chmod u+x "$BIN_DIR/"* \
 && apk add --no-cache sudo \
 && mkdir -p /usr/local/sbin \
 && ln /usr/bin/sudo /usr/local/sbin/sudo \
 && chown root:sudoer /usr/local/sbin \
 && chmod ug=rx,o= /usr/local/sbin \
 && echo 'Defaults lecture="never"' > "$SUDOERS_DIR/docker1" \
 && echo 'Defaults secure_path="/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' >> "$SUDOERS_DIR/docker1" \
 && echo 'Defaults env_keep = "BEV_ REV_"' > "$SUDOERS_DIR/docker2" \
 && echo 'Defaults !root_sudo' >> "$SUDOERS_DIR/docker2" \
 && echo "sudoer ALL=(root) NOPASSWD: $BIN_DIR/start" >> "$SUDOERS_DIR/docker2" \
 && chmod u=rw,go= "$SUDOERS_DIR/docker"*

ENV REV_LINUX_USER="root"

USER sudoer

CMD ["sudo","start"]
