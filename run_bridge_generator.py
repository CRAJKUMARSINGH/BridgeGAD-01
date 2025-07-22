#!/usr/bin/env python3
"""
Simple interactive interface for the Bridge Drawing Generator
"""

from bridge_drawings import BridgeDrawingGenerator, BridgeType, BridgeParameters, OutputFormat, create_example_bridges
import matplotlib.pyplot as plt

def interactive_bridge_generator():
    """Interactive command-line interface for generating bridge drawings"""
    print("=" * 60)
    print("  BRIDGE GENERAL ARRANGEMENT DRAWING GENERATOR")
    print("=" * 60)
    print()
    
    while True:
        print("Options:")
        print("1. Generate example bridges (all types)")
        print("2. Create custom bridge")
        print("3. Exit")
        print()
        
        choice = input("Select option (1-3): ").strip()
        
        if choice == "1":
            generate_examples()
        elif choice == "2":
            create_custom_bridge()
        elif choice == "3":
            print("Thank you for using the Bridge Drawing Generator!")
            break
        else:
            print("Invalid choice. Please select 1, 2, or 3.")
        
        print()

def generate_examples():
    """Generate all example bridges"""
    print("\nGenerating example bridges of all types...")
    print("-" * 40)
    
    examples = create_example_bridges()
    
    for bridge_type, params, filename in examples:
        print(f"Creating {bridge_type.value.title()} Bridge...")
        generator = BridgeDrawingGenerator(bridge_type, params)
        generator.generate_drawing()
        generator.save_drawing(filename, OutputFormat.PNG)
        print(f"  Saved: {filename}.png")
    
    print(f"\nGenerated {len(examples)} example bridges successfully!")
    print("Files saved in current directory.")

def create_custom_bridge():
    """Interactive custom bridge creation"""
    print("\nCustom Bridge Generator")
    print("-" * 25)
    
    # Bridge type selection
    print("\nAvailable bridge types:")
    bridge_types = list(BridgeType)
    for i, bt in enumerate(bridge_types, 1):
        print(f"  {i}. {bt.value.title()} Bridge")
    
    while True:
        try:
            choice = int(input(f"\nSelect bridge type (1-{len(bridge_types)}): "))
            if 1 <= choice <= len(bridge_types):
                bridge_type = bridge_types[choice - 1]
                break
            else:
                print(f"Please enter a number between 1 and {len(bridge_types)}")
        except ValueError:
            print("Please enter a valid number")
    
    # Get bridge parameters
    print(f"\nConfiguring {bridge_type.value.title()} Bridge:")
    print("(Press Enter for default values)")
    
    try:
        # Span length
        span_input = input("Span length in meters [100]: ").strip()
        span_length = float(span_input) if span_input else 100.0
        
        # Deck width
        width_input = input("Deck width in meters [12]: ").strip()
        deck_width = float(width_input) if width_input else 12.0
        
        # Height
        height_input = input("Overall height in meters [20]: ").strip()
        height = float(height_input) if height_input else 20.0
        
        # Supports (for applicable bridge types)
        if bridge_type in [BridgeType.BEAM]:
            supports_input = input("Number of intermediate supports [1]: ").strip()
            supports = int(supports_input) if supports_input else 1
        else:
            supports = 0
        
        # Load capacity
        load_input = input("Design load in kN/m [50]: ").strip()
        load_capacity = float(load_input) if load_input else 50.0
        
        # Material
        print("\nCommon materials: steel, concrete, timber, stone")
        material_input = input("Primary material [steel]: ").strip()
        material = material_input if material_input else "steel"
        
        # Create parameters
        params = BridgeParameters(
            span_length=span_length,
            deck_width=deck_width,
            height=height,
            supports=supports,
            load_capacity=load_capacity,
            material=material
        )
        
        # Output filename
        filename_input = input("\nOutput filename (without extension) [custom_bridge]: ").strip()
        filename = filename_input if filename_input else "custom_bridge"
        
        # Generate the bridge
        print(f"\nGenerating {bridge_type.value.title()} Bridge...")
        print(f"Specifications: {params}")
        
        generator = BridgeDrawingGenerator(bridge_type, params)
        fig = generator.generate_drawing()
        
        # Save the drawing
        generator.save_drawing(filename, OutputFormat.PNG)
        print(f"Bridge drawing saved as: {filename}.png")
        
        # Option to display the drawing
        display_choice = input("\nDisplay the drawing now? (y/n) [y]: ").strip().lower()
        if display_choice != 'n':
            plt.show()
        
    except ValueError as e:
        print(f"Error: Invalid input - {e}")
    except Exception as e:
        print(f"Error generating bridge: {e}")

if __name__ == "__main__":
    try:
        interactive_bridge_generator()
    except KeyboardInterrupt:
        print("\n\nProgram interrupted by user. Goodbye!")
    except Exception as e:
        print(f"\nUnexpected error: {e}")