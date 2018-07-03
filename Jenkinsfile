@Library('stevetarver/jenkins-pipe@master') _

containerPipeline([
    // Configure the environment available in the build pipeline
    environment: [
        DOCKER_CI_IMAGE: 'stevetarver/maven-java-ci:3.5.4-jdk-8-alpine-r0',
    ],
    // Configure the build pipeline
    pipeline: [
        dockerGroup: 'stevetarver',
        slackChannel: 'tarver-build',
        slackCredentialId: 'tarver-build-slack-token',
        test: [
            unitTestResults: 'target/surefire-reports/*.xml',
            codeCoverageHtmlDir: 'target/site/clover'
        ],
    ],
    // Identify scripts to run for each stage of the build pipeline
    stageCommands: [
        build: "mvn -Dspring.profiles.active=dev clean compile",
        test: "mvn -Dspring.profiles.active=dev clean clover:setup test clover:aggregate clover:clover",
        package: "./jenkins/scripts/package.sh",
        deploy: "./jenkins/scripts/deploy.sh",
        integrationTest: "./integration-test/run.sh -t integration -e dev.ops",
        prodDeploy: "./jenkins/scripts/prod_deploy.sh",
        prodTest: "./integration-test/run.sh -t integration -e prod.ops"
    ]
])
