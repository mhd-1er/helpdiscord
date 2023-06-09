import ballerina/http;

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    # A resource for generating greetings
    # + name - the input string name
    # + return - string name with hello message or error
    resource function get greeting(string name) returns string|error {
        // Send a response back to the caller.
        if name is "" {
            return error("name should not be empty!");
        }
        return "Hello, " + name;
    }
}
configurable string hrEndpoint = https://samples.choreoapps.dev/company/hr;
type Request record {|
int[] employeeIds;
|};

type Employees record {|
json[] employeeDetails;
|};
import ballerina/http;

// Define configurable variables, including the HR endpoint
configurable string hrEndpoint = ?;

type Request record {|
    int[] employeeIds;
|};

type Employees record {|
    json[] employeeDetails;
|};

service / on new http:Listener(9090) {
    // Define your resource functions here
    resource function post employees(@http:Payload Request payload) returns Employees|error? {
        http:Client locationEP = check new (hrEndpoint);
        int[] idList = payload.employeeIds;
        json[] employeInfoList = [];
        foreach int id in idList {
            json empResponseJson = check locationEP->get(string `/employee/${id}`);
            employeInfoList.push(empResponseJson);
        }
        Employees aggregatedResponse = {employeeDetails: employeInfoList};
        return aggregatedResponse;
    }
}
