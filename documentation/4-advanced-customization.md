# 4. Advanced customization

Tailor the repository to your project's needs and optionally implement alternative approaches.

### Table of contents

* [Change Environment Variables](#Change-environment-variables)
* [Change locales](#Change-locales)
* [Configure a clean master](#Configure-a-clean-master)
    * [Edit the YAML](#Edit-the-YAML)
    * [Protect the master and develop branches](#Protect-the-master-and-develop-branches)
* [Exclude training data](#Exclude-training-data)
* [Use Git Large File Storage](#Use-Git-Large-File-Storage)
    * [Edit the YAML](#Edit-the-YAML-1)
    * [Convert files to Git LFS](#Convert-files-to-Git-LFS)

## Change Environment Variables

[GitHub Actions Environment Variables](https://help.github.com/en/actions/reference/workflow-syntax-for-github-actions#env) are defined at the beginning of the workflow and are available to each job and step within the workflow.

The following environment variables are set in at least one of `speech-test-data-ci.yml` or `speech-train-data-ci-cd.yml`. Variable values that are paths should not contain anchors at the beginning or end like `./foo.txt` does, and folders should not contain slashes at the end such as `var/`.

| Variable                    | Value |
|-----------------------------|-------|
| **IS_PRIVATE_REPOSITORY**   | `true` if the repository is private and `false` otherwise. |
| **PRONUNCIATION_FILE_PATH** | The path from the root of the repository to the pronunciation data file.<br><br>***Note:** This should be the same value as one of the three entries for `on.push.paths`.* |
| **RELATED_TEXT_FILE_PATH**  | The path from the root of the repository to the related text data file.<br><br>***Note:** This should be the same value as one of the three entries for `on.push.paths`.* |
| **SPEECH_LOCALE**           | See [Language Support](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/language-support) for available locales. |
| **TEST_TRANS_FILE**         | The name and extension of the .txt transcript file that will be extracted from `testZipSourcePath`. |
| **TEST_ZIP_SOURCE_PATH**    | The path from the root of the repository to a .zip with .wav files and a .txt transcript used for testing. |
| **TRAIN_TRANS_FILE**        | The name and extension of the .txt transcript file that will be extracted from `trainZipSourcePath`. |
| **TRAIN_ZIP_SOURCE_PATH**   | The path from the root of the repository to a .zip with .wav files and a .txt transcript used for training.<br><br>***Note:** This should be the same value as one of the three entries for `on.push.paths`.* |

## Change locales

Custom Speech supports different features depending on the locale the project is built with. See [Language Support](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/language-support) for a list of possible locales, along with which features the locales support.

In `speech-train-data-ci-cd.yml`, the locale is defined to be `en-us`:

```YAML
  SPEECH_LOCALE: "en-us"
```

Change `en-us` to the locale that works best for your project, but note its available customizations. As seen on Language Support, not all locales can have all three types of training data. If your locale does not support all three types of training data, you must [exclude the unsupported training data](#Exclude-Some-Training-Data) from the workflow.

If under **Customizations** it says "No" for your locale, that means Custom Speech is not supported and you must exclude all three types of training data. While this solution then cannot help with continuously improving Custom Speech models, it can still test baseline Azure Speech models against test data as the test data changes, or as new baseline models are released.

## Configure a clean master

The training data in **master** does not always represent an improved Custom Speech model because the workflows execute *after* a pull request has already been merged, meaning there is no way to guarantee that model is better. This is not necessarily a problem because there is special behavior when models improve - a Custom Speech endpoint is created, a GitHub release is created containing that endpoint, and the repository is tagged with a new version. This approach is also great because training Custom Speech models and testing them against a large data set will take a long time, and is only done once for each commit to master.

If the special behavior from improved models is not enough for your project, an alternative branching strategy can ensure a "clean" **master** where every commit represents an improved Custom Speech model. Many branching strategies will solve this problem, but [Gitflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) is simple and will show the general changes to make for any strategy. With Gitflow, merge feature branches into **develop** and merge **develop** into **master** so that every commit in **master** represents an improved Custom Speech model.

### Edit the YAML

Find the following YAML once in `speech-test-data-ci.yml` and once in `speech-train-data-ci-cd.yml`:

```YAML
on:
  push:
    # Execute on pushes to master.
    branches:
      - master
```

Change both occurrences to:

```YAML
on:
  push:
    # Execute on pushes to master and develop.
    branches:
      - master
      - develop
```

Add, commit, and push these changes so that both workflows trigger on pushes to **master** and **develop**. For more information, read about [GitHub events that trigger workflows](https://help.github.com/en/actions/reference/workflow-syntax-for-github-actions#on).

### Protect the master and develop branches

During Setup, you [protected the **master** branch](1-setup.md#Protect-the-master-branch). Add another rule so that pushes to the **develop** branch also require updates to be made via approved pull requests.

***Important:*** *Individual GitHub accounts must be public or have a GitHub Pro subscription to enforce branch protections. If you are using a private repository with a personal GitHub account, you will have to change your repository to be public in repository settings.*

To configure these protections:

1. In the home page for your repository, click **Settings**.
2. On the Settings page, click on **Branches** in the Options menu.
3. Under **Branch protection rules**, click the **Add rule** button.
4. Configure the rule:
    1. In the **Branch name pattern** box, enter **develop**.
    2. Check **Require pull request reviews before merging**.
    3. Do **not** check **Include administrators**. Later you will need to use your administrator privileges to bypass merging restrictions. Once multiple people are contributing to the project, consider configuring these restrictions for administrators as well.
    4. Click the **Create** button at the bottom of the page.

With the branch protections and triggers in place, create pull requests from feature branches to **develop**. If the models in **develop** improve, create pull requests from **develop** to **master** so that every commit in **master** represents an improved Custom Speech model.

## Exclude training data

The three types of training data to use when building a Custom Speech model were [explained in more detail](2-train-an-initial-model.md#Create-pull-request-for-training-data-updates) previously, but it's possible to exclude any or all of the data if it is [unsupported by the locale](#Change-locales), or if your project does not require it.

To exclude training data, find the following YAML in `speech-train-data-ci-cd.yml`:

```YAML
  #############################################################################
  # Training Data
  #############################################################################
  PRONUNCIATION_FILE_PATH: "training/pronunciation.txt"
  RELATED_TEXT_FILE_PATH: "training/related-text.txt"
  TRAIN_TRANS_FILE: "trans.txt"
  TRAIN_ZIP_SOURCE_PATH: "training/audio-and-trans.zip"
```

Set the paths to an empty string for each type of training data you wish to exclude. For example, if a locale did not support acoustic models:

```YAML
  #############################################################################
  # Training Data
  #############################################################################
  PRONUNCIATION_FILE_PATH: "training/pronunciation.txt"
  RELATED_TEXT_FILE_PATH: "training/related-text.txt"
  TRAIN_TRANS_FILE: ""
  TRAIN_ZIP_SOURCE_PATH: ""
```

That's it. The pipeline will continue to train Custom Speech models with the remaining training data.

## Use Git Large File Storage

The solution stores testing and training data in the GitHub repository, and manages the data with Git. It is strongly recommended that you use [Git Large File Storage](https://git-lfs.github.com/) to manage the data. Git LFS optimizes operations for large files to occur only when the files are interacted with specifically. It is cheaper than Git, requires no additional tools, and its setup is outlined in its entirety below to manage .zip testing and training files.

There are alternatives to managing the data with Git LFS, but Git LFS doesn't require additional tooling. This is at the cost of paying more for storage than using a solution with Azure Blob Storage for example, but with the amount of data typically used for Custom Speech models, this will probably not be a very high cost.

### Edit the YAML

The template repository was not developed with Git LFS, so three edits will have to be made to the two YAML files in `.github/workflows`.

Once in `speech-train-data-ci-cd.yml` and once in `speech-test-data-ci.yml` is the following YAML:

```YAML
    # lfs: true

# - name: Checkout LFS objects
#   run: git lfs checkout
```

Uncomment the YAML in both of its locations so that instead it looks like this:

```YAML
    lfs: true

- name: Checkout LFS objects
  run: git lfs checkout
```

There is one more change to make in `speech-train-data-ci-cd.yml` with the following YAML:

```YAML
#   with:
#     lfs: true

# - name: Checkout LFS objects
#   run: git lfs checkout
```

Uncomment the YAML to look like this:

```YAML
  with:
    lfs: true

- name: Checkout LFS objects
  run: git lfs checkout
```

Commit the changes:

```bash
git add .
git commit -m "Checkout with LFS."
```

### Convert files to Git LFS

Download the [Git LFS command line extension for Windows](https://github.com/git-lfs/git-lfs/releases/download/v2.10.0/git-lfs-windows-v2.10.0.exe) or find [OS-specific guidance](https://github.com/git-lfs/git-lfs/wiki/Installation).

Change into your repository's directory and install Git LFS. Every developer working on the project in the future should download and install Git LFS, but they do not need to do anything else:

```bash
git lfs install
```

Track the testing and training data, and add them as Git LFS objects:

```bash
git checkout -b gitLFS master
git lfs track "*.zip"
git add .gitattributes
git commit -m "Track large files with LFS."
```

The testing and training data is currently stored as Git objects and needs to be converted to Git LFS objects. First, you need to remove the testing and training data Git objects:

```bash
git rm --cached "*.zip"
git add "*.zip"
git commit -m "Convert large files from last commit to LFS."
git push -u origin gitLFS
git lfs ls-files
```

Running `git lfs ls-files` in the above command should output two files that Git LFS is successfully managing. For example:

```bash
7aeb3069fa - testing/audio-and-trans.zip
3a7ddef774 - training/audio-and-trans.zip
```

Merge the changes into **master** and if needed, [purchase more large file storage](https://help.github.com/en/github/setting-up-and-managing-billing-and-payments-on-github/upgrading-git-large-file-storage) through GitHub.

Now models can be developed quickly and versioned with commits, tags, and releases in the same way that the rest of the repository is versioned.
