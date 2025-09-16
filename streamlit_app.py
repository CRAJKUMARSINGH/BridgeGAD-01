import streamlit as st
import matplotlib.pyplot as plt
import io
import base64
from bridge_drawings import BridgeDrawingGenerator, BridgeType, BridgeParameters, OutputFormat

# Page configuration
st.set_page_config(
    page_title="Bridge Drawing Generator",
    page_icon="🌉",
    layout="wide",
    initial_sidebar_state="expanded"
)

st.title("🌉 Bridge General Arrangement Drawing Generator")
st.markdown("---")

# Sidebar for bridge configuration
st.sidebar.header("Bridge Configuration")

# Bridge type selection
bridge_type_options = {
    "Beam Bridge": BridgeType.BEAM,
    "Truss Bridge": BridgeType.TRUSS,
    "Arch Bridge": BridgeType.ARCH,
    "Suspension Bridge": BridgeType.SUSPENSION,
    "Cable-Stayed Bridge": BridgeType.CABLE_STAYED,
    "T-Beam Bridge": BridgeType.T_BEAM,
    "Slab Bridge": BridgeType.SLAB
}

selected_bridge = st.sidebar.selectbox(
    "Select Bridge Type:",
    options=list(bridge_type_options.keys())
)

bridge_type = bridge_type_options[selected_bridge]

# Bridge parameters
st.sidebar.subheader("Bridge Parameters")

span_length = st.sidebar.slider(
    "Span Length (m)",
    min_value=20.0,
    max_value=500.0,
    value=100.0,
    step=5.0
)

deck_width = st.sidebar.slider(
    "Deck Width (m)",
    min_value=6.0,
    max_value=30.0,
    value=12.0,
    step=1.0
)

height = st.sidebar.slider(
    "Height (m)",
    min_value=10.0,
    max_value=100.0,
    value=20.0,
    step=2.0
)

# Supports (only for applicable bridge types)
if bridge_type in [BridgeType.BEAM, BridgeType.T_BEAM]:
    supports = st.sidebar.slider(
        "Intermediate Supports",
        min_value=0,
        max_value=10,
        value=1
    )
else:
    supports = 0

load_capacity = st.sidebar.slider(
    "Design Load (kN/m)",
    min_value=25.0,
    max_value=150.0,
    value=50.0,
    step=5.0
)

material_options = ["steel", "concrete", "timber", "stone"]
material = st.sidebar.selectbox(
    "Primary Material:",
    options=material_options
)

# Advanced parameters in expander
with st.sidebar.expander("Advanced Parameters"):
    approach_length = st.slider(
        "Approach Length (m)",
        min_value=20.0,
        max_value=100.0,
        value=50.0,
        step=5.0
    )
    
    foundation_depth = st.slider(
        "Foundation Depth (m)",
        min_value=2.0,
        max_value=15.0,
        value=5.0,
        step=1.0
    )
    
    girder_depth = st.slider(
        "Girder Depth (m)",
        min_value=1.0,
        max_value=5.0,
        value=2.0,
        step=0.5
    )

# Main content area
col1, col2 = st.columns([3, 1])

with col1:
    st.subheader(f"{selected_bridge} Configuration")
    
    # Display current parameters
    st.write("**Current Specifications:**")
    st.write(f"• **Span Length:** {span_length} m")
    st.write(f"• **Deck Width:** {deck_width} m") 
    st.write(f"• **Height:** {height} m")
    st.write(f"• **Supports:** {supports}")
    st.write(f"• **Load Capacity:** {load_capacity} kN/m")
    st.write(f"• **Material:** {material.title()}")

with col2:
    # Generate button
    if st.button("🎨 Generate Bridge Drawing", type="primary"):
        try:
            # Create bridge parameters
            params = BridgeParameters(
                span_length=span_length,
                deck_width=deck_width,
                height=height,
                supports=supports,
                load_capacity=load_capacity,
                material=material,
                approach_length=approach_length,
                foundation_depth=foundation_depth,
                girder_depth=girder_depth
            )
            
            # Generate the bridge drawing
            with st.spinner(f"Generating {selected_bridge}..."):
                generator = BridgeDrawingGenerator(bridge_type, params)
                fig = generator.generate_drawing()
                
                # Display the drawing
                st.pyplot(fig)
                
                # Save options
                st.subheader("Download Options")
                
                # Create download buttons for different formats
                filename = f"{bridge_type.value}_bridge_{span_length}m"
                
                # PNG download
                img_buffer = io.BytesIO()
                fig.savefig(img_buffer, format='png', dpi=300, bbox_inches='tight')
                img_buffer.seek(0)
                
                st.download_button(
                    label="📥 Download PNG",
                    data=img_buffer.getvalue(),
                    file_name=f"{filename}.png",
                    mime="image/png"
                )
                
                # SVG download
                svg_buffer = io.StringIO()
                fig.savefig(svg_buffer, format='svg', bbox_inches='tight')
                svg_content = svg_buffer.getvalue()
                
                st.download_button(
                    label="📥 Download SVG",
                    data=svg_content,
                    file_name=f"{filename}.svg",
                    mime="image/svg+xml"
                )
                
                # DXF download (AutoCAD format)
                try:
                    import tempfile
                    import os
                    
                    # Create temporary file for DXF export
                    with tempfile.NamedTemporaryFile(suffix='.dxf', delete=False) as tmp_file:
                        tmp_filename = tmp_file.name
                    
                    # Generate DXF file
                    generator.save_as_dxf(tmp_filename)
                    
                    # Read DXF content
                    with open(tmp_filename, 'rb') as dxf_file:
                        dxf_content = dxf_file.read()
                    
                    # Clean up temp file
                    os.unlink(tmp_filename)
                    
                    st.download_button(
                        label="📥 Download DXF (AutoCAD)",
                        data=dxf_content,
                        file_name=f"{filename}.dxf",
                        mime="application/dxf"
                    )
                        
                except Exception as e:
                    st.error(f"DXF export failed: {str(e)}")
                    st.info("DXF export requires the ezdxf library. The PNG and SVG downloads are still available.")
                
                plt.close(fig)  # Clean up
                
        except Exception as e:
            st.error(f"Error generating bridge: {str(e)}")

# Information section
st.markdown("---")
st.subheader("📚 Bridge Type Information")

bridge_info = {
    "Beam Bridge": {
        "description": "Simple span bridges with deck supported by beams or girders",
        "typical_span": "20-100m",
        "materials": "Steel, concrete, timber",
        "advantages": "Simple construction, economical for short spans"
    },
    "Truss Bridge": {
        "description": "Framework of triangular units for efficient load distribution",
        "typical_span": "50-200m",
        "materials": "Steel, timber",
        "advantages": "High strength-to-weight ratio, suitable for long spans"
    },
    "Arch Bridge": {
        "description": "Curved structure that transfers loads through compression",
        "typical_span": "30-300m",
        "materials": "Stone, concrete, steel",
        "advantages": "Excellent durability, aesthetic appeal"
    },
    "Suspension Bridge": {
        "description": "Deck suspended from cables supported by towers",
        "typical_span": "200-2000m",
        "materials": "Steel cables and towers",
        "advantages": "Capable of very long spans"
    },
    "Cable-Stayed Bridge": {
        "description": "Deck supported by cables directly connected to towers",
        "typical_span": "100-1000m",
        "materials": "Steel, concrete",
        "advantages": "Efficient for medium to long spans, modern aesthetics"
    },
    "T-Beam Bridge": {
        "description": "Reinforced concrete bridge with T-shaped beams",
        "typical_span": "15-80m",
        "materials": "Reinforced concrete",
        "advantages": "Good for medium spans, durable"
    },
    "Slab Bridge": {
        "description": "Simple concrete slab structure",
        "typical_span": "5-30m",
        "materials": "Reinforced concrete",
        "advantages": "Simple construction, low maintenance"
    }
}

if selected_bridge in bridge_info:
    info = bridge_info[selected_bridge]
    
    col1, col2 = st.columns(2)
    
    with col1:
        st.write(f"**Description:** {info['description']}")
        st.write(f"**Typical Span:** {info['typical_span']}")
    
    with col2:
        st.write(f"**Materials:** {info['materials']}")
        st.write(f"**Advantages:** {info['advantages']}")

# Footer
st.markdown("---")
st.markdown(
    """
    **Bridge General Arrangement Drawing Generator**  
    Professional engineering drawings for civil engineering projects and education.  
    Generated drawings follow standard engineering conventions and include proper dimensioning.
    """
)