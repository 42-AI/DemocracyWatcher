# Specification Document Sentimental BB

# A. WHAT THE PROGRAM DOES


## A1. DATA

The 1st subpart of the program is related to datasets in general.

### A1a. Download/Scrap

**Goal**: Download or scrap data online to store them in data/raw.

#### 1) Use Case Allocine:

For allocine, the download is directly done in make_dataset_allocine (see A1b allocine).

#### 2) Use Case Twitter:

Every day, <span style="color: red;">X</span> tweets mentionning every candidate must be downloaded from twitter to _data/raw/twitter/candidate\_name_ with the command below. The tweets mentionning a candidate must be formatted as such <span style="color: red;">tbd</span> and named as such <span style="color: red;">tbd</span>.

+ Called via CLI
+ Command: `poetry run python -m src data --download twitter`
+ Other Arguments:
  -  <span style="color: red;">tbd</span>
+ Outputs: create csvs containing <span style="color: red;">nb</span> tweets for every candidate in _data/raw/twitter/candidate\_name_

The source code to perform this action must be written in _src/data/download/download\_twitter.py_


### A1b. Make Dataset

**Goal**: From _data/raw_ or _data/processed_, Make a processessed csv dataset.  

#### 1) Use Case Allocine:

There are 2 types of datasets that need to be made for allocine:

#####<span style="color: blue;">1. Train</span>

+  **What it will do**:
   + Load allocine dataset from Datasets hugginfface (Download)
   + Format the dataset in the right format (see output)
   + Export the csv to train
+ Called via CLI
+ **Command:** `poetry run python m src data --task make-dataset --data allocine --split train`
+ **Other Arguments:**
  -  None
+ **Outputs**: creates a csv named _allocine_nbofreviews\_reviews_totrain.csv_ in _data/processed/allocine/train_ with at leat 100 000 reviews formatted as such:
  - 'text': contains the text review
  - 'Positive': contains 1 if review is positive, 0 otherwise
  - 'Negative': contains 1 if review is negative, 0 otherwise

The source code to perform this action must be written in a function in _src/data/make\_dataset/make\_dataset\_allocine.py_


##### <span style="color: blue;">2. Test</span>

+  **What it will do**:
   + Load allocine dataset from Datasets hugginfface (Download). WARNING: not the "train dataset"
   + Format the dataset in the right format (see output)
   + Export the csv in test to be tested
+ Called via CLI
+ **Command:** `poetry run python m src data --task make-dataset --data allocine --split test`
+ **Other Arguments:**
  -  None
+ **Outputs**: creates a csv named _allocine_nbofreviews\_reviews_totest.csv_ with a couple hundreds of reviews in _src/tests_ with thousands of reviews formatted as such:
  - 'text': contains the text review
  - 'Positive': contains 1 if review is positive, 0 otherwise
  - 'Negative': contains 1 if review is negative, 0 otherwise

The source code to perform this action must be written in a function in _src/data/make\_dataset/make\_dataset\_allocine.py_


#### 2) Use Case Twitter:

There are 2 types of datasets that need to be made for twitter:

##### <span style="color: blue;">1. Predict</span>

+  **What it does**: 
    - Given a dates range and a candidate name (either one candidate or all candidates), takes the corresponding csvs in _data/raw/twitter_
    - Concatenates all the csvs for one candidate and a specific day
    - Reformat the columns of the csv
    - Delete the RTs
    - Creates a csv with all the tweets for a specific candidate and for a specific day. 
    - Export the csv
+ Called via CLI
+ **Command**:  `poetry run python m src data --task make-dataset --data twitter --split predict`
+ **Other Arguments**: All are required
    - --candidate: name of candidate ("all" if perform task on all of them): {"Pecresse","Zemmour","Dupont-Aignan","Melenchon","Le Pen","Lassalle","Hidalgo","Macron","Jadot","Roussel","Arthaud","Poutou","all"}
    - --start_time: first day for the date range. format: _yyyy-mm-dd_
    - --end_time: last day for the date range. format: _yyyy-mm-dd_
+ **Outputs**: creates csvs in _data/processed/twitter/predict/day(mmdd)/_ formatted as such:
  - 'candidate': name of candidate (see list above for name format)
  - 'time': timestamp of tweet formatted as such _hh:mm:ss_
  - 'tweet_id': id of tweet
  - 'text': text of tweet
+ **Warning**: If the program must create a csv file that already exists, it will overwrite it.

The source code to perform this action is written in _src/data/make\_dataset/make\_dataset\_twitter.py_


##### <span style="color: blue;">2. Test</span>

+  **What it will do**:
    - From nb tweets (selected by user in CLI) randomly chosen from all the csv files in _data/processed/twitter/predict_ creates one non-labelled csv with all the nb tweets that will later be labelled in order to test a model.
    - **WARNING**: Those tweets must somehow be removed from the predict csvs they've been chosen from.
    - The output csv must have more or less the same number of tweets for each candidate.
    - Once the tweets are all concatenated in one structure, simply add two columns 'Positive' and 'Negative' with zeroes in them. 
    - Warning: Stored in _src/test_ as this small data needs to be git pushed for the unit tests.
+ Called via CLI
+ **Command**:  `poetry run python m src data --task make-dataset --data twitter --split test`
+ **Other Arguments**: all Required
  -  --nb-tweets: Number of tweets to select from all the files (Not more than a couple of hundreeds as we'll have to label them by hands afterwards)
+ **Outputs**: creates a csv as _src/test/nbtweets\_tweets\_date\_unlabelled.csv_ formatted as such:
  - 'candidate': name of candidate
  - 'time': timestamp of tweet formatted as _hh:mm:ss_
  - 'tweet_id': id of tweet
  - 'text': text of tweet
  - 'Positive': every value set to 0 as it yet has to be labelled
  - 'Negative': every value set to 0 as it yet has to be labelled

Once the csv is created, it will have to be manually labelled (via google sheet for exple) and the name of the csv will have to be updated to _nbtweets\_tweets\_date\_labelled.csv_

The source code to perform this action must be written in a function in _src/data/make\_dataset/make\_dataset\_twitter.py_



## A1c. Load Dataset

**Goal**: From csvs in _data/processed_, creates python objects such as np.array or pd.dataframes to be mostly used by functions and classes in models.

**Called**: as a library by other parts of the code

**1) Use Case Models**

<span style="color: red;">tbd</span>


The source code to perform these actions must be written in in _src/data/load\_dataset/.../.py_



## A2. FEATURES

The 2nd subpart of the program build features on top of the data python objects created by _load\_dataset_.

+ Used as a library by other parts of codes
+ Returns: Mainly returns python data objects with new features built on top

Not clear yet if we'll have to use it.

<span style="color: red;">tbd</span>


## A3. MODELS


The 3rd subpart of the program is related to everything related to model training/testing/predicting. In order to function it needs the appropriate dataset(s) made by data/make_dataset.

Before calling the parts here under in the CLI, it's good to know in advance if the needed code to make the needed dataset has already been done.


### A3a. Train

**Goal**: Based on a chosen algo, chosen hyperparameters and chosen train data set stored in _data/processed/train_, train a model and outputs it in the folder _models_ in root. The ouput will mainly consists of weights  

+ Called via CLI <span style="color: red;">(but also as lib?)</span>
+ Command:  <span style="color: red;">tbd</span> 
+ Other Arguments:
  -  <span style="color: red;">tbd</span>
+ Outputs: store weights in a folder in _models/_ <span style="color: red;">tbd</span>

The source code to perform this action must written in _src/models/typeoflibraryused/nameofalgo.py_


### A3b. Test

**Goal**: Based on a chosen train model (weights), a chosen test set in _src/test_ and a chosen perofrmance metric, outputs the score of the model in a file <span style="color: red;">tbd</span> in _data/processed/results_ and outputs the csv used to test with the predictions added somewhere in _data/processed/results_ <span style="color: red;">tbd</span>. 

+ Called via CLI <span style="color: red;">(but also as lib?)</span> 
+ Command:  <span style="color: red;">tbd</span> 
+ Other Arguments:
  -  <span style="color: red;">tbd</span>
+ Outputs: 
  - score of the model in a file <span style="color: red;">tbd</span> in _data/processed/results_
  - csv used to test with the predictions added 'Postivie_pred', 'Negative_pred' somewhere in _data/processed/results_ <span style="color: red;">tbd</span>

The source code to perform this action must written in _src/models/typeoflibraryused/nameofalgo.py_


### A3c. Predict

**Goal**: Based on a chosen train model (weights), a chosen predict set in _data/processed/predict_ and a chosen perofrmance metric outputs the csv used to predict with the predictions added.

The source code to perform this action must written in _src/models/typeoflibraryused/nameofalgo.py_

Based on a csv from a specific candidate on a specific day in _data/processed/predict_, outputs the csv with the predictions.
<span style="color: red;">Possibility to do many candidates and many dates all at once?</span>

+ Called via CLI 
+ Command:  <span style="color: red;">tbd</span> 
+ Other Arguments:
  -  <span style="color: red;">tbd</span>
+ Outputs: csv as _data/processed/results/modelname\_timestampofcommand/day/candidate.csv formatted as such:
  - 'Candidate': candidate name
  - 'pred': 1 if positive, 0 if negative
  - 'datetime': same format as in prodict csv passed in input
  - 'text': text of tweet
  



## A4. TEST


The 4th part of the program is related to all the tests run in the CI/CD process.
For each new block of code, a corresponding unit test need to be added somewhere in _src/tests_ and the function written must start with "test_" to be tested by pytest.


## A5. VISUALIZATION


The 5th part of the program takes csv results and creates charts from it.

<span style="color: red;">tbd</span>


# B. DATA ARCHITECTURE

All the data are stored in the folder _data_ located in the root folder of the project. The data stored is not git push and in order to retrieve it, `dvc pull` must be done.

<span style="color: red;">tbd</span>