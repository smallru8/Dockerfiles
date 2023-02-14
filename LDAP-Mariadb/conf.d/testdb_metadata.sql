insert into ldap_oc_mappings (id,name,keytbl,keycol,create_proc,delete_proc,expect_return) values (1,'inetOrgPerson','users','id',NULL,NULL,0);
insert into ldap_oc_mappings (id,name,keytbl,keycol,create_proc,delete_proc,expect_return) values (2,'document','documents','id',NULL,NULL,0);
insert into ldap_oc_mappings (id,name,keytbl,keycol,create_proc,delete_proc,expect_return) values (3,'organization','institutes','id',NULL,NULL,0);
insert into ldap_oc_mappings (id,name,keytbl,keycol,create_proc,delete_proc,expect_return) values (4,'referral','referrals','id',NULL,NULL,0);
insert into ldap_attr_mappings (id,oc_map_id,name,sel_expr,from_tbls,join_where,add_proc,delete_proc,param_order,expect_return) values (1,1,'cn',"concat(users.name,' ',users.surname)",'users',NULL,NULL,NULL,3,0);
insert into ldap_attr_mappings (id,oc_map_id,name,sel_expr,from_tbls,join_where,add_proc,delete_proc,param_order,expect_return) values (2,1,'telephoneNumber','phones.phone','users,phones','phones.pers_id=users.id',NULL,NULL,3,0);
insert into ldap_attr_mappings (id,oc_map_id,name,sel_expr,from_tbls,join_where,add_proc,delete_proc,param_order,expect_return)values (3,1,'givenName','users.name','users',NULL,NULL,NULL,3,0);
insert into ldap_attr_mappings (id,oc_map_id,name,sel_expr,from_tbls,join_where,add_proc,delete_proc,param_order,expect_return)values (4,1,'sn','users.surname','users',NULL,NULL,NULL,3,0);
insert into ldap_attr_mappings (id,oc_map_id,name,sel_expr,from_tbls,join_where,add_proc,delete_proc,param_order,expect_return)values (5,1,'userPassword','users.password','users','users.password IS NOT NULL',NULL,NULL,3,0);
insert into ldap_attr_mappings (id,oc_map_id,name,sel_expr,from_tbls,join_where,add_proc,delete_proc,param_order,expect_return)values (6,1,'seeAlso','seeAlso.dn','ldap_entries AS seeAlso,documents,authors_docs,users',        'seeAlso.keyval=documents.id AND seeAlso.oc_map_id=2 AND authors_docs.doc_id=documents.id AND authors_docs.pers_id=users.id',	NULL,NULL,3,0);
insert into ldap_attr_mappings (id,oc_map_id,name,sel_expr,from_tbls,join_where,add_proc,delete_proc,param_order,expect_return)values (7,2,'description','documents.abstract','documents',NULL,NULL,NULL,3,0);
insert into ldap_attr_mappings (id,oc_map_id,name,sel_expr,from_tbls,join_where,add_proc,delete_proc,param_order,expect_return)values (8,2,'documentTitle','documents.title','documents',NULL,NULL,NULL,3,0);
insert into ldap_attr_mappings (id,oc_map_id,name,sel_expr,from_tbls,join_where,add_proc,delete_proc,param_order,expect_return)values (9,2,'documentAuthor','documentAuthor.dn','ldap_entries AS documentAuthor,documents,authors_docs,users',	'documentAuthor.keyval=users.id AND documentAuthor.oc_map_id=1 AND authors_docs.doc_id=documents.id AND authors_docs.pers_id=users.id',	NULL,NULL,3,0);
insert into ldap_attr_mappings (id,oc_map_id,name,sel_expr,from_tbls,join_where,add_proc,delete_proc,param_order,expect_return)values (10,2,'documentIdentifier','concat(''document '',documents.id)','documents',NULL,NULL,NULL,3,0);
insert into ldap_attr_mappings (id,oc_map_id,name,sel_expr,from_tbls,join_where,add_proc,delete_proc,param_order,expect_return)values (11,3,'o','institutes.name','institutes',NULL,NULL,NULL,3,0);
insert into ldap_attr_mappings (id,oc_map_id,name,sel_expr,from_tbls,join_where,add_proc,delete_proc,param_order,expect_return)values (12,3,'dc','lower(institutes.name)','institutes,ldap_entries AS dcObject,ldap_entry_objclasses as auxObjectClass',	'institutes.id=dcObject.keyval AND dcObject.oc_map_id=3 AND dcObject.id=auxObjectClass.entry_id AND auxObjectClass.oc_name=''dcObject''',	NULL,NULL,3,0);
insert into ldap_attr_mappings (id,oc_map_id,name,sel_expr,from_tbls,join_where,add_proc,delete_proc,param_order,expect_return)values (13,4,'ou','referrals.name','referrals',NULL,NULL,NULL,3,0);
insert into ldap_attr_mappings (id,oc_map_id,name,sel_expr,from_tbls,join_where,add_proc,delete_proc,param_order,expect_return)values (14,4,'ref','referrals.url','referrals',NULL,NULL,NULL,3,0);
insert into ldap_attr_mappings (id,oc_map_id,name,sel_expr,from_tbls,join_where,add_proc,delete_proc,param_order,expect_return)values (15,1,'userCertificate','certs.cert','users,certs',        'certs.pers_id=users.id',NULL,NULL,3,0);
insert into ldap_entries (id,dn,oc_map_id,parent,keyval)values (1,'dc=example,dc=com',3,0,1);
insert into ldap_entries (id,dn,oc_map_id,parent,keyval)values (2,'cn=Mitya Kovalev,dc=example,dc=com',1,1,1);
insert into ldap_entries (id,dn,oc_map_id,parent,keyval)values (3,'cn=Torvlobnor Puzdoy,dc=example,dc=com',1,1,2);
insert into ldap_entries (id,dn,oc_map_id,parent,keyval)values (4,'cn=Akakiy Zinberstein,dc=example,dc=com',1,1,3);
insert into ldap_entries (id,dn,oc_map_id,parent,keyval)values (5,'documentTitle=book1,dc=example,dc=com',2,1,1);
insert into ldap_entries (id,dn,oc_map_id,parent,keyval)values (6,'documentTitle=book2,dc=example,dc=com',2,1,2);
insert into ldap_entries (id,dn,oc_map_id,parent,keyval)values (7,'ou=Referral,dc=example,dc=com',4,1,1);
insert into ldap_entry_objclasses (entry_id,oc_name)values (1,'dcObject');
