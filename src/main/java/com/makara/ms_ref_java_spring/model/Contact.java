package com.makara.ms_ref_java_spring.model;

import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.validator.constraints.NotEmpty;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

/**
 * Model for Contact documents
 */
@Data
@Document(collection = "contacts")
@NoArgsConstructor
public class Contact {
    @Id
    private String id;

    @NotEmpty
    private String firstName;
    @NotEmpty
    private String lastName;
    private String companyName;
    private String address;
    private String city;
    private String county;
    private String state;
    @NotEmpty
    private String zip;
    private String phone1;
    private String phone2;
    @NotEmpty
    private String email;
    private String website;
}
