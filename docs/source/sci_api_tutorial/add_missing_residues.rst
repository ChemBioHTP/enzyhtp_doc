============================================
Adding Missing Residues
============================================

.. note:: 
    
    **Using this functionality requires the modeller python package to be installed.**
    For more information on installing the package, see the `Sali Lab website <https://salilab.org/modeller/>`_


.. note::

    Science API is a special concept in EnzyHTP. They stands for those top-layer APIs
    the are supposed to be used in assembling the `workflow <https://enzyhtp-doc.readthedocs.io/en/latest/sci_api_tutorial/how_to_assemble.html#find-the-science-api-that-directly-gives-what-you-need>`_.

.. warning::
    
    Some loop refinement methods are known to slightly move sidechain positions. It may be necessary to minimize a ``Structure`` after filling in missing loops.

**You will find a detailed tutorial of how to use this Science API.**

Input/Output
=========================================================================================

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    .. image:: ../../figures/add_missing_residues.svg
        :width: 100%
        :alt: dipole_bond

Input
-----------------------------------------------------------------------------------------
.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    The parameters of the ``add_missing_residues`` API contain the following options



**Input**: The ``stru``, ``missing_residues``, ``method`` arguments and required inputs

    - ``stru``:
        A ``Structure()`` object that is missing residues. 

        .. admonition:: Getting a ``Structure``

            | A ``Structure()`` object can be obtained by using various parsers including the ``PDBParser()`` from ``structure_io`` submodule.

    - ``missing_residues``:
        A ``List[SeqRes]`` objects which describe the chain/index location and identity of each missing residue.

        .. admonition:: Getting the missing residues

            | A ``List[SeqRes]`` objects can be created by giving the four letter PDB code of a structure using the ``identify_missing_residues()`` function from the ``preparation`` module.

    - ``method``:
        A ``str`` specifying the method to use for filling missing residues.

        .. admonition:: Current method options

            | At present, only ``modeller`` is supported.

    - ``work_dir``:
        Working directory containing all the files in the calculation process. Optional argument.

    - ``inplace``:
        Should the missing residues be added to the supplied ``Structure`` or to a new, copied one. Optional argument, ``True`` by default.



Output
-----------------------------------------------------------------------------------------
.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    **Output**: A ``Union[None, Structure]`` that is either nothing or a copied ``Structure`` with the added missing residues.



Examples
================================================================================



Example Code
-----------------------------------------------------------------------------------------


    .. code:: python

        from enzy_htp import (
                PDBParser,
                identify_missing_residues,
                fill_missing_residues)

        sp = PDBParser()

        stru = sp.get_structure("./2a2c_raw.pdb")

        fill_missing_residues(stru, identify_missing_residues("2A2C"))


