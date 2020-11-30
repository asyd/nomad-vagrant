global
    log /run/systemd/journal/syslog local0 info

defaults
    log     global
    mode    http
    option  httplog
    option  dontlognull
    timeout connect 5000
    timeout client  50000
    timeout server  50000


frontend f_web
    bind *:80
    default_backend b_web

backend b_web{{range service "example-frontend"}}
    server node-{{.Port}} {{.Address}}:{{.Port}}{{end}}

