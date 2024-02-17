==============================================
 Preparation: Remove Solvent
==============================================

Briefs
==============================================

This science API, named ``enzy_htp.preparation.clean.remove_solvent``,
removes solvent from the supplied ``enzy_htp.structure.Structure`` class instance 
(hereafter referred to as ``Structure`` instance).

All ``enzy_htp.structure.Solvent`` class instances (hereafter referred to as
``Solvent`` instances) will be removed.

Input/Output
==============================================

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    .. image:: ../../figures/preparation_remove_solvent_dfd.svg
        :width: 100%
        :alt: preparation_remove_solvent

    .. **input**: A ``Structure`` instance (no matter it's a protein, polypeptite, or ligand).

    .. **output**: A ``Structure`` instance with solvent removed (in-place modification,
    .. but still provides a return value).


Arguments
==============================================

``stru``
    The input ``Structure`` instance (no matter it's a protein, polypeptite, or ligand).

.. ``protect``
.. (optional) Protect some solvent from removal and change its rtype to Ligand. Use selection grammer.

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

Use ``preparation.clean.remove_solvent`` to remove solvent from your structure.

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    The way to use ``remove_solvent`` is pretty simple.

    .. code:: python

        from enzy_htp.preparation.clean import remove_solvent
        
        stru = remove_solvent(stru=stru)

    We can also directly import ``remove_solvent`` from ``enzy_htp.preparation`` since it has been cited in
    the ``__init__.py`` file of ``preparation`` module.

    .. code:: python

        from enzy_htp.preparation import remove_solvent
        
        stru = remove_solvent(stru=stru)

.. note::

    This API modifies the ``Structure`` instance (what we passed as argument ``stru``) itself but also returns a reference value.
    
    Thus, even if you write ``remove_solvent(stru=stru)`` (you don't use any variables to receive the return value),
    the structure referred by ``stru`` will still be changed.

After Execution: Check Output
----------------------------------------------

Let's try executing the API here and check if there's any changes taking place.

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    We choose the crystal structure of small protein crambin at 0.48 Angstrom resolution for example.

    Now, we can go through the procedure.

    .. code:: python
        
        import enzy_htp.structure as struct
        from enzy_htp.preparation import remove_solvent
                                    
        sp = struct.PDBParser()

        # Read PDB file here.
        pdb_filepath = "3NIR.pdb"
        stru = sp.get_structure(pdb_filepath)

        # Remove solvents here.
        print(stru.num_atoms)       # 742.
        remove_solvent(stru=stru)   # <enzy_htp.structure.structure.Structure object at 0x7fa383c4aa30>
        print(stru.num_atoms)       # 644.
    
We may notice that, after executing the API, the number of atoms (``num_atoms``) in the structure decreased,
representing that the solvent have been removed from the structure.
