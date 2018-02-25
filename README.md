[![Build Status](https://img.shields.io/circleci/project/cptactionhank/docker-atlassian-bamboo.svg)](https://circleci.com/gh/cptactionhank/docker-atlassian-bamboo) [![Open Issues](https://img.shields.io/github/issues/cptactionhank/docker-atlassian-bamboo.svg)](https://github.com/cptactionhank/docker-atlassian-bamboo/issues) [![Stars on GitHub](https://img.shields.io/github/stars/cptactionhank/docker-atlassian-bamboo.svg)](https://github.com/cptactionhank/docker-atlassian-bamboo/stargazers) [![Forks on GitHub](https://img.shields.io/github/forks/cptactionhank/docker-atlassian-bamboo.svg)](https://github.com/cptactionhank/docker-atlassian-bamboo/network) [![Stars on Docker Hub](https://img.shields.io/docker/stars/cptactionhank/atlassian-bamboo.svg)](https://hub.docker.com/r/cptactionhank/atlassian-bamboo/) [![Pulls on Docker Hub](https://img.shields.io/docker/pulls/cptactionhank/atlassian-bamboo.svg)](https://hub.docker.com/r/cptactionhank/atlassian-bamboo/) [![Sponsor by PayPal](https://img.shields.io/badge/sponsor-PayPal-blue.svg)](https://paypal.me/cptactionhank/5)

# Atlassian Bamboo in a Docker container

This is a containerized installation of Atlassian Bamboo with Docker, and it's a match made in heaven for us all to enjoy. The aim of this image is to keep the image as vanilla as possible, only with a few Docker related twists. You can get started by clicking the appropriate link below and reading the documentation.

* [Atlassian JIRA Core](https://cptactionhank.github.io/docker-atlassian-jira)
* [Atlassian JIRA Software](https://cptactionhank.github.io/docker-atlassian-jira-software)
* [Atlassian JIRA Service Desk](https://cptactionhank.github.io/docker-atlassian-service-desk)
* [Atlassian Confluence](https://cptactionhank.github.io/docker-atlassian-confluence)
* [Atlassian Bamboo](https://github.com/cptactionhank/docker-atlassian-bamboo)
* [Atlassian Bitbucket Server](https://cptactionhank.github.io/docker-atlassian-bitbucket)

If you want to help out, you can check out the contribution section further down.

## I'm in the fast lane! Get me started

To quickly get started running a Bamboo instance, use the following command:
```bash
docker run --detach --publish 8085:8085 cptactionhank/atlassian-bamboo:latest
```

Then simply navigate to [`http://localhost:8085`](http://localhost:8085) and finish the installation.

## Configuration

You can configure a small set of things by supplying the following environment variables

| Environment Variable   | Description |
| ---------------------- | ----------- |
| X_PROXY_NAME           | Sets the Tomcat Connectors `ProxyName` attribute |
| X_PROXY_PORT           | Sets the Tomcat Connectors `ProxyPort` attribute |
| X_PROXY_SCHEME         | If set to `https` the Tomcat Connectors `secure=true` and `redirectPort` equal to `X_PROXY_PORT`   |
| X_PATH                 | Sets the Tomcat connectors `path` attribute |

## Contributions

This image has been created with the best intentions and an expert understanding of Docker, but it should not be expected to be flawless. Should you be in the position to do so, I request that you help support this repository with best-practices and other additions.

CircleCI has been configured to build the `Dockerfile` and run acceptance tests on the Atlassian Bamboo image to ensure it is working. Additionally it been configured to automatically deploy new version branches upon successfully building a new version of Atlassian Bamboo in the `master` branch and serves as the base.

If you see out of date documentation, lack of tests, etc., you can help out by either
- creating an issue and opening a discussion, or
- sending a pull request with modifications (Remember to read [contributing guide](CONTRIBUTING.md) before)

Continuous Integration and Continuous Delivery is made possible with the great services from [GitHub](https://github.com) and [CircleCI](https://circleci.com/) written in [Ruby](https://www.ruby-lang.org/), using [RSpec](http://rspec.info/), [Capybara](https://github.com/teamcapybara/capybara/), and [PhantomJS](http://phantomjs.org/) frameworks.

## Donations

Thank you for wanting to help support this repository by supporting me and my supply of hair cuts, tea and coffee, among others.

__Bitcoin:__ `1CT2J3kT1kmj9Z6f4SEvvL3oAkNFQwD5kQ`

__Ethereum:__ `0x82305dcE146b2aCaDA0d63235b84c187A5A23c36`

__Doge:__ `DDKU3SHDu7BcR1P7n5qXGwb8SviiCG5gFX`
