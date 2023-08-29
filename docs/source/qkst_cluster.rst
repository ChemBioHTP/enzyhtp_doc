==============================================
 Quick Start: 2. Support Your Local Cluster
==============================================

Overview
========================================================

EnzyHTP is designed to run on High Performance Cluster (HPC) to match with
the large computing resource need of high-throughput workflows. EnzyHTP use `Adaptive Resource Manager (ARMer) <https://pubs.acs.org/doi/10.1021/acs.jcim.3c00618>`_
to interface different HPCs. It allows EnzyHTP to submit children jobs for
resource intensive steps (e.g.: MD or QM) to the cluster during the workflow
instead of requesting the heterogenous resource in whole at the beginning, which
is impossible in most time.

In order for ARMer to work, EnzyHTP needs to know some necessary information about
your local HPC. (e.g.: how to submit a job)

In this tutorial, I will lead you through steps that create a plug-in of your
local cluster for EnzyHTP. This plug-in will provide the necessary information
to EnzyHTP and have it supports your local cluster.


Before We Start
========================================================
check if any file under ``core/clusters/`` matchs the name of your local cluster,
some user in our open-source community may already support your local cluster.
In that case, you just need to import the class from the file.

Write the Plug-in by Anwsering a Questionnaire
========================================================

The overall process of writing the plug-in for supporting your local HPC is like
anwsering a questionnaire. We may actual make a google form and automated this in the future lol. But
for now you need to write them in a python file.

1. Create a new HPC plug-in file in EnzyHTP
--------------------------------------------------------
The HPC plug-in files in EnzyHTP goes to ``core/clusters/``. Make a new file under this folder with the
name of your cluster (e.g.: ``hof2.py``). Please use the exact name so that other users in our open-source
community can look up to see if the cluster is already supported.

2. Define a subclass of ClusterInterface
--------------------------------------------------------
Define a subclass of ClusterInterface in this file. For example:

.. code:: python

    class Hof2(ClusterInterface):

This class will carry all the information EnzyHTP needs to know. ClusterInterface is an abstract class that
defines what are the necessary information for EnzyHTP. In other word, which method/constant you need
to have in the subclass

3. Satisfy the interface in this class
--------------------------------------------------------
Define all the method/constant stated in ``core/cluster/_interface.py::ClusterInterface``. You can use ``core/cluster/accre.py::Accre``
as reference.

Here I will briefly explain some required methods:

.. code:: python

    @classmethod
    def parser_resource_str(cls, res_dict: dict) -> str:

.. dropdown:: :fa:`eye,mr-1` Click to see interface explanation

    Input 
        an enzyhtp-standard-format resource dictionary. like this:

        .. code:: python

            # The default resource dict for CPU-based MD
            {
            'core_type' : 'cpu',
            'nodes':'1',
            'node_cores' : '16',
            'job_name' : 'EHTP_MD',
            'partition' : 'production',
            'mem_per_core' : '3G',
            'walltime' : '1-00:00:00',
            'account' : 'xxx'
            }

        Functions like PDBMD() will feed a dictionary like this when calling this method. User can change values
        in this dictionary (e.g.: user may set ``partition`` as ``shared`` for hof2 according to
        `this <https://www.hoffman2.idre.ucla.edu/Using-H2/Computing/Computing.html#requesting-multiple-cores>`_ )

    Output: 
        xxx







