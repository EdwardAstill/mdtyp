# GENG5507 midsemester statistics cheat sheet

**Order of use:** translate the event → choose the model → calculate the probability or lifetime → estimate unknown parameters → handle sample means. This sheet covers the supplied statistics lectures through Week 5, Weibull analysis and their reliability applications. See [worked examples](examples.md), [R guide](R.md), [question collection](questions.md) and [engineering notes](engineering-content.md).

## 1. Decode the question

| Wording | Mathematical event or tool |
|---|---|
| Not $A$ | $A^c=A'$ |
| $A$ and $B$ | Intersection $A\cap B$ |
| $A$ or $B$, including both | Union $A\cup B$ |
| $B$ given that $A$ happened | $P(B\mid A)$; restrict the population to $A$ |
| At least one | $1-P(\text{none})$ |
| Failure by time $t$ | $F(t)=P(T\le t)$ |
| Survives beyond $t$ | $R(t)=P(T>t)=1-F(t)$ |
| Probability from a boundary | CDF, R prefix `p` |
| Boundary from a probability | Quantile, R prefix `q` |
| One observation | Use its SD $\sigma$ |
| Mean of $n$ independent observations | Use standard error $\sigma/\sqrt n$ |

## 2. Probability rules: build, split, then reverse

For equally likely outcomes only, $P(A)=\#(A)/\#(\Omega)$.

$$
P(A^c)=1-P(A),\qquad
P(A\cup B)=P(A)+P(B)-P(A\cap B).
$$

### Conditional probability and intersection

$$
P(B\mid A)=\frac{P(A\cap B)}{P(A)},\qquad P(A)>0.
$$

**Correct version of the requested identity:**

$$
\boxed{P(B\mid A)P(A)=P(A\cap B)=P(A\mid B)P(B).}
$$

The final factor is **$P(B)$**, because the preceding conditional is given $B$. Multiply the probability along one branch of a probability tree to get an intersection.

### Law of total probability: add all the routes to the event

$A$ and $A^c$ split the population into two non-overlapping groups containing everybody. Event $B$ can occur in either group:

$$
\boxed{P(B)=P(B\mid A)P(A)+P(B\mid A^c)P(A^c).}
$$

This is a **weighted average of the within-group probabilities**, weighted by the group sizes. More generally, if $A_1,\ldots,A_k$ are mutually exclusive and exhaustive,

$$
P(B)=\sum_{i=1}^{k}P(B\mid A_i)P(A_i).
$$

Example: supplier $A$ supplies $60\%$ of parts with defect probability $0.02$; the other supplier has defect probability $0.05$. Then $P(D)=0.02(0.60)+0.05(0.40)=0.032$.

### Bayes: reverse the conditioning

$$
P(A_j\mid B)=\frac{P(B\mid A_j)P(A_j)}{P(B)}
=\frac{P(B\mid A_j)P(A_j)}{\sum_i P(B\mid A_i)P(A_i)}.
$$

In the supplier example, $P(A\mid D)=0.012/0.032=0.375$. A defective part is not automatically most likely to come from the largest supplier.

### Independence is different from mutual exclusion

| Property | Test | Consequence |
|---|---|---|
| Independent | $P(A\cap B)=P(A)P(B)$ | Knowing one occurred does not change the probability of the other. |
| Mutually exclusive/disjoint | $P(A\cap B)=0$ | Both cannot occur together. Positive-probability disjoint events are dependent. |

For independent events, $P(\text{none})=\prod_i[1-P(A_i)]$. For $n$ independent equal-probability opportunities, $P(\text{at least one})=1-(1-p)^n$.

## 3. PMF, PDF, CDF, mean and standard deviation

| Quantity | Discrete random variable | Continuous random variable |
|---|---|---|
| Main model formula | PMF $p(x)=P(X=x)$ | PDF $f(x)$ is density, not point probability |
| Normalisation | $\sum_xp(x)=1$ | $\int_{-\infty}^{\infty}f(x)\,dx=1$ |
| CDF | $F(x)=\sum_{u\le x}p(u)$ | $F(x)=\int_{-\infty}^{x}f(u)\,du$ |
| Mean | $\mu=\sum_xxp(x)$ | $\mu=\int_{-\infty}^{\infty}xf(x)\,dx$ |
| Second moment | $E[X^2]=\sum_xx^2p(x)$ | $E[X^2]=\int_{-\infty}^{\infty}x^2f(x)\,dx$ |

$$
\operatorname{Var}(X)=E[X^2]-\mu^2,\qquad \sigma=\sqrt{\operatorname{Var}(X)}.
$$

For continuous $X$, $P(X=x)=0$ and $P(a<X<b)=F(b)-F(a)$; inclusion of the endpoints does not matter. For integer-valued $X$,

$$
P(a\le X\le b)=F(b)-F(a-1),\qquad P(X\ge k)=1-F(k-1).
$$

A PDF can exceed $1$; its **area** must sum to $1$. A PMF value is itself a probability.

## 4. Reliability, hazard and MTTF

Let $T\ge0$ be a continuous time to failure.

| Function | Formula | Interpretation |
|---|---|---|
| Failure CDF | $F(t)=P(T\le t)$ | Fraction failed by $t$ |
| Reliability/survival | $R(t)=1-F(t)$ | Fraction surviving beyond $t$ |
| Failure PDF | $f(t)=F'(t)=-R'(t)$ | Density of failure times |
| Hazard | $h(t)=f(t)/R(t)=-\frac{d}{dt}\ln R(t)$ | Instantaneous failure rate among current survivors |
| Cumulative hazard | $H(t)=\int_0^t h(u)\,du=-\ln R(t)$ | Accumulated hazard; hence $R(t)=e^{-H(t)}$ |

The slides also write the hazard as $r(t)$ or $Z(t)$. Hazard has units of inverse time and is **not a probability**. For small $\Delta t$,

$$
P(t<T\le t+\Delta t\mid T>t)\approx h(t)\Delta t.
$$

**Yes: mean time to failure is the mean of the lifetime distribution.**

$$
\boxed{\operatorname{MTTF}=E[T]=\int_0^\infty tf(t)\,dt=\int_0^\infty R(t)\,dt.}
$$

A count or a strength has a mean, but that mean is not a time to failure. MTTF is not generally the median, Weibull scale $\eta$, or $1/h(t)$; the reciprocal-hazard result applies to constant-hazard exponential lifetimes. Mean repair duration is **MTTR**, not MTTF.

### Conditional remaining life

For $s,u\ge0$,

$$
P(T>s+u\mid T>s)=\frac{R(s+u)}{R(s)},
\qquad
P(s<T\le s+u\mid T>s)=1-\frac{R(s+u)}{R(s)}.
$$

Without the condition, $P(s<T\le s+u)=F(s+u)-F(s)$. Only the exponential model makes the conditional remaining-life distribution identical to the original lifetime distribution.

## 5. Distribution formula tables

All PMFs/PDFs below are zero outside their stated support. $\Phi$ and $\phi$ are the standard normal CDF and PDF. $\Gamma(a)=\int_0^\infty u^{a-1}e^{-u}\,du$, with $\Gamma(a+1)=a\Gamma(a)$ and $\Gamma(m)=(m-1)!$ for positive integers $m$.

### Counts and equally likely outcomes

| Model and support | **PMF/PDF — main formula** | Mean | SD | Special property |
|---|---|---|---|---|
| Discrete uniform on integers $a,\ldots,b$; $k=b-a+1$ | $p(x)=1/k$ | $(a+b)/2$ | $\sqrt{(k^2-1)/12}$ | All $k$ outcomes equally likely. For arbitrary values $x_i$, mean is $\sum x_i/k$. |
| Binomial $X\sim\mathrm{Bin}(n,p)$; $x=0,\ldots,n$ | $p(x)=\binom nx p^x(1-p)^{n-x}$ | $np$ | $\sqrt{np(1-p)}$ | Fixed $n$, independent trials, two outcomes, constant $p$. Bernoulli is $n=1$. |
| Poisson $X\sim\mathrm{Pois}(m)$; $x=0,1,\ldots$ | $p(x)=e^{-m}m^x/x!$ | $m$ | $\sqrt m$ | Mean = variance. For event rate $\lambda$ over duration $t$, $m=\lambda t$. |
| Continuous uniform $U(a,b)$; $a\le x\le b$ | $f(x)=1/(b-a)$ | $(a+b)/2$ | $(b-a)/\sqrt{12}$ | Equal-length subintervals have equal probability; median = mean. |

Counts have no lifetime hazard or MTTF in their usual interpretation. Their upper tail is still $1-F(x)$. For a uniform **lifetime** with $0\le a<b$, MTTF is $(a+b)/2$; $R(t)=1$ for $t<a$, $(b-t)/(b-a)$ for $a\le t<b$, and $0$ for $t\ge b$. Its hazard is $0$ before $a$ and $1/(b-t)$ for $a\le t<b$; hazard is undefined once no survivors remain.

### Continuous measurements and lifetimes: PDF and moments

For gamma use **shape $k>0$, rate $\lambda>0$**, equivalently scale $\theta=1/\lambda$. This sheet reserves $\beta$ for Weibull shape; the slides sometimes use $\beta$ for gamma shape too.

| Model and support | **PDF — main formula** | Mean / MTTF when a lifetime | Standard deviation |
|---|---|---|---|
| Normal $N(\mu,\sigma^2)$; $x\in\mathbb R$, $\sigma>0$ | $f(x)=\frac{1}{\sigma\sqrt{2\pi}}\exp[-\frac{(x-\mu)^2}{2\sigma^2}]$ | $\mu$; lifetime approximation only | $\sigma$ |
| Lognormal; $\ln T\sim N(\mu,\sigma^2)$; $t>0$ | $f(t)=\frac{1}{t\sigma\sqrt{2\pi}}\exp[-\frac{(\ln t-\mu)^2}{2\sigma^2}]$ | $m_T=e^{\mu+\sigma^2/2}$ | $m_T\sqrt{e^{\sigma^2}-1}$ |
| Exponential, rate $\lambda>0$; $t\ge0$ | $f(t)=\lambda e^{-\lambda t}$ | $1/\lambda$ | $1/\lambda$ |
| Weibull, shape $\beta>0$, scale $\eta>0$; $t>0$ | $f(t)=\frac{\beta}{\eta}(t/\eta)^{\beta-1}e^{-(t/\eta)^\beta}$ | $\eta\Gamma(1+1/\beta)$ | $\eta\sqrt{\Gamma(1+2/\beta)-[\Gamma(1+1/\beta)]^2}$ |
| Gamma, shape $k$, rate $\lambda$; $t>0$ | $f(t)=\frac{\lambda^k}{\Gamma(k)}t^{k-1}e^{-\lambda t}$ | $k/\lambda=k\theta$ | $\sqrt{k}/\lambda=\sqrt{k}\theta$ |
| Student's $t_\nu$, degrees of freedom $\nu>0$; $x\in\mathbb R$ | $f(x)=\frac{\Gamma((\nu+1)/2)}{\sqrt{\nu\pi}\Gamma(\nu/2)}(1+x^2/\nu)^{-(\nu+1)/2}$ | $0$ for $\nu>1$; otherwise undefined. Not a lifetime model. | $\sqrt{\nu/(\nu-2)}$ for $\nu>2$; otherwise no finite SD. |

The normal model allows negative values. It can approximate a lifetime if $P(T<0)=\Phi(-\mu/\sigma)$ is negligible. An actual normal distribution has mean $\mu$, but the nonnegative-lifetime identity $\int_0^\infty R(t)dt=\mu$ is not exact for it. A truncated normal is a different model.

### The same lifetime models: reliability, hazard and useful properties

For gamma, define $Q(k,x)=\Gamma(k)^{-1}\int_x^\infty u^{k-1}e^{-u}\,du$; this is its upper-tail integral.

| Model | Reliability $R(t)=1-F(t)$ | Hazard $h(t)$ | Special properties |
|---|---|---|---|
| Normal, $z=(t-\mu)/\sigma$ | $1-\Phi(z)$ | $\phi(z)/\{\sigma[1-\Phi(z)]\}$ | Symmetric; mean = median = mode; standardise with $z$. |
| Lognormal, $z=(\ln t-\mu)/\sigma$ | $1-\Phi(z)$ | $\phi(z)/\{t\sigma[1-\Phi(z)]\}$ | Positive, right-skewed; median $e^\mu$; parameters refer to **log times**. Hazard rises then falls. |
| Exponential | $e^{-\lambda t}$ | $\lambda$ | **Memoryless**; mean = SD; median $(\ln2)/\lambda$; no ageing. |
| Weibull | $e^{-(t/\eta)^\beta}$ | $\frac{\beta}{\eta}(t/\eta)^{\beta-1}$ | $\beta<1$: decreasing hazard; $\beta=1$: exponential; $\beta>1$: increasing hazard. $F(\eta)=0.6321$. |
| Gamma | $Q(k,\lambda t)$ | $f(t)/Q(k,\lambda t)$ | $k=1$: exponential. Integer $k$: sum of $k$ iid exponential waiting times. |

**Beta is named but not developed in the probability-model lecture.** For completeness, $X\sim\mathrm{Beta}(a,b)$ has support $0<x<1$, PDF $x^{a-1}(1-x)^{b-1}/B(a,b)$, mean $a/(a+b)$ and SD $\sqrt{ab/[(a+b)^2(a+b+1)]}$, where $B(a,b)=\Gamma(a)\Gamma(b)/\Gamma(a+b)$. It models proportions, not unscaled lifetimes; $a=b=1$ is $U(0,1)$.

### What the distributions describe: quick examples

| Model | Description and engineering use |
|---|---|
| Discrete uniform | Random choice among equally likely values: fair die or randomly selected component label. |
| Binomial | Count within a fixed number of trials: survivors among four independent bulbs, each surviving with probability $0.9$. |
| Poisson | Count over an interval under constant rate and independent increments: breakdowns in a month or defects along a cable. |
| Continuous uniform | Bounded uncertainty with constant density: an arrival time equally likely anywhere in a fixed interval. Bounds alone do not prove uniformity. |
| Normal | Symmetric variation about a target: material strength or dimension; also sample means under the CLT. |
| Lognormal | Multiplicative positive variation: right-skewed repair duration or fatigue life when log times are approximately normal. |
| Exponential | Time to the next event in a homogeneous Poisson process: random failures with constant hazard. |
| Weibull | Lifetime with monotone age-dependent hazard: weak items failing early, random failures, or wear-out. A single two-parameter Weibull does not model the whole bathtub curve. |
| Gamma | Accumulated positive waiting time: time until the $k$th Poisson-process event when $k$ is an integer. |
| Beta | A proportion constrained to $[0,1]$: uncertainty about a defect probability or fraction. |
| Student's $t$ | Symmetric, heavier-tailed reference model for a standardised sample mean when the population SD is estimated; use $\nu=n-1$ for a normal sample. Approaches standard normal as $\nu$ increases. |

### Quantiles: solve for the time

Let $t_p$ satisfy $F(t_p)=p$, where $0<p<1$.

| Model | Failure percentile $t_p$ |
|---|---|
| Normal | $\mu+\sigma\Phi^{-1}(p)$ |
| Lognormal | $\exp[\mu+\sigma\Phi^{-1}(p)]$ |
| Exponential | $-\ln(1-p)/\lambda$ |
| Weibull | $\eta[-\ln(1-p)]^{1/\beta}$ |

If the target is reliability $r$, substitute $p=1-r$: for Weibull, $t=\eta(-\ln r)^{1/\beta}$. A $B_{10}$ life means **10% failed**, so use $p=0.10$, not reliability $0.10$.

## 6. System reliability: connect components correctly

Assume independent component states at the same time $t$ unless dependence is explicitly modelled.

| System | It operates when… | Reliability |
|---|---|---|
| Series | Every component operates | $R_{\rm sys}(t)=\prod_{i=1}^n R_i(t)$ |
| Active parallel | At least one operates | $R_{\rm sys}(t)=1-\prod_{i=1}^n[1-R_i(t)]$ |
| $k$-out-of-$n$, identical reliability $R$ | At least $k$ components operate | $R_{\rm sys}=\sum_{j=k}^n\binom nj R^j(1-R)^{n-j}$ |

For equal component reliability $R$, series gives $R^n$ and parallel gives $1-(1-R)^n$. For a complex network, condition on a key component $C$:

$$
R_{\rm sys}=P(S\mid C)R_C+P(S\mid C^c)(1-R_C).
$$

This is the law of total probability. Reduce each conditional network separately; do not count a shared component twice as if its states were independent.

For an independent series system, $h_{\rm sys}(t)=\sum_i h_i(t)$. Consequently:

- Exponential components: $\lambda_{\rm sys}=\sum_i\lambda_i$ and $\mathrm{MTTF}_{\rm sys}=1/\sum_i\lambda_i$.
- Weibull components with common shape $\beta$: $\eta_{\rm sys}=(\sum_i\eta_i^{-\beta})^{-1/\beta}$ and $\mathrm{MTTF}_{\rm sys}=\eta_{\rm sys}\Gamma(1+1/\beta)$.

Perfect cold standby with $n$ identical exponential units, one active at a time, no standby failures and perfect switching has $R_{\rm sys}(t)=e^{-\lambda t}\sum_{j=0}^{n-1}(\lambda t)^j/j!$ and MTTF $n/\lambda$. This differs from active parallel operation. Availability and maintenance decisions are in the engineering notes.

## 7. Estimate unknown parameters from data

### Complete observations

$$
\bar x=\frac1n\sum_i x_i,\qquad
s^2=\frac{\sum_i(x_i-\bar x)^2}{n-1},\qquad s=\sqrt{s^2}.
$$

| Model | Maximum-likelihood estimates (complete independent observations) |
|---|---|
| Normal | $\widehat\mu=\bar x$, $\widehat\sigma=\sqrt{\sum_i(x_i-\bar x)^2/n}$ |
| Lognormal | Apply the normal MLE formulas to $y_i=\ln x_i$; then fitted mean lifetime is $e^{\widehat\mu+\widehat\sigma^2/2}$. |
| Exponential | $\widehat\lambda=n/\sum_i x_i=1/\bar x$; fitted MTTF $=\bar x$. |

**Sample SD uses $n-1$; normal MLE SD uses $n$.** R's `sd(x)` returns the sample SD. A sample coefficient of variation $s/\bar x$ far from $1$ is evidence against an exponential fit, not a conclusive test by itself.

### Censoring and total exposure

Right-censored at $c$ means **known to survive beyond $c$**, not failed at $c$. Left-censored means failed before observation; interval-censored means failure occurred between inspections. The course mainly uses right censoring/suspensions.

Let $n$ be the original item count, $r$ the observed failures and $\mathcal T$ total accumulated time on test.

| Data collection | Total time on test |
|---|---|
| Complete observations | $\mathcal T=\sum_{i=1}^n t_i$ |
| Type I: stop at fixed time $t_*$ | $\mathcal T=\sum_{i=1}^r t_i+(n-r)t_*$ |
| Type II: stop at the $r$th failure, time $t_r$ | $\mathcal T=\sum_{i=1}^r t_i+(n-r)t_r$ |
| Different independent censoring times | Sum every item's actual observed exposure, including survivors. |

**Under the exponential lifetime model**, with $r>0$,

$$
\widehat\lambda=\frac r{\mathcal T},\qquad
\widehat{\mathrm{MTTF}}=\frac{\mathcal T}{r},\qquad
\widehat{\mathrm{SD}}(T)=\frac{\mathcal T}{r}.
$$

Do not generalise the last identity to Weibull or other lifetimes. With no failures, $\mathcal T/r$ does not give a finite MTTF estimate. Deleting survivors or applying `mean`/`sd` to censored times as though they were failures misrepresents the data.

### Likelihood: retain the information in censored observations

For independent observations with non-informative right censoring and $\delta_i=1$ for failure, $0$ for suspension,

$$
L(\theta)=\prod_i f(t_i;\theta)^{\delta_i}R(t_i;\theta)^{1-\delta_i},
\qquad \ell(\theta)=\ln L(\theta).
$$

Maximise $L$ or $\ell$ to estimate $\theta$. Failures contribute $f$; suspensions contribute $R$. Complete-data Weibull log-likelihood is

$$
\ell(\beta,\eta)=n\ln\beta-n\beta\ln\eta
 +(\beta-1)\sum_i\ln t_i-\sum_i(t_i/\eta)^\beta.
$$

Both Weibull parameters usually require numerical fitting. For fixed $\beta$, $\widehat\eta=(\sum_i t_i^\beta/n)^{1/\beta}$.

## 8. Empirical reliability and Weibull plots

### Complete-data ranking

Sort failure times as $t_{(1)}\le\cdots\le t_{(n)}$.

| Rank choice | Estimated failure probability at $t_{(i)}$ |
|---|---|
| Empirical CDF | $i/n$ for distinct failures |
| Mean rank | $i/(n+1)$ |
| Approximate median rank (Benard) | $(i-0.3)/(n+0.4)$ |

Use the rank method specified in the question. Mean/median ranks avoid $F=1$, which cannot be double-log transformed.

### Weibull straight-line transformation

$$
x_i=\ln t_{(i)},\qquad
 y_i=\ln[-\ln(1-\widehat F(t_{(i)}))],
\qquad y=a+bx.
$$

$$
\boxed{\widehat\beta=b,\qquad \widehat\eta=e^{-a/b}.}
$$

An approximately straight plot supports a Weibull fit. Slope measures ageing; scale is the $63.2\%$ failure time, **not generally the mean**. Median $=\eta(\ln2)^{1/\beta}$.

For the shifted three-parameter Weibull with failure-free period $\gamma\ge0$, replace $t$ by $t-\gamma$ for $t>\gamma$. Reliability is $1$ before $\gamma$, mean is $\gamma+\eta\Gamma(1+1/\beta)$, SD is unchanged, and characteristic failure time is $\gamma+\eta$. Use the location shift only if specified or justified.

### Median ranks with suspensions

Sort **all** observations, retaining failure/suspension labels. Let $j_{\rm prev}=0$ initially and $m$ be the number of all observations preceding the current failure. Update only at a failure:

$$
\mathrm{INC}=\frac{n+1-j_{\rm prev}}{1+n-m},\qquad
j=j_{\rm prev}+\mathrm{INC},\qquad
\widehat F(t)=\frac{j-0.3}{n+0.4}.
$$

Then set $j_{\rm prev}=j$ for the next failure. Suspensions affect ordering and risk but receive no failure plotting point. With no suspensions this reduces to ordinary integer ranks. This method and Kaplan–Meier below produce different estimates; use the requested method.

### Kaplan–Meier survival estimate

At each distinct failure time $t_j$, $n_j$ is the number at risk **immediately before** the failure time and $d_j$ is the number failing then:

$$
\boxed{\widehat R(t)=\prod_{t_j\le t}\left(1-\frac{d_j}{n_j}\right),
\qquad \widehat F(t)=1-\widehat R(t).}
$$

Failures step the survival curve down. Censoring makes no downward step, but removes subjects from later risk sets. If failures and censoring share a recorded time, conventionally count those censored as at risk for the failures at that time. The curve is constant between failures.

## 9. Sampling distributions and the CLT

A **parameter** describes the population; a **statistic** is calculated from the sample. A sampling distribution describes how a statistic changes across repeated samples. A good random sample avoids selection bias; increasing $n$ does not fix biased selection.

For constants $a,b$, $E[aX+bY]=aE[X]+bE[Y]$. If $X,Y$ are independent, $\operatorname{Var}(aX+bY)=a^2\operatorname{Var}(X)+b^2\operatorname{Var}(Y)$; otherwise include $2ab\operatorname{Cov}(X,Y)$.

For iid observations with finite mean $\mu$ and variance $\sigma^2$:

| Statistic | Mean | Variance | SD |
|---|---|---|---|
| One $X$ | $\mu$ | $\sigma^2$ | $\sigma$ |
| Sum $S_n=\sum_iX_i$ | $n\mu$ | $n\sigma^2$ | $\sqrt n\sigma$ |
| Mean $\bar X=S_n/n$ | $\mu$ | $\sigma^2/n$ | $\sigma/\sqrt n$ (standard error) |

| Situation | Standardisation and distribution | Validity |
|---|---|---|
| Normal population; known $\sigma$ | $Z=(\bar X-\mu)/(\sigma/\sqrt n)\sim N(0,1)$ | Exact for any $n$ |
| Normal population; unknown $\sigma$ | $T=(\bar X-\mu)/(S/\sqrt n)\sim t_{n-1}$ | Exact for any $n$ |
| Non-normal population; large $n$ | $\bar X\approx N(\mu,\sigma^2/n)$ | CLT approximation; iid and finite variance |

The course's $n\ge30$ rule is a guide, not a guarantee for strong skew or extreme tails. The **mean's distribution** approaches normal; the original population does not become normal. Student's $t$ has heavier tails than normal and approaches normal as its degrees of freedom increase. With a small non-normal sample, the usual $t$ result is not exact.

For iid exponential lifetimes with rate $\lambda$, the exact sum is $S_n\sim\mathrm{Gamma}(n,\text{rate}=\lambda)$ and the exact mean is $\bar X\sim\mathrm{Gamma}(n,\text{rate}=n\lambda)$. For a Weibull population, first calculate $\mu,\sigma$ from its moment formulas, then use the CLT for the mean; do not apply the individual Weibull CDF to $\bar T$.

### Sample size for a probability/accuracy target

Here $z_p=\Phi^{-1}(p)$ is a **lower-tail quantile**. Some supplied tables label critical values by upper-tail probability instead; translate the tail before reading them.

| Requirement under a normal/CLT model | Required sample size |
|---|---|
| $P(\bar X\ge\mu+d)\le\alpha$, $d>0$, $\alpha<0.5$ | $n\ge(z_{1-\alpha}\sigma/d)^2$ |
| $P(\lvert\bar X-\mu\rvert<E)\ge1-\alpha$ | $n\ge(z_{1-\alpha/2}\sigma/E)^2$ |

Round **up** and recheck the probability at the resulting integer. Two-sided accuracy splits $\alpha$ equally between the tails. A fourfold sample size halves the standard error.

## 10. R reminders and final checks

| Need | R convention |
|---|---|
| PMF/PDF | `d...` (a continuous density is not a probability) |
| $P(X\le x)$ | `p...(x, ...)` |
| $P(X>x)$ / reliability | `p...(x, ..., lower.tail = FALSE)` |
| Boundary for lower-tail probability $p$ | `q...(p, ...)` |
| Generate $n$ observations | `r...(n, ...)` |

Suffixes: `binom`, `pois`, `unif`, `norm`, `lnorm`, `exp`, `weibull`, `gamma`, `beta`, `t`. Normal uses `sd`, lognormal uses `meanlog`/`sdlog`, exponential uses `rate`, Weibull uses `shape`/`scale`, gamma uses `shape` with **either** `rate` **or** `scale`. Poisson's `lambda` argument is the expected count over the requested interval, not automatically the rate per hour.

Before submitting: define the variable and units; check independence and support; distinguish PDF from probability, SD from variance, and individual from sample mean; choose the correct tail and discrete endpoint; retain censored exposure; report probabilities between $0$ and $1$ with sensible time/rate units.

## Source map

Source links refer to the supplied files. Page numbers below are **PDF page positions**, which may differ from printed slide numbers. The essential summary also contains later confidence-interval and hypothesis-testing material; those later topics are not developed here because this sheet follows the supplied statistics lectures through Week 5.

- [Probability basics](../probability-content/slides-pdf/01-GENG5507-STATS-Basics.pdf) and [additional probability slides](../probability-content/slides-pdf/02-GENG5507-STATS-extra-slides.pdf): events, conditional probability and reliability language.
- [Probability models](../probability-content/slides-pdf/03-GENG5507-STATS-ProbabilityModels.pdf): model definitions and moments; gamma and the beta/uniform reading pointers on PDF p. 43. Continuous uniform and beta formulas are compact reference supplements for those named models.
- [Hazard rate](../probability-content/slides-pdf/04-GENG5507-STATS-HazardRate.pdf): reliability, hazard, MTTF and system applications.
- [Model estimation](../probability-content/slides-pdf/05-GENG5507-STATS-ModelEstimation.pdf): complete/censored data, likelihood and Weibull fitting; Kaplan–Meier on PDF pp. 34–35.
- [Weibull analysis](../probability-content/slides-pdf/Weibull-analysis.pdf): shifted model, probability paper and adjusted median ranks.
- [Random sampling and CLT](../probability-content/slides-pdf/06-GENG5507-STATS-lecture-week5-CLT.pdf): sampling distributions, $z$, $t$ and sample size.
- [Essential summary and tables](<../GENG5507- ESSENTIAL SUMMARY AND TABLES.pdf>): printed formula pp. 1–9; probability, distributions, system reliability and data ranking. Formula conditions and parameter conventions are made explicit here.
- [Lecture questions](../questions/probability-questions/lecture/) and [practical questions](../questions/probability-questions/prac/): question patterns addressed by this sheet.
