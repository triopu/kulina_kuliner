# Kuliner

Flutter Engineer Preliminary Test - Kulina

Product List Screen
- Date Picker
    - Date Picker displays the current week until 8th week.
    - Displayed week can be changed by sliding or clicking on the arrow button
    - Saturdays and Sundays are disabled.
    - Pinned when scrolled
- Product List
    - The list must be lazy loaded
    - Add product to cart by clicking “Tambah ke keranjang”
    - Quantity can be edited after product added to cart
    - Changing quantity to 0 removes product from cart
    - Cart button displayed if there is an item in cart
- Cart Button
    - Total item & price displayed changes according to cart content
    - Clicking the button will navigate to Cart Screen

<p align="center">
  <img src="https://github.com/triopu/kulina_kuliner/blob/main/assets/images/preview.png" alt="drawing" width="550"/>
</p>

Cart Screen
- Cart Item List
    - List is order by item date, then by product id
    - Item quantity can be edited (minimum 1)
    - Changing quantity here also changes quantity in Product List screen
    - Clicking trash icon removes the item from cart
    - Clicking “Hapus Pesanan” will empty the cart and showing the empty screen
    - Use any image for empty screen
- Checkout Button
    - Total item & price displayed changes according to cart content
    - Clicking the button will navigate back to Product List Screen