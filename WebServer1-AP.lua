wifi.setmode(wifi.SOFTAP)
cfg={}
     cfg.ssid="virus-iot-8266"
     cfg.pwd="0123456789"
     wifi.ap.config(cfg)
print(wifi.ap.getip())
led1 = 0
led2 = 4
gpio.mode(led1, gpio.OUTPUT)
gpio.mode(led2, gpio.OUTPUT)
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
        local buf = "";
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
        local _GET = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                _GET[k] = v
            end
        end
                
        buf = buf.."<head>";
        buf = buf.."<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">";
        buf = buf.."<link href=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css\" rel=\"stylesheet\">";
        buf = buf.."<link href=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap-theme.min.css\" rel=\"stylesheet\">";
        buf = buf.."</head><div class=\"container\">";
        
        buf = buf.."<h1> ESP8266 Web Server - 01</h1>";
        buf = buf.."<h2> GPIO0</h2>";
        buf = buf.."<div ><a href=\"?pin=ON1\"><button type=\"button\" class=\"btn btn-lg btn-primary\">ON</button></a>&nbsp;<a href=\"?pin=OFF1\"><button  type=\"button\" class=\"btn btn-lg btn-danger\">OFF</button></a>";
        buf = buf.."<h2> GPIO2 (not working3)</h2>";
        buf = buf.."<div ><a href=\"?pin=ON2\"><button >ON</button></a>&nbsp;<a href=\"?pin=OFF2\"><button>OFF</button></a>"; 
              
        local _on,_off = "",""
        if(_GET.pin == "ON1")then
              gpio.write(led1, gpio.LOW);
        elseif(_GET.pin == "OFF1")then
              gpio.write(led1, gpio.HIGH);
        elseif(_GET.pin == "ON2")then
              gpio.write(led2, gpio.LOW);
        elseif(_GET.pin == "OFF2")then
              gpio.write(led2, gpio.HIGH);
        end
        client:send(buf);
        client:close();
        collectgarbage();
    end)
end)
