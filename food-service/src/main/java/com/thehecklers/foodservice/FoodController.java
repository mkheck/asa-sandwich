package com.thehecklers.foodservice;

import org.springframework.core.ParameterizedTypeReference;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestClient;

import java.util.UUID;

@RestController
public class FoodController {
    @GetMapping("/")
    public String getFood() {
        // Why have a simple greeting? 😉
        return "🍔🍟🍕🌭🥓🥞🍳🍜🍝🍣🍤🍦🍩🍪🍫🍬🍭🍮🍯";
    }

    @GetMapping("/random")
    public Food getRandomFood() {
        //var starchClient = RestClient.create("http://localhost:8082/random");
        //var toppingClient = RestClient.create("http://localhost:8083/random");
        var starchClient = RestClient.create("http://starch-service/random");
        var toppingClient = RestClient.create("http://topping-service/random");

        var starch = starchClient.get().retrieve().body(Starch.class);
        var toppings = toppingClient.get().retrieve().body(new ParameterizedTypeReference<Iterable<Topping>>() {});

        return new Food(UUID.randomUUID().toString(), starch, toppings);
    }
}
