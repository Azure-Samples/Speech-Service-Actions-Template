# 4. Advanced Customization

The workflow is configured to run without customization, but can optionally be customized in a number of ways for your project.

## Table of Contents

* [Changing Branch Configurations](#Changing-Branch-Configurations)
* [Use Git Large File Storage](#Use-Git-Large-File-Storage)
    * [Edit the YAML to Use LFS](#Edit-the-YAML-to-Use-LFS)
    * [Convert Files to Git LFS](#Convert-Files-to-Git-LFS)
* [Configure Different Data Storage](#Configure-Different-Data-Storage)
* [Set Values in the Pipeline](#Set-Values-in-the-Pipeline)
   * [Pipeline Trigger](#Pipeline-Trigger)
   * [Environment Variables](#Environment-Variables)

## Changing Branch Configurations

TODO

Customize and [configure protected branches](https://help.github.com/en/github/administering-a-repository/configuring-protected-branches) in GitHub.

## Use Git Large File Storage

[Git Large File Storage](https://git-lfs.github.com/) (Git LFS) optimizes operations for large files to occur only when the files are interacted with specifically. Git can be used in the same way it's always been used while Git LFS manages data from the .zip files in the background.

There are alternatives to managing the data with Git LFS, but Git LFS doesn't require additional tooling and is cheaper than storing large files with Git. This is at the cost of paying more for storage than using a solution with Azure Blob Storage for example, but with the amount of data typically used for Custom Speech models, this will probably not be a very high cost. [Customize this solution to use different storage](4-advanced-customization.md#Configure-Different-Data-Storage) options if you choose.

### Edit the YAML to Use LFS

The template repository was not developed with Git LFS, so three edits will have to be made to the two YAML files in `.github/workflows`.

Once in `speech-train-data-ci-cd.yml` and once in `speech-test-data-ci.yml` is the following YAML:

```yml
    # lfs: true

# - name: Checkout LFS objects
#   run: git lfs checkout
```

Uncomment the YAML in both of its locations so that instead it looks like this:

```yml
    lfs: true

- name: Checkout LFS objects
  run: git lfs checkout
```

There is one more change to make in `speech-train-data-ci-cd.yml` with the following YAML:

```yml
#   with:
#     lfs: true

# - name: Checkout LFS objects
#   run: git lfs checkout
```

Uncomment the YAML to look like this:

```yml
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

### Convert Files to Git LFS

Download the [Git LFS command line extension for Windows](https://github.com/git-lfs/git-lfs/releases/download/v2.10.0/git-lfs-windows-v2.10.0.exe) or find [OS-specific guidance](https://github.com/git-lfs/git-lfs/wiki/Installation).

Change into your repository's directory and install Git LFS. Every developer working on the project in the future should download and install Git LFS, but they do not need to do anything else:

```bash
git lfs install
```

Track the testing and training data, and add them as Git LFS objects:

```bash
git lfs track "*.zip"
git add .gitattributes
git commit -m "Track large files with LFS."
```

The testing and training data is currently stored as Git objects and needs to be converted to Git LFS objects. First, you need to remove the testing and training data Git objects:

```bash
git rm --cached "*.zip"
git add "*.zip"
git commit -m "Convert large files from last commit to LFS."
git push
git lfs ls-files
```

Running `git lfs ls-files` in the above command should output two files that Git LFS is successfully managing. For example:

```bash
7aeb3069fa - testing/audio-and-trans.zip
3a7ddef774 - training/audio-and-trans.zip
```

If needed, [purchase more large file storage](https://help.github.com/en/github/setting-up-and-managing-billing-and-payments-on-github/upgrading-git-large-file-storage) through GitHub.

Now, Custom Speech models can be quickly developed and versioned with commits, tags, and releases in the same way that the rest of the repository is versioned.

## Configure Different Data Storage

TODO

## Set Values in the Pipeline

TODO

### Pipeline Trigger

The pipeline will trigger on any push to master, including Pull Requests, that includes changes to training data. With the file structure in the sample, the YAML implementing this is:

```YAML
on:
  push:
    # Execute on pushes to master.
    branches:
      - master
    # The push must include updates to testing or training data.
    paths:
      - 'testing/audio-and-trans.zip'
      - 'training/audio-and-trans.zip'
      - 'training/pronunciation.txt'
      - 'training/related-text.txt'
```

Update `branches` to reflect your git branching workflow. Update `paths` to include all Custom Speech training data - pronunciation, language, and audio and human-labeled transcripts.

### Environment Variables

The following variables in `speech-ci.yml` should be set as follows:

| Variable | Value |
| --- | --- |
| **pronunciationFilePath** | The path from the root of the repository to the pronunciation data file.<br><br>E.g. `training/pronunciation.txt`<br><br>*Note: This should be the same value as one of the three entries for `on.push.paths`.* |
| **relatedTextFilePath** | The path from the root of the repository to the related text data file.<br><br>E.g. `training/related-text.txt`<br><br>*Note: This should be the same value as one of the three entries for `on.push.paths`.* |
| **testTransFile** | The name and extension of the .txt transcript file that will be extracted from `testZipSourcePath`. <br><br>E.g. `test-trans.txt` |
| **testZipSourcePath** | The path from the root of the repository to a .zip with .wav files and a .txt transcript used for testing.<br><br>E.g. `testing/audio-and-trans.zip` |
| **trainTransFile** | The name and extension of the .txt transcript file that will be extracted from `trainZipSourcePath`. <br><br>E.g. `train-trans.txt` |
| **trainZipSourcePath** | The path from the root of the repository to a .zip with .wav files and a .txt transcript used for training.<br><br>E.g. `training/audio-and-trans.zip`<br><br>*Note: This should be the same value as one of the three entries for `on.push.paths`.* |
