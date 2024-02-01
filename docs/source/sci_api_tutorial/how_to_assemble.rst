==============================================
 How to Assemble a Workflow
==============================================

.. note::

    | **You dont need to know how to code in Python to use EnzyHTP!**
    | **This tutorial will guide you step-by-step making the workflow you want
        using the API tutorials. (in 5 min)**

EnzyHTP is a python library which means it doesn't have any
direct executables but instead provides modular functions as
building blocks of any customized workflow from users. In other
word, user needs to writing a main script calling EnzyHTP functions
to furnish their automated workflow. However, this can be done easily
following the step-by-step guide below.

You just need to know how to import and call a function in Python. (this can be learned in 3 min by asking this to ChatGPT.)

1. Clarify Your Target
==============================================

Ask yourself, 
    
    | *Q1: What scientific question do you want to study?*
    | *Q2: How does modeling help answering that question?*
    | *Q3: what metrics do you want to calculate from the HTP workflow?*

| For example, if I want to study "how the internal electric field of the enzyme
    changes upon mutations and thus changes the catalysis" *(answer of Q2)*
| The metrics I want to calculate will be the internal electric field of the enzyme
    along the break bond at the center of the bond. *(answer of Q3)*

| (note that there are some details about the model that matters, e.g.: should some
    geometry constrains be applied during the MD simulation etc. but you dont need
    to worry about them now. The guide will resolve it for you as you proceed.)

**Now you know what you want! Let's find out how to achieve it.**

2. Find the Science API that Directly Gives What You Need
==========================================================================

.. note::

    Science API is a special concept in EnzyHTP. They stands for those top-layer APIs
    the are supposed to be used in assembling the workflow.

Use the searching box on this website and search based on the keywords from
your answer of Q3. 

    For the electric field (EF) example, I will try "electric field", "field strength"
    and find ``ele_field_strength_at_along`` Science API.

Or

You can also try to find based on the code "taxonomy". The module names of EnzyHTP
is pretty informative and you can find the one that is relevant to your target.

    For the electric field (EF) example, I will look into "enzy_htp/analysis" and find "electric_field.py"
    and find the ``ele_field_strength_at_along`` Science API.

**You will find a detailed tutorial of how to use this Science API.**

3. Read the Tutorial and Find Out the Prerequisite Science APIs
=========================================================================================

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    The tutorial of the Science API will contain 

    - ``Briefs`` section
        that briefly explains what does it do and the science behind this API.

    - ``Input/Output`` section
        This section will tell you 

        - What input information you should prepare

        - How to obtain those input information (either form **clarification** of what you need, or from other **Science APIs**.)

        - What output you should expect.
        
        | 
        | There will be a dataflow diagram in this section.

    - ``Arguments`` section

        | This section will explain every available arguments of this Science API.
        | There will be presented as *frequently used arguments* and *rarely used arguments* (folded).
        | There will also be advices of how to set the value of each arguments

    - ``Example`` section

        This section will give example codes of this Science API in most of its use cases.

1. Import this API and write it into your main script.
2. With the tutorial you will know what other Science APIs you need to as the input of this API.
3. Go to their tutorial.

4. Repeat Step 3 Iteratively
=========================================================================================
until there are no more APIs needed

5. Done! and Run It
=========================================================================================
Now you finished the main script for your workflow! It is the time for launching it.

Here is what your working directory should look like before launching:

.. code:: bash

    .
    ├── workflow_main.py
    ├── template_hpc_submission.sh
    ├── your_target_enzyme.pdb
    └── ncaa_lib # (optional) add this when you customize ligand parameters
        ├── XYZ_AM1BCC_GAFF2.frcmod # XYZ is the ligand 3-letter code
        └── XYZ_AM1BCC_GAFF2.mol2

(``template/template_wk_dir`` give an example of such a working dir before putting ``workflow_main.py`` in)

``template_hpc_submission.sh`` is the job submission script for our workflow main script (``workflow_main.py``).
This main script runs only requires 1 CPU and 10GB memory.
It will submit computationally intensive jobs in the workflow to other computing nodes. (e.g.: MD and QM) 
The walltime for the main script should cover the maximum time span of your workflow.

.. dropdown:: :fa:`eye,mr-1` **Do this** if you are NOT in Vanderbilt...

    You may also need to modify the ``template_hpc_submission.sh`` to match with your local cluster. Here are some instructions:

    In ``template_hpc_submission.sh``:

    1. Change ``line 1-10`` (resource settings) to match your local cluster's scheduler syntax. (checkout the submission script you normally use)
    2. Change ``line 12-24`` (environment settings) to match your local environmental setting (e.g.: how you normally load Gaussian, AmberTool, and Multiwfn)
    3. (TODO) also change the script name

.. dropdown:: :fa:`eye,mr-1` **Do this** if you are in Vanderbilt...

    In ``template_hpc_submission.sh``:

    1. Change ``xxx`` in ``line 3`` to a valid value. (e.g.: yang_lab)
    2. Change ``EFdesMD`` in ``line 2`` to a customized name for your workflow
    3. Change the path of conda ``line 22`` and the path of EnzyHTP ``line 24`` to match your own paths

Now submit the main script under this working directory. Here is an example command for submission on ACCRE @Vanderbilt:

.. code:: bash

    sbatch template_hpc_submission.sh

**Now wait for results and enjoy the power of automation of EnzyHTP!**
