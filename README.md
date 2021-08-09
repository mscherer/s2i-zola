Source to image docker image used to build static website using zola

Usage
-----

You can add the image to your Openshift cluster like any other.

Configuration
-------------

The image do not need to be configured by default.

However, since zola hardcode the domain name by default using base_url, it need
to be configured in the repository, or pass the variable WEBSITE_URL at build time.

To enable the build of the drafts, the variable DRAFTS must be defined.
