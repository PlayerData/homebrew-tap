class RabbitmqDelayedMessageExchange < Formula
  desc "RabbitMQ Delayed Message Plugin"
  homepage "https://github.com/rabbitmq/rabbitmq-delayed-message-exchange"
  url "https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/releases/download/v3.12.0/rabbitmq_delayed_message_exchange-3.12.0.ez"
  sha256 "47e5d1a959c71ed0b70b5b32fa57ca9dff6e75541528a1038b92d3af2bdf46b9"
  license "MPL-2.0"

  depends_on "rabbitmq"

  def install
    (share/"rabbitmq/plugins").install "rabbitmq_delayed_message_exchange-3.12.0.ez"
  end

  def post_install
    system "rabbitmq-plugins", "enable", "--offline", "rabbitmq_delayed_message_exchange"
  end

  test do
    ENV["CONF_ENV_FILE"] = "#{HOMEBREW_PREFIX}/etc/rabbitmq/rabbitmq-env.conf"
    ENV["RABBITMQ_MNESIA_BASE"] = testpath/"var/lib/rabbitmq/mnesia"

    pid = fork { exec "#{HOMEBREW_PREFIX}/sbin/rabbitmq-server" }

    system "#{HOMEBREW_PREFIX}/sbin/rabbitmq-diagnostics", "wait", "--pid", pid

    enabled_plugins = shell_output "rabbitmq-plugins list --enabled"
    assert_match(/rabbitmq_delayed_message_exchange/, enabled_plugins)

    system "#{HOMEBREW_PREFIX}/sbin/rabbitmqctl", "stop"
  end
end
