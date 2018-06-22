package com.makara.ms_ref_java_spring.repository;

import com.makara.ms_ref_java_spring.model.Contact;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

/**
 * I handle MongoDb datastore operations
 *
 * TODO: :( no ping command to tell if I can reach the db for readiness probe
 * TODO: use MongoTemplate to provide proper patch semantics and ping
 * see https://docs.spring.io/spring-data/mongodb/docs/current/reference/html/#mongo-template.save-update-remove
 */
public interface ContactsRepository extends MongoRepository<Contact, String> {

    // get a contact by _id
    Contact findById(String id);

    // get all contacts
    List<Contact> findAll();

    // get all contacts using query by example and include sorting and paging
    //    List<Contact> findAll(Contact c);

    // create a contact
    Contact insert(Contact c);

    // delete a contact - return count of items deleted
    Long removeDistinctById(String id);
    //    Long removeContactById(String id);

    // replace a contact doc
    Contact save(Contact c);

}
