#! /bin/bash
PROJECT=""
LN_name=""

update() {
        #保留最近3次的更新目录
        ls -lt /data/web/$PROJECT |tail -n +2 |awk 'BEGIN {FS=" "} NR > 3 {print $NF}' |xargs -i rm -rf /data/web/$PROJECT/{}
        #解压
        tar zxf /data/upload/$PROJECT.tgz -C /data/web/$PROJECT/
        name=$PROJECT-$(date +"%F-%H%M")
	find /data/web/$PROJECT/$PROJECT -type d -name ".svn" -exec rm -rf {} \; > /dev/null 2>&1
        mv /data/web/$PROJECT/$PROJECT /data/web/$PROJECT/$name
        if [ -h "/data/www/$LN_name" ];then
                rm -rf /data/www/$LN_name
                ln -s /data/web/$PROJECT/$name /data/www/$LN_name
        else
                ln -s /data/web/$PROJECT/$name /data/www/$LN_name
        fi
	sudo /usr/bin/kill -USR2 $(cat /usr/local/php56/var/run/php-fpm.pid)
}

rollback() {
        dir_ver=`ls -lt /data/web/$PROJECT |tail -n +2 |awk -v arg=$roll_v 'BEGIN {FS=" "} NR==arg {print $NF}'`
        if [ -h "/data/www/$LN_name" ];then
                rm -rf /data/www/$LN_name
                ln -s /data/web/$PROJECT/$dir_ver /data/www/$LN_name
        else
                ln -s /data/web/$PROJECT/$dir_ver /data/www/$LN_name
        fi
	sudo /usr/bin/kill -USR2 $(cat /usr/local/php56/var/run/php-fpm.pid)
}

case $1 in
        update)
                update
                ;;
        rollback)
                roll_v=$2
                rollback
                ;;
esac

user ALL=NOPASSWD:  /usr/bin/kill
#Defaults    requiretty  禁用
