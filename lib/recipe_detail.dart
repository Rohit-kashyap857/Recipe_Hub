// lib/recipe_detail.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'model.dart';

class RecipeDetail extends StatefulWidget {
  final RecipeModel recipe;

  const RecipeDetail({super.key, required this.recipe});

  @override
  State<RecipeDetail> createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {

  int selectedPersons = 1;
  late double baseYield;

  @override
  void initState() {
    super.initState();
    baseYield = widget.recipe.appyield;
    selectedPersons = baseYield.toInt();
  }

  double scaleValue(double original) {
    return (original * selectedPersons) / baseYield;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.applabel),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.recipe.appimageurl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(height: 16),

            // Servings Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Servings: ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButton<int>(
                  value: selectedPersons,
                  items: List.generate(12, (index) => index + 1)
                      .map((value) => DropdownMenuItem(
                    value: value,
                    child: Text("$value"),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPersons = value!;
                    });
                  },
                ),
              ],
            ),

            SizedBox(height: 16),

            // Calories
            Text(
              'Calories: ${scaleValue(widget.recipe.appcalories).toStringAsFixed(2)} kcal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 16),

            // Ingredients Title
            Text(
              'Ingredients:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 8),

            // Ingredients List
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.recipe.ingredients.length,
              itemBuilder: (context, index) {
                final ingredient = widget.recipe.ingredients[index];
                final scaledQty = scaleValue(ingredient.quantity);

                return ListTile(
                  leading: Icon(Icons.circle, size: 8),
                  title: Text(
                    "${scaledQty.toStringAsFixed(1)} ${ingredient.measure} ${ingredient.food}",
                  ),
                );
              },
            ),

            SizedBox(height: 20),

            // Button
            if (widget.recipe.appurl.isNotEmpty)
              Center(
                child: ElevatedButton(
                  onPressed: () => _launchURL(widget.recipe.appurl),
                  child: Text('View Full Recipe Online'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
