echo 'insert into ldap_entries (id,dn,oc_map_id,parent,keyval)values (1,"'$LDAP_BASE_DN'",3,0,1);' >> /usr/local/etc/openldap/dbschema/testdb_metadata.sql
echo 'insert into ldap_entry_objclasses (entry_id,oc_name)values (1,"dcObject");' >> /usr/local/etc/openldap/dbschema/testdb_metadata.sql
echo 'CREATE TRIGGER `users_after_insert` AFTER INSERT ON `users` FOR EACH ROW BEGIN INSERT INTO ldap_entries(`dn`,`keyval`) VALUES (CONCAT("cn=",NEW.`name`,",'$LDAP_BASE_DN'"),NEW.`id`); INSERT INTO wallet(`id`) VALUES (NEW.`id`); END' >> /usr/local/etc/openldap/dbschema/testdb_metadata.sql
echo 'CREATE TRIGGER `users_before_delete` BEFORE DELETE ON `users` FOR EACH ROW BEGIN DELETE FROM `ldap_entries` WHERE `keyval`=OLD.`id`; END' >> /usr/local/etc/openldap/dbschema/testdb_metadata.sql
