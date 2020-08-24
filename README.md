# Introduction
This Terraform module creates a static website in Google Cloud. It utilizes a bucket to store the static content, and
exposes the bucket contents to the web utilizing a HTTPS load balancer. In addition, it creates an SSL certificate
and attaches it to the load balancer.

# Variables

|`variable`|Required?|Type|Default|Description|
|:-------- |:-------:|:---:|:-----:|:----------|
|`project_id`|Yes|string|(none)|Google Cloud project ID to deploy static website|
|`base_id`|Yes|string|(none)|String used to generate Google Cloud IDs|
|`base_name`|Yes|string|(none)|Human readable name|
|`fqdns`|Yes|list(strings)|(none)|A list of FQDN string(s) that will be the used when generating the SSL certificate| 
|`bucket_add_uuid`|No|bool|`true`|Bucket names have to be globally unique. Setting `bucket_add_uuid` to `true` will append a UUID to the bucket name to ensure uniqueness|
|`bucket_location`|No|string|"US"|Location(s) of where to create the bucket, [GCS Locations](https://cloud.google.com/storage/docs/locations).|
|`bucket_versioning`|No|bool|`true`|Enable [object versioning](https://cloud.google.com/storage/docs/object-versioning)|
|`main_page_suffix`|No|string|`index.html`|`main_page_suffix` applies to each subdirectory of the bucket, and is the default page to GET|
|`not_found_page`|No|string|`404.html`|Location of the not found page.|
