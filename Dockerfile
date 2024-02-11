FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/rwv/lookscanned.io.git && \
    cd lookscanned.io && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node:alpine AS build

WORKDIR /lookscanned.io
COPY --from=base /git/lookscanned.io .
RUN npm install --global pnpm && \
    pnpm install && \
    pnpm run build

FROM pierrezemb/gostatic

COPY --from=build /lookscanned.io/dist /srv/http
EXPOSE 8043