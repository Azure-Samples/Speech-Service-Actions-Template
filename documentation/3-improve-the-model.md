# 3. Improve the model

Compare the word error rate from new models to the WER from benchmark models to determine if the changes improve the new model's recognition overall. Follow these steps to understand that model comparison and attempt to improve a model by updating the training data.

### Table of contents

* [Create pull request for data updates](#Create-pull-request-for-data-updates)
    * [Update testing data](#Update-testing-data)
    * [Update training data](#Update-training-data)
    * [Create and merge the pull request](#Create-and-merge-the-pull-request)
* [Workflow for testing data updates](#Workflow-for-testing-data-updates)
    * [Test the previous model](#Test-the-previous-model)
* [Workflow for training data updates](#Workflow-for-training-data-updates)
    * [Train a new model](#Train-a-new-model)
    * [Test the new model](#Test-the-new-model)
        * [Fail](#Fail)
        * [Pass](#Pass)
    * [Release an endpoint](#Release-an-endpoint)
* [Next steps](#Next-steps)

## Create pull request for data updates

First, update the testing data to understand the **SpeechTestDataCI** workflow. Then attempt to improve upon the initial model by creating a pull request with updates to the training data as well. A new model must have a better WER than a benchmark model to release an endpoint and become the benchmark for future iterations.

To begin an attempt to train a better model, navigate to the root of the repository, and create a feature branch:

```bash
git checkout master
git pull
git checkout -b newSpeechModel
```

### Update testing data

To make changes to `testing/audio-and-trans.zip`, unzip the file and edit the text in `trans.txt`. Transcript files must be formatted a certain way so do not add an additional line, delete the tab character, or modify the file name on the left-hand side of the tab. For example:

```txt
audio.wav	SOME UPDATE Once the test is complete, indicated by the status change to Succeeded, you'll find a WER number for both models included in your test. Click on the test name to view the testing detail page. This detail page lists all the utterances in your dataset, indicating the recognition results of the two models alongside the transcription from the submitted dataset. To help inspect the side-by-side comparison, you can toggle various error types including insertion, deletion, and substitution. By listening to the audio and comparing recognition results in each column, which shows the human-labeled transcription and the results for two speech-to-text models, you can decide which model meets your needs and where additional training and improvements are required. 
```

Zip the files in the same structure as before and replace the original `testing/audio-and-trans.zip`. Add and commit the changes:

```bash
git add .
git commit -m "Update testing data."
```

### Update training data

Attempt to create a better model than the benchmark by updating data in the `training` folder. For example, add a line to `training/relate-text.txt` such as:

```txt
This is language data for my second model.
```

Add and commit the changes to the three types of training data:

```bash
git add .
git commit -m "Update training data."
```

[Test meaningful updates to the training data](2-train-an-initial-model.md#Test-training-data-updates) before they are submitted in a pull request.

### Create and merge the pull request

Push the changes to the remote repository:

```bash
git push -u origin newSpeechModel
```

Create and approve a pull request from the branch **newSpeechModel** into **master**.

Merge or rebase the pull request and again navigate to the **Actions** tab of the repository to check out the workflows called **SpeechTrainDataCICD** and **SpeechTestDataCI** in progress.

## Workflow for testing data updates

**SpeechTestDataCI** ensures that new models are compared fairly to benchmark models. For example, if test data updates weren't handled and the WER improved, there would be no way of knowing if the WER improved because the new model has better recognition, or because the updates to the test data were easier to recognize.

To solve this problem, when test data is updated, the **SpeechTestDataCI** workflow re-tests the benchmark model using the updated data. The WER from this test becomes the WER for future models to beat, whether or not it has improved.

### Test the previous model

Test the benchmark model with the updated data which outputs test results and a test summary. The test summary contains the WER for future models to beat, regardless of whether or not it has improved compared to when the benchmark model was tested last.

The test summary and test results are saved in the `test-results` container that was created during the first execution of the workflow. The file `benchmark-test.txt` in the `configuration` container will be overwritten to contain the name of the benchmark test summary file that was created in this workflow.

**SpeechTestDataCI** guarantees that when a new models is trained and tested, its WER will be fairly compared to the WER from the test data update.

## Workflow for training data updates

While much of the workflow for updates to training data is the same as the initial model, the key difference is that endpoints will only be created for models with a better WER than the benchmark.

### Train a new model

The process of [training a model](./2-initial-custom-speech-model.md#Train) is the same for the initial and subsequent models.

### Test the new model

The process of [testing a model](./2-initial-custom-speech-model.md#Test) is the same for the initial and subsequent models. Same as before, the test summary and test results will be stored in the `test-results` container. The big difference is that with an initial or benchmark model already created, there is something to compare the new model to.

The name of the benchmark test summary is in `benchmark-test.txt`. This summary contains the WER that the new model must beat in order to pass.

#### Fail

The workflow fails if the new model's WER is worse than the benchmark model's WER. In this case, the new model will be deleted and the workflow will exit without executing the **release** job.

#### Pass

The workflow will pass when the new model has a better WER than the benchmark model. The test summary from the new model will replace the benchmark results in `benchmark-test.txt`. The workflow will continue and execute the **release** job.

### Release an endpoint

The **release** job executes after models improve. The process of [releasing a Custom Speech endpoint](./2-initial-custom-speech-model.md#Release) is the same for the initial and subsequent models.

## Next steps

Now you are able to continuously improve and manage models with the tools and resources in this repository. Visit [advanced customization](./4-advanced-customization.md) to use alternative branching strategies, change the file structure, and more.

The solution is using the provided sample data, so be sure to replace it with data for your project's scenario. Start with small data sets that replicate the acoustics and language that the project will encounter. For example, record audio on the same hardware and in the same acoustic environment as the end solution so that any incompatibilities can be sorted before investing in a larger data set. More audio data can be added at any time using the tools and documentation in this solution, and as the data grows it should be diverse and representative of your project's scenario at that given time.
