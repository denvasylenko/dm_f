CREATE TABLE rules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    scope VARCHAR(255) NOT NULL REFERENCES form_structure(scope) ON DELETE CASCADE,
    rule_name VARCHAR(255) NOT NULL, -- e.g., 'email', 'phone', 'custom'
    rule_pattern TEXT NOT NULL, -- Stores regex pattern
    error_message TEXT NOT NULL, -- Message to display if validation fails
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
