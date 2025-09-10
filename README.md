# JEDI-ACE
Workflow to use VIND (Versatile Implementation for Native Data) interfaced with the JEDI components and METplus for Atmospheric Composition Evaluation (ACE).\
[VIND repo](https://github.com/benjaminmenetrier/vind)

## Supported platforms
* Platforms with JCSDA spack-stack package.
* Module loading scripts: \
  derecho_intel (v1.8.0), derecho_gnu (v1.9.2), derecho_oneapi (v1.9.2), orion_gnu (v1.8.0)

## Tested models 
* Lambert CC projection: WRF-Chem
* Reducing Gaussian Lon-Lat: GEFS-Aerosols
* Regular Lon-Lat: MERRA-2

## Tested measurements
* TropOMI NO<sub>2</sub> and CO
* AOD from MODIS, VIIRS, OCI (PACE), AERONET
* TEMPO NO<sub>2</sub>, CO
* PANDORA NO<sub>2</sub>
* AirNow O<sub>3</sub> and PM<sub>2.5</sub>

## Clone the code
Clone this repo into `<folder>` with the command below:
`git clone https://github.com/weiwilliam/JEDI-ACE.git <folder>`

## Build VIND (VIND-bundle)
1. Create the `<repo>/vind-bundle/build` folder
2. Create virtual python env `<repo>/venv` if you do not have one.
   `source ush/setup.sh <repo path> <platform> <compiler>`
3. `cd <repo>/vind-bundle/build`
4. `ecbuild <path/to/vind-bundle>`
5. `make -j <n>`
6. `ctest` to check executables work properly

## Existing builds
Derecho (oneapi): `/glade/work/swei/projects/JEDI-ACE/vind-bundle/build` \
Orion (gnu): `/work2/noaa/jcsda/shihwei/git/caliop_opr/genint-bundle/build` (older version)
1. Update `VIND_BUILD` in `ush/setup.sh` to `/glade/work/swei/projects/JEDI-ACE/vind-bundle/build`
2. `source ush/setup.sh <your/repo/path> <platform> <compiler>`\
   It will create venv for you and point your executables to my build. \
* It may encounter permission issue

## Use of this interface
* Prerequisites: observation files in IODA format and model outputs supported by VIND [VIND README](https://github.com/benjaminmenetrier/vind/tree/develop#description).

Options currently available:
| Platform | Compilers |
|----------|-----------|
| Derecho  | gnu, intel, oneapi |
| Orion    | gnu |

1. Create Python venv under the cloned repo by running:
 `source ush/setup.sh </repo/path> <platform> <compiler>` 

2. `yamls/main` and `yamls/hofx3d` include examples of input YAML files for different models (e.g. MERRA-2, WRF-Chem) and different observations (e.g. AOD, tracegas). \
   For example to evaluate WRF-Chem trace gas you can use `main/main_wrfchem_tracegas.yaml` and it uses `hofx3d/TraceGas_WRFChem.yaml`. \
   `README.md` under `yamls/<main, hofx3d>` provides more details. \
   Modify or add your own YAML based on your application

3. Run your experiment by executing `pyscripts/vind_vrfy.py <main yaml>`

## Preprocesses for use case of WRF system
1. Create air pressure and potential temperature:\
   `ncap2 -O -s "air_potential_temperature=T+300" <wrfout> <new wrfout>`\
   Create `air_potential_temperature` for JEDI application.   
2. Cropping IODA file:\
   Use `pyscripts/get_wrfout_polygon.py` to create a polygon .csv file for your domain boundary.\
   Run `pyscripts/crop_iodafile.py -i <global/IODA/file> -o <WRF/domain/IODA/file> -p <WRF/domain/polygon/csv>`
3. Use `P_HYD` to represent `air_pressure`.\
   The `PSFC` is a diagnostic variable derived through hydrostatic function, so the `air_pressure_levels` based on akbk, ptop, and PSFC are more close to hydrostatic.
   It may cause half level pressure from `PB+P` is not between two adjacent full level.
4. To get ak and bk values from wrfout, \
    ak = C4F + P<sub>top</sub> - C3F * P<sub>top</sub> \
    bk = C3F

## Reference links
UFO operators: [JEDI document/UFO](https://jointcenterforsatellitedataassimilation-jedi-docs.readthedocs-hosted.com/en/latest/inside/jedi-components/ufo/index.html)
