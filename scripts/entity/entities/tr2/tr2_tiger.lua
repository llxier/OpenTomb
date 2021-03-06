function tr2_tiger_init(id)
    basic_init(id);
    
    setEntityAnim(id, ANIM_TYPE_BASE, 1, 1);
    setEntityAnimState(id, ANIM_TYPE_BASE, 1);
    setCharacterStateControlFunctions(id, STATE_FUNCTIONS_TIGER);
    setCharacterKeyAnim(id, ANIM_TYPE_BASE, ANIMATION_KEY_INIT);
    setCharacterAIParams(id, 0xFF, ZONE_TYPE_1);
    setCharacterBones(id, 20, 0, 0, 0, 0, 0);  --head, torso, l_hand_first, l_hand_last, r_hand_first, r_hand_last TODO taken from tr1_puma, must be adjusted for tiger
    setCharacterMoveSizes(id, 512.0, 256.0, 256.0, 256, 256); -- TODO taken from tr1_puma, must be adjusted for tiger

    setCharacterParam(id, PARAM_HEALTH, TR2_TIGER_HEALTH, TR2_TIGER_HEALTH);
    setEntityGhostCollisionShape(id,  7,  COLLISION_SHAPE_BOX, nil, nil, nil, nil, nil, nil);
    setEntityGhostCollisionShape(id,  19,  COLLISION_SHAPE_BOX, nil, nil, nil, nil, nil, nil);
    setEntityGhostCollisionShape(id,  20,  COLLISION_SHAPE_BOX, nil, nil, nil, nil, nil, nil);

    if(getEntityTypeFlag(id, ENTITY_TYPE_SPAWNED) ~= 0) then
        entity_funcs[id].onSave = function()
            return "tr2_tiger_init(" .. id .. ");\n";
        end;
    end;

    entity_funcs[id].onAttack = function(object_id, activator_id)
        local bone = entity_funcs[object_id].col_part_from;
        if(bone == 20 or bone == 21 or bone == 2 or bone == 3 or bone == 5 or bone == 6) then -- TODO taken from tr1_puma, must be adjusted for tiger
            setCharacterParam(object_id, PARAM_HIT_DAMAGE, TR2_TIGER_DAMAGES * frame_time, TR2_TIGER_DAMAGES * frame_time);
            if(entity_funcs[activator_id].onHit ~= nil) then
                entity_funcs[activator_id].onHit(activator_id, object_id);
            end;
        end;
    end;

    entity_funcs[id].onHit = function(object_id, activator_id)
        local damage = getCharacterParam(activator_id, PARAM_HIT_DAMAGE);
        changeCharacterParam(object_id, PARAM_HEALTH, -damage);
        if(getCharacterParam(object_id, PARAM_HEALTH) == 0) then
            setEntityCollision(object_id, false);
            setCharacterTarget(activator_id, nil);
        end;
    end;
    
    entity_funcs[id].onLoop = nil;
end;