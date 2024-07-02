.. warning::

    this page is outdated

==============================================
Working with Modified AA
==============================================

.. note::

    | This page is still under construction.
    | The contents here are incomplete.

Deal with PDB2PQR
--------------------

1. Obtain the protonated pdb file of the modified AA (add H manually or obtain from PDB). If you need to use force field like ff19SB_modAA, make the atom names align with the force field.
2. Align the structure with the standard backbone in PDB2PQR. (make sure the Psi Phi angles are also rotated so that all the backbone atoms align with the template and the all the H is in the right place if carry by the rotation of the backbone) Here is a reference PDB file of the backbone

    .. code::

        HETATM    1  N   PSD P   1       1.201   0.847   0.000  0.00  0.00           N  
        HETATM    2  CA  PSD P   1       0.000   0.000   0.000  0.00  0.00           C  
        HETATM    3  C   PSD P   1      -1.250   0.881   0.000  0.00  0.00           C  
        HETATM    4  O   PSD P   1      -2.185   0.660  -0.784  0.00  0.00           O  
        HETATM    5  C-1 PSD P   1       2.339   0.216   0.000  0.00  0.00           C  
        HETATM    6  N+1 PSD P   1      -1.252   1.877   1.023  0.00  0.00           N  
        HETATM    7  H   PSD P   1       1.201   1.847   0.000  0.00  0.00           H  
3. Save the pdb file with the CONNECT record.
4. Use this script to generate XML and DAT file. Paste the connectivity table to cnt_table.

    .. code:: python
        
        from enzy_htp import PDBParser, Residue
        from enzy_htp.core.file_system import write_lines


        def init_cnt_from_cnt_table(res: Residue, cnt_table: str):
            cnt_list = cnt_table.strip().splitlines()
            for idx, atom in enumerate(res.atoms):
                cnt_atom_idx = cnt_list[idx].strip().split()[1:]
                atom._connect = [res.atoms[int(i)-1] for i in cnt_atom_idx]

        sp = PDBParser()

        mse = sp.get_structure("mse.pdb").residues[0]

        cnt_table = {
            "MSE" : """  1    2   17
        2    1    3    5    9
        3    2    4
        4    3
        5    2    6   10   11
        6    5    8   12   13
        7    8   14   15   16
        8    6    7
        9    2
        10    5
        11    5
        12    6
        13    6
        14    7
        15    7
        16    7
        17    1""",
        }

        for res in [mse,]:
            res: Residue
            init_cnt_from_cnt_table(res, cnt_table[res.name])

            lines = []
            lines.extend(
                [
                # f"<?xml version='1.0'?>",
                # f"<aminoacids>",
                f"  <residue>",
                f"    <name>{res.name}</name>",
                    ])
            for atom in res.atoms:
                lines.extend(
                    [
                f"    <atom>",
                f"      <name>{atom.name}</name>",
                f"      <x>{atom.coord[0]}</x>",
                f"      <y>{atom.coord[1]}</y>",
                f"      <z>{atom.coord[2]}</z>",
                    ])
                for cnt_atom in atom.connect:
                    lines.extend([
                f"      <bond>{cnt_atom.name}</bond>",])
                lines.extend([
                f"    </atom>",])
            lines.extend([
                f"  </residue>",
                # f"</aminoacids>",
                ])
            write_lines(f"{res.name}.xml", lines)

NOTE: leave all charge and radii as 0.0 in the .DAT file. See the referenced issue below for details.

5. Merge the XML and DAT files to pdb2pqr/dat/AA.xml and pdb2pqr/dat/PARSE.DAT
6. Add a new class of the modified AA by copy others and change the name in pdb2pqr/aa.py

find related issue `here <https://github.com/ChemBioHTP/EnzyHTP/issues/124>`_

Deal with Amber
------------------

1. Prepare parameter files for modified amino acid following this tutorial ↓

    | `English Version <https://ambermd.org/tutorials/basic/tutorial5/index.php>`_
    | `Chinese Version <https://www.shaoqz.cn/2020/11/16/Amber-MD%E5%85%B3%E9%94%AE%E5%AD%97/#%E9%9D%9E%E6%A0%87%E5%87%86%E6%AE%8B%E5%9F%BA%E7%9A%84%E5%8F%82%E6%95%B0%E5%8C%96>`_

2. In ``PDB2FF``, add an argument called ``maa_parm_file_path``, it requires a list of prepin and frcmod files for you modified AA. Here is an example:

    .. code:: python
        
        pdb_obj.PDB2FF(local_lig=0, ifsavepdb=1,
                       maa_parm_file_path=[
                        [
                            "maa.prepin",
                            ["maa.frcmod1", "maa.frcmod2"]
                        ],
                        ])


**Now the workflow is ready to go!**


