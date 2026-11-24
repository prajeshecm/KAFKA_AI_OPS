package dev.copilot.consumer;

import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

@Component
public class OrderListener {

  private static final Logger log = LoggerFactory.getLogger(OrderListener.class);

  // Read from application.properties, so a config change can slow us down
  @Value("${app.processing-delay-ms}")
  private long processingDelayMs;

  // Spring polls Kafka and calls this method once per record
  @KafkaListener(topics = "${app.topic}")
  public void onOrder(ConsumerRecord<String, String> record) throws InterruptedException {
    // Simulate real work, like a database call
    Thread.sleep(processingDelayMs);

    log.info(
        "partition={} offset={} key={} value={}",
        record.partition(),
        record.offset(),
        record.key(),
        record.value());
    // No commit code: Spring commits offsets after the batch is processed
  }
}
