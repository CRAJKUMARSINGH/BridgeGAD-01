# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

BridgeGAD-01 is a professional Bridge General Arrangement Drawing Generator - a specialized civil engineering application that automatically generates technical drawings for various bridge types. This is a Python-based Streamlit web application with CAD export capabilities.

### Technology Stack
- **Frontend**: Streamlit web interface
- **Backend**: Python with engineering calculation libraries
- **Drawing Engine**: matplotlib, svgwrite, reportlab
- **CAD Export**: ezdxf for AutoCAD-compatible DXF files
- **Scientific Computing**: numpy, scipy for engineering calculations

## Development Commands

### Environment Setup
```powershell
# Install dependencies using pip
pip install -r requirements.txt

# Or using pyproject.toml
pip install -e .
```

### Running the Application

#### Web Interface (Primary)
```powershell
# Run Streamlit web app
streamlit run streamlit_app.py

# Run with custom port (configured in .streamlit/config.toml)
streamlit run streamlit_app.py --server.port 5000

# Using the batch file
.\zzAPP.bat
```

#### Command Line Interface
```powershell
# Interactive CLI mode
python run_bridge_generator.py

# Direct command line with parameters
python bridge_drawings.py beam --span 50 --width 12 --height 20 --material steel
```

### Testing and Validation
```powershell
# Test drawing generation for all bridge types
python -c "from bridge_drawings import create_example_bridges; create_example_bridges()"

# Validate DXF export functionality
python -c "from bridge_drawings import BridgeDrawingGenerator; gen = BridgeDrawingGenerator(); gen.test_dxf_export()"
```

## Architecture Overview

### Core Components Architecture

**bridge_drawings.py**: Core drawing engine containing:
- `BridgeDrawingGenerator`: Main class handling all bridge types
- `BridgeType` enum: Defines supported bridge types (BEAM, TRUSS, ARCH, SUSPENSION, CABLE_STAYED, T_BEAM, SLAB)
- `BridgeParameters`: Configuration dataclass for bridge specifications
- `OutputFormat` enum: Export formats (SVG, PNG, PDF, DXF)

**streamlit_app.py**: Web interface providing:
- Interactive parameter input via Streamlit sidebar
- Real-time preview of bridge drawings
- Export functionality for multiple formats
- Professional engineering presentation

**run_bridge_generator.py**: Command-line interface for:
- Interactive bridge type selection
- Custom parameter input
- Batch generation capabilities
- Example bridge creation

### Engineering Features

#### Bridge Types Supported
1. **Beam Bridge**: Simple span with girder system
2. **Truss Bridge**: Steel truss structural system
3. **Arch Bridge**: Stone/concrete arch construction
4. **Suspension Bridge**: Cable-supported deck system
5. **Cable-Stayed Bridge**: Direct cable-to-tower support
6. **T-Beam Bridge**: Reinforced concrete T-beam system
7. **Slab Bridge**: Solid concrete slab construction

#### Technical Capabilities
- **Parametric Design**: Adjustable spans (20-500m), widths (6-30m), heights (10-100m)
- **Material Specifications**: Steel, concrete, composite materials
- **Load Calculations**: Dead load, live load, wind load considerations
- **Foundation Design**: Pier and abutment detailing
- **Professional Annotations**: Dimensions, material specs, load ratings

#### CAD Integration
- **DXF Export**: AutoCAD-compatible drawings with structured layers
- **Layer Organization**: Foundation, Structure, Deck, Railings, Dimensions, Text
- **Engineering Standards**: Complies with civil engineering drawing conventions
- **Multi-Format Output**: PNG for reports, SVG for web, DXF for CAD

### File Structure Patterns

```
BridgeGAD-01/
├── bridge_drawings.py          # Core drawing engine
├── streamlit_app.py           # Main web application
├── run_bridge_generator.py    # CLI interface
├── requirements.txt           # Production dependencies
├── pyproject.toml            # Project configuration
├── .streamlit/
│   └── config.toml           # Streamlit server settings
├── Attached_assets/          # Supporting documentation
├── test_png/                 # Generated test images
└── WARP.md                   # This file
```

## Development Notes

### Key Engineering Considerations
- All calculations follow standard civil engineering practices
- Load factors and safety margins are built into the design algorithms
- Drawing scales automatically adjust based on bridge dimensions
- Material properties are database-driven for accuracy

### Code Architecture Patterns
- **Dataclass-based Configuration**: `BridgeParameters` centralizes all design inputs
- **Enum-driven Type Safety**: `BridgeType` and `OutputFormat` prevent invalid selections
- **Factory Pattern**: `BridgeDrawingGenerator` handles type-specific drawing logic
- **Layered Architecture**: Clear separation between UI (Streamlit), business logic (calculations), and presentation (drawings)

### Streamlit-Specific Features
- **Wide Layout**: Optimized for engineering drawing display
- **Sidebar Configuration**: Professional parameter input interface
- **Download Integration**: Direct file download for all export formats
- **Progress Indicators**: Real-time feedback during drawing generation

## Common Development Tasks

### Adding New Bridge Types
1. Add new type to `BridgeType` enum in `bridge_drawings.py`
2. Implement drawing method in `BridgeDrawingGenerator` class
3. Add UI option in `streamlit_app.py` bridge type selection
4. Update CLI options in `run_bridge_generator.py`

### Modifying Drawing Parameters
1. Update `BridgeParameters` dataclass with new fields
2. Add UI controls in Streamlit sidebar
3. Integrate new parameters into drawing calculations
4. Update DXF layer structure if needed

### Adding Export Formats
1. Add new format to `OutputFormat` enum
2. Implement export method in `BridgeDrawingGenerator`
3. Add download option to Streamlit interface
4. Update CLI export options

### Engineering Calculation Updates
1. Modify calculation methods in respective bridge type functions
2. Update material property databases
3. Validate against engineering standards
4. Test with various parameter combinations

### CAD Export Enhancements
1. Modify DXF generation in drawing methods
2. Update layer organization in `setup_dxf_layers()`
3. Add new annotation types or dimension styles
4. Test compatibility with target CAD software
