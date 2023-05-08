trigger ValidateInsuranceCoverage on Bajaj_Allianz_Group_Sampoorna_Jeevan_Suraksha__c(before insert){
    //Create maps to store the min and max values
    Map<String, Integer> minSumAssuredMap = new Map<String, Integer>{
        '50K' => 50000,
        '1Lac' => 100000,
        '1.5Lac' => 150000,
        '2Lac' => 200000
    };
    Map<String, Integer> maxSumAssuredMap = new Map<String, Integer>{
        '50K' => 50000,
        '1Lac' => 100000,
        '1.5Lac' => 150000,
        '2Lac' => 200000
    };
    Map<String, Integer> minAgeMap = new Map<String, Integer>{
        '12' => 12,
        '15' => 15,
        '18' => 18,
        '24' => 24
    };
    Map<String, Integer> maxAgeMap = new Map<String, Integer>{
        '12' => 12,
        '15' => 15,
        '18' => 18,
        '24' => 24
    };
    //Iterate through the trigger records
    for (Bajaj_Allianz_Group_Sampoorna_Jeevan_Suraksha__c bajaj : Trigger.new) {
        //Check if the annual income is less than 40K
        if(bajaj.Annual_Income__c < 40000){
            bajaj.addError('Income should be greater than 40K to get the insurance coverage');
            continue;
        }
        //Check if the sum assured is between the min and max values
        if(!minSumAssuredMap.containsKey(bajaj.Sum_Assured__c) || !maxSumAssuredMap.containsKey(bajaj.Sum_Assured__c) || bajaj.Sum_Assured_Amount__c < minSumAssuredMap.get(bajaj.Sum_Assured__c) || bajaj.Sum_Assured_Amount__c > maxSumAssuredMap.get(bajaj.Sum_Assured__c)){
            bajaj.addError('Sum assured should be in the range of 50K, 1Lac, 1.5Lac, and 2Lac');
            continue;
        }
        //Check if the age of the member is between the min and max values
        if(!minAgeMap.containsKey(bajaj.Policy_Tenure__c) || !maxAgeMap.containsKey(bajaj.Policy_Tenure__c) || bajaj.Age__c < minAgeMap.get(bajaj.Policy_Tenure__c) || bajaj.Age__c > maxAgeMap.get(bajaj.Policy_Tenure__c)){
            bajaj.addError('Age should be between 12, 15, 18 and 24 years');
            continue;
        }
        //Check if the OTP authentication is received from the Bandhan Bank sales personnel
        if(bajaj.OTP_Authentication__c == null){
            bajaj.addError('OTP authentication not received from the Bandhan Bank sales personnel');
            continue;
        }
        //Check if the spouse will also not receive coverage
        if(bajaj.Spouse_Name__c != null && bajaj.Eligible_for_Insurance_Coverage__c == false){
            bajaj.addError('Spouse will also not receive coverage');
        }
    }
}