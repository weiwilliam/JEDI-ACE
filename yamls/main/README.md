## README for main yaml keys
```
run_jedihofx: True
run_met_plus: False
restart: True
verbose: False
verify_fhours: [16,17,18,19]
time:
  sdate: 2024082419
  edate: 2024082419
  dateint: 1 
vind:
  build:  /glade/work/swei/projects/JEDI-ACE/vind-bundle/build 
  jediexec: vind_hofx3d.x
  jediyaml: hofx3d/TraceGas_WRFChem.yaml
  casename: wrfchem_evaluate
  simulated_varname: nitrogendioxideColumn
  tracer_name: volume_mixing_ratio_of_no2
Data:
  input: 
    obs: '/glade/derecho/scratch/swei/Dataset/input/obs'
    bkg: '/glade/derecho/scratch/swei/Dataset/input/bkg/wxaq'
    crtm: '/glade/work/swei/projects/JEDI-ACE/vind-bundle/build/crtm/test/testinput'
  output: '/glade/work/swei/projects/JEDI-ACE/output'
  obs_name_list: ['tropomi_s5p_no2_troposphere-wxaq']
  obs_sensor_list: ['tropomi']
  obs_template: '{obs_name}/{filetype}.{obs_name}.%Y%m%d%H.nc4'
  obs_window_length: 1
  bkg_template: wrfgsi.out.{init_date}/subset_wrfout_d01_%Y%m%d_%H0000
  bkg_extension: nc
  bkg_init_cyc: ['00']
jobconf:
  platform: derecho
  jobname: qxxgenint_wrfchem
  n_node: 1
  n_task: 1
  account: ualb0052
  partition: develop
  walltime: 0:30:00
  qos: economy
  memory: 64Gb
  check_freq: 10
metplus:
  met_conf_temp: StatAnalysis.conf_tmpl
  variables: ['var1', 'var2']
  ioda2metmpr: ioda2metplusmpr.py 
  mask_by: 'ObsValue<1e6'
  submit: False
```
* `run_jedihofx:` True: run genint hofx 3D 
* `run_met_plus:` True: run met plus after JEDI hofx 3D finished
* `restart:` True: no folder purging
* `verbose:` True: print out more information
* `verify_fhours:` List of verifying forecast hours
* `time:`
  * `sdate:` first valid time (10-digit, YYYYMMDDHH)
  * `edate:` last valid time (10-digit, YYYYMMDDHH)
  * `dateint:` interval of each valid time (in hour) 

Script will loop over `verify_fhours` to search forecast files that are available on each valid time derived from `sdate`, `edate`, and `dateint`.

* `vind:`
  * `build:` build path of vind-bundle
  * `jediexec:` the executable to use
  * `jediyaml:` yaml file for genint application
  * `casename:` your case name, used to create output folder
  * `simulated_varname:` simulated variable name used in JEDI,
    * List: aerosolOpticalDepth, nitrogendioxideTotal, nitrogendioxideColumn, carbonmonoxideTotal
  * `tracer_name:` long name for trace gas (e.g., volume_mixing_ratio_of_no2, volume_mixing_ratio_of_co), needed for column retrieval operator
* `Data:`
  * `input:` the last level of path under input will be linked to Data/input/<key>
    * `obs:` observation folder, linked to workdir/Data/input/obs 
    * `bkg:` background folder, linked to workdir/Data/input/bkg
    * `crtm:` CRTM coefficient folder, linked to workdir/Data/input/crtm
  * `output:` output path, will be linked to workdir/Data/output
  * `obs_name_list:` list of observation name, used to define the IODA file name
  * `obs_sensor_list:` sensor name, needed if running AodCRTM operator
  * `obs_template:` obs file template, will be parsed by cdate.strptime
  * `obs_window_length:` the time coverage of your observation.
  * `bkg_template:` bkg file template (please include any level with date info), will be parsed by cdate.strptime
  * `bkg_init_cyc:` searching the files initialized from the listed cycles (2-digit hours, e.g., 06).
* `jobconf:`
  * `platform:` platform name: s4, derecho, orion, discover
  * `jobname:` jobname when it submitted
  * `n_node:` number of nodes
  * `n_task:` number of tasks, use 1 for WRF-Chem for now
  * `walltime:` time limit for job
  * `account:` account name, it will be the project ID on Derecho
  * `partition:`  the partition to be submitted, Derecho: main or develop (shared job, cheaper in core hour)
  * `qos:` queue level, Derecho: premium, regular, or economy*
  * `check_freq:` check frequency for hofx step
* `metplus:`
  * `met_conf_temp:` stat_analysis template, StatAnalysis.CTC.conf_tmpl or StatAnalysis.SL1L2.conf_tmpl
  * `variables`: a list of variables to evaluate with METplus, see `pyscripts/dictionaries.py` for setup of variable and threshold (for CTC).
  * `ioda2metmpr:` python script to read IODA hofx file and provide matched paired dataset to METplus for statistics calculation
  * `mask_by`: use the group of IODA to keep data points satisfied the condition for METplus calculation
  * `submit`: True or False to run METplus on compute node or local, if it is true, please include the jobconf yaml keys under metplus section.

Derecho Core hour calculation: https://ncar-hpc-docs.readthedocs.io/en/latest/pbs/charging/#exclusive-nodes
