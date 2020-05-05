# 3. Improve Custom Speech Models

At this point an initial Custom Speech model has been created. Now the objective becomes maintaining or updating the benchmark model as testing and training data are updated.

### Table of Contents

* [Pull Request More Data Updates](#Pull-Request-More-Data-Updates)
    * [Update Testing and Training Data](#Update-Testing-and-Training-Data)
    * [Test Training Data Updates](#Test-Training-Data-Updates)
    * [Create and Merge the Pull Request](#Create-and-Merge-the-Pull-Request)
* [Workflow for Testing Data Updates](#Workflow-for-Testing-Data-Updates)
    * [Test](#Test)
* [Workflow for Training Data Updates](#Workflow-for-Training-Data-Updates)
    * [Train](#Train)
    * [Test](#Test-1)
        * [Fail](#Fail)
        * [Pass](#Pass)
    * [Release](#Release)
* [Next Steps](#Next-Steps)

## Pull Request More Data Updates

Again, the workflow will run when data in the `testing` or `training` folder is updated. Now that an initial model has been created, there is additional functionality in the workflow.

### Update Testing and Training Data

Update both the testing and training data. In the root of the repository, checkout and update the **master** branch. From there, create a feature branch:

```bash
git checkout master
git pull
git checkout -b newSpeechModel
```

An initial model has already been created, so now attempt to create a better model by updating `training/related-text.txt` such as adding the line:

```txt
This is more language data for my second model.
```

Also make changes to `testing/audio-and-trans.zip`. Unzip the file, and edit the text in `trans.txt`. Transcript files must be formatted a certain way so do not add an additional line, modify the written file name, or delete the tab character. For example:

```txt
audio.wav	SOME CHANGE Once the test is complete, indicated by the status change to Succeeded, you'll find a WER number for both models included in your test. Click on the test name to view the testing detail page. This detail page lists all the utterances in your dataset, indicating the recognition results of the two models alongside the transcription from the submitted dataset. To help inspect the side-by-side comparison, you can toggle various error types including insertion, deletion, and substitution. By listening to the audio and comparing recognition results in each column, which shows the human-labeled transcription and the results for two speech-to-text models, you can decide which model meets your needs and where additional training and improvements are required. 
```

Zip the `audio` folder and `trans.txt` into a .zip called `audio-and-trans.zip`, and use this file to replace the original `testing/audio-and-trans.zip`. Add and commit the changes:

```bash
git add .
git commit -m "More changes to my Custom Speech model."
```

### Test Training Data Updates

Again, for the purposes of this sample it is not necessary to test updates to training data before they are submitted in a Pull Request. However, for a production-worthy project [test updates to the training data](2-create-the-initial-custom-speech-model.md#Locally-Test-Training-Data-Updates) in the same way described before.

### Create and Merge the Pull Request

Push the changes to the remote repository:

```bash
git push -u origin newSpeechModel
```

Create and approve a Pull Request from the branch **newSpeechModel** into **master**.

Merge or rebase the Pull Request and again navigate to the **Actions** tab of the repository to check out the workflows called **SpeechTrainDataCICD** and **SpeechTestDataCI** in progress.

## Workflow for Testing Data Updates

As you build and compare new Custom Speech models, it is important to have a fair comparison. Any time testing data is updated, the **SpeechTestDataCI** workflow will run to ensure this fair comparison.

Imagine the initial model is tested, and after that, the test data is updated for new models to be tested on. It is impossible to fairly compare the models in isolation because both the models and the test data have changed, which could lead to a skewed Word Error Rate (WER).

To solve this problem, the workflow creates a new benchmark WER when there are updates to test data.

### Test

When test data is updated, it will be uploaded to Speech and used to test the latest Custom Speech model, which is also the benchmark or best-performing model. The WER from this test will become the benchmark WER regardless of if it has improved or not compared to the last results.

The test summary and test results are saved in the `test-results` container that was created during the first execution of the workflow. The file `benchmark-test.txt` in the `configuration` container will be overwritten to contain the name of the benchmark test summary file that was created in this workflow.

Even when testing and training data are updated in the same run, testing the test data updates will execute first.

Now when Custom Speech models are created and tested, they are guaranteed to be fairly compared to the benchmark WER from the test data update.

## Workflow for Training Data Updates

While much of the workflow for updates to training data is the same as the initial model, the key difference is that endpoints will only be created for models with a better WER than the benchmark.

### Train

The process of [training a Custom Speech model](./2-initial-custom-speech-model.md#Train) is the same for the initial and subsequent models.

### Test

The process of [testing a Custom Speech model](./2-initial-custom-speech-model.md#Test) is the same for the initial and subsequent models. Same as before, the test summary and test results will be stored in the `test-results` container. The big difference is that with an initial or benchmark model already created, there is something to compare the new model to.

The name of the benchmark test summary is in `benchmark-test.txt`. This summary contains the WER that the new model must beat in order to pass.

#### Fail

The workflow will fail when the new model has a worse WER than the benchmark model. The new model will be deleted and the workflow will exit without executing the **release** job.

#### Pass

The workflow will pass when the new model has a better WER than the benchmark model. The test summary from the new model will replace the benchmark results in `benchmark-test.txt`. The workflow will continue and execute the **release** job.

### Release

The **release** job will only execute for improved models. The process of [releasing a Custom Speech endpoint](./2-initial-custom-speech-model.md#Release) is the same for the initial and subsequent models.

## Next Steps

You can now continuously improve Custom Speech models simply by updating testing and training data in your repository. [Advanced Customization](./4-advanced-customization.md) options exist for those hoping to use alternative storage options, file structures, and more.
