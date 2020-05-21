# 2. Train an initial model

Follow these steps to understand the workflow to contribute to models, understand the data used to train and test models, and create an initial model by making a change to the training data. The initial model will automatically become the benchmark model since there are no previous models to compare it to.

### Table of contents

* [Create pull request for training data updates](#Create-pull-request-for-training-data-updates)
    * [Update training data](#Update-training-data)
        * [Test training data updates](#Test-training-data-updates)
    * [Create and merge the pull request](#Create-and-merge-the-pull-request)
* [Workflow for training data updates](#Workflow-for-training-data-updates)
    * [Train a new model](#Train-a-new-model)
    * [Test the new model](#Test-the-new-model)
    * [Release an endpoint](#Release-an-endpoint)
* [Next steps](#Next-steps)

## Create pull request for training data updates

Create a pull request with updates to the training data to trigger the **SpeechTrainDataCICD** workflow which will train an initial model.

### Update training data

An initial Custom Speech model is created when training data is updated for the first time, which includes the following files taken from the [cognitive-services-speech-sdk repository](https://github.com/Azure-Samples/cognitive-services-speech-sdk/tree/master/sampledata/customspeech/en-US):

* **`training/related-text.txt`:** [Language, or sentences, data](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#related-text-data-for-training) is a type of [related text](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#related-text-data-for-training) that trains language models.
* **`training/pronunciation.txt`:** [Pronunciation data](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#guidelines-to-create-a-pronunciation-file) is the second type of related text that also trains language models. It should be used in moderation to improve the recognition of words, phrases, and acronyms that are outside of a locale's typical vocabulary.
* **`training/audio-and-trans.zip`:** This folder of [audio + human-labeled transcript data](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#audio--human-labeled-transcript-data-for-testingtraining) is used in its entirety to train acoustic models.

To update the training data, navigate to the root of the repository and create a feature branch from master:

```bash
git checkout -b initialSpeechModel
```

Make a change to the file `training/related-text.txt` such as adding the line:

```
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

## Workflow for training data updates

The objective of the first update to training data is to train and test an initial Custom Speech model so that its accuracy can be used as a benchmark to which future models can compare their accuracy.

### Train a new model

Any time training data is updated, the **SpeechTrainDataCICD** workflow will run. When it is updated for the first time, the data from the `training` folder is used to build a new Custom Speech model. Please note that building models will take upwards of 30 minutes.

Once Custom Speech models are created, it is no longer necessary to continue hosting the training data uploads, so these will be deleted within the **SpeechTrainDataCICD** workflow.

### Test the new model

Test the new model's accuracy with [audio + human-labeled transcripts](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#audio--human-labeled-transcript-data-for-testingtraining) in `testing/audio-and-trans.zip`. Models attempt to recognize the .wav files from the `audio` folder, and the recognition is compared to its corresponding text in `trans.txt`.

The test will create a test summary and a test results file. The test summary contains the [Word Error Rate](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/how-to-custom-speech-evaluate-data#what-is-word-error-rate-wer) (WER) for that test, which is an industry-standard metric to measure recognition accuracy. It is the sum of substitutions, deletions, and insertions divided by the number of words in a sentence. Essentially it's a measure of how many words were recognized incorrectly. In future runs, it matters that the WER improves and gets lower over time, but this initial run will simply set a baseline WER for future runs.

The test summary and test results will be stored in an Azure Storage container called `test-results`. An Azure Storage container called `configuration` is also created. It stores a single file, `benchmark-test.txt`, which will point to the test summary file from the initial model. Visit the [Azure Portal](https://ms.portal.azure.com/#home) and navigate to your Azure Storage Account to view these additions.

### Release an endpoint

Finally, a [Custom Speech endpoint](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-deploy-model) is created from this initial model, and a GitHub Release is created that will contain this endpoint and a copy of the repository contents at the time the release was created. Each time an endpoint is released, the repository is tagged with a new version.

## Next steps

Now that you have you created an initial Custom Speech model, attempt to [improve the model](./3-improve-the-model.md) by replacing data in the `testing` and `training` folder with your own data. The initial model is currently the benchmark model since there were no previous models to compare it to.
