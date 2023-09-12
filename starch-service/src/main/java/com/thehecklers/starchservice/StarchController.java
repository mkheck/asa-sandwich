package com.thehecklers.starchservice;

import jakarta.annotation.PostConstruct;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.UUID;

@RestController
public class StarchController {
    private Random rnd = new Random();
    private final ArrayList<Starch> starches = new ArrayList<>();

    @PostConstruct
    public void init() {
        starches.addAll(List.of(new Starch(UUID.randomUUID().toString(), "Potato", 1),
                new Starch(UUID.randomUUID().toString(), "Baked potato, open face", 3),
                new Starch(UUID.randomUUID().toString(), "French fries", 0),
                new Starch(UUID.randomUUID().toString(), "Salad", 0),
                new Starch(UUID.randomUUID().toString(), "Rice", 0),
                new Starch(UUID.randomUUID().toString(), "Rice, layer", 1),
                new Starch(UUID.randomUUID().toString(), "Pasta", 0),
                new Starch(UUID.randomUUID().toString(), "Pasta, layer", 1),
                new Starch(UUID.randomUUID().toString(), "Bread, one slice", 1),
                new Starch(UUID.randomUUID().toString(), "Bread, two slices", 2),
                new Starch(UUID.randomUUID().toString(), "Bread, two slices, edges sealed", 6),
                new Starch(UUID.randomUUID().toString(), "Bread bowl", 5),
                new Starch(UUID.randomUUID().toString(), "Bun, one piece", 3),
                new Starch(UUID.randomUUID().toString(), "Bun, two pieces", 2),
                new Starch(UUID.randomUUID().toString(), "Pastry", 1),
                new Starch(UUID.randomUUID().toString(), "Pastry, wrapped", 4),
                new Starch(UUID.randomUUID().toString(), "Crust, single layer", 1),
                new Starch(UUID.randomUUID().toString(), "Crust, two layers", 2),
                new Starch(UUID.randomUUID().toString(), "Crust, two layers, sealed", 6),
                new Starch(UUID.randomUUID().toString(), "Pita", 3),
                new Starch(UUID.randomUUID().toString(), "Tortilla, folded", 3),
                new Starch(UUID.randomUUID().toString(), "Tortilla, wrapped", 6),
                new Starch(UUID.randomUUID().toString(), "Cake, single layer", 1),
                new Starch(UUID.randomUUID().toString(), "Cake, two layers", 2)));
    }

    @GetMapping("/")
    public String getGreeting() {
        return "Hello from Starch!";
    }

    @GetMapping("/randomstarch")
    public Starch getRandomStarch() {
        return starches.get(rnd.nextInt(starches.size()));
    }

    @GetMapping("/starches")
    public Iterable<Starch> getAllStarches() {
        return starches;
    }

    @GetMapping("/starches/{id}")
    public Starch getStarchById(@PathVariable String id) {
        return starches.stream().filter(s -> s.id().equals(id)).findFirst().orElse(null);
    }
}
