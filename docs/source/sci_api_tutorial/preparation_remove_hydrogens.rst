==============================================
 Preparation: Remove Hydrogens
==============================================

Briefs
==============================================

This science API, named ``enzy_htp.preparation.clean.remove_hydrogens``,
removes hydrogen atoms from the supplied ``enzy_htp.structure.Structure`` class instance 
(hereafter referred to as ``Structure`` instance).

Input/Output
==============================================

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    .. image:: ../../figures/preparation_remove_hydrogens_dfd.svg
        :width: 100%
        :alt: preparation_remove_solvent

    .. **input**: A ``Structure`` instance (no matter it's a protein, polypeptite, or ligand).

    .. **output**: A ``Structure`` instance with hydrogen atoms removed (in-place modification or a copy,
    .. but both provides a return value).

Arguments
==============================================

``stru``
    The input ``Structure`` instance (no matter it's a protein, polypeptite, or ligand).

``polypeptide_only``
    whether only remove hydrogen atoms from polypeptide.

    (optional, default True) 

``in_place``
    Apply the change in place (to the supplied instance) or in a copy (create a new instance).
    
    (optional, default True)

Examples
==============================================

Before Execution: Load Structure
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

Use ``preparation.clean.remove_hydrogens`` to remove hydrogen atoms from your structure.

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    The simpliest use of ``remove_hydrogens`` is as follows.
        Where the ``polypeptide_only`` and ``in_place`` are both set to ``True``.

    .. code:: python

        from enzy_htp.preparation.clean import remove_hydrogens
        
        protonate.remove_hydrogens(stru=stru)

    We can also directly import ``remove_hydrogens`` from ``enzy_htp.preparation`` since it has been cited in
    the ``__init__.py`` file of ``preparation`` module.

    .. code:: python

        from enzy_htp.preparation import remove_hydrogens
        
        stru = remove_hydrogens(stru=stru)

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    We can also customize the arguments passed to this function.
      Do you want to remove hydrogens from both polypeptide(s) and ligand(s)? Customize ``polypeptide_only``.  

      Do you want to create a new ``Structure`` instance while keeping the supplied instance still?
      Customize ``in_place``.

    .. code:: python
        
        stru_no_hydrogen = remove_hydrogens(stru=stru, polypeptide_only=False, in_place=False)

.. note::

    This API modifies the ``Structure`` instance (what we passed as argument ``stru``) itself
    or create a new ``Structure`` instance (while keeping the supplied instance still) depending
    on the ``in_place`` argument you choose. Both circumstances will return a reference value.
    
    Thus, if you set ``in_place=False`` so as to have two ``Structure`` instances (one with hydrogens,
    and the other without hydrogens), you'd better define a new variable to receive the response.

After Execution: Check Output
----------------------------------------------

Let's try executing the API here and check if there's any changes taking place.

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    We choose the crystal structure of small protein crambin at 0.48 Angstrom resolution for example.

    Now, we can go through the procedure (picking up after the "Remove Solvent" step).

    .. code:: python
        
        import enzy_htp.structure as struct
        from enzy_htp.preparation import remove_solvent, remove_hydrogens
                                    
        sp = struct.PDBParser()

        # Read PDB file here.
        pdb_filepath = "3NIR.pdb"
        stru = sp.get_structure(pdb_filepath)

        # Remove solvents here.
        print(stru.num_atoms)       # 742.
        remove_solvent(stru=stru)   # <enzy_htp.structure.structure.Structure object at 0x7fa383c4aa30>
        print(stru.num_atoms)       # 644.

        # Remove hydrogen atoms here.
        stru = remove_hydrogens(stru=stru, polypeptide_only=False)
        print(stru.num_atoms)       # 327.
    
We may notice that, after executing the API ``remove_hydrogens``, the number of atoms (``num_atoms``)
in the structure decreased, indicating that the hydrogen atoms have been removed from the structure.
