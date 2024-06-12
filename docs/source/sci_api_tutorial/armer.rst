==============================================
 Adaptive Resource Manager (ARMer)
==============================================

Briefs
==============================================
In this API named ``Adaptive Resource Manager (ARMer)``, the primary objective is to enhance efficiency by ensuring that resources like CPUs (Central Processing Units) and GPUs (Graphics Processing Units) are used optimally, minimizing idle time and unnecessary resource reservation.
In the context of enzyme modeling using EnzyHTP, ARMer is integrated into the workflow, which includes sub-tasks like mutant generation, molecular dynamics simulations, quantum mechanical calculations, and data analysis. 
This is in sharp contrast to the fixed resource allocation scheme where maximal computing resources are requested.
For specific details, please refer to the `original paper <https://doi.org/10.1021/acs.jcim.3c00618>` linked. 

.. dropdown:: :fa:`eye,mr-1` Click to learn more about ARMer's architechture

    The ARMer Python library consists of two classes: the job class and the HPC class. 
    
    The job class (called ClusterJob in the code) defines properties and functions that are associated with job configuration, submission, and dynamic monitoring of job completion. 
    
    The HPC class (subclasses of ClusterInterface in the code) supports the job class with properties and functions to mediate shell input/output in the user’s local HPC where ARMer is deployed. The HPC class files are stored in a folder named “cluster”. In the folder, _interface.py defines an abstract HPC class as the code interface and accre.py defines an example concrete HPC class we made for our local HPC at Vanderbilt. Users can create new files under this folder defining new concrete HPC classes to easily modify ARMer Python library to be compatible with their local HPC cluster. The instances of the HPC class are used as input for generating the Job instance. The methods of the HPC class are used by the Job instance through the HPC instance to interface with the corresponding local HPC cluster. The new HPC class user defines is required to fulfill the code interfaced defined by the abstract HPC class in _interface.py to make sure they are compatible with the Job class. It is enforced by requiring (by the Job class) all HPC classes to inherit the abstract HPC class so that the new HPC class has to define some required methods (otherwise python will raise an error). 
    
    Then, the ARMer library enables the “workflow script” to run shell commands on other computational nodes these commands are wrapped in the job scripts in the HPC clusters.

.. dropdown:: :fa:`eye,mr-1` Click to learn more about ARMer's workflow

    The workflow of ARMer
    ==============================================

    .. panels::

        :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

        .. image:: ../../figures/armer_architect.png
            :width: 100%
            :alt: single_point_api_io                  
        |



Three Main Functions of ARMer
==============================================
The ARMer tool contains three main functions: config job (i.e.: submission script, etc.), submit, monitor (i.e.: wait_to_end)

1. Config Job (Submission Script Generation)

    The config_job function serves as the constructor for creating a ClusterJob instance. It's responsible for setting up the submission script, which dictates how the job will be run on the HPC cluster. 

.. dropdown:: :fa:`eye,mr-1` Click here to learn what it does:

    * Commands and Environment Setup:  It takes a set of commands (specific tasks to be performed), environmental settings (required software or libraries), and resource keywords (CPU/GPU requirements) as inputs.

    * Script Generation: Combines these elements into a script which includes directives to the scheduler (like SLURM or PBS) on how to allocate resources and execute the computational tasks.

    * Dynamic Allocation: This approach allows the script to be tailored for specific tasks within the workflow, optimizing resource use.

.. dropdown:: :fa:`eye,mr-1` Click here to learn about the arguments in Job Configuration:
    ``commands``
        refers to the target shell commands for running external software for a specific enzyme modeling sub-task

    ``cluster``
        refers to an HPC class object that contains miscellaneous details about user’s local HPC

    ``env_settings``
        states environment settings of external software 

    ``res_keywords``
        configures computing resources for the job (including parameters such as `core_type`, `nodes`,`nodes_core`,etc), which can be referenced from `Input/Output <#input-output>`_ section.

    ``jobs``
        a list of ClusterJob object to be execute

    ``period``
        the time cycle for detect job state (Unit: second)

2. Job Submission

    With the job object instantiated, a job script for the required task can be generated and then submitted by the submit() method. 
    
    Notably, the format of the job script, the submission commands, and other HPC dependent information are obtained from the HPC class object that is instantiated and passed to the `cluster` argument.

.. dropdown:: :fa:`eye,mr-1` Click here to learn about the arguments in Job Submission:

    ``sub_dir`` 
        dir for submission. commands in the sub script usually run under this dir.
                
    ``script_path`` 
        path for submission script generation.
        (default: sub_dir/submit.cmd; will be sub_dir/submit_#.cmd if the file exists. # is a growing index)
           

3. Dynamic Monitoring
    Once the job has been submitted, a job ID is added to the object by the function. By tracing the job ID, the “workflow script” can monitor the status of a job object in the queue, and mediate the status by killing, holding, or releasing the job.

.. dropdown:: :fa:`eye,mr-1` Click to learn more about `Dynamic monitoring`
    The capability of dynamically monitoring the job completion status is vital to high-throughput modeling workflow because the workflow involves multiple different types of simulation subtasks that must be sequentially operated.
    
    Two methods have been implemented to achieve dynamic monitoring, they are: wait_to_end() and wait_to_array_end() methods. The wait_to_end() method checks the status of a job in the job queue within a certain period of time (i.e., every 30 s) and exits upon the detection of messages that indicate job completion, error, or cancellation. The wait_to_array_end() method takes multiple job objects and submits them in one job array. Similarly, this method also monitors the status of all jobs in the array regularly and dynamically appends new jobs to the array up to the maximal capacity (i.e., array size).

.. dropdown:: :fa:`eye,mr-1` Click to learn more about the arguments in Dynamic monitoring
    There are two functions: "wait_to_end" (single submission) and "wait_to_array_end" (array submission)
        
    ``period``
        the time cycle for update job state change (Unit: s)
    
    The following arguments are array submission only:

    ``jobs``
        a list of ClusterJob object to be execute
        
    ``array_size``
        
        how many jobs are allowed to submit simultaneously. 

        (e.g. 5 for 100 jobs means run 20 groups. All groups will be submitted and 
        in each group, submit the next job only after the previous one finishes.)
        
    ``sub_dir``
        (default: self.sub_dir)

        submission directory for all jobs in the array. 
        
        Overwrite existing self.sub_dir in the job obj
        
        * you can set the self value during config_job to make each job different
    
    ``sub_scirpt_path`` 
        (default: self.sub_script_path)
        
        path of the submission script. Overwrite existing self.sub_script_path in the job obj
        
        * you can set the self value during config_job to make each job different



For most users, only the `Job configuration` requires specific input from different users.
The first step involves configuring a job using the config_job method. This method prepares the submission script by specifying the commands to be executed, environmental settings, and resource requirements.

.. admonition:: Here is the `cluster_job_config` dictionary

        These parameters are specified under the argument `res_keywords`.

        `core_type`: This specifies that the job should be run on GPU/CPU cores. 

        `nodes`: How many nodes needed to request for the job.

        `node_cores`: How many cores needed for each node. If GPU is used, usually only one core per node will be requested.

        `job_name`: This sets the name of the job to "job_name". You can change this to a more descriptive name for your job.

        `partition`: This specifies that the job should be submitted to a specific partition, which is likely a partition dedicated to GPU resources.
        
        `mem_per_core`: This requests a number of gigabytes of memory per core.
        
        `walltime`: This sets the maximum walltime (execution time) for the job. '24:00:00' means 24 hours.
        
        `account``: This specifies the account to be charged for the job's resource usage. 

These inputs will be parsed and the output will be passed down to submission and monitoring.
To correctly prepare for the input and output, the user needs to identify the local HPC first. This should refer to the guidelines for each institution's HPC submission syntax. If you need to support your local HPC cluster, please refer to the `Quick Start: 2. Support Your Local Cluster` page from the menu bar on the left.


How ARMer is used in EnzyHTP APIs
------------------------------------------------

1. Developer Integration with Science APIs

    Developers using EnzyHTP can directly leverage ARMer's capabilities through the platform's APIs. 
    
    In EnzyHTP, ARMer is integrated into the workflow, which includes sub-tasks like mutant generation, molecular dynamics simulations, quantum mechanical calculations, and data analysis. 
    Each subtask was a seperate science API that has different computing needs, which ARMer manages effectively.

    Developers can utilize ARMer to tailor the computational resources specifically for the task at hand, whether it involves intensive CPU usage for molecular dynamics simulations or GPU resources for more complex quantum mechanical calculations.


2. User Interaction via Configured API
    For users, the interaction with ARMer is streamlined through configurations exposed by API developers:

    Cluster Job Configuration Dictionary: This dictionary (cluster_job_config) shown above is provided by the API developers and exposes various configurable options that users can set according to their specific requirements. It includes parameters such as cluster type, environmental settings, and resource keywords.
    
    Simplified Job Submission: Users don’t need to manage complex cluster configurations directly. Instead, they provide necessary parameters through a high-level interface, simplifying the computational aspects of enzyme modeling.


Input
------------------------------------------------
    In the context of ARMer and EnzyHTP, the cluster is an object that represents a specific HPC cluster configuration. This object is usually an instance of a class that implements the ClusterInterface or a similar interface that ARMer can interact with.
    In EnzyHTP, the input for ARMer should be all kinds of "clusters", for example, clusters for MD sampling, clusters for QM caluclations, etc.

.. dropdown:: :fa:`eye,mr-1` Click here to see examples

    .. admonition:: Example: how cluster_job_config is used in MD simulation sampling
    (See `<#Example-code> for more examples`_)

    .. code:: python

        #Building MD Parameterization:
        param_method = interface.amber.build_md_parameterizer(
            ncaa_param_lib_path=f"{DATA_DIR}ncaa_lib",
            force_fields=[
                "leaprc.protein.ff14SB",
                "leaprc.gaff",
                "leaprc.water.tip3p",
            ],
        )

         #Preparing Constraints:
        mut_constraints = []
        for cons in md_constraints:
            mut_constraints.append(cons(mutant_stru))

        #Configuring Cluster Job Settings: Sets up the configuration for the job submission to the cluster, specifically tailoring it for GPU-intensive tasks required in MD simulations.
        md_cluster_job_config = {
            "cluster" : Accre(),
            "res_keywords" : {
                "account" : "csb_gpu_acc",
                "partition" : "pascal"
            }
        }
        
        # Executes the equilibrium molecular dynamics sampling using the specified structure and parameters.
        md_result = equi_md_sampling(
            stru = mutant_stru,
            param_method = param_method,
            cluster_job_config = md_cluster_job_config, #The job configuration for submitting this task to the cluster.
            job_check_period=10,
            prod_constrain=mut_constraints,
            prod_time=md_length,
            record_period=md_length*0.1,
            work_dir=f"{mutant_dir}/MD/"
        )        

Example Code
==============================================

Calculate single point energy for a QM cluster
---------------------------------------------------------

In this example, we perform single point energy calculation for a QM region and for each snapshot from an ensemble of substrates of Kemp Eliminase.

Note: This is a snippt of a workflow that illustrate how `cluster_job_config` is used in the QM single point Science API.Please refer to the specific API for more details.

.. code:: python

    qm_level_of_theory = QMLevelOfTheory(
        basis_set="3-21G",
        method="hf",
    )

    # MD sampling results
    md_result = equi_md_sampling(
        stru = mutant_stru,
        param_method = param_method,
        parallel_runs = 1,
        cluster_job_config = md_cluster_job_config, 
        job_check_period=10,
        prod_constrain=mut_constraints,
        prod_time=md_length,
        record_period=md_length*0.1,
        work_dir=f"{mutant_dir}/MD/"
    )[0]

    # Specifies how the QM calculations should be run on the HPC
    qm_cluster_job_config = {
        "cluster" : Accre(),
        "res_keywords" : {
            
            'core_type' : 'cpu',
            'nodes' : '1',
            'nodes_core' : '8',
            'job_name' : 'TEST',
            'partition' : 'production',
            'mem_per_core' : '3G',
            'walltime': '24:00:00', 
            "account" : "yang_lab_csb",
    }

    # QM Calculation Function Call: 
    qm_results = single_point(
        stru=md_result,
        engine="gaussian",
        method=qm_level_of_theory,
        regions=["resi 101+254"],
        cluster_job_config=qm_cluster_job_config,
        job_check_period=60,
        job_array_size=20,
        work_dir=f"{mutant_dir}/QM_SPE/",
    )

Please note that for QM and MD the `cluster_job_config`` is different.

This example neatly encapsulates the end-to-end process from configuring and running MD simulations to performing targeted QM calculations, all managed via ARMer for efficient resource use in a high-performance computing environment.

Reference: 
Shao, Q., Jiang, Y., & Yang, Z. J. (2023). ENZYHTP computational directed evolution with Adaptive Resource Allocation. Journal of Chemical Information and Modeling, 63(17), 5650–5659. https://doi.org/10.1021/acs.jcim.3c00618 


Author: Jiayue Liu <jacquelineliu0921@gmail.com>; Qianzhen Shao <qianzhen.shao@vanderbilt.edu>

