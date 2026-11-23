package dev.copilot.producer;

import org.apache.kafka.clients.admin.NewTopic;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.config.TopicBuilder;

@Configuration
public class TopicConfig {

    // Spring's KafkaAdmin creates this topic at startup if it doesn't exist.
    // If it exists with FEWER partitions, KafkaAdmin adds partitions to match.
    // It can never remove partitions: Kafka doesn't allow that.
    @Bean
    public NewTopic ordersTopic(@Value("${app.topic}") String name,
                                @Value("${app.topic-partitions}") int partitions) {
        return TopicBuilder.name(name).partitions(partitions).replicas(1).build();
    }
}