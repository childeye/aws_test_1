#!/usr/bin/env bash

ABSPATH=$(readlink -f $0)
ABSDIR=$(dirname $ABSPATH)
source ${ABSDIR}/profile.sh

APP_HOME=/home/ec2-user/app/test_web_1
APP_REPOSITORY=$APP_HOME/source/aws_test_1
APP_LIB_DIR=$APP_HOME/lib
APP_LOG_DIR=$APP_HOME/logs
APP_CONF_DIR=$APP_HOME/conf
APP_DEPLOY_DIR=$APP_HOME/zip
ARTIFACT_ID=bootweb

echo "> Build 파일 복사"
echo "> cp $APP_DEPLOY_DIR/*.jar $APP_LIB_DIR/"

cp $APP_DEPLOY_DIR/*.jar $APP_LIB_DIR/

echo "> 새 어플리케이션 배포"
JAR_NAME=$(ls -tr $APP_LIB_DIR/*.jar | tail -n 1)

echo "> JAR Name: $JAR_NAME"

echo "> $JAR_NAME 에 실행권한 추가"

chmod +x $JAR_NAME

echo "> $JAR_NAME 실행"

IDLE_PROFILE=$(find_idle_profile)

echo "> $JAR_NAME 를 profile=$IDLE_PROFILE 로 실행합니다."
nohup java -jar \
    -Dspring.config.location=classpath:/application.properties,$APP_CONF_DIR/application-$IDLE_PROFILE.properties,$APP_CONF_DIR/application-oauth.properties,$APP_CONF_DIR/application-real-db.properties \
    -Dspring.profiles.active=$IDLE_PROFILE \
    $JAR_NAME > $APP_LOG_DIR/nohup.out 2>&1 &
