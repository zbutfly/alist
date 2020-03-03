#!/bin/bash

unset GREP_OPTIONS
urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}"; }


if [[ $1 == *"/detail/"* ]] || [[ $1 == *"/status/"* ]] || [ ${#1} -eq 16 ]
then
	tid=$(echo $1 | sed "s/.*weibo\.cn\/\(detail\|status\)\///g;s/\?.*//g")
	urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}"; }
	uid=$(curl -s "https://m.weibo.cn/detail/$tid" | egrep -o "\"profile_url\": \"https://[^?\"]+" | egrep -o "[0-9]+$")
	echo fech phone: uid: $uid, tid: $tid
	mkdir -p site/$uid/$tid

	for img in $(curl -s "https://m.weibo.cn/detail/$tid" | egrep -o "\"url\": \"https://wx[1-4]\.sinaimg\.cn\/large\/[^\"]+\"" | sed "s/\"url\": \"\([^\"]\+\)\"/\\1/g")
	do
		echo $uid/$tid: $img
		wget -c -b --tries=inf -P site/$uid/$tid -o "logs/$tid-$(echo $img | sed "s/.*\///g;s/\.[^\.]*$//g").log" "$img"
	done
else
	target=$(echo $1 | sed "s/.*weibo\.com\///g;s/\?.*//g")
	target=${target/-/\/}
	echo fech web page: $target
	mkdir -p site/$target

	cookie="ALF=1614755247;SCF=AgcsDwIO3vtTjsJ3FEuUOfxOMkTU0XUDbPqOSIrsHw8iwQWczwn8lNNzFDsD7ieuJ9g4HvdxMWWaOiiyVaWdxtk.;SINAGLOBAL=7312468128204.368.1578709958035;SSOLoginState=1582895514;SUB=_2A25zWnISDeRhGeRH7FMT9C7NyziIHXVQLuTarDV8PUJbmtAfLWr6kW9NTdEu_5UVZHfDU4E3YFJfxnGkcGx_Fz65;SUBP=0033WrSXqPxfM725Ws9jqgMF55529P9D9W5z2BX.EI_1BkvmfUkqMc.F5JpX5K-hUgL.Foz4S02ESh5pehB2dJLoIEXLxK-LB-BL1KBLxK.L1-zL1h5LxKqLB-BLB.zLxK-LB-BL1KBLxK.L1-zL1h5t;SUHB=0qjkED-Cm_FmZj;TC-Page-G0=7a922a70806a77294c00d51d22d0a6b7|1583154025|1583154025;TC-V5-G0=eb26629f4af10d42f0485dca5a8e5e20;Ugrow-G0=d52660735d1ea4ed313e0beb68c05fc5;ULV=1578709958037:1:1:1:7312468128204.368.1578709958035:;un=zbutfly@163.com;wb_view_log_2971240104=2048*11521.875;wvr=6;YF-Page-G0=ee5462a7ca7a278058fd1807a910bc74|1583219026|1583219021;YF-V5-G0=b588ba2d01e18f0a91ee89335e0afaeb"
	for img in $(curl -s "https://www.weibo.com/$target" --compressed -H "DNT: 1" -H "TE: Trailers" -H "Connection: keep-alive" -H "Upgrade-Insecure-Requests: 1"\
		-H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" -H "Accept-Language: zh-CN,en-US;q=0.8,en;q=0.5,zh-TW;q=0.3" \
		-H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:74.0) Gecko/20100101 Firefox/74.0" \
		-H "Cookie: $cookie" | egrep -o "clear_picSrc=[^&]+" | egrep -o "%2F%2Fwx[^,]+")
	do
		echo https:$(urldecode "$img") | sed "s/mw690/large/g" >> site/$target.list
	done
	cat site/$target.list
	wget -c -b --tries=inf -P site/$target -i site/$target.list -o site/$target.log
fi