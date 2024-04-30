==============================================
 Geometry: Equilibrium Molecular Dynamics Sampling
==============================================

Briefs
==============================================

This science API, named ``enzy_htp.geometry.equi_md_sampling``,
performs a production run of molecular dynamics simulation with the system equilibrated 
by several short md simulations from the starting ``enzy_htp.structure.Structure`` class instance 
(hereafter referred to as ``Structure`` instance).

(Basically md_simulation() with preset steps)
min (micro) -> heat (NVT) -> equi (NPT) -> prod (NPT)


.. dropdown:: :fa:`eye,mr-1` Click to learn more about protein protonation

    Some supplementary information concerning MD simulation.

Input/Output
==============================================

**input**: A ``Structure`` instance (no matter it's a protein, polypeptite, or ligand).

.. admonition:: How to obtain

    A ``Structure`` instance can be obtained by these `APIs <obtaining_stru.html>`_.

    Note: Structure(s) with missing loops are not acceptable.

**output**: A list of ``StructureEnsemble`` instances, i.e. a list trajectories for each replica in StructureEnsemble format.

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    .. image:: ../../figures/preparation_protonate_stru_dfd.svg
        :width: 100%
        :alt: preparation_remove_solvent

Arguments
==============================================

``stru``
    The input ``Structure`` instance (no matter it's a protein, polypeptite, or ligand).

    (See `Input/Output <#input-output>`_ section)

``param_method`` 
    The ``MolDynParameterizer`` instance for parameterization, constructed by ``Parameterizer()``, which determines the engine.

    .. dropdown:: :fa:`eye,mr-1` Click to learn more about ``ph``

        XXX

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

    (``List[stru_cons.StructureConstraint]``, optional, default ``None``)

``record_period``
    The simulation time period for recording the geom. (unit: ns)

    (Float, optional, default ``0.5``)

``cluster_job_config``
    The config for cluster_job if it is used as the parallel method.

    (Dictionary, optional, default ``None``)

    .. dropdown:: :fa:`eye,mr-1` Click to learn more about ``ph``

        XXX

``cpu_equi_step``
    Whether to use CPUs for equilibrium step.

    (Boolean, optional, default ``None``)

    .. dropdown:: :fa:`eye,mr-1` Click to learn more about ``ph``

        XXX

``cpu_equi_job_config``
    The job config for the CPU equilibrium step if specified.

    (Dictionary, optional, default ``None``)

    .. dropdown:: :fa:`eye,mr-1` Click to learn more about ``ph``

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

Use ``preparation.protonate_stru`` to protonate (i.e. add hydrogen atoms to) your structure.

The simpliest use of ``protonate_stru`` is as follows.
    Where the ``ph`` is set to ``7.0``, and ``protonate_ligand`` is set to ``True`` by default.

.. code:: python
    
    from enzy_htp.preparation import protonate_stru

    protonate_stru(stru=stru)

We can also customize the arguments passed to this function.
    How much is your pH value? Customize ``ph``.  

    Do you want to protonate your ligands? Customize ``protonate_ligand``.

.. code:: python
    
    protonate.protonate_stru(stru=stru, ph=6.5, protonate_ligand=False)

.. note::

    This API modifies the ``Structure`` instance (what we passed as argument ``stru``) itself and does not return any value, i.e. return ``None``.
    
    Thus, if you write ``stru = protonate.protonate_stru(stru=stru)``, your ``stru`` will very unfortunately be assigned the value ``None``, so Please Don't Do This!

Check the Output
----------------------------------------------

Let's try executing the API here and check if there's any changes taking place.

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    We choose the structure of a complex containing SARS-Cov-2 Main Protease 
    and Nirmatrelvir for example, whose solvent has been removed manually.

    Set ``ph=7.4`` (which is the pH value of human blood) and ``protonate_ligand=True`` (to protonate Nirmatrelvir).

    Now, we can go through the procedure.

    .. code:: python
        
        import enzy_htp.structure as struct
        from enzy_htp.preparation import protonate
                                    
        sp = struct.PDBParser()

        pdb_filepath = "7si9_rm_water.pdb"  # The structure of a complex containing SARS-Cov-2 Main Protease and Nirmatrelvir.
        stru = sp.get_structure(pdb_filepath)

        print(stru.num_atoms)   # 2402.
        protonate.protonate_stru(stru=stru, ph=7.4, protonate_ligand=True)
        print(stru.num_atoms)   # 4751.
    
We may notice that, after executing the API, the number of atoms (``num_atoms``) in the structure increased,
representing that the hydrogen atoms have been added to the structure.

Author: Zhong, Yinjie <yinjie.zhong@vanderbilt.edu>