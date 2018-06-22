package com.makara.ms_ref_java_spring.exception;

public class ResourceNotFoundInCollectionException extends RuntimeException {

    public ResourceNotFoundInCollectionException(String collection, String id) {
        super(String.format("There is no item '%s' in the %s collection.", id, collection));
    }
}
