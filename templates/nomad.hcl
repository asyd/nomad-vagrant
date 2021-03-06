data_dir   = "/var/lib/nomad"
plugin_dir = "/opt/nomad/drivers"

datacenter = "dc1"
region     = "fr"

# enable_debug = true
# log_level = "DEBUG"

bind_addr  = "0.0.0.0" # the default

advertise {
}

server {
  enabled          = true
  bootstrap_expect = 3
  server_join {
    retry_join = [
      "192.168.1.100",
      "192.168.1.101",
      "192.168.1.102"
    ]
  }
}

client {
  enabled       = true
  network_speed = 10
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}

{% if mode == 'podman' %}
plugin "nomad-driver-podman" {
  config {
    socket_path = "unix:/var/run/podman/io.podman"
  }
}
{% endif %}

consul {
  address = "{{ ansible_eth1.ipv4.address }}:8500"
}

vault {
  enabled = true
  address = "http://192.168.1.10:8200"
  token = "{{ vault_root_token }}"
}

telemetry {
  prometheus_metrics = true
  publish_node_metrics = true
  publish_allocation_metrics = true
}
