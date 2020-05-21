# 3. Improve the model

Follow these steps to make updates to the training and testing data to attempt to improve the model when compared to the baseline model from [Train an initial model](2-train-an-initial-model.md#table-of-contents).

During the development of a Custom Speech model, developers may make updates to the [training data](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#audio--human-labeled-transcript-data-for-testingtraining) used to train the Custom Speech model, and/or to the [testing data](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#audio--human-labeled-transcript-data-for-testingtraining) used to evaluate the accuracy of that model.

This template includes sample testing data from the [cognitive-services-speech-sdk repository](https://github.com/Azure-Samples/cognitive-services-speech-sdk/tree/master/sampledata/customspeech) for the purposes of this walk through. The `testing/audio-and-trans.zip` file contains [audio + human-labeled transcript data](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#audio--human-labeled-transcript-data-for-testingtraining) used to test  models.

In the steps in this document, you will update both the training and the testing data and create a Pull Request with those updates. Those updates will trigger two GitHub Action workflows:

* **SpeechTrainDataCICD** triggers on updates to training data. Its job is to build a new model from the training data and to test whether the new model has a better Word Error Rate (WER) than the benchmark model.
* **SpeechTestDataCI** triggers on updates to test data. Its job is to retest the benchmark model to calculate the new WER for the benchmark model with the changed test data.

The new model must have a better WER than a benchmark model for the workflow to release an endpoint for the new model and for the new model to become the new benchmark for future iterations.

## Table of contents

* [Create a feature branch](#create-a-feature-branch)
* [Update training data](#Update-training-data)
* [Update testing data](#Update-testing-data)
* [Test training and testing data effect](#Test-training-and-testing-data-effect)
* [Create the Pull Request](#Create-the-Pull-Request)
* [Confirm the Testing Workflow Results](#Confirm-the-Testing-Workflow-Results)
* [Confirm the Training Workflow Results](#Confirm-the-Training-Workflow-Results)
* [Next steps](#Next-steps)

## Create a feature branch

Create a feature branch for your updates to the training and testing data.

To create a feature branch:

1. Navigate to the root of the repository and create a feature branch from master:

    ```bash
    git checkout master
    git pull
    git checkout -b newSpeechModel
    ```

## Update training data

Update the training data to simulate a change to improve the model performance compared to the benchmark.

1. Change the file `training/related-text.txt` by adding the line below to the end of the file:

    ```xml
    This is language data for my second model.
    ```

    This change illustrates a training data change that will trigger the GitHub Actions workflow. After this walk through, you'll make updates that [attempt to improve the model's recognition](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#guidelines-to-create-a-sentences-file).

1. Add and commit the changes:

    ```bash
    git add .
    git commit -m "More training data updates."
    ```

## Update testing data

Update the testing data to simulate making updates to your testing data.

To make changes to the testing data:

1. Unzip the `testing/audio-and-trans.zip` file.
1. Open `trans.txt` and add some text to the beginning of the transcription, for example:

    ```txt
    audio.wav SOME UPDATE Once the test is complete, indicated by the status change to Succeeded, you'll find a WER number for both models included in your test. Click on the test name to view the testing detail page. This detail page lists all the utterances in your dataset, indicating the recognition results of the two models alongside the transcription from the submitted dataset. To help inspect the side-by-side comparison, you can toggle various error types including insertion, deletion, and substitution. By listening to the audio and comparing recognition results in each column, which shows the human-labeled transcription and the results for two speech-to-text models, you can decide which model meets your needs and where additional training and improvements are required.
    ```

    >**Note**: Transcript files strictly formatted.     Do not add an additional line, modify the file name (**audio.wav**) at the beginning of the line, or  delete the tab character separating the filename from the following text. For more details refer to the [audio + human-labeled transcript data](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#audio--human-labeled-transcript-data-for-testingtraining) in the Custom Speech documenation.

1. Zip up the files and replace the original `testing/audio-and-trans.zip`.
1. Add and commit the changes:

    ```bash
    git add .
    git commit -m "Update testing data."
    ```

## Test training and testing data effect

Changes should be tested to confirm the effect on the model before a Pull Request is created. Tests will output a [Word Error Rate](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-evaluate-data#what-is-word-error-rate-wer) (WER) you can use to evaluate whether the changes have improved the model. If so, the updates can be submitted in a Pull Request.

To do that testing, use the same development Speech project from [Train an Initial Model](2-train-an-initial-model#Test-training-data-effect).

To test the effect of your changes:

1. Open [Speech Studio](https://speech.microsoft.com/portal/).
1. Open your development Speech project from [Train an Initial Model](2-train-an-initial-model#Test-training-data-effect).
1. For each change you'd like to evaluate:
    1. Create a datasets by [uploading](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#upload-data) your `training/related-text.txt` and `training/pronunciation.txt` training data.
    1. [Train a dev model](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-train-model) using those datasets.

        >**Note:** Training models can take upwards of 30 minutes.

    1. [Test your dev model](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-evaluate-data#create-a-test) using the test data in `testing/audio-and-trans.zip` to get the [Word Error Rate](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-evaluate-data#what-is-word-error-rate-wer) (WER).
    1. Submit a Pull Request if the WER has improved.

If the model did not improve, add more training data and test the effect on the model.

## Create the Pull Request

Once you are satisfied with your changes, create a Pull Request to submit those changes to master.

To create the Pull Request:

1. Push your changes:

    ```bash
    git push -u origin newSpeechModel
    ```

1. Create a Pull Request from **newSpeechModel** to **master**.
1. Click the **Merge pull request** button to merge the pull request into **master**.
    >**Note:** If you have set up the branch protection policies, it will be necessary to check **Use your administrator privileges** to merge this pull request to complete the merge.

## Confirm the Testing Workflow Results

When you merge a Pull Request to master that includes testing data updates, the **SpeechTestDataCI** GitHub Actions workflow will execute. **SpeechTestDataCI**  retests the benchmark model to calculate the new benchmark WER based on the new test data.

This ensures that when the WER of any new models are compared with the WER of the benchmark, both models have been tested against the same test data.

### Review the workflow

To view the **SpeechTestDataCI** workflow:

1. Open `.github/workflows/speech-test-data-ci.yml`.
1. Review the code in the workflow.

### View the workflow run

The **SpeechTestDataCI** workflow is configured to trigger on a merge to master that includes changes to any of the training data  in the `testing` folder.

To view workflow run for your Pull Request:

1. Navigate to the **Actions** tab of your main repository.
1. Select **SpeechTestDataCI** on the left navigation menu.
1. Select the event that represents your Pull Request.

    ![Actions tab showing that the workflow is running](../images/WorkflowRunning.png)

1. Wait for the jobs to complete successfully.
1. Familiarize yourself with the jobs and tasks in the workflow.

### View the test results

The test summary and test results are saved in the `test-results` container that was created during the first execution of the workflow. The file `benchmark-test.txt` in the `configuration` container will be overwritten to contain the name of the benchmark test summary file that was created in this run.

To view the test results and benchmark:

1. Open [Azure Portal](https://ms.portal.azure.com/#home) and navigate the Azure Storage Account created in [Setup](1-setup.md#table-of-contents).
1. Under **Tools and SDKs**, select **Storage Explorer (preview)**.
1. Select **BLOB CONTAINERS** in the navigation menu on the left.
1. Select the **test-results** container.
1. Open the `test-summary-from-train-data-update-XXXXXXX.json` file to view the test results from your baseline model.
1. Select the **configuration** container.
1. Open `benchmark-test.txt` and confirm it contains the name of the test summary file from the baseline model.

## Confirm the Training Workflow Results

While much of the workflow for updates to training data is the same as the baseline model, the key difference is that the WER of the new model is compared to the WER of the benchmark model.

* **WER is better than the benchmark** - The training workflow will pass if the new model has a better WER than the benchmark model. The test summary from the new model will replace the benchmark results in `benchmark-test.txt`. The workflow will create a release and endpoint for the new model.

* **WER is worse than the benchmark** - The workflow fails if the new model's WER is worse than the benchmark model's WER. In this case, the new model will be deleted and the workflow will exit without creating a release and endpoint for the new model.

To view the results of this workflow, follow the training workflow confirmation steps from [Train an initial model](2-train-an-initial-model.md#Confirm-the-Workflow-Results).

## Next steps

Now you are able to make changes to training and testing data make improvements to your model, replace the sample data supplied with this repo with data for your project scenario.

Start with small data sets that replicate the acoustics and language that the project will encounter. For example, record audio on the same hardware and in the same acoustic environment as the end solution so that any incompatibilities can be sorted before investing in a larger data set. More audio data can be added at any time using the tools and documentation in this solution. As the data grows make sure it is diverse and representative of your project's scenario.

Visit [advanced customization](./4-advanced-customization.md) to use alternative branching strategies, change the file structure, and more.
