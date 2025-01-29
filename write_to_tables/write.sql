CREATE OR REPLACE FUNCTION insert_dynamic_form(form_json JSONB)
RETURNS VOID AS $$
DECLARE
    form_id UUID;
    element JSONB;
    prop JSONB;
    validation JSONB;
    data JSONB;
    rule JSONB;
    element_scope TEXT;
BEGIN
    -- Insert form metadata
    INSERT INTO forms (id, name, description)
    VALUES (gen_random_uuid(), 
            form_json->>'name', 
            COALESCE(form_json->>'description', ''))
    RETURNING id INTO form_id;

    -- Insert Form Structure
    FOR element IN SELECT * FROM jsonb_array_elements(form_json->'structure')
    LOOP
        INSERT INTO form_structure (id, form_id, name, scope, parent_scope, component_type, order_index)
        VALUES (gen_random_uuid(),
                form_id,
                element->>'name',
                element->>'scope',
                element->>'parent_scope',
                element->>'component_type',
                COALESCE((element->>'order_index')::INT, 0))
        RETURNING scope INTO element_scope;

        -- Insert Component Properties
        IF form_json ? 'props' THEN
            FOR prop IN SELECT * FROM jsonb_each(form_json->'props')
            LOOP
                IF prop.key = element_scope THEN
                    INSERT INTO component_props (id, scope, prop_key, prop_value)
                    SELECT gen_random_uuid(), element_scope, key, value
                    FROM jsonb_each(prop.value);
                END IF;
            END LOOP;
        END IF;

        -- Insert Validation Rules
        IF form_json ? 'validation' THEN
            FOR validation IN SELECT * FROM jsonb_each(form_json->'validation')
            LOOP
                IF validation.key = element_scope THEN
                    INSERT INTO validation_rules (id, scope, rule_key, rule_value)
                    SELECT gen_random_uuid(), element_scope, key, value
                    FROM jsonb_each(validation.value);
                END IF;
            END LOOP;
        END IF;

        -- Insert Component Data
        IF form_json ? 'data' THEN
            FOR data IN SELECT * FROM jsonb_each(form_json->'data')
            LOOP
                IF data.key = element_scope THEN
                    INSERT INTO component_data (id, scope, data_key, data_value)
                    SELECT gen_random_uuid(), element_scope, key, value
                    FROM jsonb_each(data.value);
                END IF;
            END LOOP;
        END IF;

        -- Insert Rules (Regex-based Validation)
        IF form_json ? 'rules' THEN
            FOR rule IN SELECT * FROM jsonb_each(form_json->'rules')
            LOOP
                IF rule.key = element_scope THEN
                    INSERT INTO rules (id, scope, rule_name, rule_pattern, error_message)
                    SELECT gen_random_uuid(), element_scope, value->>'rule_name', value->>'rule_pattern', value->>'error_message'
                    FROM jsonb_array_elements(rule.value);
                END IF;
            END LOOP;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;
