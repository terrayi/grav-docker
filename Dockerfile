ARG ALPINE_VERSION=3.18.0

# Build stage
FROM --platform=$BUILDPLATFORM alpine:${ALPINE_VERSION} AS builder
LABEL stage=builder
ARG GIT_REPO

RUN apk update \
	&& apk add --no-cache curl git libarchive-tools \
	&& curl -s -L https://getgrav.org/download/core/grav/latest | bsdtar -xf - \
	&& rm -rf ./grav/user/* \
	&& git clone $GIT_REPO ./grav/user/ \
	&& mkdir -p ./files/home/www/ \
	&& mkdir -p ./files/etc/nginx/http.d \
	&& mkdir -p ./files/etc/php82/php-fpm.d \
	&& mkdir -p ./files/usr/bin \
	&& mv ./grav/* ./files/home/www/
COPY ./etc/nginx/http.d/default.conf ./files/etc/nginx/http.d
COPY ./etc/php82/php-fpm.d/www.conf ./files/etc/php82/php-fpm.d/www.conf
COPY ./entrypoint.sh ./files/usr/bin

# Final image
ARG TARGETPLATFORM
FROM --platform=$TARGETPLATFORM alpine:${ALPINE_VERSION}
COPY --from=builder ./files/ /

RUN mkdir /run/php \
	&& chown -R nobody:nobody \
	  /home/www/assets \
	  /home/www/backup \
	  /home/www/cache \
	  /home/www/images \
	  /home/www/logs \
	  /home/www/tmp \
	  /home/www/user \
	&& apk update \
	&& apk add --no-cache \
	  nginx \
	  php82 \
	  php82-fpm \
	  php82-curl \
	  php82-ctype \
	  php82-dom \
	  php82-gd \
	  php82-mbstring \
	  php82-opcache \
	  php82-openssl \
	  php82-session \
	  php82-simplexml \
	  php82-xml \
	  php82-zip \
	&& chmod +x /usr/bin/entrypoint.sh

EXPOSE 80 443
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
