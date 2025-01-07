*** Settings ***
Library    SeleniumLibrary
Library    String
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
    
        # Verify Your Cart Page
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
    Click Button    id:checkout
        # Verify Checkout: Your Information Page
    ${current_url}=   Get Location
    Should Be Equal    ${current_url}    https://www.saucedemo.com/checkout-step-one.html
    Element Should Be Visible    class:header_secondary_container
    Element Should Contain    class:header_secondary_container    Checkout: Your Information

    #Step 4: Proceed to Checkout
    
    Input Text    id:first-name    Linda
    Input Text    id:last-name    Sonna
    Input Text    id:postal-code    11120
    Click Button    id:continue
        # Verify Checkout: Overview Page
    ${current_url}=   Get Location
    Should Be Equal    ${current_url}    https://www.saucedemo.com/checkout-step-two.html    
    Element Should Contain    class:header_secondary_container    Checkout: Overview
    Element Should Contain    data:test:payment-info-label    Payment Information:
    Element Should Contain    data:test:shipping-info-label    Shipping Information:


    # Step 5: Verify Order
        # Verify Order
    Element Should Contain    class:cart_list    T-Shirt    
    Element Should Contain    class:cart_list    T-Shirt (Red)   

        # Verify Tax and Total Price
    ${price_text}=   Get Text    data:test:subtotal-label
    ${price}=    Convert Price To Float    ${price_text}
    ${tax}=    Calculate Tax    ${price}
    ${total}=    Calculate Total    ${price}    ${tax}
    ${expected_text}=    Set Expected Text    ${total}
    ${total_tent}=    Get Text    data:test:total-label
    Should Be Equal As Strings    ${expected_text}    ${total_tent}

    # Step 6: Confirm Order
    
    Click Button    id:finish
        # Verify Checkout: Complete! Page
    ${current_url}=   Get Location
    Should Be Equal    ${current_url}    https://www.saucedemo.com/checkout-complete.html
    Element Should Contain    data:test:title    Checkout: Complete!
    Element Should Be Visible    data:test:checkout-complete-container
    Element Should Contain    data:test:complete-header    Thank you for your order!


*** Keywords ***
Verify Page
    [Arguments]    ${current_url}
    ${current_url}=   Get Location
    Should Be Equal    ${current_url}    https://www.saucedemo.com/inventory.html


Convert Price To Float
    [Arguments]    ${price_text}
    ${price}=      Remove String    ${price_text}    Item total: $
    ${price}=      Convert To Number    ${price}
    RETURN    ${price}

Calculate Tax
    [Arguments]    ${price}
    ${tax}=    Evaluate    round(${price} * ${TAX_RATE},2)
    RETURN    ${tax}

Calculate Total
    [Arguments]    ${price}    ${tax}
    ${total}=    Evaluate    ${price} + ${tax}
    RETURN    ${total}

Set Expected Text
    [Arguments]    ${total}
    ${expected_text}=    Set Variable    Total: $${total}
    RETURN    ${expected_text}