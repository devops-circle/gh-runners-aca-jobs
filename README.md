# gh-runners-aca-jobs

This repo has been created for the blog post https://blog.olandese.nl/2023/07/02/auto-scale-github-runners-and-ado-agents-with-azure-container-apps-jobs-and-workload-profiles/

To start using the code:

- clone it
- rename terraform.tfvars.example to terraform.tfvars
- create a GitHub PAT token as described in the blog
- paste the GitHub PAT token in the gh_pat_value variable in the terrafom.tfvars
- run terraform plan/apply