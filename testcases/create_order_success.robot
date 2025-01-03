*** Settings ***
Library    SeleniumLibrary
Test Setup    Open Browser    ${URL}    ${BROWSER}
#Test Teardown    Close Browser   

*** Variables ***
${URL}    https://www.saucedemo.com/
${BROWSER}    chrome
${TAX_RATE}    0.08

*** Test Cases ***
Create Order Success
    # step 1: Login

    Input Text    id:user-name    standard_user
    Input Text    id:password    secret_sauce
    Click Button    id:login-button
    ${current_url}=   Get Location
    Should Be Equal    ${current_url}    https://www.saucedemo.com/inventory.html        
    Element Should Be Visible    class:app_logo
    Element Should Contain    class:app_logo    Swag Labs
    Element Should Contain    xpath://*[@id="header_container"]/div[2]/span    Products
    
    # step 2: Search and Add item to Cart

        # Add item: Backpack
    Element Should Contain    id:inventory_container    Backpack
    Click Button    id:add-to-cart-sauce-labs-backpack
        # Add item: T-Shirt
    Element Should Contain    id:inventory_container    T-Shirt
    Click Button    id:add-to-cart-sauce-labs-bolt-t-shirt
    Click Button    id:add-to-cart-test.allthethings()-t-shirt-(red)
        # Add item: Flashlight (Verify that there is no product named Flashlight.)
    Element Should Not Contain    id:inventory_container    flashlight

    # Step 3: Verify Item in Cart
    
    Click Element    class:shopping_cart_link
    ${current_url}=   Get Location
    Should Be Equal    ${current_url}    https://www.saucedemo.com/cart.html
    ############Element Should Be Visible    class:app_logo
    Element Should Be Visible    class:header_secondary_container
    Element Should Contain    class:header_secondary_container    Your Cart
        # Verify Item in Cart
    Element Should Contain    class:cart_list    Backpack    
    Element Should Contain    class:cart_list    T-Shirt    
    Element Should Contain    class:cart_list    T-Shirt (Red)
        # Remove Backpack item in Cart
    Click Button    id:remove-sauce-labs-backpack
        # Verify Item in Cart
    Element Should Not Contain    class:cart_list    Backpack
    Element Should Contain    class:cart_list    T-Shirt    
    Element Should Contain    class:cart_list    T-Shirt (Red)
        # Click Checkout
    Click Button    id:checkout
    ${current_url}=   Get Location
    Should Be Equal    ${current_url}    https://www.saucedemo.com/checkout-step-one.html
    Element Should Be Visible    class:header_secondary_container
    Element Should Contain    class:header_secondary_container    Checkout: Your Information

    
    #Step 4: Proceed to Checkout
    
    Input Text    id:first-name    Linda
    Input Text    id:last-name    Sonna
    Input Text    id:postal-code    11120
    Click Button    id:continue
    ${current_url}=   Get Location
    Should Be Equal    ${current_url}    https://www.saucedemo.com/checkout-step-two.html    
    Element Should Contain    class:header_secondary_container    Checkout: Overview


    # Step 5: Verify Order
    
    Element Should Contain    class:cart_list    T-Shirt    
    Element Should Contain    class:cart_list    T-Shirt (Red)   
    Element Should Contain    data:test:payment-info-label    Payment Information:
    Element Should Contain    data:test:shipping-info-label    Shipping Information:
        # Verify Tax and Total Price
    ${price_text}=   Get Text    data:test:subtotal-label
    
         


    # Step 6: Confirm Order



