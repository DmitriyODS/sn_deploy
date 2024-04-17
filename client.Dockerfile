FROM node:20.11.0-alpine3.18 AS holaBuilder
LABEL stage=holaBuilder

ARG base_url
ARG base_port
ARG base_api

ENV VITE_SRV_URL=$base_url
ENV VITE_SRV_PORT=$base_port
ENV VITE_SRV_V_API=$base_api

RUN npm update npm -g

COPY ${PWD}/hola-front /front
WORKDIR /front
RUN rm -rfv /front/dist
RUN rm -rfv /front/node_modules
RUN npm i
RUN npm run build

FROM nginx:stable-alpine AS holaFrontProd
WORKDIR /front
RUN rm /etc/nginx/conf.d/default.conf
COPY ${PWD}/nginx/conf.d /etc/nginx/conf.d
COPY ${PWD}/nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=holaBuilder /front/dist /front