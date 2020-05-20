---
page_type: sample
languages:
- csharp
products:
- dotnet
description: "Add 150 character max description"
urlFragment: "update-this-to-unique-url-stub"
---

# Speech Services DevOps Solution

<!--
Guidelines on README format: https://review.docs.microsoft.com/help/onboard/admin/samples/concepts/readme-template?branch=master

Guidance on onboarding samples to docs.microsoft.com/samples: https://review.docs.microsoft.com/help/onboard/admin/samples/process/onboarding?branch=master

Taxonomies for products and languages: https://review.docs.microsoft.com/new-hope/information-architecture/metadata/taxonomies?branch=master
-->

Use this template to create a repository to develop [Azure Custom Speech](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/how-to-custom-speech) models with built-in support for DevOps and common software engineering practices.

Train, test, and release new Custom Speech models automatically as training data is updated. Version data, test results, endpoints, models, and more out of the box.

**Important:** This is a *template* repository. Please ensure that you read the [setup instructions](./documentation/1-setup.md) before forking or cloning this repo.

## Contents

| File/folder          | Description                                |
|----------------------|--------------------------------------------|
| `.github/workflows/` | CI/CD workflows for GitHub Actions.        |
| `documentation/`     | Guidance for executing workflows.          |
| `testing/`           | Data to test Speech models against.        |
| `training/`          | Data to train Speech models with.          |
| `.gitignore`         | Define what to ignore at commit time.      |
| `azuredeploy.json`   | ARM template used by **Deploy to Azure**.  |
| `CODE_OF_CONDUCT.md` | Guidelines for contributing to the sample. |
| `GitVersion.yml`     | Configuration for GitVersion.              |
| `LICENSE`            | The license for the sample.                |
| `README.md`          | This README file.                          |
| `SECURITY.md`        | Information on reporting security issues.  |

## Prerequisites

* [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli?view=azure-cli-latest)
* [Azure subscription](https://azure.microsoft.com/free/)
* [Git](https://git-scm.com/downloads)
* [Git Large File Storage](https://git-lfs.github.com/)
    * [Windows installer](https://github.com/git-lfs/git-lfs/releases/download/v2.10.0/git-lfs-windows-v2.10.0.exe)
    * See here for [OS-specific guidance](https://github.com/git-lfs/git-lfs/wiki/Installation)
* [GitHub account](https://github.com/join)

## How to use this repository

***Required:*** Follow the steps below to create and configure a personal repository to deploy models to your Azure Subscription, use the provided sample data to understand the development process, and a create a model for your project by replacing the sample data with your own:

1. Follow the [Setup](./documentation/1-setup.md) instructions to clone this template repository to your own GitHub account and to configure it for use.
2. Follow the [Train an Initial Model](./documentation/2-train-an-initial-model.md) step-by-step guidance to understand the "dev inner loop" workflow for making updates to a Speech service model app while using DevOps practices.
3. Use additional data to [Improve the Model](./documentation/3-improve-the-model.md) in an interative fashion.

***Customization:*** Visit [Advanced customization](./documentation/4-advanced-customization.md) to change the folder structure, use an alternative branching strategy, and more.

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
