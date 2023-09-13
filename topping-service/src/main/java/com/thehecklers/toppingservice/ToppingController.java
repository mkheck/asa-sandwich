package com.thehecklers.toppingservice;

import jakarta.annotation.PostConstruct;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.*;

@RestController
public class ToppingController {
    private Random rnd = new Random();
    private final ArrayList<Topping> toppings = new ArrayList<>();

    @PostConstruct
    public void init() {
        toppings.addAll(
                List.of(new Topping(UUID.randomUUID().toString(), "Cheese", Taste.BOTH),
                        new Topping(UUID.randomUUID().toString(), "Sour cream", Taste.SAVORY),
                        new Topping(UUID.randomUUID().toString(), "Ice cream", Taste.SWEET),
                        new Topping(UUID.randomUUID().toString(), "Chives", Taste.SAVORY),
                        new Topping(UUID.randomUUID().toString(), "Onions", Taste.SAVORY),
                        new Topping(UUID.randomUUID().toString(), "Shredded leaf veggies", Taste.SAVORY),
                        new Topping(UUID.randomUUID().toString(), "Tomato sauce", Taste.SAVORY),
                        new Topping(UUID.randomUUID().toString(), "Peanut butter", Taste.BOTH),
                        new Topping(UUID.randomUUID().toString(), "Jelly/Jam/Preserves", Taste.SWEET),
                        new Topping(UUID.randomUUID().toString(), "Hot dog", Taste.SAVORY),
                        new Topping(UUID.randomUUID().toString(), "Fruit filling", Taste.SWEET),
                        new Topping(UUID.randomUUID().toString(), "Chutney", Taste.BOTH),
                        new Topping(UUID.randomUUID().toString(), "Chocolate", Taste.BOTH),
                        new Topping(UUID.randomUUID().toString(), "Chocolate chips", Taste.SWEET),
                        new Topping(UUID.randomUUID().toString(), "Meat", Taste.SAVORY),
                        new Topping(UUID.randomUUID().toString(), "Lettuce", Taste.SAVORY),
                        new Topping(UUID.randomUUID().toString(), "Tomatoes", Taste.SAVORY),
                        new Topping(UUID.randomUUID().toString(), "Frosting", Taste.SWEET),
                        new Topping(UUID.randomUUID().toString(), "Pie filling", Taste.SWEET),
                        new Topping(UUID.randomUUID().toString(), "Hot peppers", Taste.SAVORY),
                        new Topping(UUID.randomUUID().toString(), "Cream/cheesecake filling", Taste.SWEET),
                        new Topping(UUID.randomUUID().toString(), "Avocado/guacamole", Taste.SAVORY),
                        new Topping(UUID.randomUUID().toString(), "Soup", Taste.SAVORY),
                        new Topping(UUID.randomUUID().toString(), "Falafel", Taste.SAVORY),
                        new Topping(UUID.randomUUID().toString(), "Mashed potatoes", Taste.SAVORY),
                        new Topping(UUID.randomUUID().toString(), "Custard", Taste.SWEET),
                        new Topping(UUID.randomUUID().toString(), "Marshmallows", Taste.SWEET),
                        new Topping(UUID.randomUUID().toString(), "Croutons", Taste.SAVORY),
                        new Topping(UUID.randomUUID().toString(), "Eggs", Taste.SAVORY),
                        new Topping(UUID.randomUUID().toString(), "Chickpeas", Taste.SAVORY)));
    }

    @GetMapping("/")
    public String getGreeting() {
        return "Hello from Topping!";
    }

    @GetMapping("/toppings")
    public Iterable<Topping> getAllToppings() {
        return toppings;
    }

    @GetMapping("/toppings/{id}")
    public Topping getToppingById(@PathVariable String id) {
        return toppings.stream()
                .filter(t -> t.id().equals(id))
                .findFirst()
                .orElse(new Topping("00000000-0000-0000-0000-000000000000", "Topping not found", Taste.BOTH));
    }

    @GetMapping("/random")
    public Iterable<Topping> getToppings(@RequestParam(required = false) Integer count) {
        var n = null == count
                ? rnd.nextInt(toppings.size())
                : count;

        // Retrieve a random subset of toppings using count as the number to retrieve
        var shuffledToppings = new ArrayList<>(toppings);
        Collections.shuffle(shuffledToppings);

        //return shuffledToppings.subList(0, Math.min(n, shuffledToppings.size()));
        System.out.println(">>> Returning " + n + " toppings.");

        return shuffledToppings.subList(0, n);

        // MH: Next step, select SWEET, SAVORY, or BOTH
    }
}
