# Creating a Static Local Copy of your Deployment
Sometimes you want to show a local copy of your Cloud Foundry deployment, without maintaining a connection to your deployed Scope server. This is easy to do with the Scope debugging menu.
## Prerequisites
A running Scope server that you wish to display locally  
Docker  
## Procedure
1. Connect to your running Scope server.  

2. Click the Troubleshooting menu in the bottom right of your Scope window:  
<img src="https://github.com/bendalby82/weave-scope-release/blob/master/docs/images/debug-menu.png" />  

3. Select JSON download from the window that appears:  
<img src="https://github.com/bendalby82/weave-scope-release/blob/master/docs/images/debugging-options.png" width="400px"/>  

4. Run the following Docker command from the directory where you downloaded your JSON file to:  

    ```
    docker run --rm -v $PWD/report.json:/tmp/report.json -p 4040:4040 weaveworks/scope:latest_release \
    --mode=app --weave=false --app-only --app.collector=file:///tmp/report.json
    ```

5. Weave Scope should now be available on [http://localhost:4040](http://localhost:4040), displaying your JSON data file.
