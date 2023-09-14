package com.thehecklers.foodservice;

public record Food(String id, Starch starch, Iterable<Topping> topping) {
}
