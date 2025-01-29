CREATE TABLE validation_rules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    scope VARCHAR(255) NOT NULL REFERENCES form_structure(scope) ON DELETE CASCADE,
    rule_key VARCHAR(255) NOT NULL, -- e.g., 'required', 'minLength'
    rule_value TEXT NOT NULL, -- e.g., 'true', '3'
    error_message TEXT NOT NULL, -- Message to display if validation fails
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
