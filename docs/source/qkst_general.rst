==============================================
 Quick Start
==============================================

EnzyHTP is a python library which means it doesn't have any
direct executables but instead provides modular functions as
building blocks of any customized workflow from users. In other
word, user needs to writing a main script calling EnzyHTP functions
to furnish their automated workflow.

Modify from a Template
======================

As a quick-start, we will modify from a main script template
provided under the `/template` folder of EnzyHTP. I will explain
functions used in the template and talk about how they can be modified
to match customized demand from users.

.. note::

    The code below are sections from `template/template_main.py`

Workflow Configurations
------------------------
This part of the code configure the workflow with some settings

.. code:: python

    import pickle

    from core.clusters.accre import Accre
    from Class_PDB import PDB
    from Class_Conf import Config
    from helper import write_data

This import EnzyHTP functions/classes to this script. We won't change
anything here in our quick-start.

.. code:: python

    # Configurations
    ## resource of the main script
    Config.n_cores = 1
    Config.max_core = 2000 #MB
    ## Details of MD
    Config.Amber.conf_equi['nstlim'] = 500000 # * 2 fs = 1 ns
    Config.Amber.conf_prod['nstlim'] = 55000000 # * 2 fs = 110 ns
    Config.Amber.conf_prod['ntwx'] = '50000' # * 2 fs = 0.1 ns

These lines config the resource that this main script would expect and
settings of MD simulations. 

