*** setting ***
Library    SeleniumLibrary
Test Setup    Open Browser    ${URL}    ${BROWSER}
test Teerdown    Close Browser   

*** variable ***
${URL}    https://www.saucedemo.com/
${BROWSER}    chrome

*** test case ***
login
    Input Username    standard_user
    Input Password    secret_sauce
    Click Botton    xpath://*[@id="login-button"]
    Element Should Contain    xpath://*[@id="header_container"]/div[2]/span    Products