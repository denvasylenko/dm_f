CREATE TABLE component_props (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    scope VARCHAR(255) NOT NULL REFERENCES form_structure(scope) ON DELETE CASCADE,
    prop_key VARCHAR(255) NOT NULL, -- e.g., 'label', 'placeholder', 'options'
    prop_value TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
