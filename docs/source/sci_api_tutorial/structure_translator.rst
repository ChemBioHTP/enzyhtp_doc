==============================================
    Structure Translation     
==============================================


It is common for molecular modelling packages to use different atom and residue naming 
schemes. As a result, there is a need to interconvert atom and residue names so that
EnzyHTP can effectively interface with as many packages as possible. EnzyHTP delegates
this functionality to the ``translate_structure()`` function from the ``enzy_htp.structure.structure_translator``
module.


=============================================
    API 
=============================================


All usage should go through the ``translate_structure()`` function. Below is calling convention and
argument information from the docstring in the source code.

.. code:: python
    
    def translate_structure(stru:Structure, start_naming:str=None, end_naming:str=None) -> Union[None, Structure]:
        """Translates names of the supplied Structure()'s Residue() and Atom() objects to EnzyHTP standard or
        a supported naming convention. Exactly one of start_naming or end_naming scheme must be supplied. It is assumed that
        the other, blank parameter is EnzyHTP standard/AmberMD. end_naming should be left blank if a Structure() is to be
        converted to EnzyHTP standard and start_naming should be left blank if a Structure() is already in EnzyHTP standard naming.
        Function performs basic checks on supplied naming parameters and will error if they are invalid. Naming is always done
        in place.
    
        Args:
            stru: The Structure() to rename.
            start_naming: The starting naming scheme as a str().
            end_naming:  The ending naming scheme as a str().
    
        Returns:
            Nothing or a renamed Structure(), depending on usage of inplace.
        """ 

A few notes about the above function:

    + The AmberMD naming scheme is the default or standard for ``EnzyHTP``.
    + Only one of ``start_naming`` or ``end_naming`` should be supplied.
    + If you would like to convert a standard named ``Structure()``, you leave ``start_naming`` blank and set ``end_naming`` to the desired scheme.
    + If you would like to convert a non-standard named ``Structure()`` to the standard naming scheme, you leave ``end_naming`` blank and set ``start_naming`` to the current naming scheme.
    + Only ``rosetta`` naming is currently supported. To add more naming schemes, see the **Developer** section


==========================================
    Examples
==========================================

Below are some example API calls to translate ``Structure()`` objects with the ``translate_structure()``.

.. code:: python

    >>> import enzy_htp as eh
    
    >>> parser = eh.PDBParser()
    >>> stru = parser.get_structure('./start.pdb')
   
    # the original naming in a Rosetta structure
    >>> stru.residues[0]
    Residue(1, MET, atom:19, Chain(A, residue: 1-218))
    
    >>> [aa.name for aa in stru.residues[0].atoms]
    ['N', 'CA', 'C', 'O', 'CB', 'CG', 'SD', 'CE', '1H', 'HA', 'HB2', 'HB3', 'HG2', 'HG3', 'HE1', 'HE2', 'HE3', '2H', '3H']
    
    >>> stru.residues[6]
    Residue(7, HIS, atom:17, Chain(A, residue: 1-218))

    >>> [aa.name for aa in stru.residues[6].atoms]
    ['N', 'CA', 'C', 'O', 'CB', 'CG', 'CD2', 'ND1', 'CE1', 'NE2', 'H', 'HA', '1HB', '2HB', 'HD2', 'HE1', 'HE2']
    
    # converting to EnzyHTP standard/AmberMD 
    eh.structure.translate_structure(stru, start_naming='rosetta')

    >>> stru.residues[0]
    Residue(1, MET, atom:19, Chain(A, residue: 1-218))

    >>> [aa.name for aa in stru.residues[0].atoms]
    ['N', 'CA', 'C', 'O', 'CB', 'CG', 'SD', 'CE', 'H1', 'HA', 'HB2', 'HB3', 'HG2', 'HG3', 'HE1', 'HE2', 'HE3', 'H2', 'H3']

    >>> stru.residues[6]
    Residue(7, HIE, atom:17, Chain(A, residue: 1-218))

    >>> [aa.name for aa in stru.residues[6].atoms]
    ['N', 'CA', 'C', 'O', 'CB', 'CG', 'CD2', 'ND1', 'CE1', 'NE2', 'H', 'HA', 'HB3', 'HB2', 'HD2', 'HE1', 'HE2']
    
    # change back to the original Rosetta naming 
    eh.structure.translate_structure(stru, end_naming='rosetta')

    >>> stru.residues[0]
    Residue(1, MET, atom:19, Chain(A, residue: 1-218))

    >>> [aa.name for aa in stru.residues[0].atoms]
    ['N', 'CA', 'C', 'O', 'CB', 'CG', 'SD', 'CE', '1H', 'HA', '2HB', '1HB', '2HG', '1HG', '1HE', '2HE', '3HE', '2H', '3H']

    >>> stru.residues[6]
    Residue(7, HIS, atom:17, Chain(A, residue: 1-218))

    >>> [aa.name for aa in stru.residues[6].atoms]
    ['N', 'CA', 'C', 'O', 'CB', 'CG', 'CD2', 'ND1', 'CE1', 'NE2', 'H', 'HA', '1HB', '2HB', 'HD2', 'HE1', 'HE2']    




================================
    Developer
================================


If you would like to provide support for new naming schemes, you will need to interact with the ``TranslatorBase``
class found in ``enzy_htp.structure.structure_translator.translator_base.py``.
