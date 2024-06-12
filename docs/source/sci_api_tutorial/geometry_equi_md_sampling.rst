=======================================================
Geometry: Equilibrium Molecular Dynamics Sampling
=======================================================

Briefs
==============================================

This science API, named ``enzy_htp.geometry.equi_md_sampling``,
performs a production run of Molecular Dynamics Simulation (hereinafter called **MD Simulation**) 
with the system equilibrated by several short md simulations from the starting ``enzy_htp.structure.Structure`` class instance 
(hereafter referred to as ``Structure`` instance).

.. dropdown:: :fa:`eye,mr-1` Click to learn more about **Equilibrium Molecular Dynamics Sampling**

    (Basically md_simulation() with preset steps)
    Minimalization (micro) -> Heating (NVT) -> Equilibrium (NPT) -> Production (NPT)

Input/Output
==============================================

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    .. image:: ../../figures/geometry_equi_md_sampling.svg
        :width: 100%
        :alt: preparation_remove_solvent

**input**: A well-preparaed ``Structure`` instance (no matter it's a protein, polypeptite, or ligand) and a ``MolDynParameterizer`` instance.

.. admonition:: How to obtain well-preparaed ``Structure`` instance

    A ``Structure`` instance can be obtained by these `APIs <obtaining_stru.html>`_.

    Note: Structure(s) with missing loops are not acceptable.

    To prepare structure, please refer to these `APIs <preparation.html>`_.

.. admonition:: How to compose ``MolDynParameterizer`` instance

    The ``MolDynParameterizer`` class is a parameterizer for Molecular Dynamics simulation.

    For detailed instructions, see `Molecular Dynamics Parameterizer <geometry_mol_dyn_param.html>`_.

**output**: A list of ``StructureEnsemble`` instances, i.e. a list trajectories for each replica in StructureEnsemble format.

Arguments
==============================================

``stru``
    The input ``Structure`` instance (no matter it's a protein, polypeptite, or ligand).

    (See `Input/Output <#input-output>`_ section)

``param_method`` 
    The ``MolDynParameterizer`` instance for parameterization, constructed by ``Parameterizer()``, which determines the engine.

    (See `Input/Output <#input-output>`_ section)

``parallel_runs``
    The number of desired parallel runs of the steps.

    (Integer, optional, default ``3``)

``parallel_method``
    The method to parallelize the multiple runs.

    (String, optional, default ``cluster_job``)

``work_dir``
    The directory that contains all the MD input/intermediate/output files.

    (String, optional, default ``./MD``)

``prod_time``
    The simulation time in production step (unit: ns)

    (Float, optional, default ``50.0``)

``prod_temperature``
    The production temperature (unit: K).

    (Float, optional, default ``300.0``)

``prod_constrain``
    The constrain applied in the production step.

    (``List[structure_constraint.StructureConstraint]``, optional, default ``None``)

    .. dropdown:: :fa:`eye,mr-1` Click to learn more about ``StructureConstraint``

        ``StructureConstraint`` is a class from ``enzy_htp.structure.structure_constraint`` module, defining the API for a constraint.
        
        Each primitive StructureConstraint defines exactly one type of interaction. 
        
        StructureConstraints are meant to define flexible, non-package specific relationships that can be translated 
        in between different software packages.

``record_period``
    The simulation time period for recording the geometry. (unit: ns)

    (Float, optional, default ``0.5``)

``cluster_job_config``
    The config for cluster_job if it is used as the parallel method.

    (Dictionary, optional, default ``None``)

    .. dropdown:: :fa:`eye,mr-1` Click to learn more about ``cluster_job_config``

        The value of this argument depends on the settings of the supercomputer/cluster you use.

``cpu_equi_step``
    Whether to use CPUs for equilibrium step.

    (Boolean, optional, default ``False``)

    .. dropdown:: :fa:`eye,mr-1` Click to learn more about ``cpu_equi_step``

        XXX

``cpu_equi_job_config``
    The job config for the CPU equilibrium step if specified, functions when ``cpu_equi_step=False``.

    (Dictionary, optional, default ``None``)

    .. dropdown:: :fa:`eye,mr-1` Click to learn more about ``cpu_equi_job_config``

        XXX

``job_check_period``
    The check period for wait_to_2d_array_end, functions when ``parallel_method='cluster_job'``. (unit: s)

    (Integer, optional, default ``210``)


Examples
==============================================

Prepare the Input: Load Structure
----------------------------------------------

In order to make use of the API, we should have structure loaded.

.. code:: python    

    import enzy_htp.structure as struct
                                
    sp = struct.PDBParser()

    pdb_filepath = "/path/to/your/structure.pdb"
    stru = sp.get_structure(pdb_filepath)

Execute API
----------------------------------------------

Use ``geometry.equi_md_sampling`` to implement Equilibrium MD Simulation.

.. code:: python    

    import enzy_htp.structure as struct
                                
    sp = struct.PDBParser()

    pdb_filepath = "/path/to/your/structure.pdb"
    stru = sp.get_structure(pdb_filepath)

    from enzy_htp.core.clusters.accre import Accre
    from enzy_htp.geometry import md_simulation, equi_md_sampling
    from enzy_htp import interface

    amber_interface = interface.amber

    param_method = amber_interface.build_md_parameterizer()
    cluster_job_config = {
        "cluster" : Accre(),    # This is the interface for operating Vanderbilt University's Advanced Computational Cluster for Research and Education.
                                # You can customize a new class in `enzy_htp.core_cluster` folder so as 
                                # to have it compatible to the computational cluster resources in your own institution(s).
        "res_keywords" : {
            "account" : "csb_gpu_acc",
            "partition" : "turing"
        }
    }
    md_result = equi_md_sampling(
        stru = stru,
        param_method=param_method,
        cluster_job_config=cluster_job_config,
        job_check_period=10,
        prod_time=0.5,
        record_period=0.05)

.. note::

    Here, we execute MD simulation with a very short ``prod_time`` for example use.

    In real cases, the ``prod_time`` will usually be 30 ns ~ 110 ns.

Check the Output
----------------------------------------------

Let's try executing the API here and check if there's any changes taking place.

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    Here, we use a well-preparaed complex containing SARS-Cov-2 Main Protease and Nirmatrelvir for example.

    .. code:: python

        import enzy_htp.structure as struct
                                    
        sp = struct.PDBParser()

        pdb_filepath = "7si9_rm_water_aH.pdb"
        stru = sp.get_structure(pdb_filepath)

        from enzy_htp.core.clusters.accre import Accre
        from enzy_htp.geometry import md_simulation, equi_md_sampling
        from enzy_htp import interface

        amber_interface = interface.amber

        param_method = amber_interface.build_md_parameterizer()
        cluster_job_config = {
            "cluster" : Accre(),    # This is the interface for operating Vanderbilt University's Advanced Computational Cluster for Research and Education.
                                    # You can customize a new class in `enzy_htp.core_cluster` folder so as 
                                    # to have it compatible to the computational cluster resources in your own institution(s).
            "res_keywords" : {
                "account" : "csb_gpu_acc",
                "partition" : "a6000x4"
            }
        }
        md_result = equi_md_sampling(
            stru = stru,
            param_method=param_method,
            cluster_job_config=cluster_job_config,
            job_check_period=10,
            prod_time=0.5,
            record_period=0.05)

        len(md_result) # 3.
    
We may notice that the MD simulation has generated 3 snapshots and stored in ``md_result``.

Author: Zhong, Yinjie <yinjie.zhong@vanderbilt.edu>