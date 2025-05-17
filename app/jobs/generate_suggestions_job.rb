require 'ollama-ai'

class GenerateSuggestionsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    create_suggestions

  end

  private

  def create_suggestions
    client = Ollama.new(
      credentials: { address: 'http://localhost:11434' },
      options: { server_sent_events: true }
    )

    Suggestion.destroy_all
    Product.find_each(batch_size: 100) do |product|
      result = client.generate(
        { model: 'mistral',
          prompt: "Only use german. Please provide 3 different Alt texts for this product optimized for SEO as a JSON array of strings. The product name is '#{product.name}'. Do not include any of these symbols $ ! [] .Respond using JSON",
          "format": "json",
          stream: false }
      )
      parsed_response = JSON.parse(result.first["response"])

      alt_texts = parsed_response.values
      alt_texts.each do |alt_text|
        product.suggestions.build(suggestion: alt_text)
      end
      product.save!
    end
  end
end
