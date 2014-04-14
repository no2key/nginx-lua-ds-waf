nginx-lua-ds-waf
================

基于nginx+lua实现的waf系统

nginx.conf中http段添加如下配置：

    lua_package_path "/u/nginx/lua/ds_waf/?.lua;/u/nginx/lua/?.lua;;";
    init_by_lua_file lua/ds_waf/init.lua;
    access_by_lua_file lua/ds_waf/main.lua;
    
将代码放在nginx根目录下的lua/ds_waf/下。

waf相关的配置在config.lua中，需要保证nginx的worker process对日志文件有读写权限。
