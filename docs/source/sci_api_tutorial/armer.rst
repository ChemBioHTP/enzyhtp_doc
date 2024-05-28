==============================================
 Adaptive Resource Manager (ARMer)
==============================================

Briefs
==============================================
In this API named ``Adaptive Resource Manager (ARMer)``, the primary objective is to enhance efficiency by ensuring that resources like CPUs (Central Processing Units) and GPUs (Graphics Processing Units) are used optimally, minimizing idle time and unnecessary resource reservation.
In the context of enzyme modeling using EnzyHTP, ARMer is integrated into the workflow, which includes sub-tasks like mutant generation, molecular dynamics simulations, quantum mechanical calculations, and data analysis. 
Using commands implemented in the ARMer Python library, the workflow script configures, submits, and monitors new jobs in HPC clusters that pertain to the actual need of computing resources in a subtask of the workflow. 
This is in sharp contrast to the fixed resource allocation scheme where maximal computing resources are requested.

.. dropdown:: :fa:`eye,mr-1` Click to learn more about ARMer's architechture

    The ARMer Python library consists of two classes: the job class and the HPC class. 
    
    The job class (called ClusterJob in the code) defines properties and functions that are associated with job configuration, submission, and dynamic monitoring of job completion. 
    
    The HPC class (subclasses of ClusterInterface in the code) supports the job class with properties and functions to mediate shell input/output in the user’s local HPC where ARMer is deployed. The HPC class files are stored in a folder named “cluster”. In the folder, _interface.py defines an abstract HPC class as the code interface and accre.py defines an example concrete HPC class we made for our local HPC at Vanderbilt. Users can create new files under this folder defining new concrete HPC classes to easily modify ARMer Python library to be compatible with their local HPC cluster. The instances of the HPC class are used as input for generating the Job instance. The methods of the HPC class are used by the Job instance through the HPC instance to interface with the corresponding local HPC cluster. The new HPC class user defines is required to fulfill the code interfaced defined by the abstract HPC class in _interface.py to make sure they are compatible with the Job class. It is enforced by requiring (by the Job class) all HPC classes to inherit the abstract HPC class so that the new HPC class has to define some required methods (otherwise python will raise an error). 
    
    Then, the ARMer library enables the “workflow script” to run shell commands on other computational nodes these commands are wrapped in the job scripts in the HPC clusters.

The workflow of ARMer
==============================================

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    .. image:: ../../figures/armer_architect.png
        :width: 100%
        :alt: single_point_api_io                  
    |

For most of the users, even though the flowchart contains 3 parts, the attention should only be focused on the `Job configuration`, which will be elaborated in the next section.

.. dropdown:: :fa:`eye,mr-1` Click to learn more about `Job Submission`
    
    With the job object instantiated, a job script for the required task can be generated and then submitted by the submit() method. Notably, the format of the job script, the submission commands, and other HPCdependent information are obtained from the HPC class object that is instantiated and passed to the `cluster` argument.


.. dropdown:: :fa:`eye,mr-1` Click to learn more about `Dynamic monitoring`
    
    Once the job has been submitted, a job ID is added to the object by the function. By tracing the job ID, the “workflow script” can monitor the status of a job object in the queue, and mediate the status by killing, holding, or releasing the job. Notably, the capability of dynamically monitoring the job completion status is vital to high-throughput modeling workflow. 
    This is because the workflow involves multiple different types of simulation subtasks that must be sequentially operated.
    
    Two methods have been implemented to achieve dynamic monitoring, they are: wait_to_end() and wait_to_array_end() methods. The wait_to_end() method checks the status of a job in the job queue within a certain period of time (i.e., every 30 s) and exits upon the detection of messages that indicate job completion, error, or cancellation. The wait_to_array_end() method takes multiple job objects and submits them in one job array. Similarly, this method also monitors the status of all jobs in the array regularly and dynamically appends new jobs to the array up to the maximal capacity (i.e., array size).

Implementation of ARMer in EnzyHTP enables an if_cluster_job option for all computationally insensitive functions (like MD, QM, and free energy calculation). With this option turned on, the subsections that requires a lot of computing power can achieve adaptive resource allocation.

Input/Output
==============================================
As described in the previous section, only the `Job configuration` requires specific input from different users.
These inputs will be parsed and the output will be passed down to submission and monitoring.
To correctly prepare for the input and output, the user needs to identify the local HPC first. 

Input
------------------------------------------------

``res_keywords``
    configures computing resources for the job. 

    .. admonition:: How to obtain

        This should refer to the guidelines for each institution's HPC submission syntax. If you need to support your local HPC cluster, please refer to the `Quick Start: 2. Support Your Local Cluster` page from the menu bar on the left.

        .. dropdown:: :fa:`eye,mr-1` Click here to learn more about ACCRE if you are a Vanderbilt User

            `core_type`: This specifies that the job should be run on GPU/CPU cores. 

            `nodes`: How many nodes needed to request for the job.

            `node_cores`: How many cores needed for each node. If GPU is used, usually only one core per node will be requested.

            `job_name`: This sets the name of the job to "job_name". You can change this to a more descriptive name for your job.

            `partition`: This specifies that the job should be submitted to a specific partition, which is likely a partition dedicated to GPU resources.
            
            `mem_per_core`: This requests a number of gigabytes of memory per core.
            
            `walltime`: This sets the maximum walltime (execution time) for the job. '24:00:00' means 24 hours.
            
            `account``: This specifies the account to be charged for the job's resource usage. 

``commands`` 
    Commands refers to the target shell commands for running external software for a specific enzyme modeling sub-task.
    
    .. admonition:: How to obtain

        The ARMer tool is integrated with other `APIs <single_point.html>`_ that requires the ARMer Config. No changes need to be made by users.
    
``env_settings``
     env_settings states environment settings of external software (e.g., env_settings = ‘’’module load Gaussian/16.B.01’’’).
    
    .. admonition:: How to obtain
        
        Same as `commands`, different subtasks require different environments. 
     

Output
------------------------------------------------
A job script will be generated by the “workflow script” using commands implemented in ARMer.  


Arguments
==============================================

.. dropdown:: :fa:`eye,mr-1` Click to see full argument explanations
    
    1. For Job Configuration:

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
        
    
    2. For Job Submission:

    ``sub_dir`` 
        dir for submission. commands in the sub script usually run under this dir.
                
    ``script_path`` 
        path for submission script generation.
        (default: sub_dir/submit.cmd; will be sub_dir/submit_#.cmd if the file exists. # is a growing index)
                
    
    3. For Job Monitoring:
    
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
        

Example Code
==============================================

1. Code to generate job submission script (single and array submission)
---------------------------------------------------------

.. admonition:: How input is prepared
    (See `Details <#input-output>`_)
    
.. code:: python

    from armer import ClusterJob
    import clusters

    cluster = clusters.accre.Accre()

    # For a single submission
    job = clusterJob.config job(
        commands = "g16 < xxx.gjf > xxx.out",
        cluster = cluster,
        env_settings = cluster.G16_ENV['CPU'],

        res_keywords = {'core_type' : 'cpu',
                        'nodes' : '1',
                        'nodes_core' : '8',
                        'job_name' : 'TEST',
                        'partition' : 'production',
                        'mem_per_core' : '3G',
                        'walltime': '24:00:00', 
                        'account' : 'xxx'
                        }
        )
    job.submit(sub_dir="./")
    job.wait_to_end(period=10)

    # For array submission, 10 submissions in this case 
    jobs = []

    for i in range(10):
        jobs.append(ClusterJob.config_job(
            commands = "g16 < xxx.gjf > xxx.out",
            cluster = cluster,
            env_settings = cluster.G16_ENV['CPU'],
            res_keywords = {'core_type' : 'cpu',
                            'nodes' : '1',
                            'nodes_core' : '8',
                            'job_name' : 'TEST',
                            'partition' : 'production',
                            'mem_per_core' : '3G',
                            'walltime': '24:00:00', 
                            'account' : 'xxx'
                            },
            sub_dir="./")
        )
    ClusterJob.wait_to_array_end(jobs, period = 30, array_size = 5)

2. Sample job scripts that performs QM calculations
---------------------------------------------------------

For ACCRE users, the SBATCH submission scripts will be generated first with the inputs provided above. Then the env_setting and commands will be tailored to specific tasks, in this case, the QM calculation using Gaussian16.
The job script is generated by the "workflow script" inplemented in ARMer.

.. code:: bash

    #!/bin/bash
    #SBATCH--nodes-1
    #SBATCH --cpus-per-task=8

    #SBATCH--job-name=EHTP OMcluster
    #SBATCH--partition=production
    #SBATOH--mem-per-cpu-36
    #SBATCH--time 24:80;80
    #SBATCH --account=xxx

    module load Gaussian/16.8.61 # env_setting
    mkdir $TMPDIR/SLURM_JOB_ID
    export GAUSS_SCRDIR=$TMPDIR/$SLURM_J0B_ID

    g16 < ./QM_cluster/qm_cluster_1.gjf> ./QM cluster/qm_cluster_1.out # commands
    rm -rf $TMPDIR/$SLURM_J0B_ID
    

Reference: 
Shao, Q., Jiang, Y., & Yang, Z. J. (2023). ENZYHTP computational directed evolution with Adaptive Resource Allocation. Journal of Chemical Information and Modeling, 63(17), 5650–5659. https://doi.org/10.1021/acs.jcim.3c00618 


Author: Jiayue Liu <jacquelineliu0921@gmail.com>; Qianzhen Shao <qianzhen.shao@vanderbilt.edu>

