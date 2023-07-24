# gh-runners-aca-jobs

This repo has been created for the blog post https://blog.olandese.nl/2023/07/02/auto-scale-github-runners-and-ado-agents-with-azure-container-apps-jobs-and-workload-profiles/

## To start using the code:

- clone/fork this repo
- rename terraform.tfvars.example to terraform.tfvars
- create a GitHub PAT token as described in the blog
- paste the GitHub PAT token in the gh_pat_value variable in the terrafom.tfvars
- fill the gh_owner and gh_repository variables with your GitHub repository information (if you fork or push this repo in your own GitHub account)
- go the terraform folder
- run terraform plan/apply

## Test

In the .github folder there are different workflows to test this implementation.

If you fork this repo or you push it in a new GitHub repo, fill the gh_owner and gh_repository variables with your GitHub repository information and then deploy everything in Azure.
You can manually run the workflows and see the GitHub Runners being spinned up in the Azure Container Apps created.
