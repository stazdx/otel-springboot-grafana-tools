package com.staz.observability;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class Controller {

    @PostMapping("/fail")
    public String fail() {
        return "Fail!";
    }

    @GetMapping("/success")
    public String success() {

        return "Success!";
    }

}