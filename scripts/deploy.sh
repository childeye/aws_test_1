#!/bin/bash

APP_HOME=/home/ec2-user/app/test_web_1
APP_REPOSITORY=$APP_HOME/source/aws_test_1
APP_LIB_DIR=$APP_HOME/lib
APP_LOG_DIR=$APP_HOME/logs
APP_CONF_DIR=$APP_HOME/conf
APP_DEPLOY_DIR=$APP_HOME/zip
ARTIFACT_ID=bootweb

cd $APP_HOME

echo "> Build 파일 복사"

cp APP_DEPLOY_DIR/*.jar $APP_LIB_DIR/

echo "> 현재 구동중인 애플리케이션 pid 확인"

CURRENT_PID=$(pgrep -fl $ARTIFACT_ID | grep jar | awk '{print $1}')

echo "현재 구동중인 어플리케이션 pid: $CURRENT_PID"

if [ -z "$CURRENT_PID" ]; then
    echo "> 현재 구동중인 애플리케이션이 없으므로 종료하지 않습니다."
else
    echo "> kill -15 $CURRENT_PID"
    kill -15 $CURRENT_PID
    sleep 5
fi

echo "> 새 어플리케이션 배포"

JAR_NAME=$(ls -tr $APP_LIB_DIR/*.jar | tail -n 1)

echo "> JAR Name: $JAR_NAME"

echo "> $JAR_NAME 에 실행권한 추가"

chmod +x $JAR_NAME

echo "> $JAR_NAME 실행"

# nohup java -jar $JAR_NAME > $APP_LOG_DIR/nohup.out 2>&1 &

nohup java -jar \
    -Dspring.config.location=classpath:/application.properties,$APP_CONF_DIR/application-real.properties,$APP_CONF_DIR/application-oauth.properties,$APP_CONF_DIR/application-real-db.properties \
    -Dspring.profiles.active=real \
    $JAR_NAME > $APP_LOG_DIR/nohup.out 2>&1 &