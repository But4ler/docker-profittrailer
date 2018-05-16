FROM openjdk:8-jre

ARG PT_VERSION=${PT_VERSION:-2.0.5}

ENV PT_DL=https://github.com/taniman/profit-trailer/releases/download/$PT_VERSION/ProfitTrailer-$PT_VERSION.zip
VOLUME ["/app/ProfitTrailer"]
ADD $PT_DL /opt
ADD entrypoint.sh /
CMD ["/entrypoint.sh"]
EXPOSE 8081
