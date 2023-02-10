#!/bin/bash
##############  用户配置（修改这里）  ###############
# CloudFlare 注册邮箱
auth_email=$(printenv CF_EMAIL)
# CloudFlare Global API Key
auth_key=$(printenv CF_GLOBAL_API_KEY)
# 根域名
zone_name=$(printenv CF_ROOT_DOMAIN)
# DDNS的域名
record_name=$(printenv CF_FULL_DOMAIN)
# IP类型，填ipv4或ipv6
type="ipv6"
#############  脚本配置（不懂不要修改）  ############
# 变动前的公网 IP 保存位置
ip_file="./ip.txt"
# 域名识别信息保存位置
id_file="./cloudflare.ids"
# 监测日志保存位置
log_file="./cloudflare.log"

################  下面的不懂不要改  ###############
##################  功能定义  ####################
record_type=""
ip=""
zone_identifier=""
record_identifier=""
update=""
#日志
log() {
    #if [ "$1" ]; then
    #    echo -e "[$(date)] - $1" >> $log_file
    #fi
    echo ""
}
#获取本机IP
get_ip() {
    if [ $type == "ipv4" ]; then
	    record_type="A"
	    ip=$(curl -s http://v4.ipv6-test.com/api/myip.php)
    elif [ $type == "ipv6" ]; then
	    record_type="AAAA"
	    ip=$(curl -k -s https://checkip6.spdyn.de)
    else
	    echo "Type wrong"
	    log "Type wrong"
        exit 0
    fi
}
#判断IP是否变化，不变化则结束程序
check_ip_change() {
    if [ -f $ip_file ]; then
        old_ip=$(cat $ip_file)
        if [ "$ip" == "$old_ip" ]; then
            echo "IP has not changed."
            log "IP has not changed."
            exit 0
        fi
    fi
}
#获取域名zone_id和子域名记录ID
get_id() {
    if [ -f $id_file ] && [ $(wc -l $id_file | cut -d " " -f 1) == 2 ]; then
        zone_identifier=$(head -1 $id_file)
        record_identifier=$(tail -1 $id_file)
    else
        zone_identifier=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$zone_name" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json" | grep -Po '(?<="id":")[^"]*' | head -1 )
        rec_response_json=`curl -X GET "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records?name=$record_name" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json"`
        record_identifier=`echo $rec_response_json | grep -Po '(?<="id":")[^"]*'`
        echo "$zone_identifier" > $id_file
        echo "$record_identifier" >> $id_file
    fi
}
#更新 DNS 记录
update_dns() {
    update=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records/$record_identifier" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json" --data "{\"id\":\"$zone_identifier\",\"type\":\"$record_type\",\"name\":\"$record_name\",\"content\":\"$ip\"}")
}
###################  脚本主体  ###################
log "Script start."
#获取IP
get_ip
#判断是否成功获取到IP
if [ "$ip" == "" ]; then
    echo "Can not get IP address.Please check your network connection."
    log "Can not get IP address.Please check your network connection."
    exit 0
fi
#检查IP是否变化
check_ip_change
#获取域名zone_id和子域名记录ID
get_id
#判断是否成功获取到ID
if [ "$zone_identifier" == "" ]; then
    echo "Can not get zone_id."
    log "Can not get zone_id."
    exit 0
elif [ "$record_identifier" == "" ]; then
    echo "Can not get record_id."
    log "Can not get record_id."
    exit 0
fi
#更新 DNS 记录
update_dns
#判断是否成功
if [[ $update == *"\"success\":false"* ]]; then
    log "API UPDATE FAILED. DUMPING RESULTS:\n$update"
    echo -e "API UPDATE FAILED. DUMPING RESULTS:\n$update"
    exit 0
else
    echo "$ip" > $ip_file
    log "$record_name IP changed to: $ip"
    echo "$record_name IP changed to: $ip"
fi
