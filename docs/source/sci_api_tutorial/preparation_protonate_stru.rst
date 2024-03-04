==============================================
 Preparation: Protonate Structure
==============================================

Briefs
==============================================

This science API, named ``enzy_htp.preparation.protonate.protonate_stru``,
solves the protein protonation problem that add missing H atoms to the supplied
``enzy_htp.structure.Structure`` class instance (hereafter referred to as ``Structure`` instance).
Protonation states are determined for residues with multiple ones.

Input/Output
==============================================

**input**: A ``Structure`` instance (no matter it's a protein, polypeptite, or ligand).

.. dropdown:: :fa:`eye,mr-1` How to obtain ``Structure`` instance?

    Structure can be obtained by 
    
    1. parsing from a file using one of the StructureParser:

    - `PDBParser <xxx>`_
    - `PrmtopParser <xxx>`_

    2. OR using the output of `Remove Solvent <preparation_remove_solvent.html>`_ or `Remove Hydrogens <preparation_remove_solvent.html>`_. (Commonly used here)

**output**: A ``Structure`` instance of protonated structure (in-place modification, not as return value).

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    .. image:: ../../figures/preparation_protonate_stru_dfd.svg
        :width: 100%
        :alt: preparation_remove_solvent

Arguments
==============================================

``stru``
    The input ``Structure`` instance (no matter it's a protein, polypeptite, or ligand).

``ph``
    The pH value for determining the protonation state.
    (Float, optional, default ``7.0``)

    .. dropdown:: :fa:`eye,mr-1` Click to learn more about ``ph``

        The choice of pH value depends on the physiological environment of the protein you are simulating.

        For example, if you are simulating a protein in human blood, then the pH value is best set in the range [7.35, 7.45].

``protonate_ligand``
    If also protonate ligand.
    
    (Boolean, optional, default ``True``)

``engine``
    Engine for determining the pKa and adding hydrogens to the protein peptide part.

    (String, optional, default ``pdb2pqr``) 
    
    .. dropdown:: :fa:`eye,mr-1` Click to learn more about ``engine``

        The ``engine`` option determines which third-party tool you use to add hydrogen atoms to your protein (polypeptide).

        Currently only ``pdb2pqr`` is available. More ``engine`` options will be available in future versions.

``ligand_engine``
    Engine for adding hydrogens to ligands (current available values: ``pybel``)

    (String, optional, default ``pybel``)
    
    .. dropdown:: :fa:`eye,mr-1` Click to learn more about ``engine``

        The ``ligand_engine`` option determines which third-party tool you use to add hydrogen atoms to your ligand.

        Currently only ``pybel`` is available. More ``ligand_engine`` options will be available in future versions.

``**kwarg``
    Setting(s)/Option(s) related to specific engine.

    (optional, default ``None``)

Examples
==============================================

Prepare the Input: Load Structure
----------------------------------------------

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    In order to make use of the API, we should have structure loaded.

    .. code:: python    

        import enzy_htp.structure as struct
                                    
        sp = struct.PDBParser()

        pdb_filepath = "/path/to/your/structure.pdb"
        stru = sp.get_structure(pdb_filepath)

Execute API
----------------------------------------------

Use ``preparation.protonate.protonate_stru`` to protonate (i.e. add hydrogen atoms to) your structure.

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    The simpliest use of ``protonate_stru`` is as follows.
        Where the ``ph`` is set to ``7.0``, and ``protonate_ligand`` is set to ``True`` by default.

    .. code:: python
        
        from enzy_htp.preparation import protonate

        protonate.protonate_stru(stru=stru)
    
    We can also directly import ``protonate_stru`` from ``enzy_htp.preparation`` since it has been cited in
    the ``__init__.py`` file of ``preparation`` module.

    .. code:: python
        
        from enzy_htp.preparation import protonate_stru
        
        protonate_stru(stru=stru)

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    We can also customize the arguments passed to this function.
      How much is your pH value? Customize ``ph``.  

      Do you want to protonate your ligands? Customize ``protonate_ligand``.

    .. code:: python
        
        protonate.protonate_stru(stru=stru, ph=6.5, protonate_ligand=False)

.. note::

    This API modifies the ``Structure`` instance (what we passed as argument ``stru``) itself and does not return any value, i.e. return ``None``.
    
    Thus, if you write ``stru = protonate.protonate_stru(stru=stru)``, your ``stru`` will very unfortunately be assigned the value ``None``.

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
