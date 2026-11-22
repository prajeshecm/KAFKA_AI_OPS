package dev.copilot.producer;

import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.web.bind.annotation.*;

@RestController
public class OrderController {

    private final KafkaTemplate<String, String> kafka;

    // Spring injects the KafkaTemplate it built from application.properties
    public OrderController(KafkaTemplate<String, String> kafka) {
        this.kafka = kafka;
    }

    // POST /orders?count=100 sends that many order messages
    @PostMapping("/orders")
    public String send(@RequestParam(defaultValue = "10") int count) {
        for (int i = 1; i <= count; i++) {
            String orderId = "order-" + i;
            // key = orderId, so one order's messages stay in one partition
            kafka.send("orders", orderId, "{\"orderId\":\"" + orderId + "\",\"amount\":50}");
        }
        return "Sent " + count + " orders";
    }
}