sam package --template-file template.yaml --output-template-file packaged-template.yaml --s3-bucket shuffle-lunch-deployment
sam deploy --template-file packaged-template.yaml --stack-name shuffleLunchDynamo --capabilities CAPABILITY_IAM
