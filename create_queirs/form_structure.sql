CREATE TABLE form_structure (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    form_id UUID NOT NULL,
    name VARCHAR(255) NOT NULL,
    scope VARCHAR(255) NOT NULL UNIQUE,  -- Used to link with other tables
    parent_scope VARCHAR(255) NULL, -- Represents nesting
    component_type VARCHAR(50) NOT NULL, -- e.g., 'Input', 'Dropdown'
    order_index INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
