terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
      version = ">= 0.5.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 2.15.0"
    }
  }
}

provider "coder" {
  # The Coder provider automatically detects the URL from the
  # environment when this template is run inside a Coder deployment.
}

resource "coder_agent" "forms-runner" {
  os   = "linux"
  arch = "amd64"

  display_apps {
    vscode       = true
    web_terminal = true
    ssh_helper   = true
  }
}

resource "coder_devcontainer" "forms-runner" {
  agent_id         = coder_agent.forms-runner.id
  workspace_folder = "/workspace"
  config_path      = ".devcontainer/devcontainer.json"
}

resource "coder_app" "forms-runner" {
  agent_id     = coder_agent.forms-runner.id
  slug         = "forms-runner"
  display_name = "Forms Runner"
  url          = "http://localhost:3000"
  icon         = "/icon/rails.svg"
}