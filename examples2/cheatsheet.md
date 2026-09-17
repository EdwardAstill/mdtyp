# GENG5507 Probability and Statistics Cheatsheet

<!-- Table of contents -->

Use this after learning the concepts in the
[study map](./README.md). The [worked examples](../probability-examples/worked-examples.md)
show how the formulas are applied.

## 1. Translate the wording

| Words | Symbol |
|---|---|
| not $A$ | $A^c$ |
| $A$ or $B$, including both | $A\cup B$ |
| $A$ and $B$ | $A\cap B$ |
| $A$, given $B$ | $P(A\mid B)$ |
| fails by $t$ | $F(t)=P(T\le t)$ |
| survives beyond $t$ | $R(t)=P(T>t)$ |
| between $a$ and $b$ | $F(b)-F(a)$ |
| at least one | $1-P(\text{none})$ |
| probability from a boundary | CDF: R prefix <code>p</code> |
| boundary from a probability | quantile: R prefix <code>q</code> |

## 2. Event rules

$$
P(A^c)=1-P(A)
$$

$$
P(A\cup B)=P(A)+P(B)-P(A\cap B)
$$

$$
P(A\mid B)=\frac{P(A\cap B)}{P(B)}
$$

$$
P(A\cap B)=P(A\mid B)P(B)
$$

For independent events,

$$
P(A\cap B)=P(A)P(B).
$$

For independent $A_1,\ldots,A_n$,

$$
P(\text{at least one})
=
1-\prod_{i=1}^nP(A_i^c).
$$

If each has probability $p$,

$$
P(\text{at least one})=1-(1-p)^n.
$$

**Law of total probability:** split $B$ into the cases where $A$ happens
and where it does not. For $0<P(A)<1$,

$$
P(B)=P(B\mid A)P(A)+P(B\mid A^c)P(A^c).
$$

Weight each conditional probability by the probability of its case;
$P(B\mid A)+P(B\mid A^c)$ alone is not the rule.
Equivalently, $P(B)=P(B\cap A)+P(B\cap A^c)$.

More generally, if $B_1,\ldots,B_k$ form a partition (mutually exclusive,
exhaustive cases with positive probabilities),

$$
P(A)=\sum_{i=1}^kP(A\mid B_i)P(B_i).
$$

Bayes:

$$
P(B_j\mid A)
=
\frac{P(A\mid B_j)P(B_j)}
{\sum_iP(A\mid B_i)P(B_i)}.
$$

**Do not confuse:**

- disjoint: $P(A\cap B)=0$;
- independent: $P(A\cap B)=P(A)P(B)$.

Positive-probability disjoint events are not independent.

## 3. Random-variable functions

| Object | Discrete | Continuous |
|---|---|---|
| Probability model | PMF $p(x)=P(X=x)$ | PDF $f(x)$, a density |
| Total probability | $\sum_xp(x)=1$ | $\int f(x)\,dx=1$ |
| Interval probability | Sum relevant masses | $\int_a^bf(x)\,dx$ |
| CDF | $F(x)=P(X\le x)$ | $F(x)=\int_{-\infty}^xf(u)\,du$ |
| Mean | $\sum_xxp(x)$ | $\int xf(x)\,dx$ |

$$
\operatorname{Var}(X)=E[X^2]-E[X]^2,
\qquad
\operatorname{SD}(X)=\sqrt{\operatorname{Var}(X)}.
$$

For a continuous variable,

$$
P(a<X<b)=F(b)-F(a),
\qquad
P(X=x)=0.
$$

## 4. Reliability and hazard

Let $T\ge0$ be the time to failure. The **failure function** (CDF) is

$$
F(t)=P(T\le t),
$$

the probability that the item **has failed by time $t$**. The **reliability
function** (survival function) is

$$
R(t)=P(T>t),
$$

the probability that the item **has not failed by time $t$** and survives
beyond it. These are complementary events, so

$$
F(t)+R(t)=1,
\qquad
R(t)=1-F(t).
$$

For a continuous lifetime, the other functions are:

| Function | What it is | Meaning |
|---|---|---|
| $f(t)=F'(t)=-R'(t)$ | Failure-time density (PDF) | Describes how concentrated failures are near $t$. For small $\Delta t$, $f(t)\Delta t\approx P(t<T\le t+\Delta t)$. |
| $h(t)=f(t)/R(t)$ | Hazard rate | Instantaneous failure rate at age $t$ **among items that have survived to $t$**. |
| $H(t)=\int_0^t h(u)\,du$ | Cumulative hazard | Total hazard accumulated from time $0$ to $t$. |

Thus, for small $\Delta t$,

$$
P(t<T\le t+\Delta t\mid T>t)
\approx h(t)\Delta t.
$$

The functions describe the same lifetime distribution and can be converted
using

$$
R(t)=e^{-H(t)},
\qquad
f(t)=h(t)R(t).
$$

The mean time to failure is the expected lifetime, or equivalently the area
under the reliability curve:

$$
\operatorname{MTTF}
=E[T]
=\int_0^\infty tf(t)\,dt
=\int_0^\infty R(t)\,dt.
$$

Both $f(t)$ and $h(t)$ are densities or rates, not probabilities. If time is
measured in hours, their units are $1/\text{hour}$.

### Multicomponent systems

At time $t$, let component $i$ have reliability $R_i(t)$. If component
failures are independent:

| System | It works when | System reliability |
|---|---|---|
| Series | Every component works | $R_{\mathrm{series}}(t)=\prod_{i=1}^mR_i(t)$ |
| Parallel | At least one component works | $R_{\mathrm{parallel}}(t)=1-\prod_{i=1}^m[1-R_i(t)]$ |

For $m$ independent components with identical reliability $R(t)$,

$$
R_{\mathrm{series}}(t)=R(t)^m,
\qquad
R_{\mathrm{parallel}}(t)=1-[1-R(t)]^m.
$$

For either system, $F_{\mathrm{sys}}(t)=1-R_{\mathrm{sys}}(t)$. The product formulas do
not apply directly when component failures are dependent.

For an independent series system, cumulative hazards and hazard rates add:

$$
H_{\mathrm{series}}(t)=\sum_{i=1}^mH_i(t),
\qquad
h_{\mathrm{series}}(t)=\sum_{i=1}^mh_i(t).
$$

If component $i$ has a constant exponential failure rate $\lambda_i$, then

$$
\lambda_{\mathrm{series}}=\sum_{i=1}^m\lambda_i,
\qquad
R_{\mathrm{series}}(t)
=\exp\left(-t\sum_{i=1}^m\lambda_i\right).
$$

## 5. Choose a distribution

| Model | Use when | Mean | Standard deviation |
|---|---|---:|---:|
| Binomial $(n,p)$ | Success count in fixed $n$ independent trials | $np$ | $\sqrt{np(1-p)}$ |
| Poisson $(\mu=\lambda t)$ | Event count in an interval | $\mu$ | $\sqrt\mu$ |
| Uniform $[a,b]$ | All positions in a bounded interval equally likely | $(a+b)/2$ | $(b-a)/\sqrt{12}$ |
| Normal $(\mu,\sigma^2)$ | Symmetric measurements | $\mu$ | $\sigma$ |
| Lognormal $(\mu,\sigma^2)$ | $\ln T\sim N(\mu,\sigma^2)$ | $e^{\mu+\sigma^2/2}$ | $e^{\mu+\sigma^2/2}\sqrt{e^{\sigma^2}-1}$ |
| Exponential $(\lambda)$ | Constant-hazard lifetime | $1/\lambda$ | $1/\lambda$ |
| Weibull $(\beta,\eta)$ | Flexible monotone-hazard lifetime | $\eta\Gamma(1+1/\beta)$ | $\eta\sqrt{\Gamma(1+2/\beta)-\Gamma(1+1/\beta)^2}$ |
| Gamma, shape $k$, rate $\lambda$ | Positive staged waiting time | $k/\lambda$ | $\sqrt{k}/\lambda$ |

### CDF, reliability, hazard and MTTF at a glance

For continuous lifetimes, $R(t)=1-F(t)$ and $h(t)=f(t)/R(t)$ wherever
$R(t)>0$. All scale, shape and rate parameters below are positive.
Write $\phi(z)=e^{-z^2/2}/\sqrt{2\pi}$ and
$\Phi(z)=P(Z\le z)$ for the standard normal PDF and CDF.

| Distribution | CDF $F(t)$ | Reliability $R(t)$ | Hazard $h(t)$ | MTTF $E[T]$ |
|---|---|---|---|---|
| Uniform $[a,b]$, $0\le a<b$; $a\le t<b$ | $(t-a)/(b-a)$ | $(b-t)/(b-a)$ | $1/(b-t)$ | $(a+b)/2$ |
| Normal $(\mu,\sigma^2)$; $z=(t-\mu)/\sigma$ | $\Phi(z)$ | $1-\Phi(z)$ | $\phi(z)/[\sigma(1-\Phi(z))]$ | $\mu$ (mean; lifetime approximation only) |
| Lognormal $(\mu,\sigma^2)$; $z=(\ln t-\mu)/\sigma$, $t>0$ | $\Phi(z)$ | $1-\Phi(z)$ | $\phi(z)/[t\sigma(1-\Phi(z))]$ | $e^{\mu+\sigma^2/2}$ |
| Exponential $(\lambda)$; $t\ge0$ | $1-e^{-\lambda t}$ | $e^{-\lambda t}$ | $\lambda$ | $1/\lambda$ |
| Weibull $(\beta,\eta)$; $t>0$ | $1-e^{-(t/\eta)^\beta}$ | $e^{-(t/\eta)^\beta}$ | $(\beta/\eta)(t/\eta)^{\beta-1}$ | $\eta\Gamma(1+1/\beta)$ |
| Gamma, shape $k$, rate $\lambda$; $t>0$ | $G_k(\lambda t)$ | $1-G_k(\lambda t)$ | $\lambda^k t^{k-1}e^{-\lambda t}/[\Gamma(k)(1-G_k(\lambda t))]$ | $k/\lambda$ |

Here the gamma CDF uses

$$
G_k(y)=\frac{1}{\Gamma(k)}\int_0^y u^{k-1}e^{-u}\,du.
$$

For integer $k\ge1$, gamma reliability also has the finite-sum form

$$
R(t)=e^{-\lambda t}\sum_{j=0}^{k-1}\frac{(\lambda t)^j}{j!}.
$$

For uniform lifetimes, $F=0$, $R=1$, $h=0$ when $t<a$;
$F=1$, $R=0$ when $t\ge b$, where hazard is undefined.
For lognormal, exponential, Weibull and gamma lifetimes, $F(t)=0$ and
$R(t)=1$ for $t\le0$; hazard at $0$ is interpreted by its right-hand limit.
The untruncated normal allows negative values, so its mean $\mu$ is only an
approximate MTTF when the negative tail is negligible. The nonnegative-lifetime
identity $E[T]=\int_0^\infty R(t)\,dt$ does not hold for that untruncated model.

**Count distributions:** binomial and Poisson CDFs are sums of masses.
For $x\ge0$,

$$
F_{\mathrm{bin}}(x)=\sum_{j=0}^{\min(n,\lfloor x\rfloor)}
\binom njp^j(1-p)^{n-j},
\qquad
F_{\mathrm{Pois}}(x)=\sum_{j=0}^{\lfloor x\rfloor}\frac{\mu^je^{-\mu}}{j!}.
$$

Both CDFs are $0$ for $x<0$, and $P(X>x)=1-F(x)$.
Their means $np$ and $\mu$ are counts, not MTTFs. If an integer-valued
variable instead represents lifetime in discrete time steps, use the
**discrete hazard** $P(T=j\mid T\ge j)=p(j)/[1-F(j-1)]$, not the
continuous hazard formula, and $E[T]=\sum_{j=0}^\infty P(T>j)$ for $T\ge0$.

### Binomial

$$
P(X=x)=\binom nxp^x(1-p)^{n-x}.
$$

Check: fixed $n$, two outcomes, constant $p$, independent trials.

### Poisson

$$
P(X=x)=\frac{\mu^xe^{-\mu}}{x!},
\qquad
\mu=\lambda t.
$$

Check: count, constant rate, independent increments.

### Normal

$$
Z=\frac{X-\mu}{\sigma}\sim N(0,1).
$$

R uses $\sigma$, even when the model is written $N(\mu,\sigma^2)$.

### Lognormal

$$
P(T\le t)
=
\Phi\left(\frac{\ln t-\mu}{\sigma}\right).
$$

Parameters describe $\ln T$, not $T$.

### Exponential

$$
f(t)=\lambda e^{-\lambda t},
\quad
F(t)=1-e^{-\lambda t},
\quad
R(t)=e^{-\lambda t},
\quad
h(t)=\lambda.
$$

$$
P(T>s+t\mid T>s)=P(T>t).
$$

### Weibull

$$
F(t)=1-e^{-(t/\eta)^\beta},
\qquad
R(t)=e^{-(t/\eta)^\beta},
$$

$$
h(t)=\frac{\beta}{\eta}(t/\eta)^{\beta-1}.
$$

| Shape | Meaning |
|---:|---|
| $\beta<1$ | Decreasing hazard; early defects. |
| $\beta=1$ | Constant hazard; exponential. |
| $\beta>1$ | Increasing hazard; fatigue or wear-out. |

$$
F(\eta)=1-e^{-1}\approx0.632,
\qquad
t_{\mathrm{med}}=\eta(\ln2)^{1/\beta}.
$$

## 6. R distribution functions

| Need | Prefix | Normal example |
|---|---|---|
| PMF/PDF height | <code>d</code> | <code>dnorm(x, mean, sd)</code> |
| Lower-tail probability | <code>p</code> | <code>pnorm(x, mean, sd)</code> |
| Quantile | <code>q</code> | <code>qnorm(p, mean, sd)</code> |
| Random sample | <code>r</code> | <code>rnorm(n, mean, sd)</code> |

Replace <code>norm</code> with <code>binom</code>, <code>pois</code>,
<code>unif</code>, <code>lnorm</code>, <code>exp</code>,
<code>weibull</code> or <code>gamma</code>.

~~~r
# P(X > x)
pnorm(x, mean = mu, sd = sigma, lower.tail = FALSE)

# P(a < X < b)
pnorm(b, mean = mu, sd = sigma) -
  pnorm(a, mean = mu, sd = sigma)

# c such that P(X > c) = alpha
qnorm(alpha, mean = mu, sd = sigma, lower.tail = FALSE)
~~~

Parameter reminders:

- <code>pbinom(x, size = n, prob = p)</code>
- <code>ppois(x, lambda = rate * time)</code>
- <code>plnorm(t, meanlog = mu, sdlog = sigma)</code>
- <code>pexp(t, rate = lambda)</code>
- <code>pweibull(t, shape = beta, scale = eta)</code>
- <code>pgamma(t, shape = k, rate = lambda)</code>

Use <code>lower.tail = FALSE</code> for reliability $P(T>t)$.

## 7. Estimation

For complete data,

$$
\bar x=\frac1n\sum_ix_i,
\qquad
s=\sqrt{\frac1{n-1}\sum_i(x_i-\bar x)^2}.
$$

| Model | MLE |
|---|---|
| Normal | $\hat\mu=\bar x$, $\hat\sigma=\sqrt{\sum_i(x_i-\bar x)^2/n}$ |
| Lognormal | $\hat\mu=\frac1n\sum_{i=1}^n\ln x_i$, $\hat\sigma=\sqrt{\frac1n\sum_{i=1}^n(\ln x_i-\hat\mu)^2}$ |
| Exponential, complete | $\hat\lambda=1/\bar x$ |

For censored exponential data, with $r$ failures and total time on test
$\mathcal{T}=\sum_i t_i$,

$$
\hat\lambda=\frac r{\mathcal{T}},
\qquad
\hat{\operatorname{MTTF}}=\frac{\mathcal{T}}{r}.
$$

Likelihood with status $\delta_i$:

$$
L(\theta)
=
\prod_i
f(t_i;\theta)^{\delta_i}
R(t_i;\theta)^{1-\delta_i}.
$$

Complete-data plotting positions:

$$
\hat F(t_{(i)})=\frac{i}{n+1}
\quad\text{or}\quad
\frac{i-0.3}{n+0.4}.
$$

Weibull plot:

$$
\ln[-\ln(1-\hat F(t))]
=
\beta\ln t-\beta\ln\eta.
$$

Slope $=\beta$; intercept $a=-\beta\ln\eta$; therefore

$$
\eta=e^{-a/\beta}.
$$

Kaplan–Meier:

$$
\hat R(t)
=
\prod_{t_j\le t}
\frac{n_j-d_j}{n_j}.
$$

Censoring causes no downward step, but it reduces the later risk set.

## 8. Sampling distribution and CLT

$$
\bar X=\frac1n\sum_iX_i,
\qquad
E[\bar X]=\mu,
\qquad
\operatorname{SE}(\bar X)=\frac{\sigma}{\sqrt n}.
$$

| Situation | Standardisation |
|---|---|
| Normal population, $\sigma$ known | $\frac{\bar X-\mu}{\sigma/\sqrt n}\sim N(0,1)$, exact |
| Normal population, $\sigma$ unknown | $\frac{\bar X-\mu}{S/\sqrt n}\sim t_{n-1}$, exact |
| Non-normal population, large $n$ | $\bar X\dot\sim N(\mu,\sigma^2/n)$, CLT |

Course rule of thumb: $n\ge30$ is large, but strong skewness or far tails may
need more.

### Sample-size symbols

These formulas assume independent observations with population standard
deviation $\sigma$ known. They are exact for a normal population and
approximate when using the CLT.

| Symbol | Meaning |
|---|---|
| $n$ | Required number of observations. |
| $\bar X$, $\mu$ | Sample mean and true population mean. |
| $\sigma$ | Population standard deviation, not variance $\sigma^2$. |
| $\alpha$ | Allowed probability of falling outside the desired bound; e.g. $0.05$. |
| $1-\alpha$ | Desired probability of meeting the bound; e.g. $0.95$. |
| $d$ | Allowed upward deviation of the sample mean from $\mu$ (one-sided). |
| $E$ | Allowed error in either direction from $\mu$ (two-sided). |
| $z_p$ | Standard normal quantile: the value with probability $p$ to its left, so $P(Z\le z_p)=p$ for $Z\sim N(0,1)$. In R: <code>qnorm(p)</code>. |

**Read the subscripts as a whole:** $z_{1-\alpha}$ means the normal quantile
at probability $1-\alpha$, not $z_1-\alpha$.
Similarly, $z_{1-\alpha/2}$ uses probability $1-(\alpha/2)$.
The $\sigma$ after either quantile is a separate multiplication factor.

One-sided sample size: keep the probability of overshooting $\mu$ by at
least $d$ below or equal to $\alpha$.

$$
P(\bar X\ge\mu+d)\le\alpha
\quad\Rightarrow\quad
n\ge
\left(\frac{z_{1-\alpha}\times\sigma}{d}\right)^2.
$$

Two-sided sample size: keep the sample mean within $E$ of $\mu$ with
probability at least $1-\alpha$. Split the allowed error probability equally
between the two tails: $\alpha/2$ in each.

$$
P(|\bar X-\mu|<E)\ge1-\alpha
\quad\Rightarrow\quad
n\ge
\left(\frac{z_{1-\alpha/2}\times\sigma}{E}\right)^2.
$$

| Desired probability $1-\alpha$ | $\alpha$ | One-sided $z_{1-\alpha}$ | Two-sided $z_{1-\alpha/2}$ |
|---|---|---|---|
| $0.90$ | $0.10$ | $z_{0.90}\approx1.282$ | $z_{0.95}\approx1.645$ |
| $0.95$ | $0.05$ | $z_{0.95}\approx1.645$ | $z_{0.975}\approx1.960$ |
| $0.99$ | $0.01$ | $z_{0.99}\approx2.326$ | $z_{0.995}\approx2.576$ |

For example, with $\sigma=10$ hours and allowed error $2$ hours at
$1-\alpha=0.95$:

- One-sided: $n\ge(1.645\times10/2)^2\approx67.65$, so use $n=68$.
- Two-sided: $n\ge(1.960\times10/2)^2\approx96.04$, so use $n=97$.

Square the entire fraction, then round $n$ up to a whole number.

## 9. Final checks

- Did I define the random variable and its units?
- Is it a count or a continuous measurement?
- Does the distribution's support match the variable?
- Did I use variance or standard deviation correctly?
- Did I choose the requested lower, upper or two-sided tail?
- For a sample mean, did I use $\sigma/\sqrt n$?
- If $\sigma$ is unknown, is t exact or only approximate here?
- Did I account for censored observations?
- Does the fitted hazard shape match the physical failure mechanism?
- Is the final number a probability, rate, time, variance or standard
  deviation, and are its units correct?
