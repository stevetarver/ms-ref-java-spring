package com.makara.ms_ref_java_spring.model;

import org.junit.jupiter.api.Test;

import javax.validation.ConstraintViolation;
import javax.validation.Validation;
import javax.validation.Validator;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.assertTrue;


class ContactTest {

    /**
     * This is not a good unit test. It is included simply to generate a junit-results.xml
     * for archiving with the project.
     *
     * NOTE: none of this test coverage will show in clover reports because we are using lombok
     * On one hand, it does not show a lack of coverage for things that lombok adds where
     * JaCoCo that instruments binaries will
     *
     * NOTE: To register test results during the build, use
     *         target/surefire-reports/*.xml
     *       see https://wiki.jenkins.io/display/JENKINS/JUnit+Plugin
     */
    @Test
    void validationFailsWhenNoEmail() {
        Contact subject = new Contact();
        subject.setFirstName("Bob");
        subject.setLastName("Zuul");
        subject.setZip("81623");

        Validator validator = Validation.buildDefaultValidatorFactory().getValidator();
        Set<ConstraintViolation<Contact>> violations = validator.validate(subject);

        assertTrue(violations.size() == 1);
    }
}