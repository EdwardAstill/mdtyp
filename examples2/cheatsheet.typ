#set page(paper: "a4", margin: 16mm, numbering: "1")
#set text(size: 10.5pt)
#show raw: set text(size: 8pt)
#show table: set text(size: 9pt)

= GENG5507 midsemester statistics cheat sheet

*Order of use:* translate the event → choose the model → calculate the probability or lifetime → estimate unknown parameters → handle sample means. This sheet covers the supplied statistics lectures through Week 5, Weibull analysis and their reliability applications. See #link("examples.md")[worked examples], #link("R.md")[R guide], #link("questions.md")[question collection] and #link("engineering-content.md")[engineering notes].


== 1. Decode the question

#table(
  columns: 2,
  align: (auto, auto,),
  table.header(
    [*Wording*],
    [*Mathematical event or tool*],
  ),
  [Not $A$],
  [$A^c=A'$],
  [$A$ and $B$],
  [Intersection $A ∩ B$],
  [$A$ or $B$, including both],
  [Union $A union B$],
  [$B$ given that $A$ happened],
  [$P(B ∣ A)$; restrict the population to $A$],
  [At least one],
  [$1-P("none")$],
  [Failure by time $t$],
  [$F(t)=P(T <= t)$],
  [Survives beyond $t$],
  [$R(t)=P(T>t)=1-F(t)$],
  [Probability from a boundary],
  [CDF, R prefix `p`],
  [Boundary from a probability],
  [Quantile, R prefix `q`],
  [One observation],
  [Use its SD $sigma$],
  [Mean of $n$ independent observations],
  [Use standard error $sigma/sqrt(n)$],
)

== 2. Probability rules: build, split, then reverse

For equally likely outcomes only, $P(A)=\#(A)/\#(Omega)$.

$ P(A^c)=1-P(A),wide
P(A union B)=P(A)+P(B)-P(A ∩ B). $


=== Conditional probability and intersection

$ P(B ∣ A)=frac(P(A ∩ B), P(A)),wide P(A)>0. $

*Correct version of the requested identity:*

$ P(B ∣ A)P(A)=P(A ∩ B)=P(A ∣ B)P(B). $

The final factor is *$P(B)$*, because the preceding conditional is given $B$. Multiply the probability along one branch of a probability tree to get an intersection.


=== Law of total probability: add all the routes to the event

$A$ and $A^c$ split the population into two non-overlapping groups containing everybody. Event $B$ can occur in either group:

$ P(B)=P(B ∣ A)P(A)+P(B ∣ A^c)P(A^c). $

This is a *weighted average of the within-group probabilities*, weighted by the group sizes. More generally, if $A_1,dots,A_k$ are mutually exclusive and exhaustive,

$ P(B)=sum_(i=1)^(k)P(B ∣ A_i)P(A_i). $

Example: supplier $A$ supplies $60 %$ of parts with defect probability $0.02$; the other supplier has defect probability $0.05$. Then $P(D)=0.02(0.60)+0.05(0.40)=0.032$.


=== Bayes: reverse the conditioning

$ P(A_j ∣ B)=frac(P(B ∣ A_j)P(A_j), P(B))
=frac(P(B ∣ A_j)P(A_j), sum_i P(B ∣ A_i)P(A_i)). $

In the supplier example, $P(A ∣ D)=0.012/0.032=0.375$. A defective part is not automatically most likely to come from the largest supplier.


=== Independence is different from mutual exclusion

#table(
  columns: 3,
  align: (auto, auto, auto,),
  table.header(
    [*Property*],
    [*Test*],
    [*Consequence*],
  ),
  [Independent],
  [$P(A ∩ B)=P(A)P(B)$],
  [Knowing one occurred does not change the probability of the other.],
  [Mutually exclusive/disjoint],
  [$P(A ∩ B)=0$],
  [Both cannot occur together. Positive-probability disjoint events are dependent.],
)
For independent events, $P("none")=product_i[1-P(A_i)]$. For $n$ independent equal-probability opportunities, $P("at least one")=1-(1-p)^n$.


== 3. PMF, PDF, CDF, mean and standard deviation

#table(
  columns: 3,
  align: (auto, auto, auto,),
  table.header(
    [*Quantity*],
    [*Discrete random variable*],
    [*Continuous random variable*],
  ),
  [Main model formula],
  [PMF $p(x)=P(X=x)$],
  [PDF $f(x)$ is density, not point probability],
  [Normalisation],
  [$sum_x p(x)=1$],
  [$integral_(-infinity)^(infinity)f(x)thin "dx"=1$],
  [CDF],
  [$F(x)=sum_(u <= x)p(u)$],
  [$F(x)=integral_(-infinity)^(x)f(u)thin "du"$],
  [Mean],
  [$mu=sum_x x p(x)$],
  [$mu=integral_(-infinity)^(infinity)x f(x)thin "dx"$],
  [Second moment],
  [$E[X^2]=sum_x x^2 p(x)$],
  [$E[X^2]=integral_(-infinity)^(infinity)x^2 f(x)thin "dx"$],
)
$ op("Var")(X)=E[X^2]-mu^2,wide sigma=sqrt(op("Var")(X)). $

For continuous $X$, $P(X=x)=0$ and $P(a<X<b)=F(b)-F(a)$; inclusion of the endpoints does not matter. For integer-valued $X$,

$ P(a <= X <= b)=F(b)-F(a-1),wide P(X >= k)=1-F(k-1). $

A PDF can exceed $1$; its *area* must sum to $1$. A PMF value is itself a probability.


== 4. Reliability, hazard and MTTF

Let $T >= 0$ be a continuous time to failure.

#table(
  columns: 3,
  align: (auto, auto, auto,),
  table.header(
    [*Function*],
    [*Formula*],
    [*Interpretation*],
  ),
  [Failure CDF],
  [$F(t)=P(T <= t)$],
  [Fraction failed by $t$],
  [Reliability/survival],
  [$R(t)=1-F(t)$],
  [Fraction surviving beyond $t$],
  [Failure PDF],
  [$f(t)=F'(t)=-R'(t)$],
  [Density of failure times],
  [Hazard],
  [$h(t)=f(t)/R(t)=-frac(d, "dt")ln R(t)$],
  [Instantaneous failure rate among current survivors],
  [Cumulative hazard],
  [$H(t)=integral_0^t h(u)thin "du"=-ln R(t)$],
  [Accumulated hazard; hence $R(t)=e^(-H(t))$],
)
The slides also write the hazard as $r(t)$ or $Z(t)$. Hazard has units of inverse time and is *not a probability*. For small $Delta t$,

$ P(t<T <= t+Delta t ∣ T>t)approx h(t)Delta t. $

*Yes: mean time to failure is the mean of the lifetime distribution.*

$ op("MTTF")=E[T]=integral_0^infinity t f(t)thin "dt"=integral_0^infinity R(t)thin "dt". $

A count or a strength has a mean, but that mean is not a time to failure. MTTF is not generally the median, Weibull scale $eta$, or $1/h(t)$; the reciprocal-hazard result applies to constant-hazard exponential lifetimes. Mean repair duration is *MTTR*, not MTTF.


=== Conditional remaining life

For $s,u >= 0$,

$ P(T>s+u ∣ T>s)=frac(R(s+u), R(s)),
wide
P(s<T <= s+u ∣ T>s)=1-frac(R(s+u), R(s)). $

Without the condition, $P(s<T <= s+u)=F(s+u)-F(s)$. Only the exponential model makes the conditional remaining-life distribution identical to the original lifetime distribution.


== 5. Distribution formula tables

All PMFs/PDFs below are zero outside their stated support. $Phi$ and $phi.alt$ are the standard normal CDF and PDF. $Gamma(a)=integral_0^infinity u^(a-1)e^(-u)thin "du"$, with $Gamma(a+1)=a Gamma(a)$ and $Gamma(m)=(m-1)!$ for positive integers $m$.


=== Counts and equally likely outcomes

#table(
  columns: 5,
  align: (auto, auto, auto, auto, auto,),
  table.header(
    [*Model and support*],
    [*PMF/PDF — main formula*],
    [*Mean*],
    [*SD*],
    [*Special property*],
  ),
  [Discrete uniform on integers $a,dots,b$; $k=b-a+1$],
  [$p(x)=1/k$],
  [$(a+b)/2$],
  [$sqrt((k^2-1)/12)$],
  [All $k$ outcomes equally likely. For arbitrary values $x_i$, mean is $sum x_i/k$.],
  [Binomial $X tilde.op upright("Bin")(n,p)$; $x=0,dots,n$],
  [$p(x)=binom(n, x) p^x(1-p)^(n-x)$],
  [$"np"$],
  [$sqrt(n p(1-p))$],
  [Fixed $n$, independent trials, two outcomes, constant $p$. Bernoulli is $n=1$.],
  [Poisson $X tilde.op upright("Pois")(m)$; $x=0,1,dots$],
  [$p(x)=e^(-m)m^x/x!$],
  [$m$],
  [$sqrt(m)$],
  [Mean = variance. For event rate $lambda$ over duration $t$, $m=lambda t$.],
  [Continuous uniform $U(a,b)$; $a <= x <= b$],
  [$f(x)=1/(b-a)$],
  [$(a+b)/2$],
  [$(b-a)/sqrt(12)$],
  [Equal-length subintervals have equal probability; median = mean.],
)
Counts have no lifetime hazard or MTTF in their usual interpretation. Their upper tail is still $1-F(x)$. For a uniform *lifetime* with $0 <= a<b$, MTTF is $(a+b)/2$; $R(t)=1$ for $t<a$, $(b-t)/(b-a)$ for $a <= t<b$, and $0$ for $t >= b$. Its hazard is $0$ before $a$ and $1/(b-t)$ for $a <= t<b$; hazard is undefined once no survivors remain.


=== Continuous measurements and lifetimes: PDF and moments

For gamma use *shape $k>0$, rate $lambda>0$*, equivalently scale $theta=1/lambda$. This sheet reserves $beta$ for Weibull shape; the slides sometimes use $beta$ for gamma shape too.

#table(
  columns: 4,
  align: (auto, auto, auto, auto,),
  table.header(
    [*Model and support*],
    [*PDF — main formula*],
    [*Mean / MTTF when a lifetime*],
    [*Standard deviation*],
  ),
  [Normal $N(mu,sigma^2)$; $x in RR$, $sigma>0$],
  [$f(x)=frac(1, sigma sqrt(2 pi))exp[-frac((x-mu)^2, 2 sigma^2)]$],
  [$mu$; lifetime approximation only],
  [$sigma$],
  [Lognormal; $ln T tilde.op N(mu,sigma^2)$; $t>0$],
  [$f(t)=frac(1, t sigma sqrt(2 pi))exp[-frac((ln t-mu)^2, 2 sigma^2)]$],
  [$m_T=e^(mu+sigma^2/2)$],
  [$m_T sqrt(e^(sigma^2)-1)$],
  [Exponential, rate $lambda>0$; $t >= 0$],
  [$f(t)=lambda e^(-lambda t)$],
  [$1/lambda$],
  [$1/lambda$],
  [Weibull, shape $beta>0$, scale $eta>0$; $t>0$],
  [$f(t)=frac(beta, eta)(t/eta)^(beta-1)e^(-(t/eta)^beta)$],
  [$eta Gamma(1+1/beta)$],
  [$eta sqrt(Gamma(1+2/beta)-[Gamma(1+1/beta)]^2)$],
  [Gamma, shape $k$, rate $lambda$; $t>0$],
  [$f(t)=frac(lambda^k, Gamma(k))t^(k-1)e^(-lambda t)$],
  [$k/lambda=k theta$],
  [$sqrt(k)/lambda=sqrt(k)theta$],
  [Student's $t_nu$, degrees of freedom $nu>0$; $x in RR$],
  [$f(x)=frac(Gamma((nu+1)/2), sqrt(nu pi)Gamma(nu/2))(1+x^2/nu)^(-(nu+1)/2)$],
  [$0$ for $nu>1$; otherwise undefined. Not a lifetime model.],
  [$sqrt(nu/(nu-2))$ for $nu>2$; otherwise no finite SD.],
)
The normal model allows negative values. It can approximate a lifetime if $P(T<0)=Phi(-mu/sigma)$ is negligible. An actual normal distribution has mean $mu$, but the nonnegative-lifetime identity $integral_0^infinity R(t)"dt"=mu$ is not exact for it. A truncated normal is a different model.


=== The same lifetime models: reliability, hazard and useful properties

For gamma, define $Q(k,x)=Gamma(k)^(-1)integral_x^infinity u^(k-1)e^(-u)thin "du"$; this is its upper-tail integral.

#table(
  columns: 4,
  align: (auto, auto, auto, auto,),
  table.header(
    [*Model*],
    [*Reliability $R(t)=1-F(t)$*],
    [*Hazard $h(t)$*],
    [*Special properties*],
  ),
  [Normal, $z=(t-mu)/sigma$],
  [$1-Phi(z)$],
  [$phi.alt(z)/{ sigma[1-Phi(z)]}$],
  [Symmetric; mean = median = mode; standardise with $z$.],
  [Lognormal, $z=(ln t-mu)/sigma$],
  [$1-Phi(z)$],
  [$phi.alt(z)/{ t sigma[1-Phi(z)]}$],
  [Positive, right-skewed; median $e^mu$; parameters refer to *log times*. Hazard rises then falls.],
  [Exponential],
  [$e^(-lambda t)$],
  [$lambda$],
  [*Memoryless*; mean = SD; median $(ln 2)/lambda$; no ageing.],
  [Weibull],
  [$e^(-(t/eta)^beta)$],
  [$frac(beta, eta)(t/eta)^(beta-1)$],
  [$beta<1$: decreasing hazard; $beta=1$: exponential; $beta>1$: increasing hazard. $F(eta)=0.6321$.],
  [Gamma],
  [$Q(k,lambda t)$],
  [$f(t)/Q(k,lambda t)$],
  [$k=1$: exponential. Integer $k$: sum of $k$ iid exponential waiting times.],
)
*Beta is named but not developed in the probability-model lecture.* For completeness, $X tilde.op upright("Beta")(a,b)$ has support $0<x<1$, PDF $x^(a-1)(1-x)^(b-1)/B(a,b)$, mean $a/(a+b)$ and SD $sqrt("ab"/[(a+b)^2(a+b+1)])$, where $B(a,b)=Gamma(a)Gamma(b)/Gamma(a+b)$. It models proportions, not unscaled lifetimes; $a=b=1$ is $U(0,1)$.


=== What the distributions describe: quick examples

#table(
  columns: 2,
  align: (auto, auto,),
  table.header(
    [*Model*],
    [*Description and engineering use*],
  ),
  [Discrete uniform],
  [Random choice among equally likely values: fair die or randomly selected component label.],
  [Binomial],
  [Count within a fixed number of trials: survivors among four independent bulbs, each surviving with probability $0.9$.],
  [Poisson],
  [Count over an interval under constant rate and independent increments: breakdowns in a month or defects along a cable.],
  [Continuous uniform],
  [Bounded uncertainty with constant density: an arrival time equally likely anywhere in a fixed interval. Bounds alone do not prove uniformity.],
  [Normal],
  [Symmetric variation about a target: material strength or dimension; also sample means under the CLT.],
  [Lognormal],
  [Multiplicative positive variation: right-skewed repair duration or fatigue life when log times are approximately normal.],
  [Exponential],
  [Time to the next event in a homogeneous Poisson process: random failures with constant hazard.],
  [Weibull],
  [Lifetime with monotone age-dependent hazard: weak items failing early, random failures, or wear-out. A single two-parameter Weibull does not model the whole bathtub curve.],
  [Gamma],
  [Accumulated positive waiting time: time until the $k$th Poisson-process event when $k$ is an integer.],
  [Beta],
  [A proportion constrained to $[0,1]$: uncertainty about a defect probability or fraction.],
  [Student's $t$],
  [Symmetric, heavier-tailed reference model for a standardised sample mean when the population SD is estimated; use $nu=n-1$ for a normal sample. Approaches standard normal as $nu$ increases.],
)

=== Quantiles: solve for the time

Let $t_p$ satisfy $F(t_p)=p$, where $0<p<1$.

#table(
  columns: 2,
  align: (auto, auto,),
  table.header(
    [*Model*],
    [*Failure percentile $t_p$*],
  ),
  [Normal],
  [$mu+sigma Phi^(-1)(p)$],
  [Lognormal],
  [$exp[mu+sigma Phi^(-1)(p)]$],
  [Exponential],
  [$-ln(1-p)/lambda$],
  [Weibull],
  [$eta[-ln(1-p)]^(1/beta)$],
)
If the target is reliability $r$, substitute $p=1-r$: for Weibull, $t=eta(-ln r)^(1/beta)$. A $B_(10)$ life means *10% failed*, so use $p=0.10$, not reliability $0.10$.


== 6. System reliability: connect components correctly

Assume independent component states at the same time $t$ unless dependence is explicitly modelled.

#table(
  columns: 3,
  align: (auto, auto, auto,),
  table.header(
    [*System*],
    [*It operates when…*],
    [*Reliability*],
  ),
  [Series],
  [Every component operates],
  [$R_(upright("sys"))(t)=product_(i=1)^n R_i(t)$],
  [Active parallel],
  [At least one operates],
  [$R_(upright("sys"))(t)=1-product_(i=1)^n[1-R_i(t)]$],
  [$k$-out-of-$n$, identical reliability $R$],
  [At least $k$ components operate],
  [$R_(upright("sys"))=sum_(j=k)^n binom(n, j) R^j(1-R)^(n-j)$],
)
For equal component reliability $R$, series gives $R^n$ and parallel gives $1-(1-R)^n$. For a complex network, condition on a key component $C$:

$ R_(upright("sys"))=P(S ∣ C)R_C+P(S ∣ C^c)(1-R_C). $

This is the law of total probability. Reduce each conditional network separately; do not count a shared component twice as if its states were independent.

For an independent series system, $h_(upright("sys"))(t)=sum_i h_i(t)$. Consequently:

- Exponential components: $lambda_(upright("sys"))=sum_i lambda_i$ and $upright("MTTF")_(upright("sys"))=1/sum_i lambda_i$.
- Weibull components with common shape $beta$: $eta_(upright("sys"))=(sum_i eta_i^(-beta))^(-1/beta)$ and $upright("MTTF")_(upright("sys"))=eta_(upright("sys"))Gamma(1+1/beta)$.

Perfect cold standby with $n$ identical exponential units, one active at a time, no standby failures and perfect switching has $R_(upright("sys"))(t)=e^(-lambda t)sum_(j=0)^(n-1)(lambda t)^j/j!$ and MTTF $n/lambda$. This differs from active parallel operation. Availability and maintenance decisions are in the engineering notes.


== 7. Estimate unknown parameters from data


=== Complete observations

$ macron(x)=frac(1, n)sum_i x_i,wide
s^2=frac(sum_i(x_i-macron(x))^2, n-1),wide s=sqrt(s^2). $

#table(
  columns: 2,
  align: (auto, auto,),
  table.header(
    [*Model*],
    [*Maximum-likelihood estimates (complete independent observations)*],
  ),
  [Normal],
  [$hat(mu)=macron(x)$, $hat(sigma)=sqrt(sum_i(x_i-macron(x))^2/n)$],
  [Lognormal],
  [Apply the normal MLE formulas to $y_i=ln x_i$; then fitted mean lifetime is $e^(hat(mu)+hat(sigma^2)/2)$.],
  [Exponential],
  [$hat(lambda)=n/sum_i x_i=1/macron(x)$; fitted MTTF $=macron(x)$.],
)
*Sample SD uses $n-1$; normal MLE SD uses $n$.* R's `sd(x)` returns the sample SD. A sample coefficient of variation $s/macron(x)$ far from $1$ is evidence against an exponential fit, not a conclusive test by itself.


=== Censoring and total exposure

Right-censored at $c$ means *known to survive beyond $c$*, not failed at $c$. Left-censored means failed before observation; interval-censored means failure occurred between inspections. The course mainly uses right censoring/suspensions.

Let $n$ be the original item count, $r$ the observed failures and $cal(T)$ total accumulated time on test.

#table(
  columns: 2,
  align: (auto, auto,),
  table.header(
    [*Data collection*],
    [*Total time on test*],
  ),
  [Complete observations],
  [$cal(T)=sum_(i=1)^n t_i$],
  [Type I: stop at fixed time $t_*$],
  [$cal(T)=sum_(i=1)^r t_i+(n-r)t_*$],
  [Type II: stop at the $r$th failure, time $t_r$],
  [$cal(T)=sum_(i=1)^r t_i+(n-r)t_r$],
  [Different independent censoring times],
  [Sum every item's actual observed exposure, including survivors.],
)
*Under the exponential lifetime model*, with $r>0$,

$ hat(lambda)=frac(r, cal(T)),wide
hat(upright("MTTF"))=frac(cal(T), r),wide
hat(upright("SD"))(T)=frac(cal(T), r). $

Do not generalise the last identity to Weibull or other lifetimes. With no failures, $cal(T)/r$ does not give a finite MTTF estimate. Deleting survivors or applying `mean`/`sd` to censored times as though they were failures misrepresents the data.


=== Likelihood: retain the information in censored observations

For independent observations with non-informative right censoring and $delta_i=1$ for failure, $0$ for suspension,

$ L(theta)=product_i f(t_i;theta)^(delta_i)R(t_i;theta)^(1-delta_i),
wide ell(theta)=ln L(theta). $

Maximise $L$ or $ell$ to estimate $theta$. Failures contribute $f$; suspensions contribute $R$. Complete-data Weibull log-likelihood is

$ ell(beta,eta)=n ln beta-n beta ln eta
 +(beta-1)sum_i ln t_i-sum_i(t_i/eta)^beta. $

Both Weibull parameters usually require numerical fitting. For fixed $beta$, $hat(eta)=(sum_i t_i^beta/n)^(1/beta)$.


== 8. Empirical reliability and Weibull plots


=== Complete-data ranking

Sort failure times as $t_((1))<= dots.c <= t_((n))$.

#table(
  columns: 2,
  align: (auto, auto,),
  table.header(
    [*Rank choice*],
    [*Estimated failure probability at $t_((i))$*],
  ),
  [Empirical CDF],
  [$i/n$ for distinct failures],
  [Mean rank],
  [$i/(n+1)$],
  [Approximate median rank (Benard)],
  [$(i-0.3)/(n+0.4)$],
)
Use the rank method specified in the question. Mean/median ranks avoid $F=1$, which cannot be double-log transformed.


=== Weibull straight-line transformation

$ x_i=ln t_((i)),wide
 y_i=ln[-ln(1-hat(F)(t_((i))))],
wide y=a+"bx". $

$ hat(beta)=b,wide hat(eta)=e^(-a/b). $

An approximately straight plot supports a Weibull fit. Slope measures ageing; scale is the $63.2 %$ failure time, *not generally the mean*. Median $=eta(ln 2)^(1/beta)$.

For the shifted three-parameter Weibull with failure-free period $gamma >= 0$, replace $t$ by $t-gamma$ for $t>gamma$. Reliability is $1$ before $gamma$, mean is $gamma+eta Gamma(1+1/beta)$, SD is unchanged, and characteristic failure time is $gamma+eta$. Use the location shift only if specified or justified.


=== Median ranks with suspensions

Sort *all* observations, retaining failure/suspension labels. Let $j_(upright("prev"))=0$ initially and $m$ be the number of all observations preceding the current failure. Update only at a failure:

$ upright("INC")=frac(n+1-j_(upright("prev")), 1+n-m),wide
j=j_(upright("prev"))+upright("INC"),wide
hat(F)(t)=frac(j-0.3, n+0.4). $

Then set $j_(upright("prev"))=j$ for the next failure. Suspensions affect ordering and risk but receive no failure plotting point. With no suspensions this reduces to ordinary integer ranks. This method and Kaplan–Meier below produce different estimates; use the requested method.


=== Kaplan–Meier survival estimate

At each distinct failure time $t_j$, $n_j$ is the number at risk *immediately before* the failure time and $d_j$ is the number failing then:

$ hat(R)(t)=product_(t_j <= t)( 1-frac(d_j, n_j)),
wide hat(F)(t)=1-hat(R)(t). $

Failures step the survival curve down. Censoring makes no downward step, but removes subjects from later risk sets. If failures and censoring share a recorded time, conventionally count those censored as at risk for the failures at that time. The curve is constant between failures.


== 9. Sampling distributions and the CLT

A *parameter* describes the population; a *statistic* is calculated from the sample. A sampling distribution describes how a statistic changes across repeated samples. A good random sample avoids selection bias; increasing $n$ does not fix biased selection.

For constants $a,b$, $E["aX"+"bY"]="aE"[X]+"bE"[Y]$. If $X,Y$ are independent, $op("Var")("aX"+"bY")=a^2 op("Var")(X)+b^2 op("Var")(Y)$; otherwise include $2"ab" op("Cov")(X,Y)$.

For iid observations with finite mean $mu$ and variance $sigma^2$:

#table(
  columns: 4,
  align: (auto, auto, auto, auto,),
  table.header(
    [*Statistic*],
    [*Mean*],
    [*Variance*],
    [*SD*],
  ),
  [One $X$],
  [$mu$],
  [$sigma^2$],
  [$sigma$],
  [Sum $S_n=sum_i X_i$],
  [$n mu$],
  [$n sigma^2$],
  [$sqrt(n)sigma$],
  [Mean $macron(X)=S_n/n$],
  [$mu$],
  [$sigma^2/n$],
  [$sigma/sqrt(n)$ (standard error)],
)
#table(
  columns: 3,
  align: (auto, auto, auto,),
  table.header(
    [*Situation*],
    [*Standardisation and distribution*],
    [*Validity*],
  ),
  [Normal population; known $sigma$],
  [$Z=(macron(X)-mu)/(sigma/sqrt(n))tilde.op N(0,1)$],
  [Exact for any $n$],
  [Normal population; unknown $sigma$],
  [$T=(macron(X)-mu)/(S/sqrt(n))tilde.op t_(n-1)$],
  [Exact for any $n$],
  [Non-normal population; large $n$],
  [$macron(X)approx N(mu,sigma^2/n)$],
  [CLT approximation; iid and finite variance],
)
The course's $n >= 30$ rule is a guide, not a guarantee for strong skew or extreme tails. The *mean's distribution* approaches normal; the original population does not become normal. Student's $t$ has heavier tails than normal and approaches normal as its degrees of freedom increase. With a small non-normal sample, the usual $t$ result is not exact.

For iid exponential lifetimes with rate $lambda$, the exact sum is $S_n tilde.op upright(Gamma)(n,"rate"=lambda)$ and the exact mean is $macron(X)tilde.op upright(Gamma)(n,"rate"=n lambda)$. For a Weibull population, first calculate $mu,sigma$ from its moment formulas, then use the CLT for the mean; do not apply the individual Weibull CDF to $macron(T)$.


=== Sample size for a probability/accuracy target

Here $z_p=Phi^(-1)(p)$ is a *lower-tail quantile*. Some supplied tables label critical values by upper-tail probability instead; translate the tail before reading them.

#table(
  columns: 2,
  align: (auto, auto,),
  table.header(
    [*Requirement under a normal/CLT model*],
    [*Required sample size*],
  ),
  [$P(macron(X)>=mu+d)<= alpha$, $d>0$, $alpha<0.5$],
  [$n >=(z_(1-alpha)sigma/d)^2$],
  [$P(|macron(X)-mu|<E)>= 1-alpha$],
  [$n >=(z_(1-alpha/2)sigma/E)^2$],
)
Round *up* and recheck the probability at the resulting integer. Two-sided accuracy splits $alpha$ equally between the tails. A fourfold sample size halves the standard error.


== 10. R reminders and final checks

#table(
  columns: 2,
  align: (auto, auto,),
  table.header(
    [*Need*],
    [*R convention*],
  ),
  [PMF/PDF],
  [`d...` (a continuous density is not a probability)],
  [$P(X <= x)$],
  [`p...(x, ...)`],
  [$P(X>x)$ / reliability],
  [`p...(x, ..., lower.tail = FALSE)`],
  [Boundary for lower-tail probability $p$],
  [`q...(p, ...)`],
  [Generate $n$ observations],
  [`r...(n, ...)`],
)
Suffixes: `binom`, `pois`, `unif`, `norm`, `lnorm`, `exp`, `weibull`, `gamma`, `beta`, `t`. Normal uses `sd`, lognormal uses `meanlog`/`sdlog`, exponential uses `rate`, Weibull uses `shape`/`scale`, gamma uses `shape` with *either* `rate` *or* `scale`. Poisson's `lambda` argument is the expected count over the requested interval, not automatically the rate per hour.

Before submitting: define the variable and units; check independence and support; distinguish PDF from probability, SD from variance, and individual from sample mean; choose the correct tail and discrete endpoint; retain censored exposure; report probabilities between $0$ and $1$ with sensible time/rate units.


== Source map

Source links refer to the supplied files. Page numbers below are *PDF page positions*, which may differ from printed slide numbers. The essential summary also contains later confidence-interval and hypothesis-testing material; those later topics are not developed here because this sheet follows the supplied statistics lectures through Week 5.

- #link("../probability-content/slides-pdf/01-GENG5507-STATS-Basics.pdf")[Probability basics] and #link("../probability-content/slides-pdf/02-GENG5507-STATS-extra-slides.pdf")[additional probability slides]: events, conditional probability and reliability language.
- #link("../probability-content/slides-pdf/03-GENG5507-STATS-ProbabilityModels.pdf")[Probability models]: model definitions and moments; gamma and the beta/uniform reading pointers on PDF p. 43. Continuous uniform and beta formulas are compact reference supplements for those named models.
- #link("../probability-content/slides-pdf/04-GENG5507-STATS-HazardRate.pdf")[Hazard rate]: reliability, hazard, MTTF and system applications.
- #link("../probability-content/slides-pdf/05-GENG5507-STATS-ModelEstimation.pdf")[Model estimation]: complete/censored data, likelihood and Weibull fitting; Kaplan–Meier on PDF pp. 34–35.
- #link("../probability-content/slides-pdf/Weibull-analysis.pdf")[Weibull analysis]: shifted model, probability paper and adjusted median ranks.
- #link("../probability-content/slides-pdf/06-GENG5507-STATS-lecture-week5-CLT.pdf")[Random sampling and CLT]: sampling distributions, $z$, $t$ and sample size.
- #link("../GENG5507-%20ESSENTIAL%20SUMMARY%20AND%20TABLES.pdf")[Essential summary and tables]: printed formula pp. 1–9; probability, distributions, system reliability and data ranking. Formula conditions and parameter conventions are made explicit here.
- #link("../questions/probability-questions/lecture/")[Lecture questions] and #link("../questions/probability-questions/prac/")[practical questions]: question patterns addressed by this sheet.
