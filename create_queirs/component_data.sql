CREATE TABLE component_data (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    scope VARCHAR(255) NOT NULL REFERENCES form_structure(scope) ON DELETE CASCADE,
    data_key VARCHAR(255) NOT NULL, -- e.g., 'value, selectedValue, selectedKey', etc. 
    data_value JSONB NOT NULL, -- Stores array of dropdown options, radio choices, etc.
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
