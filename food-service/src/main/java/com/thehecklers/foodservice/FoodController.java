package com.thehecklers.foodservice;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class FoodController {
    @GetMapping("/")
    public String getFood() {
        // Why have a simple greeting? 😉
        return "🍔🍟🍕🌭🥓🥞🍳🍜🍝🍣🍤🍦🍩🍪🍫🍬🍭🍮🍯";
    }
}
