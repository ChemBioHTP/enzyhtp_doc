==============================================
Bond Dipole
==============================================

.. note::

    | **This bond_dipole calculation requires Multiwfn installed**

.. note::

    Science API is a special concept in EnzyHTP. They stands for those top-layer APIs
    the are supposed to be used in assembling the `workflow <https://enzyhtp-doc.readthedocs.io/en/latest/sci_api_tutorial/how_to_assemble.html#find-the-science-api-that-directly-gives-what-you-need>`__.

**You will find a detailed tutorial of how to use dipole calculation API and integrated in real cases.**

Briefs
=========================================================================================

The bond dipole calculation. This function calculate the dipole of chemical bond which for now only supporting the real chemical bond dipole.



Input/Output
=========================================================================================

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    .. image:: ../../figures/dipole_bond.svg
        :width: 100%
        :alt: dipole_bond

Input
-----------------------------------------------------------------------------------------
.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    The requirement input of the bond_dipole API contain the following components. 

**Input**: The ``ele_stru``, ``atom_1``, ``atom_2`` and  are required input

    - ``ele_stru``:
        Electronic structure which represent the wave function of the QM (Quantum Mechanics) region containing the target bond.
        
        .. admonition:: How to obtain
            
            | A Electronic Strutcuture can be obtained by these `APIs <obtaining_ele_stru.html>`_.

    - ``atom_1`` and ``atom_2``:
        Atoms defining the target bond within the region. The direction for the output of the dipole calculation is from atom_1 to atom_2. In the current version EnzyHTP2.0, dipole bond calculation only support real chemical bond (etc a forming bond). Though Multiwfn dip file contains the lone pair dipole, EnzyHTP will support the lone pair dipole calculation in the future. 
        
        .. admonition:: How to obtain
            
            | A atom_1 and atom_2 `Atom()` object can be obtained by these `APIs <obtaining_Atom.html>`_ with `create_region_from_selection_pattern()`. 

Output
-----------------------------------------------------------------------------------------
**Output**: A `Tuple[float, np.array]` contains the dipole sign and the dipole vector
The expected returns of the bond_dipole calcuation are the signed norm of the dipole and dipole vector. dipole_norm_signed is the signed norm of the dipole according to its projection to be bond vector. Dipole positive direction goes from negative to positive, and the result direction is from ``atom_1`` to ``atom_2``.

Argument code
=========================================================================================

``ele_stru``:
    Electronic structure of the QM (Quantum Mechanics) region containing the target bond.

``atom_1`` and ``atom_2``:
    Atoms defining the target bond within the region.

``method``:
the method keyword specifying the algorithm & software of the dipole calculation. User can choose different calculation methods in the future version of EnzyHTP. The method detail can find under the following reference.
    
    .. admonition:: Where to look

        REF: The Multiwfn manual version 3.6 section; 3.21.1 Functions.Electron excitation analysis.dipole
        REF: Lu, T.; Chen, F., Multiwfn: A multifunctional wavefunction analyzer. J. Comput. Chem. 2012, 33 (5), 580-592.

``work_dir``:
    Working directory containing all the files in the calculation process.

``keep_in_file``:
    Whether to keep the input file of the calculation.

``cluster_job_config``:
    Configuration for cluster job execution. User can select different configuration based on their cluster.  (default is None for local execution). (See `ARMer Config <armer.html#api-config-dict>`_ section)

``job_check_period``:
    Time cycle for updating job state changes (default is 30 seconds).


Example code
=========================================================================================
.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    We will use the script to calculate the dipole moment between the ``CAE`` atom1 and ``H2`` atom2 in the H5J ligand of KE_mutant_101_254 mutant      
        
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
        
        #import the PDBParser class and make PDBParser instance. ``sp = PDBParser()``
        ke_stru = sp.get_structure(f"{DATA_DIR}KE_mutant_101_254_frame_0.pdb")
        
        #Assign the charge and the spin for the ligand with specific name "H5J"
        ke_stru.assign_ncaa_chargespin({"H5J" : (0,1)})

        #Select the region which you want to do the dipole calculation with nterm and cterm
        test_region = create_region_from_selection_pattern( ke_stru, "resi 101+254", nterm_cap = "H", cterm_cap = "H",)
        
        #Adjust the atoms order after the capping atoms
        cap_h_1 = test_region.atoms.pop(-2)
        test_region.atoms.insert(1, cap_h_1)
        cap_h_2 = test_region.atoms.pop(-1)
        test_region.atoms.insert(15, cap_h_2)
        target_bond = (ke_stru.ligands[0].find_atom_name("CAE"), ke_stru.ligands[0].find_atom_name("H2")) 
       
        # ======= API call ========== 
        # The ElectronicStructure API for the retreiving electronic structures in fchk file
        ke_ele_stru = ElectronicStructure(energy_0 = 0.0, geometry = test_region, mo = f"{DATA_DIR}KE_mutant_101_254_frame_0.fchk", mo_parser = None,source ="gaussian16") 
        #The bond dipole calculation api 
        result = bond_dipole(test_ele_stru, target_bond[0], target_bond[1],work_dir=WORK_DIR)

Done!
=========================================================================================



