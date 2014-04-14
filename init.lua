local config=require("config")
fd = io.open(config.logs_pwd.."waf.log","ab")

function get_user_ip()
    local user_ip = ngx.req.get_headers()["X-Real-IP"]
    if user_ip == nil then
       user_ip = ngx.req.get_headers()["x_forwarded_for"]
    end
    if user_ip == nil then
       user_ip = ngx.var.remote_addr
    end
    return user_ip
end

function log(args)
   local time=ngx.localtime()
   local user_ip = get_user_ip()
   local method=ngx.req.get_method()
   local request_uri=ngx.var.request_uri
   local user_agent=ngx.var.http_user_agent
   local cookie=ngx.var.http_cookie
   local http_version=ngx.req.http_version()
   if user_agent == nil then
       user_agent="-"
   end
   if cookie == nil then
       cookie="-"
   end
   local line = "["..args.module_name.."] "..user_ip.." ["..time.."] \""..method.." "..request_uri.." "..http_version.."\"".." \""..user_agent.."\"\n"
   fd:write(line)
   fd:flush()
end

---------------------------------------------------------------------------------

function block_ips_module()
    for _,block_ip in ipairs(config.block_ips) do
        if get_user_ip()==block_ip then
            log{module_name="BLOCK_IP_MODULE"}
            ngx.exit(403)
        end
    end
end

function block_url_chars_module()
    for _,block_url_char in ipairs(config.block_url_chars) do
        if ngx.re.match(ngx.var.request_uri,block_url_char,"isjo") then
            log{module_name="BLOCK_URL_MODULE"}
            ngx.exit(403)
        end
    end
end

function block_user_agents_module()
    if ngx.var.http_user_agent~=nil then
        for _,block_user_agent in ipairs(config.block_user_agents) do
            if ngx.re.match(ngx.var.http_user_agent,block_user_agent,"isjo") then
                log{module_name="BLOCK_USER_AGENT_MODULE"}
                ngx.exit(403)
            end
        end
    end
end

function block_cookie_chars_module()
    if ngx.var.http_cookie~=nil then
        for _,block_cookie_char in ipairs(config.block_cookie_chars) do
            if ngx.re.match(ngx.var.http_cookie,block_cookie_char,"isjo") then
                log{module_name="BLOCK_COOKIE_MODULE"}
                ngx.exit(403)
            end
        end
    end
end

