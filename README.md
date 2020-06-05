---
page_type: sample
languages:
- csharp
products:
- dotnet
description: "Add 150 character max description"
urlFragment: "update-this-to-unique-url-stub"
---

# Speech Services DevOps Template

![Flask sample MIT license badge](https://img.shields.io/badge/license-MIT-green.svg) ![Preview](https://img.shields.io/github/v/release/Azure-Samples/Speech-Service-DevOps-Template?include_prereleases&sort=semver)

> **Speech-Service-DevOps-Template** is currently under **public preview** and is not ready for production use.

<!--
Guidelines on README format: https://review.docs.microsoft.com/help/onboard/admin/samples/concepts/readme-template?branch=master

Guidance on onboarding samples to docs.microsoft.com/samples: https://review.docs.microsoft.com/help/onboard/admin/samples/process/onboarding?branch=master

Taxonomies for products and languages: https://review.docs.microsoft.com/new-hope/information-architecture/metadata/taxonomies?branch=master
-->

Use this template to create a repository to develop [Azure Custom Speech](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/how-to-custom-speech) models with built-in support for DevOps and common software engineering practices.

Train, test, and release new Custom Speech models automatically as training and testing data are updated. Version data, test results, endpoints, models, and more out of the box.

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

* [Azure subscription](https://azure.microsoft.com/free/)
* [Git](https://git-scm.com/downloads)
* [GitHub account](https://github.com/join)

## How to use this repository

***Required:*** Follow the steps below to create and configure your repository to deploy models to your Azure Subscription, use the provided sample data to understand the workflow, and create a model for your project by replacing the sample data with your own:

1. Follow the steps in [setup](./documentation/1-setup.md) to create a GitHub repository for your project and configure it for use in your project.
1. Follow the [test the baseline model](./documentation/2-test-the-baseline-model.md) step-by-step guidance to understand the process and establish a baseline model.
1. Update the training and testing data to understand how to [improve the model](./documentation/3-improve-the-model.md) in an iterative fashion.
1. Visit [advanced customization](./documentation/4-advanced-customization.md) to customize your repository and project, including changing the folder structure, using an alternative branching strategy, and more.

This template includes sample data from the [cognitive-services-speech-sdk repository](https://github.com/Azure-Samples/cognitive-services-speech-sdk/tree/master/sampledata/customspeech) for the purposes of following these steps. Later in this documentation, you will learn how to [replace the sample data](documentation/3-improve-the-model.md#Next-steps) with data for your own project.

## Submit feedback

File feedback regarding documentation or tooling as a an [issue](https://github.com/Azure-Samples/Speech-Service-DevOps-Template/issues), or propose changes by submitting a pull request into the **develop** branch.

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
