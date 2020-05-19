# 1. Setup

Create the Azure resources and set up Git to begin developing Custom Speech models.

### Table of Contents

* [Use this Template](#Use-this-Template)
* [Create the Resource Group and Resources](#Create-the-Resource-Group-and-Resources)
* [Create the Speech Project](#Create-the-Speech-Project)
* [Create the Service Principal](#Create-the-Service-Principal)
* [Save GitHub Secrets](#Save-GitHub-Secrets)
* [Protect the Master Branch](#Protect-the-Master-Branch)
* [Next Steps](#Next-Steps)

## Use this Template

[Generate a copy of this template repository](https://github.com/KatieProchilo/CustomSpeechDevOpsSample/generate) to hold the code and the GitHub Actions pipelines:

1. Enter a name for the repository where prompted.
2. The solution works with public repositories by default. To create a private repository, select **Private** and [change the `IS_PRIVATE_REPOSITORY` environment variable](4-advanced-customization.md##Change-Environment-Variables) to `true`.
3. Leave **Include all branches** unchecked. You only need to copy the master branch of this repository.
4. Click **Create repository from template** to create your copy.

[Clone the repository](https://help.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository). Use this repository to walk through this guide and for your own experimentation.

If you are using this solution as the starting point for a Custom Speech project with a lot of data, consider [using Git Large File Storage](4-advanced-customization.md#Use-Git-Large-File-Storage) to manage large files in this repository. This will cost less compared to storing large files with Git.

## Create the Resource Group and Resources

Developing Custom Speech models with the CI/CD pipeline requires an Azure Resource Group, under which an Azure Speech Resource and an Azure Storage Account must be created. To create these resources, click the Deploy to Azure button below:

**TEMPORARY:** URL behind this button is temporary while the repo is private. REMOVE THIS MESSAGE and change URL to correct target when this goes public.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FKatieProchilo%2FDeployToAzure%2Fmaster%2Fazuredeploy.json)

<!--
[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure-Samples%2FSpeech-Services-DevOps-Samples%2Fmaster%2Fazuredeploy.json)
-->

Enter the values as prompted. Take a note of the values you enter for the `STORAGE_ACCOUNT_NAME` and for `SPEECH_RESOURCE_REGION`, as you will need them later on when we configure the CI/CD pipelines:

* **Resource Group:** Up to 90 alphanumeric characters, periods, underscores, hyphens and parenthesis. Cannot end in a period.
* **Location:** Select the region from the dropdown that's best for your project.
* **STORAGE_ACCOUNT_NAME:** 8-24 alphanumeric characters. Must be unique across Azure. Record your name for later.
* **STORAGE_ACCOUNT_REGION:** Select the region from the dropdown that's best for your project.
* **SPEECH_RESOURCE_NAME:** 2-64 alphanumeric characters, underscores, and hyphens.
* **SPEECH_RESOURCE_REGION:** Select the region from the dropdown that's best for your project. Record your choice for later.

Agree to the terms and click **Review + create** to create the Resource Group and Resources. Fix any validation errors if necessary and then click **Create**.

## Create the Speech Project

You must create a Speech Project in [Speech Studio](https://speech.microsoft.com/portal/) for your project. To create the project:

1. Open [Speech Studio](https://speech.microsoft.com/portal/) and click the cog in the upper right corner, then click **Speech resources**:

   ![Speech Studio Speech Resource](../images/SpeechStudioSpeechResources.png)

1. Select the Speech Resource that was created in Setup, and then click the eye icon to reveal the Speech subscription key. Record this value for use later on.

   ![Speech Studio Speech Subscription Key](../images/SpeechStudioSubscriptionKey.png)

1. Click **Go to Studio** and [create a Speech project](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/how-to-custom-speech#how-to-create-a-project). Save the name of the speech project for use later on.

1. Under **Language**, select the language you will use for testing and training models. The project is configured for **English (United States)**. To use other languages, [change locales](4-advanced-customization.md#Change-Locales).

## Create the Service Principal

You need to configure an [Azure Service Principal](https://docs.microsoft.com/cli/azure/create-an-azure-service-principal-azure-cli) to allow the pipeline to login using your identity and to work with Azure resources in a role-restricted fashion on your behalf. You will save the access token for the service principal in the GitHub Secrets for your repository.

A Powershell script [./setup/create_sp.ps1](./setup/create_sp.ps1) is provided in this repo to make this simple and the easiest way to run the script is to use [Azure Cloud Shell](https://shell.azure.com).

To launch Azure Cloud Shell:

* Go to [https://shell.azure.com](https://shell.azure.com), or click  this button to open Cloud Shell in your browser: [![Launch Cloud Shell in a new window](./images/hdi-launch-cloud-shell.png)](https://shell.azure.com)
* Or select the **Cloud Shell** button on the menu bar at the upper right in the [Azure portal](https://portal.azure.com).

When Cloud shell launches, select the Azure subscription you used before to create the Azure resources, and if this is the first time of use, complete the initialization procedure.

To run the script:

1. Select **Powershell** at the top left of the terminal taskbar.

1. Click the **Upload/Download** button on the taskbar.

   ![Azure CloudShell Upload button](./images/cloudshell.png?raw=true "Uploading in Azure Cloud Shell")

1. Click **Upload** and navigate to the **/setup/create_sp.ps1** file in the cloned copy of this repo on your computer.

1. After the file has finished uploading, execute it:

   ```powershell
   ./create_sp.ps1
   ```

1. Enter the  requested input as prompted.

   > **IMPORTANT:** The Service Principal name you use must be unique within your Active Directory. When prompted enter your own unique name or hit *Enter* to use the auto-generated unique name. Also enter the **Resource Group** name you created when you configured the Azure resources:

   ![Azure create-for-rbac](./images/rbac.png?raw=true "Saving output from az ad sp create-for-rbac")

1. As prompted, copy the JSON that is returned, then in your repository, [create a GitHub Secret](https://help.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets#creating-encrypted-secrets) called `AZURE_CREDENTIALS` and set it to the JSON output from the command, for example:

```json
{
  "clientId": "########-####-####-####-############",
  "clientSecret": "########-####-####-####-############",
  "subscriptionId": "########-####-####-####-############",
  "tenantId": "########-####-####-####-############",
  "activeDirectoryEndpointUrl": "https:...",
  "resourceManagerEndpointUrl": "https:...",
  "activeDirectoryGraphResourceId": "https:...",
  "sqlManagementEndpointUrl": "https:...",
  "galleryEndpointUrl": "https:...",
  "managementEndpointUrl": "https:..."
}
```

## Save GitHub Secrets

[GitHub Secrets](https://help.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets#creating-encrypted-secrets) serve as parameters to the workflow, while also hiding secret values. When viewing the logs for a workflow on GitHub, secrets will appear as `***`.
You access GitHub Secrets by clicking on the **Settings** tab on the home page of your repository, or by going to `https://github.com/{your-GitHub-Id}/{your-repository}/settings`. Then click on **Secrets** in the **Options** menu, which brings up the UI for entering Secrets.

As well as the `AZURE_CREDENTIALS` secret you have already saved, a number of other values must be saved for use by the pipelines:

| Secret Name | Value |
|-------------|-------|
| **AZURE_CREDENTIALS** | The output from the `create_sp.ps1` script from the previous step |
| **SPEECH_RESOURCE_REGION** | The region you selected when configuring the Azure resources |
| **SPEECH_SUBSCRIPTION_KEY** | The speech subscription key |
| **SPEECH_PROJECT_NAME** | The speech project name |
| **STORAGE_ACCOUNT_NAME** | Azure storage account name |

![GitHub Secrets](../images/GitHubSecrets.png)

## Protect the Master Branch

It is recommended (and a software engineering best practice) to protect the master branch from direct check-ins. By protecting the master branch in this way, you require all developers to check-in changes by raising a Pull Request and you may enforce certain workflows such as requiring more than one pull request review or requiring certain status checks to pass before allowing a pull request to merge. Read [Configuring protected branches](https://help.github.com/en/github/administering-a-repository/configuring-protected-branches) to learn more about protecting branches in GitHub.

This solution uses [GitHub Flow](https://guides.github.com/introduction/flow/), which involves creating feature branches and merging them into **master**. This approach is lightweight, but illustrates the basics of protecting branches. To learn about using different branching strategies, refer to [changing branching strategies](4-advanced-customization.md#Configure-a-Clean-Master).

Note that the CI/CD pipelines in this repository are configured to run when a merge to master occurs, for example after a PR is merged. Branch Protections are not required to enable this behavior so setting them can be considered optional. However, By setting branch protections as described in the rest of this section, you encourage good software engineering practices by requiring developers to raise a PR in order to propose changes to master and to get those changes reviewed.

> **Important:** Branch protections are supported on public GitHub repositories, or if you have a GitHub Pro subscription. If you are using a personal GitHub account and you created your repository as a private repository, you will have to change it to be **public** if you want to configure Branch protection policies. You can change your repository to be public in repository settings.

You should configure the specific workflows that you require for your software engineering organization. In order to support the solution walk through described in this documentation, you can configure branch protections as follows:

1. In the home page for your repository, click **Settings**.
2. On the Settings page, click on **Branches** in the Options menu.
3. Under **Branch protection rules**, click the **Add rule** button.
4. Configure the rule:
    1. In the **Branch name pattern** box, enter **master**.
    2. Check **Require pull request reviews before merging**.
    3. Do **not** check **Include administrators**. Later you will need to use your administrator privileges to bypass merging restrictions. Once multiple people are contributing to the project, consider configuring these restrictions for administrators as well.
    4. Click the **Create** button at the bottom of the page.

## Next Steps

For the next steps, find out how to [create an initial custom speech model](./2-train-an-initial-model.md) using data stored in the `testing` and `training` folder of the repository.

## Further Reading

See the following documents for more information on this template and the engineering practices it demonstrates:

* [Create an initial custom speech model](2-train-an-initial-model.md#table-of-contents)

* [Improve the model](3-improve-the-model.md#table-of-contents)

* [Advanced customization](4-advanced-customization.md#table-of-contents)