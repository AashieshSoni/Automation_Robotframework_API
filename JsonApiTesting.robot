*** Settings ***
Library       OperatingSystem
Library       RequestsLibrary
Library       JSONLibrary
Library       String
Library       Collections
Library       BuiltIn
Library       json


*** Variables ***
${API_URL}                  https://reqres.in/api/users
${EXPECTED_JSON_FILE}       resources/libs/RestAPI.json

*** Keywords ***
Read JSON Data
    ${file_contents}         Get File  ${EXPECTED_JSON_FILE}
    ${json_data}             Evaluate  json.loads('''${file_contents}''')
    [Return]                 ${json_data}

Send GET Request
    [Arguments]  ${test_data}
    ${relative_url}           Set Variable  ${test_data["TEST_DATA"]["RELATIVE_URL"]}
    ${response_expected_status}  Set Variable  ${test_data["TEST_DATA"]["RESPONSE_EXPECTED_STATUS"]}
    ${response_expected_startwith}  Set Variable  ${test_data["TEST_DATA"]["RESPONSE_EXPECTED_STARTWITH"]}

    ${headers}               Create Dictionary  Content-Type=application/json
    Create Session          api_session  ${API_URL}
    ${response}             Get On Session  api_session
    ...                     ${relative_url}
    ...                     headers=${headers}
    ...                     verify=${False}

    Log  Response Status: ${response.status_code}

    Should Be Equal As Strings  ${response.status_code}  ${response_expected_status}

    ${response_text}        Set Variable  ${response.text}
    ${response_dict}        Evaluate  json.loads('''${response_text}''')

    Dictionary Should Contain Key  ${response_dict}  ${response_expected_startwith}

    [Teardown]               Delete All Sessions

Send POST Request
    [Arguments]  ${test_data}
    ${relative_url}           Set Variable  ${test_data["TEST_DATA"]["RELATIVE_URL"]}
    ${request_body}           Set Variable  ${test_data["TEST_DATA"]["REQUEST_BODY"]}
    ${response_expected_status}  Set Variable  ${test_data["TEST_DATA"]["RESPONSE_EXPECTED_STATUS"]}
    ${response_expected_startwith}  Set Variable  ${test_data["TEST_DATA"]["RESPONSE_EXPECTED_STARTWITH"]}

 

*** Test Cases ***
Validate API Responses
    ${api_responses}  Read JSON Data
    FOR  ${test_data}  IN  @{\}
        Intialise Variables
        Run Keyword If  '${test_data["TEST_DATA"]["REQUEST_TYPE"]}' == 'GET'
        ...              Send GET Request  ${test_data}
        ...              ELSE IF  '${test_data["TEST_DATA"]["REQUEST_TYPE"]}' == 'POST'
        ...              Send POST Request  ${test_data}
        ...              ELSE IF  '${test_data["TEST_DATA"]["REQUEST_TYPE"]}' == 'PUT'
        ...              Send PUT Request  ${test_data}
        ...              ELSE IF  '${test_data["TEST_DATA"]["REQUEST_TYPE"]}' == 'DELETE'
        ...              Send DELETE Request  ${test_data}
        ...              ELSE IF  '${test_data["TEST_DATA"]["REQUEST_TYPE"]}' == 'ANY'
        ...              Send ANY Request  ${test_data}
		Log to Console       ${test_data}
	END

	
	
	
'''
*** Settings ***
Library             JSONLibrary

*** Keywords ***
&{baseURL}=         this is a url
${offer}=           /offer
${URL}=             Catenate                  This is a url                                     ${appID}               /offer
log to console      ${URL}
Create Session      httpbin                   this is a url
${fullrequest}      Load Json From File       file_name=${EXECDIR}/path/to/myjsonToPost.json
# This method, without Library JSONLibrary
# ${fullrequestJson}     evaluate             json.dumps(${fullrequest})    json
# Or this one, with JSONLibrary
${fullrequestJson}      Convert String To Json    ${fullrequest}
${resp}             Post  


Post Request Create Digital Offer
    Create Session          httpbin              this is a url
    &{affordability}=       Create Dictionary    grossIncome=${60000}     netIncome=${30000}      capitalRequired=${25000}       groceries=${500}        utilities=${400}     savings=${300}     services=${200}     transport=${100}     support=${100}      housing=${500}     other=${100}
    &{employment}=          Create Dictionary    sector=CentralGovernmentSocial         status=Contract        startDate=2019-08-01           endDate=2025-08-01
    &{declarations}=        Create Dictionary    debtLiability=None      pendingRetrenchment=false      knownMedicalCondition=false
    &{fullrequest}=         Create Dictionary    affordability=${affordability}      employment=${employment}       declarations=${declarations}     bank=ABSA
    ${CreateOffer_response}=       Post         this is a url/${appID}/offer          json=${fullrequest}
    Should Be Equal As Strings  ${CreateOffer_response.status_code}     201
'''