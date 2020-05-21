# 2. Train an initial model

Follow these steps to understand the developer workflow, the data used to train and test models, and how to create the initial Custom Speech model.

This initial Custom Speech model will be used as an accuracy benchmark to compare against future models.

This template includes sample data from the [cognitive-services-speech-sdk repository](https://github.com/Azure-Samples/cognitive-services-speech-sdk/tree/master/sampledata/customspeech) for the purposes of this walk through, including:

* **`training/related-text.txt`:** [Language, or sentences, data](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#related-text-data-for-training) is a type of [related text](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#related-text-data-for-training) that trains language models.
* **`training/pronunciation.txt`:** [Pronunciation data](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#guidelines-to-create-a-pronunciation-file) is the second type of related text that also trains language models. It should be used in moderation to improve the recognition of words, phrases, and acronyms that are outside of a locale's typical vocabulary.
* **`training/audio-and-trans.zip`:** This folder of [audio + human-labeled transcript data](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#audio--human-labeled-transcript-data-for-testingtraining) is used in its entirety to train acoustic models.

After you've completed this walk through, replace the data in the repo with your project data to start creating a model specific to your project.

## Table of contents

* [Create Development Speech Project](#Create-Development-Speech-Project)
* [Update the training data](#Update-the-training-data)
* [Test training data effect](#Test-training-data-effect)
* [Create the Pull Request](#Create-the-Pull-Request)
* [Understanding the SpeechTrainDataCICD workflow](#Understanding-the-SpeechTrainDataCICD-workflow)
* [Next steps](#Next-steps)
* [Further Reading](#further-reading)

## Create Development Speech Project

The resources and Speech Project you created in [Setup](1-setup.md#table-of-contents) was for your production model. In this step, you'll create a resource and Speech project you'll use for your personal development and testing, much in the way that you use a feature branch in GitHub.

To create your development project:

1. [Create an Azure Speech resource](https://docs.microsoft.com/azure/cognitive-services/speech-service/get-started#new-resource) in the Azure Resource Group from [Setup](1-setup.md#table-of-contents).
1. [Create a Speech project](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech#how-to-create-a-project) under this resource.

## Update the training data

Update the training data to be used to create the initial model.

To update the training data:

1. Navigate to the root of the repository and create a feature branch from master:

    ```bash
    git checkout -b initialSpeechModel
    ```

1. Change the file `training/related-text.txt` by adding the line below to the end of the file:

    ```xml
    This is language data for my initial model.
    ```

    This change illustrates a training data change that will trigger the GitHub Actions workflow from a Pull Request. After this walk through, you'll make updates that [attempt to improve the model's recognition](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#guidelines-to-create-a-sentences-file).

1. Add and commit the changes:

    ```bash
    git add .
    git commit -m "Changes to my Custom Speech model."
    ```

## Test training data effect

The changes to `training/related-text.txt` represent changes you'll make to your training data to adapt your Custom Speech model to your needs. Changes should be tested to confirm the effect on the model before a pull request is created. Tests will output a [Word Error Rate](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-evaluate-data#what-is-word-error-rate-wer) (WER) you can use to evaluate whether or not the changes have generally improved the model. If so, the updates can be submitted in a pull request.

To do that testing, use your development Speech project.

To test the effect of your changes:

1. Open [Speech Studio](https://speech.microsoft.com/portal/).
1. Open your development Speech project from the prior step.
1. For each change you'd like to evaluate:
    1. Create a datasets by [uploading](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#upload-data) your `training/related-text.txt` and `training/pronunciation.txt` training data.
    1. [Train a dev model](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-train-model) using those datasets.

        >**Note:** Training models can take upwards of 30 minutes.

    1. [Test your dev model](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-evaluate-data#create-a-test) using the test data in `testing/audio-and-trans.zip` get the [Word Error Rate](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-evaluate-data#what-is-word-error-rate-wer) (WER).
    4. Submit a pull request if the (WER) has improved.

If the model did not improve, add more training data and test the effect on the model.

## Create the Pull Request

Once you are satisfied with how your development model is performing based on your changes, create a Pull Request to submit those changes to master they are built into the initial model.

To create the Pull Request:

1. Push your changes:

    ```bash
    git push -u origin initialSpeechModel
    ```

1. Create a Pull Request from **initialSpeechModel** to **master**.
1. Click the **Merge pull request** button to merge the pull request into **master**.
    >**Note:** If you have set up the branch protection policies, it will be necessary to check **Use your administrator privileges** to merge this pull request to complete the merge.

## Examine the GitHub Workflow

When you merge a Pull Request to master, the **SpeechTrainDataCICD** GitHub Actions workflow will automatically execute to create a model, a release, and an endpoint based on your Pull Request.

To confirm the execution of the workflow:

1. Navigate to the **Actions** tab of your main repository.
1. Select **SpeechTrainDataCICD** on the left navigation menu.
1. Select the event that represents your Pull Request.

    ![Actions tab showing that the workflow is running](../images/WorkflowRunning.png)

1. Wait for the jobs to complete successfully.
    > **Note:** Training models can take upwards of 30 minutes.
1. Navigate to the **Code** tab of the main repository.
1. Select **Releases** to see the release created for your Pull Request.

    ![Latest Release](../images/LatestRelease.png)
1. Select `release-endpoints.json` to download the file and view the ID of the [Custom Speech endpoint](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/how-to-custom-speech-deploy-model) created for the model:

    ```bash
    {"ENDPOINT_ID":"########-####-####-####-############"}
    ```

1. Open [Speech Studio](https://speech.microsoft.com/portal/).
1. Open the the main Speech project from [Setup](1-setup.md#table-of-contents).
1. Select **Training** and note the new model created.

## Understanding the SpeechTrainDataCICD workflow

The **SpeechTrainDataCICD** workflow is configured to trigger on a merge to master that includes changes to any of the training data files in the `training` folder in this repo.

This workflow:

* [Trains a new model](#train-a-new-model)
* [Tests the new model](#test-the-new-model)
* [Releases an endpoint](#release-an-endpoint)

During the initial run for a new project, the objective of this first change to training data is to train and test a Custom Speech model. This initial model will be used as an accuracy benchmark to compare against future models.

### Train a new model

Any time training data is updated, the **SpeechTrainDataCICD** workflow will run. When it is updated for the first time, the data from the `training` folder is used to build a new Custom Speech model.

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
