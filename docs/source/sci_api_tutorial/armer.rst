==============================================
 Adaptive Resource Manager (ARMer)
==============================================

Briefs
==============================================

ARMer is a software tool designed to manage and allocate computational resources dynamically, according to the specific needs of various sub-tasks within a computational workflow. Its primary objective is to enhance efficiency by ensuring that resources like CPUs (Central Processing Units) and GPUs (Graphics Processing Units) are used optimally, minimizing idle time and unnecessary resource reservation.
ARMer adjusts the allocation of resources based on the demands of specific sub-tasks in a workflow. For example, certain tasks might require more GPU power due to their graphic-intensive nature, while others might rely more heavily on the CPU for processing. ARMer assesses and allocates these resources in real-time to match these requirements.
In the context of enzyme modeling using EnzyHTP, ARMer is integrated into the workflow, which includes sub-tasks like mutant generation, molecular dynamics simulations, quantum mechanical calculations, and data analysis. Each of these stages has different computing needs, which ARMer manages effectively.

Overview of ARMer's Main Functions
==============================================
This section provides an overview of the ``ARMer`` module, which is designed to manage job queues for running jobs on a cluster and interface with different Linux resource managers like Slurm. The general workflow of ARMer involves taking job commands, compiling the submission script, submitting and monitoring the job, and recording the completion of the job. From a data flow perspective, ARMer should function similarly to ``subprocess.run()``. One of the key features of ARMer is that it allows users to add support for their own clusters by creating new ClusterInterface classes.

#### 1. **Config Job (Submission Script Generation)**
The `config_job` function serves as the constructor for creating a `ClusterJob` instance. It's responsible for setting up the submission script, which dictates how the job will be run on the HPC cluster. Here’s what it does:

- **Commands and Environment Setup**: It takes a set of commands (specific tasks to be performed), environmental settings (required software or libraries), and resource keywords (CPU/GPU requirements) as inputs.
- **Script Generation**: Combines these elements into a script which includes directives to the scheduler (like SLURM or PBS) on how to allocate resources and execute the computational tasks.

#### 2. **Submit**
Once the submission script is ready, the `submit` function is used to actually queue the job in the HPC system:

- **Script Deployment**: The submission script is placed in the appropriate directory, ready for execution.
- **Job Submission**: The script is submitted to the cluster's job queue. This function handles any necessary configurations such as setting the directory for execution or adjusting the script path if needed.
- **Monitoring Setup**: It also sets up initial parameters for job monitoring, storing the job ID and other relevant information for later reference.

#### 3. **Monitor (Wait to End)**
Monitoring is crucial for managing jobs on an HPC cluster:

- **Check Job Status**: This function continuously checks the state of the job (running, pending, completed, cancelled, or error).
- **Completion Detection**: It waits for the job to end, either successfully or due to an error or cancellation, and can take appropriate actions based on the job's outcome, like logging or triggering dependent processes.

Imports
==============================================

In order to make use of the API, we should have the API loaded.

.. code:: python    
    from subprocess import run
    import re
    import pytest

    import clusters
    from armer import *

Execute API

Arguments and Examples (Vanderbilt Accre)
==============================================

``env_settings_list``
    Environment settings in the submission script as a list of strings for commands in each line.

    (list[str])

    Example:
    .. code:: python    
    >>> env_settings_list = [
    ...     'module load GCC/6.4.0-2.28 OpenMPI/2.1.1',
    ...     'module load Amber/17-Python-2.7.14',
    ...     'module unload Python/2.7.14 numpy/1.13.1-Python-2.7.14'
    ... ]


``res_keywords_dict_gpu``
    Resource settings as a dictionary indicating each keyword for GPU resources.

    (dict[str, str])

    Example:
    .. code:: python    
    >>> res_keywords_dict_gpu = {
    ...     'core_type': 'gpu',
    ...     'nodes': '1',
    ...     'node_cores': '1',
    ...     'job_name': 'job_name',
    ...     'partition': 'maxwell',
    ...     'mem_per_core': '32G',
    ...     'walltime': '24:00:00',
    ...     'account': 'xxx'
    ... }

The res_keywords_dict_gpu is a dictionary that represents the resource settings for requesting GPU resources on a cluster. The keys in this dictionary are the resource keywords, and their corresponding values are the desired settings for those keywords.
Here's what each key-value pair means:

'core_type': 'gpu': This specifies that the job should be run on GPU cores. It can also be set as CPU.
'nodes': '1': This requests one node for the job.
'node_cores': '1': This requests one core per node. Since we're using GPUs, we typically request only one core per node.
'job_name': 'job_name': This sets the name of the job to "job_name". You can change this to a more descriptive name for your job.
'partition': 'maxwell': This specifies that the job should be submitted to the "maxwell" partition, which is likely a partition dedicated to GPU resources.
'mem_per_core': '32G': This requests 32 GB of memory per core.
'walltime': '24:00:00': This sets the maximum walltime (execution time) for the job to 24 hours.
'account': 'xxx': This specifies the account to be charged for the job's resource usage. You would need to replace "xxx" with your actual account name.

This dictionary can be used as the res_keywords argument when configuring a job with the ARMer module, specifically when requesting GPU resources. By passing this dictionary, the job submission script will be generated with the appropriate resource settings for running the job on GPUs.

``env_settings_str``
    Environment settings in the submission script as a string.

    (str)

    Example:
    .. code:: python    
    >>> env_settings_str = '''module load GCC/6.4.0-2.28 OpenMPI/2.1.1
    ... module load Amber/17-Python-2.7.14
    ... module unload Python/2.7.14 numpy/1.13.1-Python-2.7.14'''

``res_keywords_str``
    The res_keywords_str is a string that encapsulates the resource settings for a job submission script, typically used with a job scheduler such as SLURM. 

    (str)

    Example:
    .. code:: python    
    >>> res_keywords_str = '''#!/bin/bash
    ... #SBATCH --nodes=1
    ... #SBATCH --tasks-per-node=24
    ... #SBATCH --job-name=job_name
    ... #SBATCH --partition=production
    ... #SBATCH --mem-per-cpu=4G
    ... #SBATCH --time=24:00:00
    ... #SBATCH --account=xxx
    ... '''


Nodes: Specifies the number of compute nodes that the job should use. Here, the job is configured to use one node.
Tasks Per Node: Indicates the number of tasks to run on each node. In this context, it usually correlates with the number of processor cores to be used per node. Here, 24 tasks (or cores) per node are requested.
Job Name: Sets a name for the job, which can be useful for identifying the job within the queue or in reports generated by the scheduler. 'job_name' can be replaced with any descriptive name you prefer.
Partition: Assigns the job to a specific group of nodes or a partition. 'production' likely refers to a partition intended for regular, production-level computations.
Memory Per CPU: Allocates memory for each CPU used by the job. Here, each CPU is assigned 4 gigabytes.
Walltime: Sets the maximum duration for which the job is allowed to run. In this example, the job is allowed to run for up to 24 hours. If the job does not complete within this time, the scheduler will terminate it.
Account: Specifies the account code to be charged for the resources consumed by the job. This is important for systems where computing resources are allocated based on a project or departmental account. 'xxx' should be replaced with the actual account identifier.

Each of these directives begins with #SBATCH, which is specific to the SLURM scheduler. This prefix is used by SLURM to differentiate script comments from SLURM directives. These settings are crucial for correctly configuring the computational resources required by the job, ensuring it runs efficiently within the constraints of the HPC environment.


Support your own HPC
==============================================
ARMer is designed to be highly adaptable, not only supporting the Vanderbilt ACCRE cluster but also capable of being customized for use with other high-performance computing (HPC) systems. By developing new ClusterInterface classes, users can tailor ARMer to meet the specific requirements and configurations of virtually any HPC environment. This flexibility allows ARMer to manage and optimize computational resources across a diverse range of systems, ensuring efficient and effective use of computing power wherever it is deployed. For more details on how to implement ARMer in your own HPC system, you can start by visiting this link.










  

