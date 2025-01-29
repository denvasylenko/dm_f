CREATE OR REPLACE FUNCTION get_full_form_json()
RETURNS JSONB AS $$
WITH RECURSIVE form_tree AS (
    SELECT 
        fs.id,
        fs.name,
        fs.scope,
        fs.parent_scope,
        fs.component_type,
        fs.order_index
    FROM form_structure fs
    WHERE fs.parent_scope IS NULL

    UNION ALL

    SELECT 
        fs.id,
        fs.name,
        fs.scope,
        fs.parent_scope,
        fs.component_type,
        fs.order_index
    FROM form_structure fs
    INNER JOIN form_tree ft ON fs.parent_scope = ft.scope
)
SELECT jsonb_build_object(
    'structure', (
        SELECT jsonb_agg(jsonb_build_object(
            'name', name,
            'scope', scope,
            'component_type', component_type,
            'elements', (
                SELECT COALESCE(jsonb_agg(jsonb_build_object(
                    'name', fs_child.name,
                    'scope', fs_child.scope,
                    'component_type', fs_child.component_type
                )), '[]'::jsonb)
                FROM form_structure fs_child
                WHERE fs_child.parent_scope = form_tree.scope
            )
        )) FROM form_tree
    ),
    'props', (
        SELECT jsonb_object_agg(scope, jsonb_object_agg(prop_key, prop_value))
        FROM component_props
    ),
    'validation', (
        SELECT jsonb_object_agg(scope, jsonb_object_agg(rule_key, rule_value))
        FROM validation_rules
    ),
    'data', (
        SELECT jsonb_object_agg(scope, jsonb_object_agg(data_key, data_value))
        FROM component_data
    ),
    'rules', (
        SELECT jsonb_object_agg(scope, jsonb_agg(jsonb_build_object(
            'rule_name', rule_name,
            'rule_pattern', rule_pattern,
            'error_message', error_message
        )))
        FROM rules
    )
);
$$ LANGUAGE sql STABLE;
