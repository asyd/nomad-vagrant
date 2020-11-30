job "example" {
  # Run this job as a "service" type. Each job type has different
  # properties. See the documentation below for more examples.
  type = "service"
   
  datacenters = ["dc1"]

  # Specify this job to have rolling updates, two-at-a-time, with
  # 30 second intervals.
  update {
    stagger      = "30s"
    max_parallel = 2
  }


  # A group defines a series of tasks that should be co-located
  # on the same client (host). All tasks within a group will be
  # placed on the same host.
  group "frontend" {
    # Specify the number of these tasks we want.
    count = 1

    network {
      # This requests a dynamic port named "http". This will
      # be something like "46283", but we refer to it via the
      # label "http".
      port "http" {}

      # This requests a static port on 443 on the host. This
      # will restrict this task to running once per host, since
      # there is only one port 443 on each host.
    }

    # The service block tells Nomad how to register this service
    # with Consul for service discovery and monitoring.
    service {
      # This tells Consul to monitor the service on the port
      # labelled "http". Since Nomad allocates high dynamic port
      # numbers, we use labels to refer to them.
      port = "http"
    }

    # Create an individual task (unit of work). This particular
    # task utilizes a Docker container to front a web application.
    task "frontend" {
      # Specify the driver to be "docker". Nomad supports
      # multiple drivers.
      driver = "docker"

      # Configuration is specific to each driver.
      config {
        image = "python:3.8-alpine"
        command = "python3"
        ports = [
          "http"
        ]
        args = [
         "-m",
         "http.server",
         "${NOMAD_PORT_http}"
        ]
      }

      # Specify the maximum resources required to run the task,
      # include CPU and memory.
      resources {
        cpu    = 500 # MHz
        memory = 128 # MB
      }
    }
  }
}

