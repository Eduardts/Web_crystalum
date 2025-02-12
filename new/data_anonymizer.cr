# src/data_anonymizer.cr

require "json"

# Function to anonymize data
def anonymize_data(data: String) : String
  # Simulate data processing
  lines = data.split("\n")
  anonymized_data = lines.map do |line|
    values = line.split(",")
    # Replace sensitive info with anonymized values
    values[1] = "ANONYMIZED" # Assuming the second value is sensitive
    values.join(",")
  end
  return anonymized_data.join("\n")
end

# Read input data
input_file = "sensitive_data.csv"
output_file = "anonymized_data.csv"

File.open(input_file, "r") do |input|
  File.open(output_file, "w") do |output|
    output.write(anonymize_data(data: input.read))
  end
end

puts "Anonymization completed. Output saved to #{output_file}."

