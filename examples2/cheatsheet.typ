#set page(paper: "a4")

#set text(font: ("Helvetica", "Arial",))
#set page(margin: 15mm)
#set page(numbering: "1")
#set text(size: 12pt)

= GENG5507 Probability and Statistics Cheatsheet

#outline(title: [Table of contents])

Use this after learning the concepts in the #link("./README.md")[study map]\. The #link("../probability-examples/worked-examples.md")[worked examples] show how the formulas are applied\.


== 1\. Translate the wording

#table(
  columns: 2,
  align: (auto, auto,),
  stroke: (x: none, y: 0.5pt),
  table.header(
    [*Words*],
    [*Symbol*],
  ),
  [not $A$],
  [$A^c$],
  [$A$ or $B$, including both],
  [$A union B$],
  [$A$ and $B$],
  [$A inter B$],
  [$A$, given $B$],
  [$P(A | B)$],
  [fails by $t$],
  [$F(t)=P(T <= t)$],
  [survives beyond $t$],
  [$R(t)=P(T>t)$],
  [between $a$ and $b$],
  [$F(b)-F(a)$],
  [at least one],
  [$1-P("none")$],
  [probability from a boundary],
  [CDF\: R prefix p],
  [boundary from a probability],
  [quantile\: R prefix q],
)

== 2\. Event rules

$ P(A^c)=1-P(A) $

$ P(A union B)=P(A)+P(B)-P(A inter B) $

$ P(A | B)=frac(P(A inter B), P(B)) $

$ P(A inter B)=P(A | B)P(B) $

For independent events,

$ P(A inter B)=P(A)P(B). $

For independent $A_1,dots,A_n$,

$ P("at least one")
=
1-product_(i=1)^n P(A_i^c). $

If each has probability $p$,

$ P("at least one")=1-(1-p)^n. $

#strong[Law of total probability\:] split $B$ into the cases where $A$ happens and where it does not\. For $0<P(A)<1$,

$ P(B)=P(B | A)P(A)+P(B | A^c)P(A^c). $

Weight each conditional probability by the probability of its case; $P(B | A)+P(B | A^c)$ alone is not the rule\. Equivalently, $P(B)=P(B inter A)+P(B inter A^c)$\.

More generally, if $B_1,dots,B_k$ form a partition (mutually exclusive, exhaustive cases with positive probabilities),

$ P(A)=sum_(i=1)^k P(A | B_i)P(B_i). $

Bayes\:

$ P(B_j | A)
=
frac(P(A | B_j)P(B_j), sum_i P(A | B_i)P(B_i)). $

#strong[Do not confuse\:]

#list(tight: true,
[
disjoint\: $P(A inter B)=0$;
],
[
independent\: $P(A inter B)=P(A)P(B)$\.
],
)

Positive\-probability disjoint events are not independent\.


== 3\. Random\-variable functions

#table(
  columns: 3,
  align: (auto, auto, auto,),
  stroke: (x: none, y: 0.5pt),
  table.header(
    [*Object*],
    [*Discrete*],
    [*Continuous*],
  ),
  [Probability model],
  [PMF $p(x)=P(X=x)$],
  [PDF $f(x)$, a density],
  [Total probability],
  [$sum_x p(x)=1$],
  [$integral f(x)thin "dx"=1$],
  [Interval probability],
  [Sum relevant masses],
  [$integral_a^b f(x)thin "dx"$],
  [CDF],
  [$F(x)=P(X <= x)$],
  [$F(x)=integral_(-infinity)^x f(u)thin "du"$],
  [Mean],
  [$sum_x x p(x)$],
  [$integral x f(x)thin "dx"$],
)
$ op("Var")(X)=E[X^2]-E[X]^2,
wide
op("SD")(X)=sqrt(op("Var")(X)). $

For a continuous variable,

$ P(a<X<b)=F(b)-F(a),
wide
P(X=x)=0. $


== 4\. Reliability and hazard

Let $T >= 0$ be the time to failure\. The #strong[failure function] (CDF) is

$ F(t)=P(T <= t), $

the probability that the item #strong[has failed by time $t$]\. The #strong[reliability function] (survival function) is

$ R(t)=P(T>t), $

the probability that the item #strong[has not failed by time $t$] and survives beyond it\. These are complementary events, so

$ F(t)+R(t)=1,
wide
R(t)=1-F(t). $

For a continuous lifetime, the other functions are\:

#table(
  columns: 3,
  align: (auto, auto, auto,),
  stroke: (x: none, y: 0.5pt),
  table.header(
    [*Function*],
    [*What it is*],
    [*Meaning*],
  ),
  [$f(t)=F'(t)=-R'(t)$],
  [Failure\-time density (PDF)],
  [Describes how concentrated failures are near $t$\. For small $Delta t$, $f(t)Delta t approx P(t<T <= t+Delta t)$\.],
  [$h(t)=f(t)/R(t)$],
  [Hazard rate],
  [Instantaneous failure rate at age $t$ #strong[among items that have survived to $t$]\.],
  [$H(t)=integral_0^t h(u)thin "du"$],
  [Cumulative hazard],
  [Total hazard accumulated from time $0$ to $t$\.],
)
Thus, for small $Delta t$,

$ P(t<T <= t+Delta t | T>t)
approx h(t)Delta t. $

The functions describe the same lifetime distribution and can be converted using

$ R(t)=e^(-H(t)),
wide
f(t)=h(t)R(t). $

The mean time to failure is the expected lifetime, or equivalently the area under the reliability curve\:

$ op("MTTF")
=E[T]
=integral_0^infinity t f(t)thin "dt"
=integral_0^infinity R(t)thin "dt". $

Both $f(t)$ and $h(t)$ are densities or rates, not probabilities\. If time is measured in hours, their units are $1/"hour"$\.


=== Multicomponent systems

At time $t$, let component $i$ have reliability $R_i(t)$\. If component failures are independent\:

#table(
  columns: 3,
  align: (auto, auto, auto,),
  stroke: (x: none, y: 0.5pt),
  table.header(
    [*System*],
    [*It works when*],
    [*System reliability*],
  ),
  [Series],
  [Every component works],
  [$R_(upright("series"))(t)=product_(i=1)^m R_i(t)$],
  [Parallel],
  [At least one component works],
  [$R_(upright("parallel"))(t)=1-product_(i=1)^m[1-R_i(t)]$],
)
For $m$ independent components with identical reliability $R(t)$,

$ R_(upright("series"))(t)=R(t)^m,
wide
R_(upright("parallel"))(t)=1-[1-R(t)]^m. $

For either system, $F_(upright("sys"))(t)=1-R_(upright("sys"))(t)$\. The product formulas do not apply directly when component failures are dependent\.

For an independent series system, cumulative hazards and hazard rates add\:

$ H_(upright("series"))(t)=sum_(i=1)^m H_i(t),
wide
h_(upright("series"))(t)=sum_(i=1)^m h_i(t). $

If component $i$ has a constant exponential failure rate $lambda_i$, then

$ lambda_(upright("series"))=sum_(i=1)^m lambda_i,
wide
R_(upright("series"))(t)
=exp (-t sum_(i=1)^m lambda_i ). $


== 5\. Choose a distribution

#table(
  columns: 4,
  align: (auto, auto, right, right,),
  stroke: (x: none, y: 0.5pt),
  table.header(
    [*Model*],
    [*Use when*],
    [*Mean*],
    [*Standard deviation*],
  ),
  [Binomial $(n,p)$],
  [Success count in fixed $n$ independent trials],
  [$"np"$],
  [$sqrt(n p(1-p))$],
  [Poisson $(mu=lambda t)$],
  [Event count in an interval],
  [$mu$],
  [$sqrt(mu)$],
  [Uniform $[a,b]$],
  [All positions in a bounded interval equally likely],
  [$(a+b)/2$],
  [$(b-a)/sqrt(12)$],
  [Normal $(mu,sigma^2)$],
  [Symmetric measurements],
  [$mu$],
  [$sigma$],
  [Lognormal $(mu,sigma^2)$],
  [$ln T tilde.op N(mu,sigma^2)$],
  [$e^(mu+sigma^2/2)$],
  [$e^(mu+sigma^2/2)sqrt(e^(sigma^2)-1)$],
  [Exponential $(lambda)$],
  [Constant\-hazard lifetime],
  [$1/lambda$],
  [$1/lambda$],
  [Weibull $(beta,eta)$],
  [Flexible monotone\-hazard lifetime],
  [$eta Gamma(1+1/beta)$],
  [$eta sqrt(Gamma(1+2/beta)-Gamma(1+1/beta)^2)$],
  [Gamma, shape $k$, rate $lambda$],
  [Positive staged waiting time],
  [$k/lambda$],
  [$sqrt(k)/lambda$],
)

=== CDF, reliability, hazard and MTTF at a glance

For continuous lifetimes, $R(t)=1-F(t)$ and $h(t)=f(t)/R(t)$ wherever $R(t)>0$\. All scale, shape and rate parameters below are positive\. Write $phi.alt(z)=e^(-z^2/2)/sqrt(2 pi)$ and $Phi(z)=P(Z <= z)$ for the standard normal PDF and CDF\.

#table(
  columns: 5,
  align: (auto, auto, auto, auto, auto,),
  stroke: (x: none, y: 0.5pt),
  table.header(
    [*Distribution*],
    [*CDF $F(t)$*],
    [*Reliability $R(t)$*],
    [*Hazard $h(t)$*],
    [*MTTF $E[T]$*],
  ),
  [Uniform $[a,b]$, $0 <= a<b$; $a <= t<b$],
  [$(t-a)/(b-a)$],
  [$(b-t)/(b-a)$],
  [$1/(b-t)$],
  [$(a+b)/2$],
  [Normal $(mu,sigma^2)$; $z=(t-mu)/sigma$],
  [$Phi(z)$],
  [$1-Phi(z)$],
  [$phi.alt(z)/[sigma(1-Phi(z))]$],
  [$mu$ (mean; lifetime approximation only)],
  [Lognormal $(mu,sigma^2)$; $z=(ln t-mu)/sigma$, $t>0$],
  [$Phi(z)$],
  [$1-Phi(z)$],
  [$phi.alt(z)/[t sigma(1-Phi(z))]$],
  [$e^(mu+sigma^2/2)$],
  [Exponential $(lambda)$; $t >= 0$],
  [$1-e^(-lambda t)$],
  [$e^(-lambda t)$],
  [$lambda$],
  [$1/lambda$],
  [Weibull $(beta,eta)$; $t>0$],
  [$1-e^(-(t/eta)^beta)$],
  [$e^(-(t/eta)^beta)$],
  [$(beta/eta)(t/eta)^(beta-1)$],
  [$eta Gamma(1+1/beta)$],
  [Gamma, shape $k$, rate $lambda$; $t>0$],
  [$G_k(lambda t)$],
  [$1-G_k(lambda t)$],
  [$lambda^k t^(k-1)e^(-lambda t)/[Gamma(k)(1-G_k(lambda t))]$],
  [$k/lambda$],
)
Here the gamma CDF uses

$ G_k(y)=frac(1, Gamma(k))integral_0^y u^(k-1)e^(-u)thin "du". $

For integer $k >= 1$, gamma reliability also has the finite\-sum form

$ R(t)=e^(-lambda t)sum_(j=0)^(k-1)frac((lambda t)^j, j!). $

For uniform lifetimes, $F=0$, $R=1$, $h=0$ when $t<a$; $F=1$, $R=0$ when $t >= b$, where hazard is undefined\. For lognormal, exponential, Weibull and gamma lifetimes, $F(t)=0$ and $R(t)=1$ for $t <= 0$; hazard at $0$ is interpreted by its right\-hand limit\. The untruncated normal allows negative values, so its mean $mu$ is only an approximate MTTF when the negative tail is negligible\. The nonnegative\-lifetime identity $E[T]=integral_0^infinity R(t)thin "dt"$ does not hold for that untruncated model\.

#strong[Count distributions\:] binomial and Poisson CDFs are sums of masses\. For $x >= 0$,

$ F_(upright("bin"))(x)=sum_(j=0)^(min(n,floor.l x floor.r))
binom(n, j) p^j(1-p)^(n-j),
wide
F_(upright("Pois"))(x)=sum_(j=0)^(floor.l x floor.r)frac(mu^j e^(-mu), j!). $

Both CDFs are $0$ for $x<0$, and $P(X>x)=1-F(x)$\. Their means $"np"$ and $mu$ are counts, not MTTFs\. If an integer\-valued variable instead represents lifetime in discrete time steps, use the #strong[discrete hazard] $P(T=j | T >= j)=p(j)/[1-F(j-1)]$, not the continuous hazard formula, and $E[T]=sum_(j=0)^infinity P(T>j)$ for $T >= 0$\.


=== Binomial

$ P(X=x)=binom(n, x) p^x(1-p)^(n-x). $

Check\: fixed $n$, two outcomes, constant $p$, independent trials\.


=== Poisson

$ P(X=x)=frac(mu^x e^(-mu), x!),
wide
mu=lambda t. $

Check\: count, constant rate, independent increments\.


=== Normal

$ Z=frac(X-mu, sigma)tilde.op N(0,1). $

R uses $sigma$, even when the model is written $N(mu,sigma^2)$\.


=== Lognormal

$ P(T <= t)
=
Phi ( frac(ln t-mu, sigma)). $

Parameters describe $ln T$, not $T$\.


=== Exponential

$ f(t)=lambda e^(-lambda t),
quad
F(t)=1-e^(-lambda t),
quad
R(t)=e^(-lambda t),
quad
h(t)=lambda. $

$ P(T>s+t | T>s)=P(T>t). $


=== Weibull

$ F(t)=1-e^(-(t/eta)^beta),
wide
R(t)=e^(-(t/eta)^beta), $

$ h(t)=frac(beta, eta)(t/eta)^(beta-1). $

#table(
  columns: 2,
  align: (right, auto,),
  stroke: (x: none, y: 0.5pt),
  table.header(
    [*Shape*],
    [*Meaning*],
  ),
  [$beta<1$],
  [Decreasing hazard; early defects\.],
  [$beta=1$],
  [Constant hazard; exponential\.],
  [$beta>1$],
  [Increasing hazard; fatigue or wear\-out\.],
)
$ F(eta)=1-e^(-1)approx 0.632,
wide
t_(upright(med))=eta(ln 2)^(1/beta). $


== 6\. R distribution functions

#table(
  columns: 3,
  align: (auto, auto, auto,),
  stroke: (x: none, y: 0.5pt),
  table.header(
    [*Need*],
    [*Prefix*],
    [*Normal example*],
  ),
  [PMF\/PDF height],
  [d],
  [dnorm(x, mean, sd)],
  [Lower\-tail probability],
  [p],
  [pnorm(x, mean, sd)],
  [Quantile],
  [q],
  [qnorm(p, mean, sd)],
  [Random sample],
  [r],
  [rnorm(n, mean, sd)],
)
Replace norm with binom, pois, unif, lnorm, exp, weibull or gamma\.

#raw(lang: "r", "# P(X > x)\npnorm(x, mean = mu, sd = sigma, lower.tail = FALSE)\n\n# P(a < X < b)\npnorm(b, mean = mu, sd = sigma) -\n  pnorm(a, mean = mu, sd = sigma)\n\n# c such that P(X > c) = alpha\nqnorm(alpha, mean = mu, sd = sigma, lower.tail = FALSE)", block: true)

Parameter reminders\:

#list(tight: true,
[
pbinom(x, size \= n, prob \= p)
],
[
ppois(x, lambda \= rate \* time)
],
[
plnorm(t, meanlog \= mu, sdlog \= sigma)
],
[
pexp(t, rate \= lambda)
],
[
pweibull(t, shape \= beta, scale \= eta)
],
[
pgamma(t, shape \= k, rate \= lambda)
],
)

Use lower\.tail \= FALSE for reliability $P(T>t)$\.


== 7\. Estimation

For complete data,

$ macron(x)=frac(1, n)sum_i x_i,
wide
s=sqrt(frac(1, n-1)sum_i(x_i-macron(x))^2). $

#table(
  columns: 2,
  align: (auto, auto,),
  stroke: (x: none, y: 0.5pt),
  table.header(
    [*Model*],
    [*MLE*],
  ),
  [Normal],
  [$hat(mu)=macron(x)$, $hat(sigma)=sqrt(sum_i(x_i-macron(x))^2/n)$],
  [Lognormal],
  [$hat(mu)=frac(1, n)sum_(i=1)^n ln x_i$, $hat(sigma)=sqrt(frac(1, n)sum_(i=1)^n(ln x_i-hat(mu))^2)$],
  [Exponential, complete],
  [$hat(lambda)=1/macron(x)$],
)
For censored exponential data, with $r$ failures and total time on test $cal(T)=sum_i t_i$,

$ hat(lambda)=frac(r, cal(T)),
wide
hat(op("MTTF"))=frac(cal(T), r). $

Likelihood with status $delta_i$\:

$ L(theta)
=
product_i
f(t_i;theta)^(delta_i)
R(t_i;theta)^(1-delta_i). $

Complete\-data plotting positions\:

$ hat(F)(t_((i)))=frac(i, n+1)
quad"or"quad
frac(i-0.3, n+0.4). $

Weibull plot\:

$ ln[-ln(1-hat(F)(t))]
=
beta ln t-beta ln eta. $

Slope $=beta$; intercept $a=-beta ln eta$; therefore

$ eta=e^(-a/beta). $

Kaplan–Meier\:

$ hat(R)(t)
=
product_(t_j <= t)
frac(n_j-d_j, n_j). $

Censoring causes no downward step, but it reduces the later risk set\.


== 8\. Sampling distribution and CLT

$ macron(X)=frac(1, n)sum_i X_i,
wide
E[macron(X)]=mu,
wide
op("SE")(macron(X))=frac(sigma, sqrt(n)). $

#table(
  columns: 2,
  align: (auto, auto,),
  stroke: (x: none, y: 0.5pt),
  table.header(
    [*Situation*],
    [*Standardisation*],
  ),
  [Normal population, $sigma$ known],
  [$frac(macron(X)-mu, sigma/sqrt(n))tilde.op N(0,1)$, exact],
  [Normal population, $sigma$ unknown],
  [$frac(macron(X)-mu, S/sqrt(n))tilde.op t_(n-1)$, exact],
  [Non\-normal population, large $n$],
  [$macron(X)dot(tilde.op) N(mu,sigma^2/n)$, CLT],
)
Course rule of thumb\: $n >= 30$ is large, but strong skewness or far tails may need more\.


=== Sample\-size symbols

These formulas assume independent observations with population standard deviation $sigma$ known\. They are exact for a normal population and approximate when using the CLT\.

#table(
  columns: 2,
  align: (auto, auto,),
  stroke: (x: none, y: 0.5pt),
  table.header(
    [*Symbol*],
    [*Meaning*],
  ),
  [$n$],
  [Required number of observations\.],
  [$macron(X)$, $mu$],
  [Sample mean and true population mean\.],
  [$sigma$],
  [Population standard deviation, not variance $sigma^2$\.],
  [$alpha$],
  [Allowed probability of falling outside the desired bound; e\.g\. $0.05$\.],
  [$1-alpha$],
  [Desired probability of meeting the bound; e\.g\. $0.95$\.],
  [$d$],
  [Allowed upward deviation of the sample mean from $mu$ (one\-sided)\.],
  [$E$],
  [Allowed error in either direction from $mu$ (two\-sided)\.],
  [$z_p$],
  [Standard normal quantile\: the value with probability $p$ to its left, so $P(Z <= z_p)=p$ for $Z tilde.op N(0,1)$\. In R\: qnorm(p)\.],
)
#strong[Read the subscripts as a whole\:] $z_(1-alpha)$ means the normal quantile at probability $1-alpha$, not $z_1-alpha$\. Similarly, $z_(1-alpha/2)$ uses probability $1-(alpha/2)$\. The $sigma$ after either quantile is a separate multiplication factor\.

One\-sided sample size\: keep the probability of overshooting $mu$ by at least $d$ below or equal to $alpha$\.

$ P(macron(X)>=mu+d)<= alpha
quad =>quad
n >=
( frac(z_(1-alpha)times sigma, d))^2. $

Two\-sided sample size\: keep the sample mean within $E$ of $mu$ with probability at least $1-alpha$\. Split the allowed error probability equally between the two tails\: $alpha/2$ in each\.

$ P(|macron(X)-mu|<E)>= 1-alpha
quad =>quad
n >=
( frac(z_(1-alpha/2)times sigma, E))^2. $

#table(
  columns: 4,
  align: (auto, auto, auto, auto,),
  stroke: (x: none, y: 0.5pt),
  table.header(
    [*Desired probability $1-alpha$*],
    [*$alpha$*],
    [*One\-sided $z_(1-alpha)$*],
    [*Two\-sided $z_(1-alpha/2)$*],
  ),
  [$0.90$],
  [$0.10$],
  [$z_(0.90)approx 1.282$],
  [$z_(0.95)approx 1.645$],
  [$0.95$],
  [$0.05$],
  [$z_(0.95)approx 1.645$],
  [$z_(0.975)approx 1.960$],
  [$0.99$],
  [$0.01$],
  [$z_(0.99)approx 2.326$],
  [$z_(0.995)approx 2.576$],
)
For example, with $sigma=10$ hours and allowed error $2$ hours at $1-alpha=0.95$\:

#list(tight: true,
[
One\-sided\: $n >=(1.645 times 10/2)^2 approx 67.65$, so use $n=68$\.
],
[
Two\-sided\: $n >=(1.960 times 10/2)^2 approx 96.04$, so use $n=97$\.
],
)

Square the entire fraction, then round $n$ up to a whole number\.


== 9\. Final checks

#list(tight: true,
[
Did I define the random variable and its units?
],
[
Is it a count or a continuous measurement?
],
[
Does the distribution\'s support match the variable?
],
[
Did I use variance or standard deviation correctly?
],
[
Did I choose the requested lower, upper or two\-sided tail?
],
[
For a sample mean, did I use $sigma/sqrt(n)$?
],
[
If $sigma$ is unknown, is t exact or only approximate here?
],
[
Did I account for censored observations?
],
[
Does the fitted hazard shape match the physical failure mechanism?
],
[
Is the final number a probability, rate, time, variance or standard deviation, and are its units correct?
],
)
