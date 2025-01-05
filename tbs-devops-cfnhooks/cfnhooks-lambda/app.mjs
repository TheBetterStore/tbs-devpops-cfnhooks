export const handler = async (event, context) => {
  var targetModel = event?.requestData?.targetModel;
  var targetName = event?.requestData?.targetName;

  var response = {
    "hookStatus": "SUCCESS",
    "message": "Lambda is correctly configured.",
    "clientRequestToken": event.clientRequestToken
  };

  if (targetName == "AWS::Lambda::Function") {
    let concurrency = targetModel?.resourceProperties?.ReservedConcurrentExecutions;

    let errorMessage = ""
    if (!concurrency) {
      errorMessage += "ReservedConcurrentExecutions must be present.\n "
    }

    if(errorMessage) {
      response.hookStatus = "FAILED";
      response.errorCode = "NonCompliant";
      response.message = errorMessage;
    }
  }
  return response;
};
  