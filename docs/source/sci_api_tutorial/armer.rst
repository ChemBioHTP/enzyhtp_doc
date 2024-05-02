==============================================
 Adaptive Resource Manager (ARMer)
==============================================

Overview
==============================================

API Config Dict
==============================================
| This section describe a soft-enforced standard format of 
  the configuration dictionary used as input of all the 
  Science APIs.
| For example: 
| ``quantum.single_point()`` needs 
  to know what resource/account it needs to use when running
  commands through ARMer. We have a ``cluster_job_config``
  argument in this function as a dictionary obtain this information.
  The format of this dictionary is soft-enforced.

TODO
  
Author: QZ Shao <shaoqz@icloud.com>
