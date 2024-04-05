==============================================
Electric Field
==============================================


Briefs
=========================================================================================

The `electric_field_strength_at_along` function calculates the electric field strength at a specified point between two atoms based on their coordinates and charge, optionally considering a specified direction, and supports different units for the result.


Input/Output
=========================================================================================

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    .. image:: ../../figures/ele_field_api.svg
        :width: 100%
        :alt: Electric Field

Input
-----------------------------------------------------------------------------------------
.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left


**Input**: The ``stru``, ``p1``, ``p2``, ``d1``, and ``region_pattern``  are required input

    - ``stru``:
        Structure which represent the structure of the target enzyme need to obtain from . MUST have charges initialized.
        
        .. admonition:: How to obtain
            
            | A protein strutcuture object can be obtained by this `APIs <PDBParser.html>`_.

    - ``p1``, ``p2`` and ``d1``:
        Specify either the direction or the point for measuring the electric field, with combinations like (p1, p2) or (p1, d1), where p1 and p2 represent an Atom() or a Cartesian point. d1 the vector that defines the direction of field strength projection
        
        .. admonition:: How to obtain
            
            | A p1 and p2 might be `Atom()` object which can be obtained by these `APIs <obtaining_Atom.html>`_. The p1 and p2 can also be the coordinates (x, y, z). 

    - ``region_pattern``: 
        the region in the structure that is considered as field source charges. Please use pymol region selection syntax.

        .. admonition:: What's the syntax like

            | An example of the selection pattern can be "chain A and (not resi 101)"

Output
-----------------------------------------------------------------------------------------
**Output**: A specified field strength in {unit}. The direction is from ``p2`` to ``p1`` or along the ``d1`` direction

Argument code
=========================================================================================

``stru``:
    The target enzyme's structure must be initialized with charges.

``p1``, ``p2`` and ``d1``:
    To calculate the electric field within an enzyme, input a location and either a direction (d1) or two points (p1, p2), ensuring enzyme charges are included; d1 defines the field strength projection direction.

``location``:
    When specifying two points, the location of the measurement is determined; if the format is (p1, d1), then p1 represents the position, with supported keywords including "center", "p1", and "p2".

    .. admonition:: Where to look

        REF: EnzyHTP: A High-Throughput Computational Platform for Enzyme Modeling (https://pubs.acs.org/doi/full/10.1021/acs.jcim.1c01424)

``region_pattern``:
    The area within the structure designated as the source of field charges, employing PyMOL selection syntax.

``unit``:
    The unit of the result (default: kcal/(mol*e*Ang))


Example code
=========================================================================================
.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    We will use the script to calculate the electric field between the atoms ``CAE``, ``H2`` with KE 07 mutant(101, 254)
        
    .. code:: python

        efield = ele_field_strength_at_along(stru_obj, (p1, p2), region_pattern="chain A and (not resi 101)",)

**Let's put them together as a python script.**
        
    .. code:: python
        
        import os
        import numpy as np
        from enzy_htp.analysis import ele_field_strength_at_along
        from enzy_htp import PDBParser

        # Initialize PDB parser
        sp = PDBParser()

        # Load structure from PDB file
        stru_obj = sp.get_structure(f"{DATA_DIR}KE_mutant_101_254_frame_0.pdb")

        # Assign charges to the structure
        stru_obj.assign_ncaa_chargespin({"H5J" : (0,1)})

        # Define EF calcuation region as p1, p2
        target_bond = (test_stru.ligands[0].find_atom_name("CAE"),test_stru.ligands[0].find_atom_name("H2"))

        # Calculate electric field strength at the specified location along the bond
        result = ele_field_strength_at_along(stru_obj, *target_bond, region_pattern="chain A and (not resi 101)",)

        print("Electric field strength:", result)

Done!
=========================================================================================

Author: Xinchun Ran <xinchun.ran@vanderbilt.edu>

