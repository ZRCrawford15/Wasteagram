// Citation
// Author: OSU CS492 Mobile Development Module 10 "Testing and Debugging"
// 03/13/2022
// Source code - Automated testing
// https://canvas.oregonstate.edu/courses/1850133/pages/exploration-testing-and-debugging?module_item_id=21730733

import 'package:flutter_test/flutter_test.dart';
import 'package:test/models/post.dart';

void main() {
  test('Post created from values', () {
    final date = DateTime.parse('2022-13-03');
    final url = "Test URL";
    final quantity = 5;
    final latitude = '24.0';
    final longitude = '22.5';

    final food_post = Post(dateTime: date, lattitude: latitude, longitude: longitude, itemCount: quantity, image: url);

    expect(food_post.getDateTime, date);
    expect(food_post.getImage, url);
    expect(food_post.getNumItems, quantity);
    expect(food_post.lattitude, latitude);
    expect(food_post.longitude, longitude);
    });


}
