package com.thehecklers.foodservice;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Collections;

@RestController
public class FoodController {
    @GetMapping("/")
    public String getFood() {
        // Why have a simple greeting? 😉
        return "🍔🍟🍕🌭🥓🥞🍳🍜🍝🍣🍤🍦🍩🍪🍫🍬🍭🍮🍯";
    }

    @GetMapping("/random")
    public Food getRandomFood() {
        return new Food("1", new Starch("1", "Potato", 1), Collections.singletonList(new Topping("1", "Bacon", Taste.SAVORY)));
    }
}
