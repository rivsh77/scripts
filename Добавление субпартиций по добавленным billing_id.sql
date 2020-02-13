begin
    for r in (select rownum+2 rn, t.* from all_objects t where 1=1 and object_name='CLIENT_CONTACTS' and OBJECT_TYPE='TABLE PARTITION') loop
          execute immediate 'ALTER TABLE <TABLE_NAME> MODIFY PARTITION '|| r.SUBOBJECT_NAME||'  ADD SUBPARTITION <TABLE_NAME>'||r.rn ||' VALUES (<billing_id>)';       
   end loop;
end;   
