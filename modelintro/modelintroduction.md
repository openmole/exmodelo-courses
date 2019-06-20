---
tags: model introduction
title: model introduction
slideOptions:
  theme: 'white'
  transition: 'fade'
 
---
 <style>
    .reveal .slides section {
        font-size: 35px;
        text-align: left;
        color: #666;
    }   
    
    .reveal .slides h2{
        color: #37abc8;
    }
    
    .reveal blockquote {
        margin-top:20px;
        padding: 0 1em;
        color: #999;
        border-left: 0.25em solid #ddd;
        box-shadow:none;
        font-size:35px;
        font-style:normal;
        width:100%;
    }
    
.reveal .slides section img { 
  background: none;
  border: none;
  box-shadow: none;
  display: block;
  margin: 10px auto;
}
    
    .reveal .slides {
         display: block;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
  background: url(https://miniocodimd.openmole.org:443/codimd/uploads/upload_3d8c8d9cf6036122fc2fca8f07dd9ee3.png) no-repeat 100% 100%;
        background-attachment:fixed;
        background-size: 170px auto;
    }
    
  .reveal a {
    top:50px;    
    color: #0c2c85;
    }
    
</style>

[TOC]

# Introducing a model 


general purpose : spatial epidemio model

scenarization

 - pedestrian dynamics


---

```scala
SensitivityMorris(
    evaluation = (model on env by 5000),
    inputs = List(
       humanFollowProbability in (0.0,1.0),
       humanInformedRatio in (0.0,1.0),
       humanInformProbability in (0.0,1.0)
    ),
    outputs = List(totalZombified,halfZombified),
    repetitions = 1000,
    levels = 20
) hook CSVHook(workDirectory / "morris_result.csv")
```




---

```scala
val explo = DirectSampling(
  evaluation = (model hook reshook on env by 500),
  sampling = 
    (humanFollowProbability in (0.0 to 1.0 by 0.1))
    x (humanInformedRatio in (0.0 to 1.0 by 0.1))
    x (humanInformProbability in (0.0 to 1.0 by 0.1))
    x (replication in UniformDistribution[Long](100000) take 100)
 )
 ```


explo




---

```scala
import zombies._

val rng = new scala.util.Random(replication)

val result = zombieInvasion(
   humanFollowProbability = humanFollowProbability,
   humanInformedRatio =humanInformedRatio,
   humanInformProbability = humanInformProbability,
   zombies = 4,
   humans = 250,
   steps = 500,
   random = rng
)   

val humansDynamic = result.humansDynamic(20)
val zombiesDynamic = result.zombiesDynamic(20)
```


---

```scala
val sen = SensitivitySaltelli(
  evaluation = (model on env by 1000),
  samples = 100000,
  inputs = List( 
    humanFollowProbability in (0.0,1.0),
    humanInformedRatio in (0.0,1.0),
    humanInformProbability in (0.0,1.0)
  ),
  outputs = List(totalZombified,halfZombified)
)

sen hook SaltelliHook(sen,workDirectory)
```






