# 2. Train an Initial Model

Follow these steps to understand the workflow to contribute to models, understand the data used to train and test models, and create an initial model by making a change to the training data. The initial model will automatically become the benchmark model since there are no previous models to compare it to.

### Table of Contents

* [Pull Request Training Data Updates](#Pull-Request-Training-Data-Updates)
    * [Update Training Data](#Update-Training-Data)
        * [Test Training Data Updates](#Test-Training-Data-Updates)
    * [Create and Merge the Pull Request](#Create-and-Merge-the-Pull-Request)
* [Workflow for Training Data Updates](#Workflow-for-Training-Data-Updates)
    * [Train a New Model](#Train-a-New-Model)
    * [Test the New Model](#Test-the-new-Model)
    * [Release an Endpoint](#Release-an-Endpoint)
* [Next Steps](#Next-Steps)

## Pull Request Training Data Updates

Create a pull request with updates to the training data to trigger the **SpeechTrainDataCICD** workflow which will train an initial model.

### Update Training Data

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

This change is meant to illustrate how to trigger the **SpeechTrainDataCICD** workflow, but after you have walked through this solution, the updates should be meaningful and [attempt to improve the model's recognition](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#guidelines-to-create-a-sentences-file).

Add and commit the changes:

```bash
git add .
git commit -m "Changes to my Custom Speech model."
```

You may [exclude any or all training data](4-advanced-customization.md#Exclude-Training-Data).

#### Test Training Data Updates

The changes to `training/related-text.txt` demonstrate the workflow to update training data. They weren't meant to improve the model and don't need to be tested, but meaningful changes should be tested before a pull request is created. To do so, [create an Azure Speech resource](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/get-started#new-resource) for personal use. [Create a Speech project](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/how-to-custom-speech#how-to-create-a-project) under this resource to test changes you make to training data before they are submitted to a greater audience.

Now you can begin the testing loop. Each of the following three steps should be done in the [Speech Studio](https://speech.microsoft.com/portal/) until it seems that the updates to the training data have improved the model:

1. [Upload training and testing data](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#upload-data)
2. [Train a model for Custom Speech](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/how-to-custom-speech-train-model)
3. [Evaluate Custom Speech accuracy](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/how-to-custom-speech-evaluate-data#create-a-test)

Tests will output a [Word Error Rate](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/how-to-custom-speech-evaluate-data#what-is-word-error-rate-wer) (WER) which can be used to gauge whether or not the changes have generally improved the model. If so, the updates can be submitted in a pull request.

If the model did not improve, more training data should be updated and the testing loop should start over.

### Create and Merge the Pull Request

Push the changes to the remote repository once you are satisfied with how the model is performing:

```bash
git push -u origin initialSpeechModel
```

Click the **Merge pull request** button to merge the pull request into **master**. If you have set up the branch protection policies, it will be necessary to check **Use your administrator privileges** to merge this pull request to complete the merge.

Merge or rebase the pull request into **master**. If everything has been set up properly, the workflow will automatically execute after a few seconds. Navigate to the **Actions** tab of the repository to see the workflow called **SpeechTrainDataCICD** in progress:

![Actions tab showing that the workflow is running](../images/WorkflowRunning.png)

## Workflow for Training Data Updates

The objective of the first update to training data is to train and test an initial Custom Speech model so that its accuracy can be used as a benchmark to which future models can compare their accuracy.

### Train a New Model

Any time training data is updated, the **SpeechTrainDataCICD** workflow will run. When it is updated for the first time, the data from the `training` folder is used to build a new Custom Speech model. Please note that building models will take upwards of 30 minutes.

Once Custom Speech models are created, it is no longer necessary to continue hosting the training data uploads, so these will be deleted within the **SpeechTrainDataCICD** workflow.

### Test the New Model

Test the new model's accuracy with [audio + human-labeled transcripts](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#audio--human-labeled-transcript-data-for-testingtraining) in `testing/audio-and-trans.zip`. Models attempt to recognize the .wav files from the `audio` folder, and the recognition is compared to its corresponding text in `trans.txt`.

The test will create a test summary and a test results file. The test summary contains the [Word Error Rate](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/how-to-custom-speech-evaluate-data#what-is-word-error-rate-wer) (WER) for that test, which is an industry-standard metric to measure recognition accuracy. It is the sum of substitutions, deletions, and insertions divided by the number of words in a sentence. Essentially it's a measure of how many words were recognized incorrectly. In future runs, it matters that the WER improves and gets lower over time, but this initial run will simply set a baseline WER for future runs.

The test summary and test results will be stored in an Azure Storage container called `test-results`. An Azure Storage container called `configuration` is also created. It stores a single file, `benchmark-test.txt`, which will point to the test summary file from the initial model. Visit the [Azure Portal](https://ms.portal.azure.com/#home) and navigate to your Azure Storage Account to view these additions.

### Release an Endpoint

Finally, a [Custom Speech endpoint](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/how-to-custom-speech-deploy-model) is created from this initial model, and a GitHub Release is created that will contain this endpoint and a copy of the repository contents at the time the release was created. Each time an endpoint is released, the repository is tagged with a new version.

To find the best-performing Custom Speech endpoint, navigate to the **Code** tab in the repository, then click the **Releases** sub-tab. At the top of the releases page will be a release with an icon next to it that says **Latest release**, the commit hash the model was built from, and the Custom Speech model's version:

![Latest Release](../images/LatestRelease.png)

The repository was tagged with this new version, and like every tag in **master** it represents an improved Custom Speech model. On the releases page, click on the file **release-endpoints.json** to download it. It will contain the Custom Speech endpoint created in the workflow:

```json
{"ENDPOINT_ID":"########-####-####-####-############"}
```

The latest release will always contain the best-performing Custom Speech endpoint. Users can update endpoints in their client applications to use the latest release at their own discretion.

## Next Steps

Now that you have you created an initial Custom Speech model, attempt to [improve the model](./3-improve-the-model.md) by replacing data in the `testing` and `training` folder with your own data. The initial model is currently the benchmark model since there were no previous models to compare it to.
