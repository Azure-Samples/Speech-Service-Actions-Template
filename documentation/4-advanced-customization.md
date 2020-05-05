# 4. Advanced Customization

The workflow is configured to run without customization, but can optionally be customized in a number of ways for your project.

## Table of Contents

* [Changing Branch Configurations](#Changing-Branch-Configurations)
* [Configure Different Data Storage](#Configure-Different-Data-Storage)
* [Set Values in the Pipeline](#Set-Values-in-the-Pipeline)
   * [Pipeline Trigger](#Pipeline-Trigger)
   * [Environment Variables](#Environment-Variables)

## Changing Branch Configurations

TODO

Customize and [configure protected branches](https://help.github.com/en/github/administering-a-repository/configuring-protected-branches) in GitHub.

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
