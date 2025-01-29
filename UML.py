# Create Updated UML Diagram with Rules Table
from graphviz import Digraph

uml = Digraph('DynamicFormDB_Updated', filename='dynamic_form_db_updated', format='png')

# Set node shape to box
uml.attr('node', shape='record')

# Define tables with a structured layout
uml.node('Forms', '''{ Forms | 
------------------ |
+ ID (UUID) PK |
+ Name (VARCHAR) |
+ Description (TEXT) |
+ Created_At (TIMESTAMP) |
+ Updated_At (TIMESTAMP) }''')

uml.node('FormStructure', '''{ FormStructure | 
------------------ |
+ ID (UUID) PK |
+ Form_ID (UUID) FK |
+ Name (VARCHAR) |
+ Scope (VARCHAR) UNIQUE |
+ Parent_Scope (VARCHAR) FK |
+ Component_Type (VARCHAR) |
+ Order_Index (INT) |
+ Created_At (TIMESTAMP) |
+ Updated_At (TIMESTAMP) }''')

uml.node('ComponentProps', '''{ ComponentProps | 
------------------ |
+ ID (UUID) PK |
+ Scope (VARCHAR) FK |
+ Prop_Key (VARCHAR) |
+ Prop_Value (TEXT) |
+ Created_At (TIMESTAMP) |
+ Updated_At (TIMESTAMP) }''')


uml.node('ComponentData', '''{ ComponentData | 
------------------ |
+ ID (UUID) PK |
+ Scope (VARCHAR) FK |
+ Data_Key (VARCHAR) |
+ Data_Value (JSONB) |
+ Created_At (TIMESTAMP) |
+ Updated_At (TIMESTAMP) }''')

uml.node('ValidationRules', '''{ ValidationRules | 
------------------ |
+ ID (UUID) PK |
+ Scope (VARCHAR) FK |
+ Rule_Key (VARCHAR) |
+ Rule_Value (TEXT) |
+ Error_Message (TEXT) |
+ Created_At (TIMESTAMP) |
+ Updated_At (TIMESTAMP) }''')

uml.node('Rules', '''{ Rules | 
------------------ |
+ ID (UUID) PK |
+ Scope (VARCHAR) FK |
+ Rule_Name (VARCHAR) |
+ Rule_Pattern (TEXT) |
+ Error_Message (TEXT) |
+ Created_At (TIMESTAMP) |
+ Updated_At (TIMESTAMP) }''')

# Define Relationships
uml.edge('Forms', 'FormStructure', label='1 -> *')  # One form has many structures
uml.edge('FormStructure', 'ComponentProps', label='1 -> *')  # One structure has many props
uml.edge('FormStructure', 'ValidationRules', label='1 -> *')  # One structure has many validations
uml.edge('FormStructure', 'ComponentData', label='1 -> *')  # One structure has many data entries
uml.edge('FormStructure', 'Rules', label='1 -> *')  # One structure has many rules
uml.edge('FormStructure', 'FormStructure', label='parent_scope')  # Self-referencing for hierarchy

# Render UML Diagram
uml_path_rules = 'mnt/data/dynamic_form_db_updated'
uml.render(uml_path_rules, format='png', cleanup=True)
uml_path_rules
