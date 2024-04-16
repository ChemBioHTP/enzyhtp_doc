==============================================
 Quick Start: 1. Build Workflow
==============================================

EnzyHTP is a python library which means it doesn't have any
direct executables but instead provides modular functions as
building blocks of any customized workflow from users. In other
word, user needs to writing a **main script** calling EnzyHTP functions
to furnish their automated workflow.

1. Modify from a Template
==============================================

As a quick-start, we will modify from a main script template
provided under the ``/template`` folder of EnzyHTP.

| In this tutorial, I will
- Explain functions used in the template
- Talk about how you can be modify them to match your own need.

**This will result in a main script. 
Running this main script will perform a HTP workflow addressing your research goal.**

.. note::

    | Creating workflow from a template is a simple but limited way.
    | See `this advanced tutorial <sci_api_tutorial/how_to_assemble.html>`_ to learn 
      how to create workflow from scratch.

.. note::

    The code below are sections from ``template/template_main.py``

1.1 Workflow Configurations
------------------------------------
This part of the code configure the workflow with some settings, I will break it
down into chunks and explain each of them. You can modify this part of the template
to change the configuration of the workflow.

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    .. code:: python                                               
                                                                    
        import pickle
        from enzy_htp.preparation import protonate_stru, remove_hydrogens
        from enzy_htp.mutation import assign_mutant, mutate_stru
        from enzy_htp.geometry import equi_md_sampling
        from enzy_htp.quantum import single_point
        from enzy_htp.analysis import bond_dipole, ele_field_strength_at_along, ele_stab_energy_of_bond
        from enzy_htp import interface
        import enzy_htp.structure.structure_constraint as stru_cons
        from enzy_htp.structure import PDBParser
        from enzy_htp.chemical.level_of_theory import QMLevelOfTheory
        from enzy_htp.core.clusters.accre import Accre

    This import EnzyHTP functions/classes to this main script. We won't 
    change anything here in our quick-start.                       

    ------------------------
    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    .. code:: python                                                  
                                                                    
        # workflow config
        # I/O path
        wt_pdb_path = "KE_07_R7_2_S.pdb"
        result_path = "ke_test_result.pickle"
        ligand_chrg_spin_mapper = {"H5J" : (0,1)} # define the charge spin for ligands and modified AAs

    This part configures input and output file path of the workflow.

    .. dropdown:: :fa:`eye,mr-1` Click to see code explanation
                                                     
        ``wt_pdb_path``                     
            the WT pdb path. This structure needs to be a structure that contains
            **no missing parts (except for the hydrogens), no wrong parts, and no redundant parts (except water).** (There will be less requirements for this input
            in the next version of EnzyHTP with the docking module)
        ``result_path``               
            the path of the result file in .pickle format 
            (this file will be generated in this path after the workflow)
        ``ligand_chrg_spin_mapper``   
            we ask users to assign the charge and spin for ligands and modified amino acids
            in the protein. they are necessary for the model.

    .. note::

        **Where to modify? (Examples)**

        - change path of the PDB file
        - assign a different charge spin to model a radical cation

            .. code::
            
                ligand_chrg_spin_mapper = {"H5J" : (1,2)}

    ------------------------
    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    .. code:: python                                                  
                                                                    
        # HPC job resources
        md_hpc_job_config = {
            "cluster" : Accre(),
            "res_keywords" : {
                "account" : "your_account",
                "partition" : "your_partition"
            }
        }
        qm_hpc_job_config = {
            "cluster" : Accre(),
            "res_keywords" : {
                "account" : "your_account",
                "partition" : "your_partition",
                'walltime' : '1-00:00:00',
            }
        }
        result_dict = {}

    This part configures the resource on the HPC you want to use.

    .. dropdown:: :fa:`eye,mr-1` Click to see code explanation

        There will be MD simulation and QM calculation in this workflow. We configure the resource
        and the HPC environment for them here.

        ``md_hpc_job_config`` ``qm_hpc_job_config``                    
            the resource for MD and QM
            See `here <sci_api_tutorial/armer.html>`_ for more details about the config format

        ``result_dict``     
            a place holder for collect the results of the workflow. no need to change this.
    
    .. note::

        **Where to modify? (Examples)**

        - Support your local cluster by changing ``"cluster" : Name_of_your_cluster()`` (`Check the Tutorial of supporting your local cluster. <qkst_cluster.html>`_)
        - For Accre user, use a real account by changing ``'account':'your_real_account_name'``
        - Change the number of cores and memory

            .. code:: python

                qm_hpc_job_config = {
                    "cluster" : Accre(),
                    "res_keywords" : {
                        "account" : "your_account",
                        "partition" : "your_partition",
                        "walltime" : "1-00:00:00",
                        "node_cores" : "24",
                        "mem_per_core" : "3G",
                    }
                }


1.2 Workflow Body
------------------------------------
This following parts assemble EnzyHTP functions to a workflow, loops through mutants, 
and calculate their properties

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    .. code:: python                                                  
                                                                    
        # 1. create Structure()
        wt_stru = PDBParser().get_structure(wt_pdb_path)

        # 2. prepare
        remove_hydrogens(wt_stru, polypeptide_only=True)
        protonate_stru(wt_stru, protonate_ligand=False)


    This 1st & 2nd part create the ``Structure()`` and prepares the enzyme.
    We will not modify this part in this quick start.

    .. dropdown:: :fa:`eye,mr-1` Click to see code explanation

        ``wt_stru``
            | In EnzyHTP, ``Structure`` serve as a center class that describes the structure of a protein.
              Most functions in EnzyHTP are operations of Structure (i.e.: change a Residue() to mutate or add Atom()
              to fixs missing hydrogens, etc.)
            | A ``Structure()`` object is created by reading from a PDB file here using ``PDBParser``. See also other
              ways to obtain a ``Structure()`` `here <sci_api_tutorial/obtaining_stru.html>`_
    
        ``remove_hydrogens``
            this function remove hydrogens from the WT structure. See more details `here <sci_api_tutorial/remove_hydrogens.html>`_

        ``protonate_stru``
            this function protonate the structure with the correct titration state.

    ------------------------
    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    .. code:: python                                                  
                        
        # 3. create mutant library
        mutant_pattern = "WT, r:2[resi 254 around 4 and not resi 101: all not self]*2"
        mutants = assign_mutant(wt_stru, mutant_pattern)

        for i, mut in enumerate(mutants):
            mutant_result = []
            mutant_dir = f"mutant_{i}"

        # 4. mutate Structure()
            mutant_stru = mutate_stru(wt_stru, mut, engine="pymol")
            mutant_stru.assign_ncaa_chargespin(ligand_chrg_spin_mapper)

            remove_hydrogens(mutant_stru, polypeptide_only=True)
            protonate_stru(mutant_stru, protonate_ligand=False)

    This 3rd & 4th part create a target mutant library. 

    .. dropdown:: :fa:`eye,mr-1` Click to see code explanation

        ``assign_mutant`` 
            this powerful function allows you to create mutant library in a flexible manner.
            You can apply mutation strageties such as site-saturation mutagenesis, mutating residues
            from large to small, random mutation, etc. by writing different mutant_pattern. 
            (See syntax `here <sci_api_tutorial/assign_mutant.html#mutant-pattern>`_) 
        
        After creating the library, we use a for loop in Python to study each mutant in the library in each loop.
        For each loop, a ``mutant_result`` is initiated as a place holder for the result for this mutant. The ``mutant_dir``
        is determined as the sub-directory that contains MD files for this mutant.

        For each mutant, 

        ``mutate_stru``
            this function mutate the Struture() and create the corresponding mutant Structure()
            (See details `here <sci_api_tutorial/mutate_stru.html>`_)
        
        We then do another round of protonation to consider a perturbed protonation state of the protein mutant.

    .. note::

        **Where to modify? (Examples)**

        - Study a specific mutant by changing the ``mutant_pattern`` (See syntax `here <sci_api_tutorial/assign_mutant.html#mutant-pattern>`_) 

            .. code:: python

                mutant_pattern = "R154W"

    ------------------------
    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    .. code:: python                                                  
                                                                    
        # 5. sampling with MD
            param_method = interface.amber.build_md_parameterizer(
                ncaa_param_lib_path=f"ncaa_lib",
                force_fields=[
                    "leaprc.protein.ff14SB",
                    "leaprc.gaff2",
                    "leaprc.water.tip3p",
                ],
            )
            mut_constraints = [
                stru_cons.create_distance_constraint("B.254.H2", "A.101.OE2", 2.4, mutant_stru),
                stru_cons.create_angle_constraint("B.254.CAE", "B.254.H2", "A.101.OE2", 180.0, mutant_stru),
            ]

            md_result = equi_md_sampling(
                stru = mutant_stru,
                param_method = param_method,
                cluster_job_config = md_hpc_job_config,
                job_check_period=10,
                prod_constrain=mut_constraints,
                prod_time= 0.1, #ns
                work_dir=f"{mutant_dir}/MD/"
            )

            for replica_esm in md_result:
                replica_result = []

    This 5th part sample a geometrical ensemble for the enzyme. (still in the loop)

    .. dropdown:: :fa:`eye,mr-1` Click to see code explanation

        ``param_method``
            | this defines the force field and the MD engine you want to use.
            | Here we used Amber with ff14SB, TIP3P, and GAFF2
        
        ``mut_constraints``
            | this defines the constraint added in the MD.
            | here we add distance and angle constraint between the 2 atoms of the forming bond
              to create a TS-analog
        
        ``equi_md_sampling``
            | this function runs the MD simulation. It will submit a job to the HPC.
            | ``prod_time`` specifies the length of the MD simulation. We use 0.1 ns here for demo purpose

    The result of the MD simulation are replica trajectories from the production run. (by default 3 replica)
    We loop through it to calculate mutant properties for each replica.

    .. note::

        **Where to modify? (Examples)**

        - change ``prod_time = 100.0`` to change the length of the MD
        - change the force field by changing the names in ``force_field``

            .. code:: python

                param_method = interface.amber.build_md_parameterizer(
                    ncaa_param_lib_path=f"ncaa_lib",
                    force_fields=[
                        "leaprc.protein.ff19SB",
                        "leaprc.gaff2",
                        "leaprc.water.tip4p",
                    ],
                )

        - apply a different constraint by changing the atom key and the constraint value

            .. code:: python

                mut_constraints = [
                    stru_cons.create_distance_constraint("B.254.H2", "A.101.OE2", 1.8, mutant_stru),
                ]
                # format: chain_id.residue_idx.atom_name
        
        - run only 1 replica of the MD
    
            by default 3 replicas are run. You can set it to only run 1 by 
            set ``parallel_runs = 1`` in ``equi_md_sampling``

    ------------------------
    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    .. code:: python                                                  
                                                                    
        # 6. electronic structure
                qm_results = single_point(
                    stru=replica_esm,
                    engine="gaussian",
                    method=QMLevelOfTheory( basis_set="3-21G", method="hf" ),
                    regions=["resi 101+254"],
                    cluster_job_config=qm_hpc_job_config,
                    job_check_period=60,
                    job_array_size=20,
                    work_dir=f"{mutant_dir}/QM_SPE/",
                )

    This 6th part calculate wavefunction for active site of the enzyme using QM cluster. (still in the loop)

    .. dropdown:: :fa:`eye,mr-1` Click to see code explanation

        ``replica_result``
            this is the place holder of each replica

        ``single_point``
            this function calculates wavefunction for each frame in a trajectory (as a ``StructureEnsemble()``) using QM.
            (See `here <sci_api_tutorial/single_point.html>`_ for more details)

    .. note::

        **Where to modify? (Examples)**

        - change QM region by changing ``regions = ['resi 123+456+789']`` (this follows PyMol selection syntax)
        - change QM level of theory by changing ``method=QMLevelOfTheory( basis_set="def2-svp", method="b3lyp-d3" )``.
        - You can also remove this whole section if you don't want to do QM.

    ------------------------
    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    .. code:: python                                                  
                                                                    
        # 7. analysis
                for ele_stru in qm_results:
                    this_frame_stru = ele_stru.geometry.topology
                    atom_1 = this_frame_stru.get("B.254.CAE")
                    atom_2 = this_frame_stru.get("B.254.H2")

                # bond dipole
                    dipole = bond_dipole(
                        ele_stru, atom_1, atom_2,
                        work_dir=f"{mutant_dir}/bond_dipole/"
                    )
                # EF
                    field_strength = ele_field_strength_at_along(
                        this_frame_stru, atom_1, atom_2, region_pattern="chain A and (not resi 101)"
                    )
                # dGele
                    dg_ele = ele_stab_energy_of_bond(dipole[0], field_strength)

                    replica_result.append((dg_ele, dipole, field_strength))

                mutant_result.append(replica_result)

            result_dict[tuple(mut)] = mutant_result

    This 7th part calculate properties for mutants. (still in the loop)

    .. .. dropdown:: :fa:`eye,mr-1` Click to see code explanation

    ..     With the model generated by QM and MM, we calculate enzyme's internal electric field strength (``get_field_strength``),
    ..     the reacting bond dipole moment (``get_bond_dipole``), and the substrate positing index (or SASA ratio) (``get_sasa_ratio``).
    ..     Note that we use ``get_stru()`` to update the topology to the latest one before MD.

    ..     Most of the code are self-explaining in this part. I will explain for:
        
    ..     ``a1 = int(pdb_obj.stru.ligands[0].CAE)``
    ..         This gets the atomic index of the "CAE" atom in the substrate. The index is access in a pythonic way.
    ..     ``a1qm = pdb_obj.qm_cluster_map[str(a1)]``
    ..         This converts the atom index of a1 in the PDB to the atom index of a1 in the gaussain input/output file.
    ..     ``e_atom_mask``
    ..         This defines the region that EnzyHTP use to calculate the electric field strength.
    ..     ``mask_sasa, mask_pro, mask_sub``
    ..         These masks are the only masks that support the full Amber masking syntax.

    .. note::

        **Where to modify? (Examples)**

        - keep only functions that calculate the properties your want.
        - add functions to calculate other properties like 

            .. code::

                # MMPBSA
                ligand_mask = ":902"
                mmpbsa_result_dict = pdb_obj.get_mmpbsa_binding(
                    ligand_mask,
                    cluster=Accre(),
                    res_setting = {'account':'yang_lab'})

    ------------------------
    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    .. code:: python                                                  
                                                                    
        # Output (choose one of the two)
                # write output (python style)
                result = {
                    'mutant':pdb_obj.MutaFlags,
                    'field_strength': e_list,
                    'bond_dipole': dipole_list,
                    'sasa_ratio': sasa_ratio,
                    'traj': pdb_obj.mdcrd,
                    }
                with open(data_output_path_pickle, "ab") as of:
                    pickle.dump(result, of)

                # write output (readable style)
                write_data(
                    pdb_obj.MutaFlags, 
                    {
                    'field_strength': e_list,
                    'bond_dipole': dipole_list,
                    'sasa_ratio': sasa_ratio,
                    'traj': pdb_obj.mdcrd,
                    },
                    data_output_path_dat)

    This 6th part save our results for each mutant to the output file (still in the loop)

    You can choose between 2 styles: **pickle** or **readable**. If you don't know what pickle is, choose
    readable. You need to delete or comment out the other one after choosing. (otherwise it will save both)

    This will save the data in a file that **you specified at the beginning**. Both are python friendly that
    you can use python to further plot/analyze the data


2. Running the Workflow
==============================================
Now we finished customizing the workflow. It is the time for launching it.

Here is what your working directory should look like before the launching:

.. code:: bash

    .
    ├── template_main.py
    ├── template_hpc_submission.sh
    ├── your_target_wt_enzyme.pdb
    └── ligands # (optional) add this when you customize ligand parameters
        ├── ligand_XYZ.frcmod # XYZ is the ligand 3-letter code
        └── ligand_XYZ.prepin

(``template/template_wk_dir`` give an example of such a working dir before putting the 2 scripts in)

``template_hpc_submission.sh`` is the job submission script for our workflow main script (``template_main.py``). This main script runs only requires 1 CPU and 6GB memory.
It will submit computationally intensive jobs in the workflow to other computing nodes. (e.g.: MD and QM) 
The walltime for the main script should cover the maximum time span of your workflow.

.. dropdown:: :fa:`eye,mr-1` **Do this** if you are NOT in Vanderbilt...

    You may also need to modify the ``template_hpc_submission.sh`` to match with your local cluster. Here are some instructions:

    In ``template_hpc_submission.sh``:

    1. Change ``line 1-10`` (resource settings) to match your local cluster's scheduler syntax. (checkout the submission script you normally use)
    2. Change ``line 12-24`` (environment settings) to match your local environmental setting (e.g.: how you normally load Gaussian, AmberTool, and Multiwfn)

.. dropdown:: :fa:`eye,mr-1` **Do this** if you are in Vanderbilt...

    In ``template_hpc_submission.sh``:

    1. Change ``xxx`` in ``line 3`` to a valid value. (e.g.: yang_lab)
    2. Change ``EFdesMD`` in ``line 2`` to a customized name for your workflow
    3. Change the path of conda ``line 22`` and the path of EnzyHTP ``line 24`` to match your own paths

Now submit the main script under this working directory. Here is an example command for submission on ACCRE @Vanderbilt:

.. code:: bash

    sbatch template_hpc_submission.sh

**Now wait for results and enjoy the power of automation of EnzyHTP!**
