package com.example;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class PasswordValidatorTest {

	PasswordValidator validator = new PasswordValidator();
	
	@Test
	
	void testStrongPassword() {
		
		assertTrue(validator.isStrongPassword("mypassword"));
		assertFalse(validator.isStrongPassword("short"));
		assertFalse(validator.isStrongPassword(null));
		
	}
	
}
