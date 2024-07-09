import yaml, json
with open('config/contrast_security.yaml') as f:
    config = yaml.safe_load(f)
    print(json.dumps(config['api']))
