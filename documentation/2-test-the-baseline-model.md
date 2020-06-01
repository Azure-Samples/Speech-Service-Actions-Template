# 2. Test the baseline model

Follow these steps to understand the workflow and create the baseline Custom Speech model.

This baseline Custom Speech model will be used as an accuracy benchmark to compare against future models.

This template includes sample data from the [cognitive-services-speech-sdk repository](https://github.com/Azure-Samples/cognitive-services-speech-sdk/tree/master/sampledata/customspeech) for the purposes of this walk through, including:

* **`training/related-text.txt`:** [Language, or sentences, data](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#related-text-data-for-training) is a type of [related text](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#related-text-data-for-training) used to improve language mode accuracy when recognizing product names, or industry-specific vocabulary within the context of a sentence.
* **`training/pronunciation.txt`:** [Pronunciation data](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#guidelines-to-create-a-pronunciation-file) is the second type of related text used to improve language mode accuracy when recognizing uncommon terms, acronyms, or other words with undefined pronunciations.
* **`training/audio-and-trans.zip`:** Contains [audio + human-labeled transcript data](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#audio--human-labeled-transcript-data-for-testingtraining) used to train acoustic models.

After you've completed this walk through, replace the data in the repo with your project data to start creating a model specific to your project.

## Table of contents

* [Create development Speech Project](#Create-Development-Speech-Project)
* [Update the training data](#Update-the-training-data)
* [Test training data effect](#Test-training-data-effect)
* [Create the pull request](#Create-the-Pull-Request)
* [Confirm the workflow results](#Confirm-the-Workflow-Results)
* [Next steps](#Next-steps)
* [Further reading](#further-reading)

## Create development Speech Project

The resources and Speech Project you created in [Setup](1-setup.md#table-of-contents) was for your main model. In this step, you'll create a resource and Speech project you'll use for your personal development and testing.

To create your development project:

1. [Create an Azure Speech resource](https://docs.microsoft.com/azure/cognitive-services/speech-service/get-started#new-resource) in the Azure Resource Group from [Setup](1-setup.md#table-of-contents).
1. [Create a Speech project](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech#how-to-create-a-project) under this resource.

## Update the training data

Update the training data to be used to create the baseline model.

To update the training data:

1. Navigate to the root of the repository and create a feature branch from **master**:

    ```bash
    git checkout -b baselineSpeechModel
    ```

1. Change the file `training/related-text.txt` by adding the line below to the end of the file:

    ```xml
    This is language data for my baseline model.
    ```

    This change illustrates a training data change that will trigger the GitHub Actions workflow. After this walk through, you'll make updates that [attempt to improve the model's recognition](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#guidelines-to-create-a-sentences-file).

1. Add and commit the changes:

    ```bash
    git add .
    git commit -m "Changes to my Custom Speech model."
    ```

## Test training data effect

The changes to `training/related-text.txt` represent changes you'll make to your training data to adapt your Custom Speech model to your needs. Before a pull request is created, the changes should be tested to confirm that they will improve a model's recognition. [Word error rate](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-evaluate-data#what-is-word-error-rate-wer) (WER) is a metric output from the tests that you can use to evaluate a model's recognition accuracy. If the WER improves, the updates can be submitted in a pull request.

To do that testing, use your development Speech project.

Use your development Speech Project to test the effect of your changes:

1. Open [Speech Studio](https://speech.microsoft.com/portal/).
1. Open your development Speech project from the prior step.
1. For each change you'd like to evaluate:
    1. Create a datasets by [uploading](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#upload-data) your `training/related-text.txt` and `training/pronunciation.txt` training data.
    1. [Train a dev model](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-train-model) using those datasets.

        >**Note:** Training models can take upwards of 30 minutes.

    1. [Test your dev model](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-evaluate-data#create-a-test) using the test data in `testing/audio-and-trans.zip` to get the [Word Error Rate](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-evaluate-data#what-is-word-error-rate-wer) (WER).
    1. Submit a pull request if the (WER) has improved.

If the model did not improve, add more training data and test the effect on the model.

## Create the pull request

Once you are satisfied with how your development model performs based on your changes, create a pull request to submit those changes to **master**.

To create the pull request:

1. Push your changes:

    ```bash
    git push -u origin baselineSpeechModel
    ```

1. Create a pull request from **baselineSpeechModel** to **master**.
1. Click the **Merge pull request** button to merge the pull request into **master**.
    >**Note:** If you have set up the branch protection policies, it will be necessary to check **Use your administrator privileges** to merge this pull request to complete the merge.

## Confirm the Workflow Results

When you merge a pull request to **master**, the **SpeechTrainDataCICD** GitHub Actions workflow executes to train a model, test the model, and if the WER improves, create a GitHub release and an endpoint from that model.

GitHub Action workflows stored in the `.github/workflows/` directory will run when triggered. To view the **SpeechTrainDataCICD** YAML open `.github/workflows/speech-train-data-ci-cd.yml`.

### View the workflow run

The **SpeechTrainDataCICD** workflow triggers on a merge to **master** that includes changes to any of the training data  in the `training` folder.

To view workflow run for your pull request:

1. Navigate to the **Actions** tab of your repository.
1. Select **SpeechTrainDataCICD** on the left navigation menu.
1. Select the event that represents your pull request.

    ![Actions tab showing that the workflow is running](../images/WorkflowRunning.png)

1. Wait for the jobs to complete successfully.
    > **Note:** Training models can take upwards of 30 minutes.
1. Familiarize yourself with the jobs and steps in the workflow.

### View the model

When training data is merged to **master**, the data from the `training` folder is used to build a Custom Speech model.

To view the model:

1. Open [Speech Studio](https://speech.microsoft.com/portal/).
1. Open the the main Speech project from [Setup](1-setup.md#table-of-contents).
1. Select **Training** and note the new model created.

### View the test results

Once the new model is built, the workflow tests the new model's accuracy using [audio + human-labeled transcripts](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#audio--human-labeled-transcript-data-for-testingtraining) in `testing/audio-and-trans.zip`.

Testing creates a test summary and a test results file. The test summary contains the [Word Error Rate](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-evaluate-data#what-is-word-error-rate-wer) (WER) for that test, which is an industry-standard metric to measure recognition accuracy.

The workflow stores the test summary and test results in an Azure Storage container called `test-results`. The workflow also creates an Azure Storage container called `configuration` with a single file, `benchmark-test.txt`. This file contains the name of the test summary file for the model with the best Word Error Rate, establishing a benchmark to compare future models against.

To view the test files and the file name of the current benchmark test summary:

1. Open [Azure Portal](https://ms.portal.azure.com/#home) and navigate the Azure Storage Account created in [Setup](1-setup.md#table-of-contents).
1. Under **Tools and SDKs**, select **Storage Explorer (preview)**.
1. Select **BLOB CONTAINERS** in the navigation menu on the left.
1. Select the **test-results** container.
1. Open the `test-summary-from-train-data-update-XXXXXXX.json` file to view the test results from your baseline model.
1. Select the **configuration** container.
1. Open `benchmark-test.txt` and confirm it contains the name of the test summary file from the baseline model.

### View the release and endpoint

Finally, if the word error rate improves, the workflow creates a GitHub release and a [Custom Speech endpoint](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-deploy-model) for the model. The GitHub release contains a copy of the repository contents at the time the release was created, along with a JSON file that contains the endpoint.

Update endpoints in client applications to use the latest release at your own discretion.

To view the release and endpoint:

1. Navigate to the **Code** tab of the main repository.
1. Select **Releases** to see the release created for your pull request.

    ![Latest Release](../images/LatestRelease.png)
1. Select `release-endpoints.json` to download the file and view the ID of the [Custom Speech endpoint](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/how-to-custom-speech-deploy-model) created for the model:

    ```bash
    {"ENDPOINT_ID":"########-####-####-####-############"}
    ```

## Next steps

Now that you understand the workflow and you've created the baseline Custom Speech model, in the next step you'll attempt to [improve the model](./3-improve-the-model.md) by replacing data in the `testing` and `training` folders and comparing the results against the baseline model.

## Further Reading

See the following documents for more information on this template and the engineering practices it demonstrates:

* [Setup](1-setup.md#table-of-contents)

* [Improve the model](3-improve-the-model.md#table-of-contents)

* [Advanced customization](4-advanced-customization.md#table-of-contents)
