# 3. Improve the model

During the development of a Custom Speech model, developers  improve the accuracy of a model by updating the training data used to train the Custom Speech model, and/or the testing data used to evaluate the accuracy of that model.

Follow these steps to make updates to the training and testing data to illustrate making improvements to the model when compared to the baseline model from [Test the baseline model](2-test-the-baseline-model.md#table-of-contents).

This template includes sample testing data from the [cognitive-services-speech-sdk repository](https://github.com/Azure-Samples/cognitive-services-speech-sdk/tree/master/sampledata/customspeech) for the purposes of this walk through. The `testing/audio-and-trans.zip` file contains [audio + human-labeled transcript data](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#audio--human-labeled-transcript-data-for-testingtraining) used to test your model.

In the steps in this document, you will update the training and testing data and create a pull request containing those updates. That pull request will trigger two GitHub Action workflows:

* **SpeechTestDataCI** triggers on updates to test data. This workflow will retest the benchmark model with the updated test data to calculate the new benchmark Word Error Rate (WER).
* **SpeechTrainDataCICD** triggers on updates to training data. This workflow will build a new model from the training data and test whether the new model has a better WER than the benchmark model. If that new model has a better WER than the benchmark model, the workflow will create a release and endpoint for the new model and the new model will become the new benchmark.

## Table of contents

* [Create a feature branch](#create-a-feature-branch)
* [Update training data](#Update-training-data)
* [Update testing data](#Update-testing-data)
* [Testing the effect of training and testing data updates](#Testing-the-effect-of-training-and-testing-data-updates)
* [Create the pull request](#Create-the-Pull-Request)
* [Confirm the testing workflow results](#Confirm-the-Testing-Workflow-Results)
* [Confirm the training workflow results](#Confirm-the-Training-Workflow-Results)
* [Next steps](#Next-steps)
* [Further reading](#Further-reading)

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

Update the training data to illustrate making a change to [improve the model's recognition](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/how-to-custom-speech-improve-accuracy).

1. Change the file `training/related-text.txt` by adding the line below to the end of the file:

    ```xml
    This is language data for my improved model.
    ```

1. Add and commit the changes:

    ```bash
    git add .
    git commit -m "More training data updates."
    ```

## Update testing data

When developing a custom speech model, you update training data to improve the accuracy of your model. You update the testing data to evaluate that accuracy. Here, you will update the testing data to illustrate making a change to [improve accuracy testing](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/how-to-custom-speech-evaluate-data).

To make changes to the testing data:

1. Unzip the `testing/audio-and-trans.zip` file.
1. Open `trans.txt` and add some text to the beginning of the transcription, for example:

    ```txt
    audio.wav SOME UPDATE Once the test is complete, indicated by the status change to Succeeded, you'll find a WER number for both models included in your test. Click on the test name to view the testing detail page. This detail page lists all the utterances in your dataset, indicating the recognition results of the two models alongside the transcription from the submitted dataset. To help inspect the side-by-side comparison, you can toggle various error types including insertion, deletion, and substitution. By listening to the audio and comparing recognition results in each column, which shows the human-labeled transcription and the results for two speech-to-text models, you can decide which model meets your needs and where additional training and improvements are required.
    ```

    >**Note**: Transcript files are strictly formatted. Do not add an additional line, modify the file name (**audio.wav**) at the beginning of the line, or  delete the tab character separating the filename from the following text. For more details refer to  [audio + human-labeled transcript data](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#audio--human-labeled-transcript-data-for-testingtraining) in the Custom Speech documentation.

1. Zip up the files and replace the original `testing/audio-and-trans.zip`.
1. Add and commit the changes:

    ```bash
    git add .
    git commit -m "Update testing data."
    ```

## Testing the effect of training and testing data updates

Changes should be tested to confirm the effect on the model before a pull request is created. Tests will output a [Word Error Rate](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-evaluate-data#what-is-word-error-rate-wer) (WER) you can use to evaluate whether the changes have improved the model. If so, the updates will be submitted as a pull request.

>**Note**: In this walk through, you will submit your changes as a PR regardless of the WER to illustrate making a change to the training and testing data.

To test the effect of your changes:

1. Open [Speech Studio](https://speech.microsoft.com/portal/).
1. Open your development Speech project from [Test the baseline model](2-test-the-baseline-model#Test-training-data-effect).
1. For each change you'd like to evaluate:
    1. Create datasets by [uploading](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#upload-data) your `training/related-text.txt` and `training/pronunciation.txt` training data.
    1. [Train a model](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-train-model) using those datasets.

        >**Note:** Training models can take upwards of 30 minutes.

    1. [Test your model](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-evaluate-data#create-a-test) using the test data in `testing/audio-and-trans.zip` to get the [Word Error Rate](https://docs.microsoft.com/azure/cognitive-services/speech-service/how-to-custom-speech-evaluate-data#what-is-word-error-rate-wer) (WER).
    1. Submit a pull request if the WER has improved.
    1. If the WER did not improve, add more training data and test the effect on the model.

## Create the pull request

Once you have made your changes, create a pull request to submit those changes to master.

To create the pull request:

1. Push your changes:

    ```bash
    git push -u origin newSpeechModel
    ```

1. Create a pull request from **newSpeechModel** to **master**.
1. Click the **Merge pull request** button to merge the pull request into **master**.
    >**Note:** If you have set up branch protection policies, you will need to check **Use your administrator privileges** to merge the pull request.

## Confirm the testing workflow results

When you merge a pull request that includes testing data updates, the **SpeechTestDataCI** GitHub Actions workflow will run. **SpeechTestDataCI**  retests the benchmark model to calculate the new benchmark WER based on the updated test data.

This ensures that when the WER of any new models are compared with the WER of the benchmark, both models have been tested against the same test data.

GitHub Action workflows stored in the `.github/workflows/` directory will run when triggered. To view the **SpeechTestDataCI** YAML open `.github/workflows/speech-test-data-ci.yml`.

### View the workflow run

To view **SpeechTestDataCI** workflow run for your pull request:

1. Navigate to the **Actions** tab of your main repository.
1. Select the **SpeechTestDataCI** workflow on the left navigation menu.
1. Select the run that represents your pull request.

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

## Confirm the training workflow results

When you merge a pull request that includes training data updates, the **SpeechTrainDataCICD** GitHub Actions workflow will run. Much of the **SpeechTrainDataCICD** workflow is the same as when building the baseline model. The key difference is that the WER of the new model is compared to the WER of the benchmark model, including:

* **WER is better than the benchmark** - The training workflow will pass if the new model has a better WER than the benchmark model. The test summary from the new model will replace the benchmark results in `benchmark-test.txt`. The workflow will create a release and endpoint for the new model.

* **WER is worse than the benchmark** - The workflow fails if the new model's WER is worse than the benchmark model's WER. In this case, the new model will be deleted and the workflow will exit without creating a release and endpoint for the new model.

To view the results of this workflow, follow the training workflow confirmation steps from [Test the baseline model](2-test-the-baseline-model.md#Confirm-the-Workflow-Results).

As a part of the release job, there is a step in place which deletes all but the 5 latest models of the current model kind. 

**Deleting an endpoint should be a manual process because deleting an endpoint has larger ramifications than deleting a model**. Models will not be deleted if they are attached to an endpoint.

## Next steps

Now that you understand how to make training and testing data changes to improve the model, you are ready to start working on your model.

To start working on your model, replace the sample data supplied with this repo with data for your project. Start with small data sets that replicate the language and acoustics that the model will encounter. For example, record audio on the same hardware and in the same acoustic environment as the end solution so that any incompatibilities can be sorted before investing in a larger data set. More audio data can be added at any time using the tools and documentation in this solution. As the data set gets larger, make sure it's diverse and representative of your project's scenario.

Visit [advanced customization](./4-advanced-customization.md) to use alternative branching strategies, change the file structure, and more.

## Further reading

See the following documents for more information on this template and the engineering practices it demonstrates:

* [Setup](1-setup.md#table-of-contents)

* [Test the baseline model](2-test-the-baseline-model.md#table-of-contents)

* [Advanced customization](4-advanced-customization.md#table-of-contents)
