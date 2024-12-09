---
tags: exmodelo24, exmodelo, replications, exploration
title: ExModelo 2024 - Model exploration in OpenMOLE
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
    
    .reveal a {
    color: #0c2c85;
    }
    
.reveal .slides section img { 
  background: none;
  border: none;
  box-shadow: none;
  display: block;
  margin: 10px auto;
    max-width:100%;
    max-height:100%;
}
    
    .reveal .slides {
         display: block;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
  background: url(https://miniocodimd.openmole.org:443/codimd/uploads/upload_3d8c8d9cf6036122fc2fca8f07dd9ee3.png) no-repeat 100% 100%;
        background-attachment:fixed;
        background-size: 170px auto;
    }
    
</style>


# Model embedding and first explorations

Hands-on simple experiments in OpenMOLE:
 - run a model
 - Monte Carlo replications
 - parameter space sampling

$\rightarrow$ on the Zombie model described before

*Get the TP materials directly in OpenMOLE from the tgz link given in the chat ([this link](https://nextcloud.openmole.org/s/cwjr9Dsx8zsaH5G/download))*

---

## Embed and run the model

:::info
 - Plug the model jar as an OpenMOLE plugin: `zombies-bundle_3-0.1.0-SNAPSHOT.jar` -> "plug"
 - In script 1_run.oms: scala code to run the model
:::

```scala
  val rng = Random(seed)

  val result = zombieInvasion(    
    zombies = 4,
    humans = 250,
    steps = 500,
    random = rng,
    humanFollowProbability = 1.0,
    humanInformedRatio = 0.5,
    humanInformProbability = 0.5 
  )

val zombiesDynamic = result.zombiesDynamic(20)
val rescuedDynamic = result.rescuedDynamic(20)
```

---

## Setting up the ScalaTask

Configuration for input/outputs and model embedding as plugin:

```scala
set (
  inputs += (seed),
  outputs += (rescuedDynamic, zombiesDynamic),
  plugins += pluginsOf[zombies.agent.Agent]  
)
```

Execute the task and get results in a hook:

```scala
zombieModel hook (workDirectory / "dynamic.csv")
```

---

## Monte Carlo replications 

For **default values** of parameters, **replication** experiments to study the variability of outputs due to stochastic noise.
 

$\implies$ only the random seed varies (initialisation of the pseudo random generator)
$\implies$ `seed` is mapped as an **input** of the ScalaTask 

:::info
Open the script file `2_repli.oms`
:::



---

## Aggregation

Aggregated descriptor to describe the underlying statistical distribution: for example average or median

```scala
Replication(
  evaluation = (zombieModel hook (workDirectory / "results" / "replications.csv")),
  seed = seed,
  sample = 20,
  aggregation = Seq(
      totalZombified evaluate "totalZombified.median" as zombifiedMed,
      totalZombified evaluate "totalZombified.average" as zombifiedAvg
    )
) hook (workDirectory / "results" / "aggregated.csv")
```


---

## Convergence of estimations

![](https://miniocodimd.openmole.org/codimd/uploads/upload_6c4acca922b1310398eebcd703fde7d4.png)


---

## Output densities

![](https://miniocodimd.openmole.org:443/codimd/uploads/upload_e842bc3e1876691851a3a56d6b128731.png)

---

## Design of Experiments

___


*Interactive model exploration by hand and the need for preliminary experiments*

 $\rightarrow$ The Design of Experiments (DOE) as the definition of computational experiments to extract information from the simulation model
 
**Examples:** DOE for statistics; NetLogo behavior space: basic grid DOE; Sensitivity analysis as an advanced DOE; $\ldots$

**Remarks:**
 - terminology strongly depends on disciplines and practices
 - most are preliminary explorations before more specific experiments


---

## Basic experiments

Provide **explicitly sampling points** on which the model (or its replications) will be run: notion of **direct sampling** in OpenMOLE (corresponds to DOE in the literature)

 $\rightarrow$ full samplings
 $\rightarrow$ elaborated sampling for high dimensions given a low computational budget (the curse of dimensionality)



---

## OpenMOLE syntax

Syntax of the direct sampling method in OpenMOLE:

```scala

DirectSampling(
  evaluation = Replication(
      evaluation = (zombieModel on LocalEnvironment(8)),
      seed = seed,
      sample = 100
    ),
  sampling =
   (humanFollowProbability in (0.0 to 1.0 by 0.2)) x
   (humanInformedRatio in (0.0 to 1.0 by 0.2)) x
   (humanInformProbability in (0.0 to 1.0 by 0.2))
) hook (workDirectory / "results" / "exploration.csv")
```

Different DOEs can be specified for the `sampling` argument with OpenMOLE sampling functions: *One factor at a time, grid sampling, high-dimensional samplings*

:::info
Open the script file `3_sampling.oms`
:::


---

## One factor at a time


Cheapest and intuitive DOE: all factors have **nominal values** and a **discrete variation set**, in which each is varied while **others remaining fixed**

 $\rightarrow$ when model is slow - or computational budget highly limited
 $\rightarrow$ does not capture interaction between parameters, and highly dependent on nominal values
 $\rightarrow$ remains useful for first insights and models taking significant time, and easy to interpret thematically


---

## Example of One-At-a-Time limitation

<!-- 20231110_exploration/totalRescuedAverage_humanInformedRatio_colorhumanInformProbability_facethumanFollowProbability.png -->

<img src="https://miniocodimd.openmole.org/codimd/uploads/e7ff3bb3-5399-4c3a-a3e7-c436e53da1a8.png" height=350 width=500>

For the zombie model, average `totalRescued` indicator, obtained with a grid sampling.


---

## Grid sampling

"Brute force" DOE: ensemble product of discrete variation ranges for factors (usually a regular grid but not necessarily)

 $\rightarrow$ quickly limited by the curse of dimensionality
 $\rightarrow$ in practice still feasible with a model very fast to run and a low number of parameters
 $\rightarrow$ basic approach, but can be enough in some cases


---

## Syntax of samplings

One-factor sampling:

```scala
sampling = OneFactorSampling(
(x1 in (0.0 to 1.0 by 0.2)) nominal 0.5,
(x2 in (0.0 to 1.0 by 0.2)) nominal 0.5
)
```
Grid sampling:
```scala
sampling =
(x1 in (0.0 to 1.0 by 0.5)) x
(x2 in (0.0 to 1.0 by 0.5))
```



---

## High-dimensional samplings

Computational limitations $\implies$ need specific methods to efficiently sample the parameter space

Different methods for improving sampling in numerical experiments given limited computational resources have been proposed, as for example:

 - Sobol sequences (quicker convergence for Monte Carlo estimation of integrals)
 - Latin Hypercube Sampling
 - Orthogonal sampling


---

## Low discrepancy samplings

*Minimizing discrepancy for a point cloud: intuitively being spread evenly across the definition space*


L2-discrepancy given for normalised data points $\mathbf{X}=(x_{ij})\in \left[0,1\right]^d$ by


$\left\lVert \mathbf{t} = (t_j) \in \left[0,1\right]^d \mapsto \frac{1}{n}\sum_i 1_{\prod_j x_{ij}<t_j} - \prod_j t_j \right\rVert_2$

*Explanation:* $\prod_j t_j$ is the volume of the hypercube between **t** and the origin; the sum of indicator functions counts the points within that hypercube; the difference between expected volume and point number is integrated over the whole hypercube.


---

## Latin Hypercube Sampling

<!--
|x|||||
|:--:|:--:|:--:|:--:|:--:|
||**x**||||
|||||**x**|
||||**x**||
|||**x**|||
-->

<img src="https://miniocodimd.openmole.org/codimd/uploads/53730ed8-eea5-40ba-a92b-29a3d51579b0.png" height=300 width=300>


**Latin cube**: one point in each row and column 
$\rightarrow$ hypercube generalisation in any dimension

---

## Sobol sequence

Sobol sequences are a case of quasi-random sequences with low discrepancy (also Halton sequences for example)

$\rightarrow$ Estimate integrals in $1/N$ instead of $1/\sqrt{N}$ with random sampling
$\rightarrow$ Constructed recursively (using bit representations)


---

## Comparison of samplings

![](https://miniocodimd.openmole.org/codimd/uploads/08c9502f-d8c6-4654-979c-1a7b374b329d.png)





---

## Comparison of samplings

<img src="https://miniocodimd.openmole.org/codimd/uploads/e951a1e9-665c-4dab-b71d-5cd5a550f99e.png" height=350 width=500>

Estimated discrepancies for repetitions of samplings as a function of sample size


---

## Syntax of high-dimensional samplings


LHS Sampling

```scala
sampling = LHS(
sample = 100,
factor = Seq(
x1 in (0.0,1.0),
x2 in (0.0,1.0)
))
```
Sobol sampling

```scala
sampling = SobolSampling(
sample = 100,
factor = Seq(
x1 in (0.0,1.0),
x2 in (0.0,1.0)
))
```


---


![](https://miniocodimd.openmole.org/codimd/uploads/31788be9-a999-4789-ba33-ed90376110d2.png)

---

## Going further: Global Sensitivity Analysis

Methods to get an estimate of the overall average effect of inputs on outputs (Saltelli, 2008)

 - Morris method averaging derivatives across random trajectories in the parameter space (`SensitivityMorris` in OpenMOLE)
 - Saltelli method computing conditional variances (first order, total effect including interactions between parameters) extending Sobol indices (Saltelli et al., 2010) (`SensitivitySaltelli` in OpenMOLE)


---

## Take home messages 



- Direct samplings provide a first insight into model behaviour
- More quantitative information about the relative importance of parameters $\rightarrow$ Global Sensitivity Analysis methods (Saltelli, Morris; included in OpenMOLE but not seen here)
- Need to balance computational budget, coverage and interpretability
- The experiments always depend on your question, and more importantly on your disciplinary practices
