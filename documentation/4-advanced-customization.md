# 4. Advanced customization

Tailor your repository to your needs using these advanced customizations.

## Table of contents

* [Change environment variables](#Change-environment-variables)
* [Change locales](#Change-locales)
* [Configure a clean master](#Configure-a-clean-master)
* [Exclude training data](#Exclude-training-data)
* [Use Git Large File Storage](#Use-Git-Large-File-Storage)

## Change environment variables

[GitHub Actions environment variables](https://help.github.com/en/actions/reference/workflow-syntax-for-github-actions#env) are defined at the beginning of the workflow and are available to each job and step within the workflow.

The following environment variables are set in  `speech-test-data-ci.yml` and/or `speech-train-data-ci-cd.yml`. Modify these values as needed to customize your repo.

>**Note:** Variable values that are paths should not contain anchors at the beginning or end (for example `./foo.txt`), and folders should not contain slashes at the end (such as `var/`).

| Variable                     | Value |
|------------------------------|-------|
| **CUSTOM_SPEECH_MODEL_KIND** | V2 Custom Speech models can be either `Acoustic` or `Language` models. The proper paths to the training data for the specific model type should be set in the `speech-train-data-ci-cd.yml` environment variables. |
| **IS_PRIVATE_REPOSITORY**    | `true` if the repository is private and `false` otherwise. |
| **PRONUNCIATION_FILE_PATH**  | The path from the root of the repository to the pronunciation data file. Set to an empty string if you are training an acoustic model.<br><br>***Note:** This should be the same value as one of the three entries for `on.push.paths` in `speech-train-data-ci-cd.yml`.* |
| **RELATED_TEXT_FILE_PATH**   | The path from the root of the repository to the related text data file. Set to an empty string if you are training an acoustic model.<br><br>***Note:** This should be the same value as one of the three entries for `on.push.paths` in `speech-train-data-ci-cd.yml`.* |
| **SPEECH_LOCALE**            | See [language support](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/language-support) for available locales. |
| **TEST_ZIP_SOURCE_PATH**     | The path from the root of the repository to a .zip with .wav files and a .txt transcript used for testing.<br><br>***Note:** This should be the same value as the entry for `on.push.paths` in `speech-test-data-ci.yml`.* |
| **TEST_TRANS_FILE**          | The name and extension of the .txt transcript file that will be extracted from `testZipSourcePath`. |
| **TRAIN_ZIP_SOURCE_PATH**    | The path from the root of the repository to a .zip with .wav files and a .txt transcript used for training. Set to an empty string if you are training a language model.<br><br>***Note:** This should be the same value as one of the three entries for `on.push.paths` in `speech-train-data-ci-cd.yml`.* |
| **TRAIN_TRANS_FILE**         | The name and extension of the .txt transcript file that will be extracted from `trainZipSourcePath`. Set to an empty string if you are training a language model. |

## Change locales

Custom Speech supports different features depending on the locale. See [language support](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/language-support) for a list of possible locales, along with which features each locale supports.

In `speech-train-data-ci-cd.yml`, the locale is defined to be `en-us`:

```yml
  SPEECH_LOCALE: "en-us"
```

Change `en-us` to the locale that works best for your project, but note its available customizations. As seen in [language support](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/language-support), not all locales support all three types of training data. If your locale does not support all three types of training data, you **must** [exclude the unsupported training data](#Exclude-Some-Training-Data) from the workflow.

If under **Customizations** it says "No" for your locale, that means Custom Speech is not supported and you must exclude all three types of training data. You can still use this solution to test the baseline Azure Speech models against test data and/or as new baseline models are released.

## Configure a clean master

The training data in **master** does not always represent an improved Custom Speech model because the workflows execute *after* a pull request has already been merged, meaning there is no way to guarantee that model has improved with each change. This doesn't present a problem considering the behavior when models improve - a Custom Speech endpoint is created, a GitHub release is created containing that endpoint, and the repository is tagged with a new version. This approach is preferred because training Custom Speech models and testing them against a large data set will take a long time, and is only done once for each commit to master.

An alternative branching strategy can ensure a "clean" **master** where every commit represents an improved Custom Speech model. Many branching strategies will solve this problem, but [Gitflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) is simple and will show the general changes necessary for any branch strategy. With Gitflow, merge feature branches into **develop** and merge **develop** into **master** so that every commit in **master** represents an improved Custom Speech model.

### Edit branches

Complete the following to configure a clean **master**:

1. Configure [Gitflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) by creating a **develop** branch from master.
1. Find the following YAML in both `.github/workflows/speech-test-data-ci.yml` and `.github/workflows/speech-train-data-ci-cd.yml`:

    ```yml
    on:
      push:
        # Execute on pushes to master.
        branches:
          - master
    ```

1. Add the **develop** branch to `branches`:

    ```yml
    on:
      push:
        # Execute on pushes to master and develop.
        branches:
          - master
          - develop
    ```

1. Add, commit, and push these changes so that both workflows trigger on pushes to **master** and **develop**. For more information, read about [GitHub events that trigger workflows](https://help.github.com/en/actions/reference/workflow-syntax-for-github-actions#on).

### Protect the master and develop branches

During Setup, you protected the **master** branch. [Follow the same steps](1-setup.md#Protect-the-master-branch) to create a rule for the **develop** branch so that pushes to that branch also require updates to be made via approved pull requests.

With the branch protections and triggers in place, create pull requests from feature branches to **develop**. If the models in **develop** improve, create pull requests from **develop** to **master** so that every commit in **master** represents an improved Custom Speech model.

## Exclude training data

The three types of training data to use when building a Custom Speech model were explained when [testing the baseline model](2-test-the-baseline-model.md#Create-pull-request-for-training-data-updates), but it's possible to exclude any or all of the data if it is [unsupported by the locale](#Change-locales), or if your project does not require it.

To exclude training data:

1. Find the following YAML in `speech-train-data-ci-cd.yml`:

    ```yml
      #############################################################################
      # Training Data
      #############################################################################
      PRONUNCIATION_FILE_PATH: "training/pronunciation.txt"
      RELATED_TEXT_FILE_PATH: "training/related-text.txt"
      TRAIN_TRANS_FILE: "trans.txt"
      TRAIN_ZIP_SOURCE_PATH: "training/audio-and-trans.zip"
    ```

1. Set the paths to an empty string for each type of training data you wish to exclude. For example, if a locale did not support acoustic models:

    ```yml
      #############################################################################
      # Training Data
      #############################################################################
      PRONUNCIATION_FILE_PATH: "training/pronunciation.txt"
      RELATED_TEXT_FILE_PATH: "training/related-text.txt"
      TRAIN_TRANS_FILE: ""
      TRAIN_ZIP_SOURCE_PATH: ""
    ```

The pipeline will continue to train Custom Speech models with updates to the remaining training data.

## Use Git Large File Storage

This solution stores testing and training data in a GitHub repository, and manages the data with Git. When those data files become large, [Git Large File Storage](https://git-lfs.github.com/) can be used to manage the data. Git LFS optimizes operations for large files to occur only when the files are interacted with specifically. It supports file versioning, is lower cost (in both storage costs and time) than storing large files in Git, and requires no additional tooling after configuration) using the steps below.

There are alternatives to Git LFS for managing this data, such as [Azure Blob Storage](https://azure.microsoft.com/en-us/services/storage/blobs/?&OCID=AID2000128_SEM_Xh_x2wAAAKGjJDH6:20200527175334:s&msclkid=8ff4f1862ff4116c0b61af4886ecd70a&ef_id=Xh_x2wAAAKGjJDH6:20200527175334:s&dclid=CjgKEAjwn7j2BRDljcri0_XImx0SJAAtSGciXNY-qZfl03XsN7v2-eeVbw8t_FtwsgL4S2A3MTB-LfD_BwE), which may provide lower storage costs, but would require a versioning solution to provide the same features as Git Large File Storage.

### Edit the YAML

1. In `.github/workflows`, open `speech-train-data-ci-cd.yml` and `speech-test-data-ci.yml` and find the following YAML:

    ```yml
      #     lfs: true

      # - name: Checkout LFS objects
      #   run: git lfs checkout
    ```

1. Uncomment the YAML:

    ```yml
          lfs: true

      - name: Checkout LFS objects
        run: git lfs checkout
    ```

1. In `speech-train-data-ci-cd.yml`, find the following YAML:

    ```yml
      #   with:
      #     lfs: true

      # - name: Checkout LFS objects
      #   run: git lfs checkout
    ```

1. Uncomment the YAML:

    ```yml
        with:
          lfs: true

      - name: Checkout LFS objects
        run: git lfs checkout
    ```

1. Commit the changes:

    ```bash
    git add .
    git commit -m "Updating for LFS."
    ```

### Convert files to Git LFS

Follow these steps to convert your repo to use Git LFS:

1. Navigate to the root of the repository and create a feature branch from **master**:

    ```bash
    git checkout -b gitLFS
    ```

1. Download the [Git LFS command line extension for Windows](https://github.com/git-lfs/git-lfs/releases/download/v2.10.0/git-lfs-windows-v2.10.0.exe) or find [OS-specific guidance](https://github.com/git-lfs/git-lfs/wiki/Installation).
1. Install Git LFS in your repository's directory.
    > **Note:** Every developer working on the project will need to install Git LFS.

    ```bash
    git lfs install
    ```

1. Track the testing and training data, and add them as Git LFS objects:

    ```bash
    git checkout -b gitLFS master
    git lfs track "*.zip"
    git add .gitattributes
    git commit -m "Track large files with LFS."
    ```

The testing and training data is currently stored as Git objects and needs to be converted to Git LFS objects.

1. Remove the testing and training data Git objects:

    ```bash
    git rm --cached "*.zip"
    ```

1. Add the Git LFS objects:

    ```bash
    git add "*.zip"
    git commit -m "Convert large files from last commit to LFS."
    git push -u origin gitLFS
    git lfs ls-files
    ```

1. Running `git lfs ls-files` in the above command should output two files that Git LFS is successfully managing. For example:

    ```bash
    7aeb3069fa - testing/audio-and-trans.zip
    3a7ddef774 - training/audio-and-trans.zip
    ```

1. Merge the changes into **master**.
1. If needed, [purchase more large file storage](https://help.github.com/en/github/setting-up-and-managing-billing-and-payments-on-github/upgrading-git-large-file-storage) through GitHub.

Your repository is configured to use Git LFS to track *.zip files. How you use the repository doesn't change, but now Git LFS will only pull down those files when you need to interact with them.
