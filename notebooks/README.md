To use notebooks here, update the path settings of H(x) IODA files (output folder from the workflow) and figure saving folder in notebooks.

To test these with sample data, please download the hofx output files from Zenodo (https://doi.org/10.5281/zenodo.17058099).
  * merra2_hofx_aeronetl15.zip
  * merra2_hofx_modis.zip
  * merra2_hofx_pace.zip
  * merra2_hofx_viirsdb.zip
  * merra2_hofx_viirsdt.zip
  * wrfchem_hofx_airnow.zip
  * wrfchem_hofx_pandora.zip
  * wrfchem_hofx_tempo.zip
  * wrfchem_hofx_tropomi.zip
  * wrfchem_metplus_stats.zip

All the hofx zip files have the similar structure in it.
Unzip the files under the same folder, you should get an output folder with the structure below.
```
output
├── aodobs_merra2
│   └── hofx
└── wrfchem_evaluate
    ├── hofx
    └── stats
```
Under hofx folder, you will see verified forecast hour folder in `f??`.
Each `f??` has observation folders that are available for that forecast hour.
