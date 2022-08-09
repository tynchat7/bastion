# Create an Image using Packer

This page contains how to create an Image using Packer for Bastion host.

There are 2 ways to complete this tasks

## A- Using your Bastion host and GCP to create (this will create the image on your GCP)

### Before you begin

1. You will need `google-credentials.json` file generated in your HOME directory to be able to deploy


### Deployment 
Fist you will need to clone the repository 
```
git clone https://github.com/fuchicorp/bastion.git
```

After you have cloned the repo you will need to go to `bastion/packer-scripts` folder 
```
cd bastion/packer-scripts
```

Generate the following environment variables

```
export GOOGLE_APPLICATION_CREDENTIALS=$HOME/google-credentials.json
export GOOGLE_PROJECT_ID=yourgoogleprojectid
```

After you have generated environments variables you should be able to create the image on GCP
```
packer validate script.json 
packer build script.json 
```

To confirm you can login to your GCP >> Compute Engine >> Images

![image](https://user-images.githubusercontent.com/64328755/99853544-c94f7700-2b48-11eb-80e9-7b31648b320c.png)



## B- Using Fuchicorp Jenkins Jobs to create (this will create the image on Fuchicorp GCP)

### Before you begin

1. You will need an access to jenkins.fuchicorp.com

2. go to packer-bastion-build job

3. Find your branch and build the job.

See Picture below for successful Jenkins Build

![image](https://user-images.githubusercontent.com/64328755/99851422-c18dd380-2b44-11eb-8348-89f0c1d946cf.png)
