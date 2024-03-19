.. warning::

    This page is outdated

==============================================
 Quick Start: 1. Build Workflow
==============================================

EnzyHTP is a python library which means it doesn't have any
direct executables but instead provides modular functions as
building blocks of any customized workflow from users. In other
word, user needs to writing a main script calling EnzyHTP functions
to furnish their automated workflow.

1. Modify from a Template
==============================================

As a quick-start, we will modify from a main script template
provided under the ``/template`` folder of EnzyHTP.

- I will explain functions used in the template
- Talk about how they can be modified to match customized demand from users.
- Commonly changed parts are highlighted in the **blue boxes**.

**This will result in a main script. 
Running this main script will perform a HTP workflow addressing your research target.**

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
                                                                    
        from core.clusters.accre import Accre                      
        from Class_PDB import PDB                                  
        from Class_Conf import Config                              
        from helper import write_data                              

    This import EnzyHTP functions/classes to this script. We won't 
    change anything here in our quick-start.                       

    ------------------------
    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    .. code:: python                                                  
                                                                    
        # Configurations                                              
        ## resource of the main script                                
        Config.n_cores = 1                                            
        Config.max_core = 2000 #MB                                    
        ## Details of MD                                              
        Config.Amber.conf_equi['nstlim'] = 500000 # * 2 fs = 1 ns     
        Config.Amber.conf_prod['nstlim'] = 55000000 # * 2 fs = 110 ns 
        Config.Amber.conf_prod['ntwx'] = '50000' # * 2 fs = 0.1 ns    

    This part configures part of the workflow behavior.

    .. dropdown:: :fa:`eye,mr-1` Click to see code explanation

        The upper part configures the resource this main script would expect. They mostly only used for running python,
        MD and QM will be wrapped up and submitted to computing nodes by `ARMer@EnzyHTP <https://pubs.acs.org/doi/10.1021/acs.jcim.3c00618>`_.
        So 1 CPU and 2000 MB is enough.

        The lower part configures settings for MD simulations. (The MD settings here applies globally in this main script.)     
        Both are set by changing values of constants in the Config class.
                                                                        
        ``Config``                     
            contains general settings.
        ``Config.Amber``               
            contains Amber specific settings.
        ``Config.Amber.conf_prod``     
            is a dictionary that contains settings of the production run of the MD. (those would appears in your .in files)
            You can find settings of other MD steps (min, heat, equi) using the same naming convention.
    
    .. note::

        **Where to modify? (Examples)**

        - change the length of the MD by changing to ``Config.Amber.conf_prod['nstlim'] = 10000``
        - change the temperature of the MD by adding

            .. code::
            
                Config.Amber.conf_prod['temp0'] = '400.0'
                Config.Amber.conf_equi['temp0'] = '400.0'
                Config.Amber.conf_heat['temp0'] = '400.0'

        - change the solvation box of the MD by adding

            .. code::
            
                Config.Amber.box_type = 'box' # default: oct
                Config.Amber.box_size = 20 # default: 10

    ------------------------
    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    .. code:: python                                                  
                                                                    
        # Input                                                       
        mutants = [                                                   
            ['AA9R', 'NA22K'],                                        
            ['VA127D', 'YA128D'],                                     
            ['RA163L']                                                
        ]                                                             
        wt_pdb = "KE_07_R7_2_S.pdb"                                   
        # Output                                                      
        data_output_path_pickle = './mutant_property.pickle'          
        data_output_path_dat = './mutant_property.dat'                

    This part contains the overall input of the high-throughput workflow.

    .. dropdown:: :fa:`eye,mr-1` Click to see code explanation

        ``mutants``
            set a list of mutants of interest. Each mutant is described by a list of flags specifying mutations.
            They conform a format of ``XA##Y`` which A is the chain id. (if omitting the chain id, it will using chain A as default.)
        ``wt_pdb``
            set path of the PDB file contaning the wild-type structure. This structure needs to be a structure that contains
            **no missing parts (except for the hydrogens), no wrong parts, and no redundant parts (except water).** (There will be less requirements for this input
            in the next version of EnzyHTP with the new architecture and the docking module.)                         
        ``data_output_path_pickle``
            set path for the output data. (when using pickle, see the comment in later section)
        ``data_output_path_dat``
            set path for the output data. (when using just text)

    .. note::

        **Where to modify? (Examples)**

        - apply your actual research target by changing ``mutants = ['YOUR_MUTANT_1', 'YOUR_MUTANT_2']`` and ``wt_pdb = 'a_different_enzyme.pdb'``


1.2 Workflow Body
------------------------------------
This following parts assemble EnzyHTP functions to a workflow and loops through mutants.

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    .. code:: python                                                  
                                                                    
        def main():
            for mut in mutants:        
            # Prepare
                pdb_obj = PDB(wt_pdb, wk_dir=f"./mutation_{'_'.join(mut)}")
                pdb_obj.rm_wat()
                pdb_obj.rm_allH()
                pdb_obj.get_protonation(if_prt_ligand=0)

    This 1st part prepares the enzyme.

    .. dropdown:: :fa:`eye,mr-1` Click to see code explanation

        .. note::

            In the old architecture of EnzyHTP, the code is centered around the PDB class. It represents the PDB file
            of your current structure of operation. Changes to the structure will create a new PDB file and associate
            with the PDB object by ``pdb_obj.path``. A Structure object can be generated on demand by ``pdb_obj.get_stru()``.
            This design is entirely changed in the new architecture. EnzyHTP will center around the Structure class in the next
            version. (Expecting it next spring.)

        For each mutant in mutants of interest, we first create a PDB object using the wild-type pdb. In PDB():
    
        ``wk_dir``
            allows you to set sub-directories for each mutant. In the template it is named by putting the
            flag of the mutations together using ``join``.

        Then, the ``rm_wat()`` method removes water and counter ions.
        And ``rm_allH()`` method removes all the hydrogens in the structure in case there are wrong
        ones. By default, it won't remove those on the ligand. Finally, ``get_protonation()`` protonate the
        structure with correct protonation state.

        ``if_prt_ligand``
            set if you want to also protonate the ligand. It is turned off by default since you may want to have absolute control
            of the protonate states on your ligand in most of the time.

    ------------------------
    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    .. code:: python                                                  
                                                                    
        # Mutation
                pdb_obj.Add_MutaFlag(mut)
                pdb_obj.PDB2PDBwLeap()
                ## use minimization to relax the crude initial mutant structure
                pdb_obj.PDB2FF(local_lig=0, ifsavepdb=1)
                pdb_obj.PDBMin(cycle=20000,
                            engine='Amber_CPU', 
                            if_cluster_job=1,
                            cluster=Accre(),
                            period=180,
                            res_setting={'node_cores': '24',
                                            'mem_per_core' : '3G',
                                            'account':'xxx'} )
                pdb_obj.rm_wat()
                ## protonation perturbed by mutations
                pdb_obj.rm_allH()
                pdb_obj.get_protonation(if_prt_ligand=0)

    This 2st part mutate the enzyme. (still in the loop)

    .. dropdown:: :fa:`eye,mr-1` Click to see code explanation

        For each prepared PDB object, we use ``Add_MutaFlag()`` to assign the mutation we want to investigate.
        You can also replace mut with ``r`` to generate random mutations.

        .. note::

            In the next version of EnzyHTP, we developed a
            `more powerful way <https://github.com/ChemBioHTP/EnzyHTP/blob/29071a4fa6840f446ca40e0ec49b98dcf8b189f5/enzy_htp/mutation/api.py#L67>`_
            that allows you to assign a set of target mutants.
        
        | ``PDB2PDBwLeap()`` deploy the mutant structure to the PDB object.
        | ``PDB2FF()`` solve the system and generate Amber parameter files based on the PDB for the following MM minimization.

            ``local_lig``
                specifies whether always regenerate the parameter for the ligand or generate only once for each ligand.
                By default it is False and it creates a ligand/ folder under the same folder as you run this main script (the parent directory
                of all mutant sub-directories) and frcmod and prepin files will be generated (once for each unique ligand name) and shared in this
                folder by all mutants.
                It also allows you to costomize your own ligand (say it names "XYZ") parameter files by just putting 2 files
                named ``ligand_XYZ.prepin`` and ``ligand_XYZ.frcmod``.

        | ``PDBMin()`` runs a MM minimization to relax possible bad contacts from mutations. In this method:

            ``cycle``
                specifies the number of minimization steps.
            ``engine``
                specifies the minimization engine. 
                (only Amber_CPU and Amber_GPU is supported here. using GPU is not recommanded here 
                due to the illegal memory problem brought by potential large forces from bad contact.)
            ``if_cluster_job``
                specifies the minimization will by submitted to another computing node.
            
            (following commands are only used when if_cluster_job=1)

            ``cluster``
                provide the information of the cluster. The information is wrapped up as a ClusterInterface class.
                Take a 1-time effort and make one for your local HPC by fullfilling requests from `ClusterInterface <https://github.com/ChemBioHTP/EnzyHTP/blob/47f733b994fd3b96b3aff6f4d0174a9718da6617/core/clusters/_interface.py#L11>`_ 
                You can use the `Accre <https://github.com/ChemBioHTP/EnzyHTP/blob/master/core/clusters/accre.py>`_ class as reference. (Note that there are some optional methods defined in the Accre class)
                
                `Here is a tutorial of steps to support your local cluster. <qkst_cluster.html>`_

            ``period``
                the time period that EnzyHTP will check for the completion of the job.

            ``res_setting``
                set the resource requesting from the cluster. Check available keys from `here <https://github.com/ChemBioHTP/EnzyHTP/blob/47f733b994fd3b96b3aff6f4d0174a9718da6617/core/clusters/_interface.py#L49>`_

        | ``rm_wat()`` removes waters from the minimization.
        | ``rm_allH()`` removes all the hydrogens.
        | ``get_protonation()`` protonates the enzyme again considering it perturbed by mutations.

    .. note::

        **Where to modify? (Examples)**

        - Support your local cluster by changing ``cluster = Name_of_your_cluster()`` (`The Tutorial of supporting your local cluster. <qkst_cluster.html>`_)
        - For Accre user, use a real account by changing ``'account':'your_real_account_name'``
        - You can also remove this whole section if you don't want to do mutation.

    ------------------------
    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    .. code:: python                                                  
                                                                    
        # MD sampling
                pdb_obj.PDB2FF(local_lig=0, ifsavepdb=1)
                pdb_obj.PDBMD(engine='Amber_GPU', 
                            if_cluster_job=1,
                            cluster=Accre(),
                            period=600,
                            res_setting={'account':'xxx'} )
                ## sample from traj (.nc file)
                pdb_obj.nc2mdcrd(start=101,step=10)

    This 3rd part sample a geometrical ensemble for the enzyme. (still in the loop)

    .. dropdown:: :fa:`eye,mr-1` Click to see code explanation

        For each mutated PDB object, we use ``PDB2FF()`` to solve the system and generate Amber parameter files. (explained in the 2nd part)
        We also saved the solvated pdb by ``ifsavepdb=1`` here to record the very input structure of MD.

        We then run a MD simulation with ``PDBMD()`` it is also configured to be submitted to queue as explained above in ``PDBMin()``.

        After MD finishes, we sample snapshots from MD using ``nc2mdcrd()``. You can specify the start and end frame as well as stepsize or total frames.
        See details here `<https://github.com/ChemBioHTP/EnzyHTP/blob/47f733b994fd3b96b3aff6f4d0174a9718da6617/Class_PDB.py#L2370>`_

    .. note::

        **Where to modify? (Examples)**

        - support your local cluster by changing ``cluster = Name_of_your_cluster()`` (`The Tutorial of supporting your local cluster. <qkst_cluster.html>`_)
        - for Accre user, use a real account by changing ``'account':'your_real_account_name'``

    ------------------------
    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    .. code:: python                                                  
                                                                    
        # QM Cluster
                atom_mask = ':101,254'
                g_route = '# pbe1pbe/def2SVP nosymm'
                pdb_obj.PDB2QMCluster(  atom_mask, 
                                        g_route=g_route,
                                        ifchk=1,
                                        if_cluster_job=1, 
                                        cluster=Accre(), 
                                        job_array_size=20,
                                        period=120,
                                        res_setting={'account':'xxx'} )
                pdb_obj.get_fchk(keep_chk=0)

    This 4th part calculate wavefunction for active site of the enzyme using QM. (still in the loop)

    .. dropdown:: :fa:`eye,mr-1` Click to see code explanation

        The MD simulation will add trajectory as a property into the pdb object ``pdb_obj.mdcrd``, we use ``PDB2QMCluster()`` to calculate QM for
        a QM cluster. This QM cluster is defined by
        
        ``atom_mask``
            the pseudo-amber-style masking for the QM cluster region. (only support residue selection for this old version.)
        ``g_route``
            the exact line that will be in the gaussain input file specifying the level of theory.

        The ``PDB2QMCluster()`` method is also running QM on other computing nodes like mentioned in PDBMin() in the 2nd section.

        After QM, we use ``get_fchk()`` to generate readable wavefunction files.

        .. note::
            The QM interface and the selection syntax in atom_mask is entirely changed in the new architecture. We use pymol as the selection engine
            now so it follows the pymol syntax with the full pymol structure selection power.

    .. note::

        **Where to modify? (Examples)**

        - support your local cluster by changing ``cluster = Name_of_your_cluster()`` (`The Tutorial of supporting your local cluster. <qkst_cluster.html>`_)
        - for Accre user, use a real account by changing ``'account':'your_real_account_name'``
        - change QM region by changing ``atom_mask = ':123,456,789'`` 
        - change QM level of theory by changing ``g_route = '# b3lyp/def2svp em=gd3bj nosymm'`` Note that ``nosymm`` is always needed.
        - You can also remove this whole section if you don't want to do QM.

    ------------------------
    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    .. code:: python                                                  
                                                                    
        # --- Analysis ---
                pdb_obj.get_stru()
                # targeting C-I bond
                a1 = int(pdb_obj.stru.ligands[0].CAE)
                a2 = int(pdb_obj.stru.ligands[0].H2)
                a1qm = pdb_obj.qm_cluster_map[str(a1)]
                a2qm = pdb_obj.qm_cluster_map[str(a2)]
                # Field Strength (MM)
                e_atom_mask = ':1-100,102-253'
                e_list = pdb_obj.get_field_strength(
                    e_atom_mask,
                    a1=a1, a2=a2, bond_p1='center') 
                # Bond Dipole Moment (QM)
                dipole_list = PDB.get_bond_dipole(pdb_obj.qm_cluster_fchk, a1qm, a2qm)

                # SASA ratio
                mask_sasa = ":9,11,48,50,101,128,201,202,222"
                mask_pro = ":1-253"
                mask_sub = ":254"
                sasa_ratio = PDB.get_sasa_ratio(str(pdb_obj.prmtop_path), str(pdb_obj.mdcrd), 
                                                mask_pro, mask_sasa, mask_sub)

    This 5th part calculate all kinds of properties for each mutant. (still in the loop)

    .. dropdown:: :fa:`eye,mr-1` Click to see code explanation

        With the model generated by QM and MM, we calculate enzyme's internal electric field strength (``get_field_strength``),
        the reacting bond dipole moment (``get_bond_dipole``), and the substrate positing index (or SASA ratio) (``get_sasa_ratio``).
        Note that we use ``get_stru()`` to update the topology to the latest one before MD.

        Most of the code are self-explaining in this part. I will explain for:
        
        ``a1 = int(pdb_obj.stru.ligands[0].CAE)``
            This gets the atomic index of the "CAE" atom in the substrate. The index is access in a pythonic way.
        ``a1qm = pdb_obj.qm_cluster_map[str(a1)]``
            This converts the atom index of a1 in the PDB to the atom index of a1 in the gaussain input/output file.
        ``e_atom_mask``
            This defines the region that EnzyHTP use to calculate the electric field strength.
        ``mask_sasa, mask_pro, mask_sub``
            These masks are the only masks that support the full Amber masking syntax.

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
