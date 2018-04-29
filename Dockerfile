FROM alpine:3.7

# Build-only variables
ENV LANG="en_US.UTF-8"

# Constants
ENV CONST_ENVIRONMENT_DIR="/environment"

COPY ./start /start

RUN addgroup -S sudoer \
 && adduser -D -S -H -s /bin/false -u 101 -G sudoer sudoer \
 && chmod go= /bin /sbin /usr/bin /usr/sbin \
 && apk add --no-cache sudo \
 && mkdir -p "$CONST_ENVIRONMENT_DIR" \
 && chmod 7700 "$CONST_ENVIRONMENT_DIR" /start \
 && touch "$CONST_ENVIRONMENT_DIR/runtime_environment" "$CONST_ENVIRONMENT_DIR/restart_environment" \
 && chown :sudoer /usr/bin/sudo \
 && chmod o-rx /usr/bin/sudo \
 && ln /usr/bin/sudo /usr/local/bin/sudo \
 && ln -s /start/stage1 /start/start \
 && echo 'Defaults lecture="never"' > /etc/sudoers.d/docker-const \
 && echo 'Defaults secure_path="/start:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' >> /etc/sudoers.d/docker-const \
 && echo 'Defaults env_keep = "CONST_ VAR_"' > /etc/sudoers.d/docker-var \
 && echo 'Defaults !root_sudo' >> /etc/sudoers.d/docker-var \
 && echo "sudoer ALL=(root) NOPASSWD: /start/stage1" >> /etc/sudoers.d/docker-var \
 && chmod u=r,go= /etc/sudoers.d/docker-const \
 && chmod u=rw,go= /etc/sudoers.d/docker-var

# Variables
ENV VAR_LINUX_USER="root"

USER sudoer

CMD ["sudo","start"]
