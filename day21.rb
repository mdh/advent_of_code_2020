input = File.read('day21_input.txt')

test_input =<<EOT
mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
trh fvjkl sbzzf mxmxvkd (contains dairy)
sqjhc fvjkl (contains soy)
sqjhc mxmxvkd sbzzf (contains fish)
EOT

foods =
  input.strip.lines.map do |line|
    ingredients, allergens = line.strip.split('(contains ')
    ingredients = ingredients.split
    allergens = allergens.split(/[\),\s]{1,2}/)
    { ingredients: ingredients, allergens: allergens }
  end

allergens = foods.flat_map { |food| food[:allergens] }.uniq
allergens_per_ingredient = {}
while allergens_per_ingredient.size < allergens.size
  allergens.each do |allergen|
    foods_with_allergen = foods.find_all { |food| food[:allergens].include? allergen }
    common_allergens    = foods_with_allergen.map { |food| food[:allergens  ] }.reduce(:&)
    common_ingredients  = foods_with_allergen.map { |food| food[:ingredients] }.reduce(:&)
    # remove allergens & ingredients we already have resolved
    common_allergens    -= allergens_per_ingredient.values
    common_ingredients  -= allergens_per_ingredient.keys
    if common_allergens.size == 1 && common_ingredients.size == 1
      # we have an exact match, store it
      allergens_per_ingredient[common_ingredients[0]] = common_allergens[0]
    end
  end
end

safe_ingredients = foods.flat_map { |food| food[:ingredients] } - allergens_per_ingredient.keys
pp safe_ingredients.size

# part 2
pp allergens_per_ingredient.sort_by(&:last).map(&:first).join ','
