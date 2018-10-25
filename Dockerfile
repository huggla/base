ARG BASEIMAGE="huggla/busybox:20181017-edge"
ARG RUNDEPS="sudo dash argon2"
ARG MAKEDIRS="/environment"
ARG MAKEFILES="/etc/sudoers.d/docker1 /etc/sudoers.d/docker2"
ARG REMOVEFILES="/usr/sbin/visudo /usr/bin/sudoreplay /usr/bin/cvtsudoers /usr/bin/sudoedit"
ARG EXECUTABLES="/usr/bin/sudo /usr/bin/dash /usr/bin/argon2"
ARG BUILDCMDS=\
"   echo 'Defaults lecture=\"never\"' > /imagefs/etc/sudoers.d/docker1 "\
"&& echo 'Defaults secure_path=\"/start:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\"' >> /imagefs/etc/sudoers.d/docker1 "\
"&& echo 'Defaults env_keep = \"VAR_*\"' > /imagefs/etc/sudoers.d/docker2 "\
"&& echo 'Defaults !root_sudo' >> /imagefs/etc/sudoers.d/docker2 "\
"&& echo 'starter ALL=(root) NOPASSWD: /start/start' >> /imagefs/etc/sudoers.d/docker2 "\
"&& echo 'root ALL=(ALL) ALL' > /imagefs/etc/sudoers "\
"&& echo '#includedir /etc/sudoers.d' >> /imagefs/etc/sudoers "\
"&& chmod o= /imagefs/etc/sudoers* /imagefs/usr/bin/sudo /imagefs/usr/lib/sudo /imagefs/start /imagefs/stop "\
"&& cd /imagefs/start "\
"&& ln -s stage1 start "\
"&& cd /imagefs/stop "\
"&& ln -s ../start/includeFunctions ./ "\
"&& cd /imagefs/stop/functions "\
"&& ln -s ../../start/functions/readEnvironmentVars ../../start/functions/tryRunStage ./ "\
"&& chmod go= /imagefs/environment "\
"&& chmod u=rx,g= /imagefs/start/stage1 /imagefs/start/stage2 "\
"&& chmod -R g=r /imagefs/stop "\
"&& chmod g=rx /imagefs/stop /imagefs/stop/functions "\
"&& chmod u=rwx,g=rx /imagefs/stop/stage1"

#---------------Don't edit----------------
FROM ${CONTENTIMAGE1:-scratch} as content1
FROM ${CONTENTIMAGE2:-scratch} as content2
FROM ${BASEIMAGE:-huggla/base} as base
FROM huggla/build as build
FROM ${BASEIMAGE:-huggla/base} as image
COPY --from=build /imagefs /
#-----------------------------------------

RUN chmod u+s /usr/local/bin/sudo \
 && chgrp -R 101 /etc/sudoers* /usr/bin/sudo /usr/lib/sudo

ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/start" \
    VAR_LINUX_USER="root" \
    VAR_FINAL_COMMAND="pause" \
    VAR_ARGON2_PARAMS="-r" \
    VAR_SALT_FILE="/proc/sys/kernel/hostname" \
    HISTFILE="/dev/null"

#---------------Don't edit----------------
USER starter
ONBUILD USER root
#-----------------------------------------

CMD ["sudo","start"]
