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

Use this template repository as the foundation for your own project to implement DevOps with [Azure Custom Speech](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/how-to-custom-speech). Continuously improve Custom Speech models using a CI/CD workflow running on GitHub Actions.

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

## Walk Through the Solution

Step through the Custom Speech DevOps workflow to set up the environment, train the first model, and continuously improve any models that come after that. The project you create can be used as a starting point to develop your own Custom Speech model.

***Required:*** Follow the steps to run this workflow in your personal GitHub repository:

1. [Project Setup](./documentation/1-project-setup.md)
2. [Create the Initial Custom Speech Model](./documentation/2-create-the-initial-custom-speech-model.md)
3. [Improve Custom Speech Models](./documentation/3-improve-custom-speech-models.md)

***Customization:*** Visit [Advanced Customization](./documentation/4-advanced-customization.md) to incorporate this solution into a pre-existing Custom Speech project, change the folder structure, use alternative storage options, and more.

## Key concepts

Test, train, and release new Custom Speech models automatically as training data is updated. Version Custom Speech data, test results, endpoints, models, and more out of the box.

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
