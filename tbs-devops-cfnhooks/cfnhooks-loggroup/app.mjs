export const handler = async (event, context) => {
  var targetModel = event?.requestData?.targetModel;
  var targetName = event?.requestData?.targetName;

  var response = {
    "hookStatus": "SUCCESS",
    "message": "LogGroup is correctly configured.",
    "clientRequestToken": event.clientRequestToken
  };

  if (targetName == "AWS::Logs::LogGroup") {
    let retentionInDays = targetModel?.resourceProperties?.RetentionInDays;
    let kmsKeyId = targetModel?.resourceProperties?.KmsKeyId;

    let errorMessage = ""
    if (!retentionInDays) {
      errorMessage += "LogGroup RetentionInDays must be present.\n "
    }
    if (!kmsKeyId) {
      errorMessage += "LogGroup KmsKeyId must be present.\n "
    }

    if(errorMessage) {
      response.hookStatus = "FAILED";
      response.errorCode = "NonCompliant";
      response.message = errorMessage;
    }
  }
  return response;
};
  