package com.example;

public class PasswordValidator {
	
	public boolean isStrongPassword(String password)
	{return password != null && password.length() >= 8;}
}
