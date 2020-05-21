# 2. Train an initial model

Follow these steps to understand the developer workflow to contribute to models, understand the data used to train and test models, and to create the first speech model by making a change to the training data. This initial Custom Speech model that you create will be used as a benchmark to which future models can compare their accuracy.

### Table of contents

* [Create pull request for training data updates](#Create-pull-request-for-training-data-updates)
  * [Update training data](#Update-training-data)
    * [Test training data updates](#Test-training-data-updates)
  * [Create and merge the pull request](#Create-and-merge-the-pull-request)
* [What the SpeechTrainDataCICD workflow does](#what-the-speechtraindatacicd-workflow-does)
  * [Train a new model](#Train-a-new-model)
  * [Test the new model](#Test-the-new-model)
  * [Release an endpoint](#Release-an-endpoint)
* [Next steps](#Next-steps)
* [Further Reading](#further-reading)

## Create pull request for training data updates

In this workflow, you will create a pull request with updates to the training data to trigger the **SpeechTrainDataCICD** workflow which will train an initial model. to do this, you will:

* [Update the speech model training data](#update-training-data)
* [Test the training data updates](#test-training-data-updates)
* [Create and merge the pull request](#create-and-merge-the-pull-request)
* [Understand the operation of the SpeechTrainDataCICD workflow](#what-the-speechtraindatacicd-workflow-does)

### Update training data

An initial Custom Speech model is created when training data is updated for the first time, which includes the following files taken from the [cognitive-services-speech-sdk repository](https://github.com/Azure-Samples/cognitive-services-speech-sdk/tree/master/sampledata/customspeech):

* **`training/related-text.txt`:** [Language, or sentences, data](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#related-text-data-for-training) is a type of [related text](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#related-text-data-for-training) that trains language models.
* **`training/pronunciation.txt`:** [Pronunciation data](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#guidelines-to-create-a-pronunciation-file) is the second type of related text that also trains language models. It should be used in moderation to improve the recognition of words, phrases, and acronyms that are outside of a locale's typical vocabulary.
* **`training/audio-and-trans.zip`:** This folder of [audio + human-labeled transcript data](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#audio--human-labeled-transcript-data-for-testingtraining) is used in its entirety to train acoustic models.

To update the training data, navigate to the root of the repository and create a feature branch from master:

```bash
git checkout -b initialSpeechModel
```

Make a change to the file `training/related-text.txt` such as adding the line:

```xml
This is language data for my initial model.
```

This change is sufficient to cause the **SpeechTrainDataCICD** workflow to trigger once the PR is merged.

Add and commit the changes:

```bash
git add .
git commit -m "Changes to my Custom Speech model."
```

### Create and merge the pull request

Push the changes to the remote repository once you are satisfied with how the model is performing:

```bash
git push -u origin initialSpeechModel
```

Create a pull request from **initialSpeechModel** to **master**. Click the **Merge pull request** button to merge the pull request into **master**. If you have set up the branch protection policies, it will be necessary to check **Use your administrator privileges** to merge this pull request to complete the merge.

If everything has been set up properly, the **SpeechTrainDataCICD** workflow will automatically execute after a few seconds. Navigate to the **Actions** tab of the repository to see the workflow called the workflow in progress:

![Actions tab showing that the workflow is running](../images/WorkflowRunning.png)

## What the SpeechTrainDataCICD workflow does

The **SpeechTrainDataCICD** workflow is configured to trigger on a merge to master of changes to any of the training data files, which are in the `training` folder in this repo. In outline, this workflow:

* [Trains a new model](#train-a-new-model)
* [Tests the new model](#test-the-new-model)
* [Releases an endpoint](#release-an-endpoint)

During the initial run for a new project, the objective of this first update to training data is to train and test a Custom Speech model so that its accuracy can be used as a benchmark to which future models can compare their accuracy.

### Train a new model

Any time training data is updated, the **SpeechTrainDataCICD** workflow will run. When it is updated for the first time, the data from the `training` folder is used to build a new Custom Speech model. Please note that building models will take upwards of 30 minutes.

### Test the new model

Once the new speech model is built, the workflow tests the new model's accuracy using [audio + human-labeled transcripts](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#audio--human-labeled-transcript-data-for-testingtraining) which are in `testing/audio-and-trans.zip` in this repo. Models attempt to recognize the .wav files from the `audio` folder in this zip archive, and the recognition is compared to its corresponding text in the `trans.txt` file from the same zip archive.

The test creates a test summary and a test results file. The test summary contains the [Word Error Rate](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-evaluate-data#what-is-word-error-rate-wer) (WER) for that test, which is an industry-standard metric to measure recognition accuracy. It is the sum of substitutions, deletions, and insertions divided by the number of words in a sentence. Essentially it's a measure of how many words were recognized incorrectly. In future runs, it matters that the WER improves and gets lower over time, but this initial run will simply set a baseline WER for future runs.

The workflow stores the test summary and test results in an Azure Storage container called `test-results`. The workflow also creates an Azure Storage container called `configuration` in which it stores a single file, `benchmark-test.txt`, which contains the name of the test summary file from the initial model. On future runs of this workflow, when a new speech model is tested that improves the Word Error Rate, the workflow updates this file to point at the test summary file for the new model, thus establishing a new improved baseline for future runs.

After the workflow has completed, visit the [Azure Portal](https://ms.portal.azure.com/#home) and navigate to your Azure Storage Account to view these additions.

### Release an endpoint

Finally, a [Custom Speech endpoint](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-deploy-model) is created from this initial model, and a GitHub Release is created that will contain this endpoint and a copy of the repository contents at the time the release was created. Each time an endpoint is released, the repository is tagged with a new version.

## Next steps

Now that you have you created an initial Custom Speech model to serve as your initial benchmark, in the next steps you will attempt to [improve the model](./3-improve-the-model.md) by replacing data in the `testing` and `training` folder with your own data. The initial model is currently the benchmark model since there were no previous models to compare it to.

## Further Reading

See the following documents for more information on this template and the engineering practices it demonstrates:

* [Setup](1-setup.md#table-of-contents)

* [Improve the model](3-improve-the-model.md#table-of-contents)

* [Advanced customization](4-advanced-customization.md#table-of-contents)
