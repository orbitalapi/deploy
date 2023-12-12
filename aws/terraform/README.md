This terraform configures a full Orbital deployment on AWS, using ECS / Fargate.

### Important!
This script will create a public-facing Orbital instance. You should modify this script to manage the visibility.

It provisions the following:
 * A dedicated VPC for Orbital, with two subnets across two AZ's
 * An ECS Fargate task running Orbital
 * An RDF Instance, which Orbital can connect to
 * Logs written out to CloudWatch
 * HTTPS over SSL:
   * A Route53 DNS entry
   * HTTPS certificate and loadbalancer instance with SSL termination from 443 to 9022
   

The following application config is applied:
 * Workspaces are fetched from a Git repository [TODO]

The following are not provisioned:
 * There's no auth
 * Requests are handled by Orbital directly (vs offloaded to Lambdas)
 * There's no stream server provisioned (so persistent streams aren't enabled)

## Running

Copy `locals.tfvars.examples` and configure with any variables you wish to tweak.

Then:

```bash
export AWS_SECRET_ACCESS_KEY=xxx
export AWS_ACCESS_KEY_ID=xxx
terraform apply --var-file="locals.tfvars"

```