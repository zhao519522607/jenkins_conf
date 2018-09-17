#! /bin/bash
PROJECT="aaa"
PRO_DIR="/data/online/aaa"

update() {
        #保留最近3次的备份
        ls -lt /data/backup/$PROJECT |tail -n +2 |awk 'BEGIN {FS=" "} NR > 3 {print $NF}' |xargs -i rm -rf /data/backup/$PROJECT/{}
        tar zcf /data/backup/$PROJECT/$(date +"%F-%H%M").tgz --exclude=$PRO_DIR/bin/*.pid $PRO_DIR
        #解压
        rm -rf /data/upload/$PROJECT
        tar zxf /data/upload/$PROJECT.tgz -C /data/upload/
        find /data/upload/$PROJECT -type d -name ".svn" -exec rm -rf {} \; > /dev/null 2>&1
        #覆盖目录
        \cp -r /data/upload/$PROJECT/* $PRO_DIR
	#建立日志链接
	if [ -h $PRO_DIR/log ];then
		echo "日志目录链接已经存在"
	else
		ln -s /data/logs/download_server $PRO_DIR/log
	fi
        #执行重启操作
	kill -HUP $(more $PRO_DIR/bin/server.pid)
	#验证
        if [ -s $PRO_DIR/bin/server.pid ];then
		echo "pid文件存在"
	else
		echo "pid文件不存在"
		exit 10
	fi
}

rollback() {
        #获取回滚目录
        dir_ver=`ls -lt /data/backup/$PROJECT |tail -n +2 |awk -v arg=$roll_v 'BEGIN {FS=" "} NR==arg {print $NF}'`
        #覆盖目录
        rm -rf /data/upload$PRO_DIR
        tar zxf /data/backup/$PROJECT/$dir_ver -C /data/upload/
        find /data/upload$PRO_DIR -type d -name ".svn" -exec rm -rf {} \; > /dev/null 2>&1
        \cp -r /data/upload$PRO_DIR/* $PRO_DIR
	#建立日志链接
        if [ -h $PRO_DIR/log ];then
                echo "日志目录链接已经存在"
        else
                ln -s /data/logs/download_server $PRO_DIR/log
        fi
        #执行重启操作
	kill -HUP $(more $PRO_DIR/bin/server.pid)
	#验证
        if [ -s $PRO_DIR/bin/server.pid ];then
                echo "pid文件存在"
        else
                echo "pid文件不存在"
                exit 10
        fi

}
