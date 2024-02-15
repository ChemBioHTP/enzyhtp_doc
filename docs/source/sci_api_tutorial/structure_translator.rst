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
class found in ``enzy_htp.structure.structure_translator.translator_base.py``. For the below example, we
will assume you are translating to the fictitious 'my_package' package and naming scheme. You 
should add a file named ``my_package.py`` to ``enzy_htp.structure.structure_translator``. 
Below is an example of how you would write the code for the 'my_package' package. Keep in mind that the 
naming scheme for AmberMD is the default or standard EnzyHTP naming scheme.

.. code:: python



    from .translator_base import TranslatorBase
    
    
    class MyPackageTranslator(TranslatorBase):


        def init_mappings(self) -> None:
             self.register_mapping('GLY', ['HA3', 'HA2', 'H1', 'H2', 'H3'],
                                     'GLY', ['1HA', '2HA', '1H', '2H', '3H'])
        
             self.register_mapping('HID', ['HB3', 'HB2', 'H1', 'H2', 'H3'],
                                     'HIS', ['1HB', '2HB', '1H', '2H', '3H'])
        
        @dispatch
        def to_standard(self, res:Residue) -> None:
    
    
            if res.name == 'HIS':
                atom_names = [aa.name for aa in res.atoms]
    
                has_delta:bool = 'HD1' in atom_names
                has_eps:bool = 'HE2' in atom_names
    
                new_name:str = None
    
                if has_delta and has_eps:
                    new_name = 'HIP'
                elif has_delta:
                    new_name = 'HID'
                elif has_eps:
                    new_name = 'HIE'
                else:
                    raise ValueError()
                res.name = new_name
            else:
                super().to_standard(res)
    

A few notes about the above example:

    + there must be a version of ``init_mappings()`` which maps ``Atom()`` and ``Residue()`` names between
    the 'my_package''s naming scheme and the standard naming scheme. The API is   ``register_mapping(s_rname:str,s_atoms:List[str],t_rname:str,t_atoms:List[str])`` where
    ``s_rname`` is the standard (AmberMD) 3 letter residue name, ``t_rname`` is the translated (package) 3 letter residue name, and ``s_atoms`` and ``t_atoms``
    are lists of equal length mapping the standard and translated ``Atom()`` names respectively. That is, the nth item in each list correspond to eachother.

    + sometimes there are collisions within residue naming so that multiple standard residue names map to one translated residue name or vice versa. When this is the case,
    it is necessary to define a function like ``to_standard(self, res:Residue)`` as seen above. ``TranslatorBase`` uses overloads to resolved which version of a function to call. 
    **It is the responsibility of the developer to ensure correctness for these!**

