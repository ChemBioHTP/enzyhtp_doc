==============================================
Calculate dipole with EnzyHTP analysis module 
==============================================

.. note::

    | **This tutorial requires you to have 4 CPUs**
    | **This tutorial requires Multiwfn installed**

The target for this tutorial is calculating the molecular dipole in an KE-H5J enzyme-substrate complex. The main function provided is bond_dipole(), which calculates the dipole moment for a specified bond within two atoms. (Either enzyme or other pair of atoms) 

1. Identify dipole calculation target 
==============================================

The following input file / chemistry knowledge need to provide, 
    
    | *Files: The structure pdb file of the target enzyme and electron structure from Gaussian16 in fhck format (Example: EnzyHTP/test/analysis/data/)*
    | *Pre-knowledge: Identify the region/bond which conduct the dipole calculation. Also Identify the charge and spin. The default value for the charge and spin are 0, 1*
    | *Tips: Select the region for eletron structure analysis with capping atom for the incomplete amino acide (example of the script using the "H" as the capping atoms)*

| In order to setup the dipole calculation workflow, you will need the pre-requirement APIs (get_structure, assign_ncaa_chargespin, create_region_from_selection_pattern, ElectronicStructure) to get the dipole calucation region. 

| (Note that the dipole calcuation for the enzyme system normally involves amino acides some pre-caution need to setup during the , e.g.: The amino acide which truncated during the region selection neeed to be capped. The create_region_from_selection_pattern function provide variable (nterm_cap and cterm_cap) to help you cap the expose amino acides)

**Below we note the step by step method to use the bond_dipole science API for dipole calcuation at section 4. Before we start, let's breifly go through the bond_dipole function details**

2. Find the bond_dipole calculation API
===================================================================================

.. note::

    Science API is a special concept in EnzyHTP. They stands for those top-layer APIs
    the are supposed to be used in assembling the `workflow <https://enzyhtp-doc.readthedocs.io/en/latest/sci_api_tutorial/how_to_assemble.html#find-the-science-api-that-directly-gives-what-you-need>`_.

**You will find a detailed tutorial of how to use this Science API.**

3. Read the bond_dipole API to set the input params and understand the output tuples
=========================================================================================

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    The parameters of the bond_dipole API contain the following option

**Input**: The ``ele_stru``, ``atom_1``, ``atom_2`` and  are required input

    - ``ele_stru``:
        Electronic structure of the QM (Quantum Mechanics) region containing the target bond.

    - ``atom_1`` and ``atom_2``:
        Atoms defining the target bond within the region.

    - ``method``:

        Keyword specifying the algorithm & software for dipole calculation (default method is "LMO-Multiwfn"). Check the Multiwfn manual for the alternative methods. Utilizes the Lu-Chen method for dipole calculation, where 2-center LMO dipole is defined by the deviation of the electronic mass center relative to the bond center.

    - ``work_dir``:

        Working directory containing all the files in the calculation process.

    - ``keep_in_file``:

        Whether to keep the input file of the calculation.

    - ``cluster_job_config``:

        Configuration for cluster job execution (default is None for local execution).

    - ``cluster_job_config``:

        Time cycle for updating job state changes (default is 30 seconds).

**Output**: A tuple contains the dipole sign and the dipole vector
The expected returns of the bond_dipole calcuation are the signed norm of the dipole and dipole vector. Dipole positive direction goes from negative to positive, and the result direction is from ``atom_1`` to ``atom_2``.

4. Let's try to construct the actual scripts step by step
=========================================================================================
.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    We will use the script to calculate the dipole moment between the ``CAE`` atom1 and ``H2`` atom2 

        1. import the PDBParser class and make PDBParser instance. ``sp = PDBParser()`` and get the structure from the file provide with sp.get_structure(f"xxx.pdb")
        2. Assign the charge and the spin for the ligand with specific name "H5J". 
        3. Select the region which you want to do the dipole calculation with nterm and cterm capped with your desired methods
        4. Adjust the atoms order after the capping atoms
        5. Define the target atoms and assign to a tuple
        6. Load the electron structure fchk file output from Gaussian16 wiht ``ElectronicStructure()`` science API
        7. Get the result by input the params in the previous selection to ``bond_dipole``.
        
    .. code:: python

        bond_dipole(name_ele_stru, target_bond[0], target_bond[1])

**Let's put them together as a python script.**
        
    .. code:: python
        
        import glob
        import pytest
        import os
        import numpy as np
        from enzy_htp.core.clusters.accre import Accre
        import enzy_htp.core.file_system as fs
        from enzy_htp.structure.structure_region import create_region_from_selection_pattern
        from enzy_htp.electronic_structure import ElectronicStructure
        from enzy_htp.analysis import bond_dipole
        from enzy_htp import interface
        from enzy_htp import PDBParser

        DATA_DIR = f"{os.path.dirname(os.path.abspath(__file__))}/data/"
        STRU_DATA_DIR = f"{os.path.dirname(os.path.abspath(__file__))}/../test_data/diversed_stru/"
        WORK_DIR = f"{os.path.dirname(os.path.abspath(__file__))}/work_dir/"
        sp = PDBParser()

        ke_stru = sp.get_structure(f"{DATA_DIR}KE_mutant_101_254_frame_0.pdb")
        ke_stru.assign_ncaa_chargespin({"H5J" : (0,1)})
        test_region = create_region_from_selection_pattern( ke_stru, "resi 101+254", nterm_cap = "H", cterm_cap = "H",)
        
        cap_h_1 = test_region.atoms.pop(-2)
        test_region.atoms.insert(1, cap_h_1)
        cap_h_2 = test_region.atoms.pop(-1)
        test_region.atoms.insert(15, cap_h_2)
        target_bond = (ke_stru.ligands[0].find_atom_name("CAE"), ke_stru.ligands[0].find_atom_name("H2")) 
        
        ke_ele_stru = ElectronicStructure(energy_0 = 0.0, geometry = test_region, mo = f"{DATA_DIR}KE_mutant_101_254_frame_0.fchk", mo_parser = None,source ="gaussian16") 
        result = bond_dipole(test_ele_stru, target_bond[0], target_bond[1],work_dir=WORK_DIR)

5. Done! and Run the python scripts
=========================================================================================
Now you finished the bond dipole calculation for your workflow! It is the time for launching it.



