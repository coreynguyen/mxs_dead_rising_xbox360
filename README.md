
# *Dead Rising* (Classic Xbox 360 Version) Mesh Importer (MaxScript)

## Overview

This repository contains a **MaxScript** tool designed to import 3D models from the 2006 *Dead Rising* game for the classic Xbox 360. The script reads model files from the game and attempts to reconstruct the geometry within **3ds Max**. It supports reading the vertex and face data, but **materials and texture assignments** are currently not handled, and all submeshes are imported as a single object. As of now, the importer does not separate meshes by materials, resulting in combined old meshes during import.

## Features

- **Imports Mesh Geometry**: Reads vertex, face, and bounding box data from *Dead Rising* model files.
- **UI for Convenience**: Provides a simple user interface to control the import process, including scaling options.
- **Partial Submesh Handling**: Imports all submeshes combined into a single mesh object (work in progress).

## Installation

1. Download or clone the repository to your local machine.
2. Copy the MaxScript (`*.ms` file) into your **3ds Max** `scripts` folder or another accessible location.
3. Open **3ds Max**, go to `MaxScript > Run Script`, and select the downloaded MaxScript file.

## Usage

1. After loading the script, a rollout interface will appear with the following options:
   - **Import**: Button to begin the import process.
   - **Clear Scene**: Checkbox to clear the current scene before importing (enabled by default).
   - **Scale**: A spinner to adjust the scale of the imported model. The default value is `0.393700787` to account for unit conversions from the game’s scale.
   - Additional labels provide basic information and credits.
   
2. Select the file you want to import and click the **Import** button. The script will attempt to read the file and generate the corresponding mesh in the current scene.

## Known Issues / Work in Progress

- **No Material or Texture Assignments**: Currently, the script does not handle material or texture assignment. Models are imported without texture coordinates or material separation.
- **Combined Submeshes**: All submeshes and old meshes are imported as a single object without separation by material or group.
- **Mesh Data Accuracy**: The script reads vertex and face data, but additional mesh data like normals, tangents, and weights are not fully implemented.

## To Do

- Implement material and texture assignment.
- Separate submeshes based on their materials and groupings.
- Improve handling of old and unused mesh data.
- Add support for more accurate reconstruction of the mesh (including UVs, normals, weights, etc.).

## Requirements

- **3ds Max** (tested on version [mention tested version])
- Basic understanding of 3ds Max and MaxScript.

---

### Disclaimer

This tool is provided as-is for educational and modding purposes. The author is not responsible for any damage or issues caused by using the script. *Dead Rising* is a trademark of Capcom, and this tool is not affiliated with or endorsed by Capcom in any way.
