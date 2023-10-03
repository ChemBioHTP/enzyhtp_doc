==============================================
 Install EnzyHTP
==============================================

This guide leads you through step of installing EnzyHTP

.. contents::

1. Obtain EnzyHTP
===================================

EnzyHTP is open-source on GitHub. Currently we recommend clone
EnzyHTP directly from the repo

.. code:: bash

    git clone https://github.com/ChemBioHTP/EnzyHTP.git

This will generate a folder name "EnzyHTP" containing the source
code under where you run this command.

.. note::
    Note that the source code version when writing this tutorial is stored as a `release <https://github.com/ChemBioHTP/EnzyHTP/releases/tag/beta_3>`_ too.
    (try this version if this tutorial fails with the most current version)

2. Install Enviroment for EnzyHTP
===================================

Install Python packages
------------------------

| We recommand using conda to manage the enviroment of EnzyHTP.
| Make sure you installed and activate conda before running the following command.
| You can find many good tutorial of conda installation elsewhere.

.. code:: bash

    conda create --name enzy_htp python=3.9
    conda activate enzy_htp
    conda install -c conda-forge plum-dispatch pymol-open-source openbabel numpy pandas mdtraj
    # install pdb2pqr
    git clone https://github.com/Electrostatics/pdb2pqr.git
    cd pdb2pqr
    pip install .

| This creates a conda environment called ``enzy_htp`` and install python package EnzyHTP needs in it.
| You can activate this enviroment anytime when you need to use EnzyHTP by ``conda activate enzy_htp``

Add EnzyHTP to your PYTHONPATH
-------------------------------
.. code:: bash

    export PYTHONPATH=$PYTHONPATH:<yourpath_to_EnzyHTP>

| This command tells the system where EnzyHTP is when you need to use it outside of the EnzyHTP directory.
| You can add this line to your ``.bashrc`` if you need to use it locally.
| A more common way is adding it in the submission script (see `this section <qkst_general.html#running-the-workflow>`_)

.. note::
    We updated EnzyHTP installation in the unfinished refactoring. After it finishes,
    you can install EnzyHTP directly from conda with a 1-line command.

3. Install Amber (optional)
===================================
EnzyHTP use Amber as one of the MD engine (currently the only one). You need to install
Amber if you want to enable MD/mutation functions in EnzyHTP. AmberTools is free (CPU only) and Amber is
charged (GPU support). Most universities have Amber purchased
and installed in their local clusters. Contact your local cluster if you don't know how to
load/setup the installed Amber.

As an example, here is the command for loading Amber in our local cluster ACCRE.

.. code:: bash
    
    source /home/shaoq1/bin/amber_env/amber-accre.sh

4. Install Gaussian16 (optional)
===================================
EnzyHTP use Gaussian16 as one of the QM engine (currently the only one). You need to install
Gaussian16 if you want to enable QM-based functions in EnzyHTP. Gaussian16 is charged. Most universities 
have Gaussian16 purchased and installed in their local clusters. Contact your local cluster if
you don't know how to load/setup the installed Gaussian16.

As an example, here is the command for loading Gaussian16 in our local cluster ACCRE.

.. code:: bash

    module load Gaussian/16.B.01

5. Install Multiwfn (optional)
===================================
| EnzyHTP use Multiwfn as one of the wavefunction analysis engine.
| You need if you want to install Multiwfn to enable wavefunction analysis functions in EnzyHTP.
| Multiwfn is free and very easy to install.

| Download and follow section 2.1.2 of their manual to install
| Multiwfn Download page: http://sobereva.com/multiwfn/

.. note::
    Some HPC may not have the most up-to-date library for running Multiwfn
    For example, on our local cluster ACCRE, these module needs to be load for
    Multiwfn to run on a computing node.

    .. code::

        module load GCC/6.4.0-2.28  OpenMPI/2.1.1
