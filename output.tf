output "website_url" {
    description = "The URL of the static website"
    value      = aws_s3_bucket_website_configuration.sameep_hosting_bucket_website_configuration.website_endpoint
}