local skynet = require "skynet"
local share_memory = require "share_memory"
local cluster_monitor = require "cluster_monitor"
local proto_map = require "proto_map"


skynet.start(function()
	local redis_conf = {
		host = "127.0.0.1" ,
		port = 6379 ,
		db = 0
	}

	local current_conf = { 
			nodename = "node", 
			nodeport = 9001, 
   			intranetip = "127.0.0.1", 
   			extranetip = "127.0.0.1",
  			use_intranet = 1, 
  			serverid = 1, 
  			servertype = 1, 
  			ver = 0 
  	}

	cluster_monitor.start(redis_conf, current_conf)

	local watchdog = skynet.newservice("wswatchdog")
	skynet.call(watchdog, "lua", "start", {
		port = 9002,
		maxclient = max_client,
		nodelay = true,
	})

	cluster_monitor.open()

 	skynet.error("server is start")

end)