# Master - Workers Demo Using Zookeeper

## Active/Standby Master Server

### Checkout tag: `active-stand-by--master-nodes`

### What does it demonstrate?

Demonstrates how Zookeeper is used to coordinate the switch from active master to standby master process, when the active process
stops working.

### Configuration

The [config](/config/app.yml) file needs to have the list of Zookeeper servers your application nodes will connect to. Currently:

``` yaml
zookeeper:
  servers:
    - 127.0.0.1:2181
    - 127.0.0.1:2182
    - 127.0.0.1:2183
```

it assumes 3 Zookeeper servers running locally.  

### Usage

#### Configure and Start your Zookeeper Servers

This is not explained here. But you can read this [blog post here](https://www.simplybusiness.co.uk/about-us/tech/2017/08/introduction-to-zookeeper/) 
to learn how to configure running 3 Zookeeper servers on your local machine.

#### Start `active` Master Process

Start a master node. It will start in `active` mode.

``` bash
$ bundle exec ruby master.rb
I am active master
I am active master
... 
```

### Start `standby` Master Process

Start another master process. It will start in `standby` mode.

``` bash
$ bundle exec ruby master.rb
I am standby master
I am standby master
...
```

### Stop `active` Master Process

You will see the `standby` master process switching to be the `active` one.

``` bash
...
I am standby master
I am standby master
I am active master
I am active master
I am active master
...
```

## Explanation

A long explanation about how this one works, can be found [here]().


