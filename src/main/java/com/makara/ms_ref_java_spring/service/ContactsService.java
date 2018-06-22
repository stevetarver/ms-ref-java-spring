package com.makara.ms_ref_java_spring.service;

import com.makara.ms_ref_java_spring.exception.ResourceNotFoundInCollectionException;
import com.makara.ms_ref_java_spring.repository.ContactsRepository;
import com.makara.ms_ref_java_spring.model.Contact;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * I perform orchestration on contact related ReST calls.
 */
@Service
public class ContactsService {

    private final ContactsRepository contactsRepository;

    /**
     * The new, Spring preferred way of CDI: Component Scan with @Autowired constructor injection
     *
     * Note: @Autowired is not required iff only 1 ctor. That seems ripe for maintenance injection errors
     *       so I use it always.
     * https://docs.spring.io/spring-boot/docs/current/reference/html/using-boot-spring-beans-and-dependency-injection.html
     */
    @Autowired
    public ContactsService(ContactsRepository contactsRepository) {
        this.contactsRepository = contactsRepository;
    }

    public Contact createContact(Contact contact) {
        return contactsRepository.insert(contact);
    }

    public Long deleteContact(String id) {
        return contactsRepository.removeDistinctById(id);
    }

    public Contact getContact(String id) {
        return contactsRepository.findById(id);
    }

    public List<Contact> getContacts() {
        return contactsRepository.findAll();
    }

    public Contact patchContact(Contact contact) {
        Contact orig = contactsRepository.findById(contact.getId());
        if(null == orig) {
            throw new ResourceNotFoundInCollectionException("contacts", contact.getId());
        }

        // TODO: really ugly, please provide a simpler PATCH
        if(null == contact.getFirstName()) {
            contact.setFirstName(orig.getFirstName());
        }
        if(null == contact.getLastName()) {
            contact.setLastName(orig.getLastName());
        }
        if(null == contact.getCompanyName()) {
            contact.setCompanyName(orig.getCompanyName());
        }
        if(null == contact.getAddress()) {
            contact.setAddress(orig.getAddress());
        }
        if(null == contact.getCity()) {
            contact.setCity(orig.getCity());
        }
        if(null == contact.getCounty()) {
            contact.setCounty(orig.getCounty());
        }
        if(null == contact.getState()) {
            contact.setState(orig.getState());
        }
        if(null == contact.getZip()) {
            contact.setZip(orig.getZip());
        }
        if(null == contact.getPhone1()) {
            contact.setPhone1(orig.getPhone1());
        }
        if(null == contact.getPhone2()) {
            contact.setPhone2(orig.getPhone2());
        }
        if(null == contact.getEmail()) {
            contact.setEmail(orig.getEmail());
        }
        if(null == contact.getWebsite()) {
            contact.setWebsite(orig.getWebsite());
        }

        return contactsRepository.save(contact);
    }

    public Contact replaceContact(Contact contact) {
        return contactsRepository.save(contact);
    }
}
