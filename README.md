# Notes for Terraform VM / CICD Session
- Kanban: in the job environment this is one way that devops teams operate within the agile scrum ways. Kanban flow is when there is no planned work all of the work that comes in as based on demand and the timeline for completion depends entirely on the team.

- Planned work: The cards on the board have gone through scrum planning ceremonies where team has gathered all the info and requirements with designated deadlines.

- More differences between the two: Kanban is unpredictable workloads, so for example one sprint you can have 20+ PBI's and then the next sprint you could have less than 20+ PBI's all depending on the demand of work from your kanban team. Planned work is predictable - you see all of the work needed for the sprint up front and any efforts / deadlines are clearly communicated in the beginning of the sprint. 

## Azure Permissions
- Global admin (owner)
- Contributor access (allows for read + write permissions)
- Reader access (read only access)

## Terraform setup
- install [azure cli](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- After installing azure cli, run ```az login``` command and it will prompt you to select your account in the browser
- [Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli)
- [ssh key](https://learn.microsoft.com/en-us/azure/virtual-machines/linux/mac-create-ssh-keys)

### Intro to CI/CD
- Continious integration / Continious delivery and deployment
- CI --> everytime new code gets merged to master branch we must check if the new code is validated (example terraform fmt, validate, plan)
- CD --> everytime new code gets merged to master we must also deploy the new code into the cloud (example terraform apply)
- Reason why CICD is important --> helps you catch any issues to new code getting introduced to existing code base early on.
- Benefits --> saves time because testing and deploying code is time consuming
- CI/CD is the backbone of devops culture, we always need to leverage CI/CD with almost everything that we code whether it be infrastructure, docker containers, kubernetes etc.)

#### CICD Setup
- check in placeholder yml file to repo
- setup agent pool + agent 
- What is an agent / agent pool - agent is a virtual machine that we give the set of instructions that we wish to automate against the new incoming code to master branch. Agent pool is collection of agents.
- [YAML Schema](https://learn.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/?view=azure-pipelines)

#### Scenario
- We have created an azure virtual machine using terraform and we have setup CI/CD in place to automate the validation and deployment of the terraform code against incoming changes to the main branch. We have setup build policies to ensure that the pipeline is the required check in order to merge new code into the master branch. 

##### In progress
- Plan to setup azure keyvault to store sensitive ssh key for retrieval when it comes to logging into the newly created azure VM 