# EnzyHTP Document Repo


## How to work on this document

The document is built with Sphinx and published on ReadtheDoc

### 0. Clone this repo to your local machine

```
clone https://github.com/ChemBioHTP/enzyhtp_doc.git
```
You will be making changes locally and push to this repo.  
**make a new branch of your won if you want to make any chance and merge into main with a PR**

### 1. Install Sphinx environment
```
conda env create -n sphinx -f env.yml
conda activate sphinx
```

### 2. Make some change
All our documents are under /docs/source  
They are written in reStrcutureText (.rst).  
You can reference existing files to make new file or changes.  
The main page is index.rst

### 3. Build webpage
We build the site locally to preview the changes and debug. Normally we will make a commit to the repo after made enough changes of a small unit.
```
cd docs
make html
```
This will build webpages as .html files under the /docs/build folder.  
You can preveiw those .html files in your local browser.  
If you are using VSCode, you can install the `Live Server` extension that allows you to open the 
html file in a live server and view your changes in real time.  

### 4. Build the website
I. PR your changes to and get reviewed and merged to main   
II. Contact QZ (shaoqz@icloud.com) to publish a new build on our ReadtheDocs website

## How to write tutorial

### The design of the API tutorial

https://enzyhtp-doc.readthedocs.io/en/latest/sci_api_tutorial/how_to_assemble.html#read-the-tutorial-and-find-out-the-prerequisite-science-apis

### The design of the dataflow diagram

https://drive.google.com/drive/folders/14w8FR7LnNNHxRBCrfSlfURXtTENUDc5V?usp=sharing

### How to learn the API for your tutorial

1. read the docstring of the API
2. try the unit test for this API (under `test/`)
3. recycle the docstring as much as possible into your tutorial
