FROM node:0.12-slim

ENV TINI_VERSION 0.5.0
RUN set -x \
	&& apt-get update && apt-get install -y ca-certificates curl \
		--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/* \
	&& curl -fSL "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini" -o /usr/local/bin/tini \
	&& chmod +x /usr/local/bin/tini \
	&& tini -h \
	&& apt-get purge --auto-remove -y ca-certificates curl

ENV MONGO_EXPRESS 0.27.1

RUN npm install mongo-express@$MONGO_EXPRESS

WORKDIR /node_modules/mongo-express

RUN cp config.default.js config.js

ENV ME_CONFIG_MONGODB_SERVER="mongo"
ENV ME_CONFIG_BASICAUTH_USERNAME=""
ENV ME_CONFIG_BASICAUTH_PASSWORD=""

EXPOSE 8081
CMD ["tini", "--", "node", "app"]
