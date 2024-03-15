==============================================
 Install EnzyHTP
==============================================

This guide leads you through steps of installing EnzyHTP

.. contents::

I. Make a new environment
===================================

| We recommand using conda to manage the enviroment of EnzyHTP.
| Make sure you installed and activate conda before running the following command.
| You can find many good tutorial of conda installation elsewhere.

.. code:: bash

    conda create --name enzy_htp python=3.9
    conda activate enzy_htp

| This creates a conda environment called ``enzy_htp`` and we will install python package EnzyHTP needs in it.
| You can activate this enviroment anytime when you need to use EnzyHTP by ``conda activate enzy_htp``

II. Install EnzyHTP
===================================

There are 2 ways of installing EnzyHTP: 1) from conda 2) from source

.. note::
    Make sure you are under the correct environment when doing this step

a. Install from conda
------------------------
    Currently we recommend installing from conda.

    .. code:: bash

        conda install enzy_htp -c conda-forge


b. Install from source
------------------------

    **Obtain the source code**

    EnzyHTP is shared-source on GitHub.

    .. code:: bash

        git clone https://github.com/ChemBioHTP/EnzyHTP.git

    This will generate a folder name "EnzyHTP" containing the source
    code under where you run this command.

    .. note::
        Note that the source code version when writing this tutorial is stored as a `release <https://github.com/ChemBioHTP/EnzyHTP/releases/tag/beta_3>`_ too.
        (try this version if this tutorial fails with the most current version)

    **Install Python packages**

    .. code:: bash

        cd EnzyHTP # this is what you created via clone in the previous step
        dev-tools/conda-install
        # install pdb2pqr
        git clone https://github.com/Electrostatics/pdb2pqr.git
        cd pdb2pqr
        pip install .

III. Install External Dependencies
===================================

1. Install Amber (optional)
------------------------
EnzyHTP use Amber as one of the MD engine (currently the only one). You need to install
Amber if you want to enable MD/mutation functions in EnzyHTP. AmberTools is free (CPU only) and Amber is
charged (GPU support). Most universities have Amber purchased
and installed in their local clusters. Contact your local cluster if you don't know how to
load/setup the installed Amber.

As an example, here is the command for loading Amber in our local cluster ACCRE.

.. code:: bash
    
    source /home/shaoq1/bin/amber_env/amber-accre.sh

2. Install Gaussian16 (optional)
------------------------
EnzyHTP use Gaussian16 as one of the QM engine (currently the only one). You need to install
Gaussian16 if you want to enable QM-based functions in EnzyHTP. Gaussian16 is charged. Most universities 
have Gaussian16 purchased and installed in their local clusters. Contact your local cluster if
you don't know how to load/setup the installed Gaussian16.

As an example, here is the command for loading Gaussian16 in our local cluster ACCRE.

.. code:: bash

    module load Gaussian/16.B.01

3. Install Multiwfn (optional)
------------------------
| EnzyHTP use Multiwfn as one of the wavefunction analysis engine.
| You need to install Multiwfn if you want to enable wavefunction analysis functions in EnzyHTP.
| Multiwfn is free and very easy to install.

| Download and follow section 2.1.2 of their manual to install
| Multiwfn Download page: http://sobereva.com/multiwfn/

.. note::
    Some HPC may not have the most up-to-date library for running Multiwfn
    For example, on our local cluster ACCRE, these module needs to be load for
    Multiwfn to run on a computing node.

    .. code::

        module load GCC/6.4.0-2.28  OpenMPI/2.1.1

4. Install Rosetta (optional)
------------------------
| EnzyHTP use Rosetta as one of the post-analysis & docking engine.
| You need to install Rosetta if you want to enable docking & analysis (e.g.: thermostability assessment) functions in EnzyHTP.
| Rosetta is free and easy to install.

| Follow this page for the install:
| https://new.rosettacommons.org/demos/latest/tutorials/install_build/install_build
