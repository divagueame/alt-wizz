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

    Suggestion.all.destroy_all
    
    Product.find_each(batch_size: 100) do |product|
      alt_texts = []

      while alt_texts.size < 3 do
        result = client.generate(
          { model: 'smollm:135m',
            prompt: "Please provide 3 different Alt texts for this product optimized for SEO as a JSON array of strings. The product name is '#{product.name}'. Important: do not include any of these symbols \" $ ! [] .Respond using JSON",
            "format": "json",
            stream: false }
        )
        parsed_response = JSON.parse(result.first["response"])
        new_alt_texts = parsed_response.values

        new_alt_texts.each do |alt_text|
          alt_texts << alt_text if alt_text.is_a?(String)
        end
      end


      alt_texts.each do |alt_text|
        product.suggestions.build(suggestion: alt_text) 
        puts alt_text
      end

      product.save!
      puts "-> Total suggestions: #{product.suggestions.count}"
    end
  end


  def query_llm
  end
end
