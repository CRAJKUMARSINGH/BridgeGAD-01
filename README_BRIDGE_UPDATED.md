# Bridge General Arrangement Drawing Generator - Updated Version

## New Features Added

### DXF/AutoCAD Export Capability
- Professional AutoCAD-compatible DXF file export
- Structured CAD layers (Foundation, Structure, Deck, Railings, Dimensions, Text)
- Engineering dimensions and specifications included
- Compatible with all major CAD software

### Bridge Types Supported
- Beam Bridge
- Truss Bridge 
- Arch Bridge
- Suspension Bridge
- Cable-Stayed Bridge
- T-Beam Bridge
- Slab Bridge

### Export Formats
- PNG (High-resolution images for reports)
- SVG (Scalable vector graphics for web)
- DXF (AutoCAD format for professional CAD software)

## Installation

1. Extract the ZIP file
2. Install dependencies:
   ```bash
   pip install -r requirements_deployment.txt
   ```

## Usage

### Streamlit Web Interface
```bash
streamlit run streamlit_bridge_app.py --server.port 5000
```

### Command Line Interface
```bash
python bridge_drawings.py beam --span 50 --width 12 --height 20 --material steel
```

### Interactive CLI
```bash
python run_bridge_generator.py
```

## Key Features

### Professional Engineering Drawings
- Elevation and plan views
- Dimensional annotations
- Material specifications
- Load capacity ratings
- Foundation details

### CAD Integration
- DXF files open directly in AutoCAD
- Organized layer structure for easy editing
- Professional drawing standards compliance
- Easy conversion to DWG format

### Parametric Design
- Adjustable span lengths (20-500m)
- Variable deck widths (6-30m)
- Configurable heights (10-100m)
- Multiple material options
- Load capacity specifications

## Dependencies
- streamlit >= 1.47.0
- matplotlib >= 3.10.3
- numpy >= 2.3.1
- ezdxf >= 1.4.2 (for DXF export)
- reportlab >= 4.4.2
- svgwrite >= 1.4.3

## File Structure
```
bridge_generator_updated/
├── bridge_drawings.py          # Core drawing engine
├── streamlit_bridge_app.py     # Web interface
├── run_bridge_generator.py     # Interactive CLI
├── requirements_deployment.txt # Dependencies
├── pyproject.toml             # Project configuration
├── .streamlit/config.toml     # Streamlit settings
└── README_BRIDGE_UPDATED.md   # This file
```

## License
This project is provided for educational and professional use in civil engineering applications.