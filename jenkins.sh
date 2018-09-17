action
update
rollback
更新或者回滚动作。
version
HEAD
svn的版本号，若不指定更新到最新。
roll_ver
回滚到最近的哪一次版本，依次 2,3,4，2表示最近的一次。

svn://url@${version}

Load svn_review
Load ssh
Load mysql
Load zip
set -x
SVN_CHECK

PROJECT=""
USER=
IP=""
DIR="/data/upload/"
CONF_NAME="conf/"
#处理配置文件
python ../shell/oper_oss.py -m download -f $CONF_NAME
\cp -r /data1/jenkins_dir/$CONF_NAME conf/hqs_agent.ini.php
#功能函数操作
gzip $PROJECT
rm -rf conf/hqs_agent.ini.php
for i in $IP
do
	upfile $PROJECT $USER $i $DIR
done

rm -rf ../package/$PROJECT.tgz

for i in $IP
do
	cmd $USER $i "sh /data/upload/update.sh ${action} ${roll_ver}"
done

set +x
UPDATE_RECORD ${PROJECT}
set -x
SVN_MAIL

Set jenkins user build variables
Editable Email Template Management
