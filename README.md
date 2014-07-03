nginx-lua-ds-waf
================

基于nginx和lua的WAF系统

A WAF based on openresty/lua-nginx-module


将代码放在位于nginx根目录下的lua/ds_waf/下

Put the code into the directory lua/ds_waf which is located in the root directory of the nginx


在nginx.conf的http段中添加如下配置：

Add the config below to the http seg in nginx.conf:

    lua_package_path "/u/nginx/lua/ds_waf/?.lua;;";
    init_by_lua_file lua/ds_waf/init.lua;
    access_by_lua_file lua/ds_waf/waf.lua;
    

WAF相关的配置在config.lua中，需要保证nginx的worker process对日志文件有读写权限

You can config WAF with the file config.lua,and you must make the worker process of nginx have the read and write permission to the log file
