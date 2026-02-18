// lib/recipe_detail.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model.dart';

class RecipeDetail extends StatelessWidget {
  final RecipeModel recipe;

  const RecipeDetail({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.applabel),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: recipe.appimageurl.isNotEmpty
                  ? Image.network(
                      recipe.appimageurl,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(
                        color: Colors.grey[300],
                        height: 250,
                        child: Icon(Icons.broken_image, size: 64),
                      ),
                    )
                  : Container(
                      color: Colors.grey[300],
                      height: 250,
                      child: Icon(Icons.image_not_supported, size: 64),
                    ),
            ),

            SizedBox(height: 16),

            // Calories & Labels
            Text(
              'Calories: ${recipe.appcalories.toStringAsFixed(2)} kcal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                ...recipe.dietLabels.map((label) => Chip(label: Text(label))),
                ...recipe.healthLabels.map((label) => Chip(label: Text(label))),
              ],
            ),

            SizedBox(height: 16),

            // Ingredients
            Text(
              'Ingredients:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: recipe.ingredients.length,
              itemBuilder: (context, index) => ListTile(
                leading: Icon(Icons.circle, size: 8),
                title: Text(recipe.ingredients[index]),
              ),
            ),

            SizedBox(height: 16),

            // Recipe URL Button
            if (recipe.appurl.isNotEmpty)
              Center(
                child: ElevatedButton(
                  onPressed: () => _launchURL(recipe.appurl),
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
    } else {
      throw 'Could not launch $url';
    }
  }
}
