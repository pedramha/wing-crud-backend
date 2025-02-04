  exports.Platform = class TFBackend {
    postSynth(config) {
      config.terraform.backend = {
        s3: {
          bucket: process.env.TF_BACKEND_BUCKET,          
          region: process.env.TF_BACKEND_REGION,          
          key: "state/terraform.tfstate",
          dynamodb_table: process.env.TF_BACKEND_TABLE    
        }
      };
      return config;
    }
  }