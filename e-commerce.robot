*** Settings ***
Documentation     Automação de compra completa em e‑commerce
Library           SeleniumLibrary
Suite Setup       Abrir navegador e acessar e-commerce
Suite Teardown    Close Browser

*** Variables ***
${BROWSER}              Chrome
${LOJA_URL}             https://magento.softwaretestingboard.com/
${NOME_PRODUTO}         Affirm Water Bottle
${TIMEOUT}              30s
${CAMPO_BUSCA}          id=search
${PRODUTO}              xpath=//div[contains(@class,"product-item-details")]//a[@class="product-item-link" and normalize-space(.)="${NOME_PRODUTO}"]
${ADICIONAR_CARRINHO}   xpath=//button[@type="submit" and contains(normalize-space(.), "Add to Cart")]
${TEXTO_ADICIONADO}     xpath=//button[@type="submit" and contains(normalize-space(.), "Added")]
${BOTAO_CARRINHO}       xpath=//a[contains(@class,"action") and contains(@class,"showcart")]
${BOTAO_CHECKOUT}       id=top-cart-btn-checkout
${HEADER_SHIPPING}      id=shipping
${BOTAO_AVANÇAR}        xpath=//button[@data-role="opc-continue" and @type="submit" and .//span[normalize-space(text())="Next"]]
${SUMARIO_PEDIDO}       xpath=//span[@class="title" and normalize-space(text())="Order Summary"]
${VALOR_FINAL}          xpath=//span[@class="price" and @data-bind="text: getValue()"]
${FINALIZAR_COMPRA}     xpath=//button[@type="submit" and contains(normalize-space(.), "Place Order")]
${MENSAGEM_SUCESSO}     xpath=//span[@class="base" and normalize-space(text())="Thank you for your purchase!"]

*** Keywords ***
Abrir navegador e acessar e-commerce
    [Documentation]    Abre o navegador e vai para a home do e‑commerce
    Open Browser    ${LOJA_URL}    ${BROWSER}
    Maximize Browser Window
    Capture Page Screenshot
    Set Selenium Timeout    ${TIMEOUT}

Procurar pelo produto
    [Documentation]    Busca o produto pelo nome
    Wait Until Element Is Visible   ${CAMPO_BUSCA}    ${TIMEOUT}
    Input Text    ${CAMPO_BUSCA}    ${NOME_PRODUTO}
    Press Keys    ${CAMPO_BUSCA}    ENTER
    Wait Until Page Contains Element    ${PRODUTO}    ${TIMEOUT}

Adicionar produto ao carrinho
    [Documentation]    Seleciona o produto e adiciona ao carrinho
    Scroll Element Into View        ${PRODUTO}
    Capture Page Screenshot
    Click Element                   ${PRODUTO}
    Click Button                    ${ADICIONAR_CARRINHO}
    Wait Until Element Is Visible   ${TEXTO_ADICIONADO}    ${TIMEOUT}
    Capture Page Screenshot

Ir para o checkout
    [Documentation]    Vai para a página de checkout
    Sleep   2s
    Click Element                       ${BOTAO_CARRINHO}
    Wait Until Page Contains Element    ${BOTAO_CHECKOUT}    ${TIMEOUT}
    Capture Page Screenshot
    Click Element                       ${BOTAO_CHECKOUT}

Preencher informações do Checkout
    [Documentation]    Preenche dados de compra (exemplo genérico)
    Wait Until Element Is Visible    ${HEADER_SHIPPING}
    Wait Until Element Is Visible  id=customer-email
    Sleep   3s
    Capture Page Screenshot
    Input Text    id=customer-email  automacaoecommerce@teste.teste.br
    Input Text    name=firstname        Vladmir
    Input Text    name=lastname         Prates
    Input Text    name=street[0]        Rua Exemplo, 123
    Input Text    name=city             São Paulo
    Input Text    name=postcode         01000-000
    Select From List By Value           name=country_id    BR
    Select From List By Value           name=region_id     508
    Input Text    name=telephone        11999990000
    Select Radio Button     ko_unique_1     flatrate_flatrate
    Click Element   ${BOTAO_AVANÇAR}
    Wait Until Element Is Visible   ${SUMARIO_PEDIDO}

Finalizar Compra
    Wait Until Element Is Visible   ${VALOR_FINAL}
    Sleep   5s
    Capture Page Screenshot
    Element Text Should Be  ${VALOR_FINAL}    $12.00
    Click Element   ${FINALIZAR_COMPRA}

Validar Sucesso da Compra
    [Documentation]    Verifica confirmação de sucesso
    Wait Until Element Is Visible   ${MENSAGEM_SUCESSO}
    Element Should Contain    ${MENSAGEM_SUCESSO}    Thank you for your purchase!
    Capture Page Screenshot

*** Test Cases ***
Fluxo Completo De Compra
    [Tags]    Compra    E2E
    Procurar pelo produto
    Adicionar produto ao carrinho
    Ir para o checkout
    Preencher informações do Checkout
    Finalizar Compra
    Validar Sucesso da Compra
