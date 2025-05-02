# Create Certificate using AWS CloudFormation

Allows you to provision both the apex (e.g. domain.com) and wildcard (e.g. \*.domain.com) ACM certificates via CloudFormation, automatically creating DNS validation records and exporting the certificate ARN for use in other scripts or templates.

## Summary of Scripts

A small collection of Bash utilities to streamline ACM certificate provisioning:

- **get-hosted-zone-id.sh**  
  Lookup the Route 53 Hosted Zone ID for a given domain and AWS CLI profile.

- **deploy-certificate.sh**  
  Deploy a DNS‑validated ACM certificate (apex + wildcard) using CloudFormation, tagging resources by application name.

Both scripts verify prerequisites (AWS CLI) and validate all required parameters before executing. Simply pass in your domain, hosted zone, application name and AWS profile to automate certificate issuance end‑to‑end.

## License

MIT License

Copyright (c) 2025 Chris Schuld

Permission is hereby granted, free of charge, to any person obtaining a copy
