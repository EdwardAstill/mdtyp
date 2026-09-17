# Worked examples — one route through each problem type

[Cheat sheet](cheatsheet.md) · [All questions](questions.md) · [Engineering notes](engineering-content.md) · [R guide](R.md)

Use the recognition cue to choose a method, then cover the solution and try the calculation. Examples use supplied course questions unless marked **adapted** or **toy**. Extra subparts show closely related skills without repeating whole questions. Numerical results were checked using R; retain full precision until the final answer. In $N(\mu,\sigma^2)$ the second parameter is **variance**.

## Problem index

| If the question asks about… | Example |
|---|---|
| Unions, intersections, disjointness, valid probabilities | [1](#1-event-algebra-and-valid-probabilities) |
| Overall probability, false positives, reverse conditioning | [2](#2-total-probability-bayes-and-a-probability-tree) |
| Multiple possible causes / event-tree paths | [3](#3-multiple-causes-and-event-tree-paths) |
| Unknown PDF constant, CDF, mean and variance | [4](#4-normalise-a-pdf-and-obtain-its-cdf-and-moments) |
| A piecewise density or a supplied CDF | [5](#5-piecewise-pdf-and-cdf-to-pdf) |
| A fixed number of binary trials | [6](#6-binomial-counts-and-at-least-one) |
| Counts in a time interval | [7](#7-poisson-counts-and-independent-arrival-streams) |
| Uniform interval probabilities and quantiles | [8](#8-uniform-probabilities-and-quantiles) |
| Normal tails, quantiles, parameter finding | [9](#9-normal-tails-quantiles-and-unknown-parameters) |
| Lognormal repair time or conditional survival | [10](#10-lognormal-moments-tails-and-survival-given-age) |
| Gamma probabilities / expected fines | [11](#11-gamma-tails-quantiles-and-expected-cost) |
| Exponential rate from a probability, memorylessness | [12](#12-exponential-parameter-finding-and-memorylessness) |
| Weibull failure probability, hazard, mean, SD, quantile | [13](#13-weibull-lifetime-calculations) |
| Convert between $R,f,h$ / integrate to find MTTF | [14](#14-convert-reliability-to-density-hazard-and-mttf) |
| Failure of any component / minimum lifetime | [15](#15-series-systems-and-minimum-lifetime) |
| Redundancy / maximum lifetime / system MTTF | [16](#16-parallel-and-mixed-systems) |
| A bridge network that does not reduce directly | [17](#17-condition-on-a-bridge-component) |
| Fit complete observations and assess model choice | [18](#18-complete-data-parameter-estimation-and-model-choice) |
| Censored tests / total exposure / units | [19](#19-total-time-on-test-and-censored-exponential-estimation) |
| Repairable event timestamps / MTBF / SD | [20](#20-repairable-systems-and-interfailure-times) |
| Kaplan–Meier steps and censoring | [21](#21-kaplanmeier-with-censoring-and-tied-failures) |
| Mean ranks and Weibull probability plots | [22](#22-ranks-and-weibull-probability-plots) |
| Numerically fit Weibull parameters | [23](#23-weibull-maximum-likelihood-estimation) |
| Normal sample mean or sum | [24](#24-normal-sample-mean-sum-and-standard-error) |
| Minimum sample size, one or two tails | [25](#25-minimum-sample-size) |
| Student's $t$ and exact versus approximate distributions | [26](#26-students-t-and-two-sided-critical-values) |
| Non-normal sample average and CLT | [27](#27-clt-for-weibull-lifetimes) |
| Scheduled maintenance cost optimisation | [28](#28-shifted-weibull-and-age-replacement-cost) |
| Discounted costs, availability, engineering judgement | [29](#29-engineering-calculations-and-short-answer-patterns) |

## 1. Event algebra and valid probabilities

**Recognise:** “$A$ or $B$, given $C$” requires a union inside a conditional probability. **Source:** [2025 paper Q13–14](../questions/midsem/Mid-Sem-2025-Sem-1-questions-and-answers.md).

Given $P(A)=0.2$, $P(B)=0.1$, $P(C)=0.4$, $A\cap B=\varnothing$, $B$ independent of $C$, and $P(A\cap C)=0.1$:

$$
P(B\cap C)=P(B)P(C)=0.04,
$$

$$
P(A\cup B\mid C)=\frac{P(A\cap C)+P(B\cap C)}{P(C)}
=\frac{0.10+0.04}{0.40}=\boxed{0.35}.
$$

There is no triple-intersection subtraction because $A$ and $B$ are disjoint. To check any proposed assignment, use

$$
\max(0,P(A)+P(B)-1)\le P(A\cap B)\le\min(P(A),P(B)).
$$

For $P(A)=0.5$, $P(B)=0.7$, the intersection must be at least $0.2$: a proposed $0.1$ is invalid because it would make the union $1.1$. The assignment $0.7,0.2,0.1$ is valid and gives union $0.8$.

**Trap:** disjoint events with positive probabilities are not independent. Independence would require a positive intersection.

## 2. Total probability, Bayes and a probability tree

**Recognise:** an imperfect test gives conditional probabilities; the observed positive-test frequency can reveal prevalence. **Source:** [Prac 1 Q1](../questions/probability-questions/prac/prac-sheet-1.pdf).

Let $A$ = pipe has corrosion and $B$ = test indicates corrosion. Given $P(B\mid A)=0.7$, $P(B\mid A')=0.2$, $P(B)=0.25$, set $p=P(A)$.

$$
0.25=P(B\mid A)p+P(B\mid A')(1-p)=0.7p+0.2(1-p),
\qquad \boxed{p=0.1}.
$$

The tree's terminal branches are:

| First branch | Second branch | Multiply along the path |
|---|---|---:|
| Corrosion $A$: $0.1$ | Positive $B$: $0.7$ | $P(A\cap B)=0.07$ |
| Corrosion $A$: $0.1$ | Negative $B'$: $0.3$ | $P(A\cap B')=0.03$ |
| No corrosion $A'$: $0.9$ | Positive $B$: $0.2$ | $P(A'\cap B)=0.18$ |
| No corrosion $A'$: $0.9$ | Negative $B'$: $0.8$ | $P(A'\cap B')=0.72$ |

Add the positive branches: $P(B)=0.07+0.18=0.25$. Reverse the condition by dividing the appropriate joint probability by the observed event:

$$
P(A\mid B)=\frac{0.07}{0.25}=\boxed{0.28},\qquad
P(A\mid B')=\frac{0.03}{0.75}=\boxed{0.04}.
$$

**Trap:** $P(B\mid A)$ is not $P(A\mid B)$. The identity to memorise is

$$
\boxed{P(B\mid A)P(A)=P(A\cap B)=P(A\mid B)P(B).}
$$

The multiplier on the right is $P(B)$.

## 3. Multiple causes and event-tree paths

**Recognise:** combine different scenarios, each with its own conditional outcome probability. **Source:** [Lecture 1 Q1](../questions/probability-questions/lecture/Lecture1.pdf).

Treat the four stated causes $A,B,C,D$ as mutually exclusive and exhaustive, with probabilities $0.30,0.40,0.15,0.15$. Conditional explosion probabilities are $0.25,0.20,0.40,0.75$.

$$
P(E)=\sum_i P(i)P(E\mid i)
=0.075+0.080+0.060+0.1125=\boxed{0.3275}.
$$

Given that an explosion occurred, the probability assigned to static electricity is

$$
P(A\mid E)=\frac{0.075}{0.3275}=\boxed{0.2290}.
$$

**Adapted event-tree extension:** a leak occurs with probability $0.02$ per mission; ignition given a leak has probability $0.3$; suppression fails given an ignited leak with probability $0.1$. The major-fire path is

$$
P(\text{major fire})=0.02(0.3)(0.1)=\boxed{0.0006\text{ per mission}}.
$$

**Trap:** multiply conditional probabilities along a path and add disjoint outcome paths. Do not sum overlapping possible causes as though they formed a partition. A frequency initiating an event tree produces a frequency at its endpoint; a probability produces a probability.

## 4. Normalise a PDF and obtain its CDF and moments

**Recognise:** the density contains an unknown constant. **Adapted from:** [Stats Quiz 1 Q8](../questions/probability-questions/quizes/stat-quiz-1.md), replacing its known coefficient by $c$.

Let $f(x)=cx$ for $0<x<8$, zero otherwise. Total area must be one:

$$
1=\int_0^8 cx\,dx=32c\quad\Rightarrow\quad c=\frac1{32}.
$$

Then

$$
F(x)=\begin{cases}0,&x\le0,\\x^2/64,&0<x<8,\\1,&x\ge8.\end{cases}
$$

$$
P(1.6<X<4.1)=\frac{4.1^2-1.6^2}{64}=0.22265625\approx\boxed{0.22}.
$$

$$
E[X]=\int_0^8\frac{x^2}{32}\,dx=\frac{16}{3},\qquad
E[X^2]=\int_0^8\frac{x^3}{32}\,dx=32,
$$

$$
\operatorname{Var}(X)=32-(16/3)^2=\frac{32}{9},\qquad
\operatorname{SD}(X)=\frac{\sqrt{32}}3\approx1.8856.
$$

For the median, $F(m)=0.5$ gives $m=\sqrt{32}\approx5.6569$.

**Trap:** a density height is not a point probability; $P(X=x)=0$ for a continuous variable. Variance requires subtracting the squared mean.

## 5. Piecewise PDF and CDF to PDF

**Recognise:** the integration rule changes at a breakpoint. **Sources:** [Lecture 1 Q2](../questions/probability-questions/lecture/Lecture1.pdf), [Stats Quiz 1 Q7](../questions/probability-questions/quizes/stat-quiz-1.md).

Repair time has $f(x)=x/1600$ for $0<x\le40$ and $(80-x)/1600$ for $40<x<80$, zero elsewhere. Integrating from the beginning of the support gives

$$
F(x)=\begin{cases}
0,&x\le0,\\
x^2/3200,&0<x\le40,\\
1-(80-x)^2/3200,&40<x<80,\\
1,&x\ge80.
\end{cases}
$$

The second branch includes the area already accumulated to $40$. Therefore

$$
P(60\le X\le70)=F(70)-F(60)=\frac{20^2-10^2}{3200}=\boxed{0.09375}.
$$

For an interval crossing the breakpoint (added subpart),

$$
P(30<X<50)=F(50)-F(30)=1-\frac{30^2}{3200}-\frac{30^2}{3200}=0.4375.
$$

Symmetry gives $E[X]=40$ h; equivalently integrate $xf(x)$ separately over $(0,40)$ and $(40,80)$.

**Reverse direction:** if $F(x)=(x+1)^2/9$ on $-1<x\le2$, with zero below and one above, then $f(x)=F'(x)=2(x+1)/9$ on $(-1,2)$ and zero elsewhere. Check the CDF is continuous at the boundaries; a jump would represent point mass.

**Trap:** do not start the second CDF branch at zero. Cumulative probability does not reset at a breakpoint.

## 6. Binomial counts and at least one

**Recognise:** fixed $n$, independent trials, two outcomes and constant $p$. **Source:** [Prac 2 Q1](../questions/probability-questions/prac/prac-sheet-2.pdf).

For ten resistors with defect probability $0.08$, $X\sim\operatorname{Binomial}(10,0.08)$:

$$
P(X>1)=1-P(X=0)-P(X=1)
=1-0.92^{10}-10(0.08)(0.92)^9=\boxed{0.1879}.
$$

Added subparts: $E[X]=np=0.8$, $\operatorname{SD}(X)=\sqrt{np(1-p)}=\sqrt{0.736}\approx0.8579$. The probability of at least one defect is $1-0.92^{10}\approx0.5656$.

```r
pbinom(1, size = 10, prob = 0.08, lower.tail = FALSE)
```

**Trap:** $P(X\ge k)=1-P(X\le k-1)$. Discrete endpoints matter.

## 7. Poisson counts and independent arrival streams

**Recognise:** events counted over time at a specified rate. **Sources:** [2025 Q15](../questions/midsem/Mid-Sem-2025-Sem-1-questions-and-answers.md), [Prac 2 Q2](../questions/probability-questions/prac/prac-sheet-2.pdf).

Repair requests arrive at one per week. Over four weeks $N\sim\operatorname{Poisson}(4)$, so

$$
P(N=3)=\frac{4^3e^{-4}}{3!}=\boxed{0.195367\approx0.195}.
$$

The parameter is rate times interval, $\mu=\lambda t$, and both mean and variance equal $4$.

For independent elevator/passenger streams at rates $1$ and $5$ per minute, respectively, the chance of no elevator and at least ten passengers in one minute is

$$
e^{-1}\left[1-\sum_{k=0}^{9}\frac{5^ke^{-5}}{k!}\right]=\boxed{0.011709}.
$$

```r
dpois(0, 1) * ppois(9, 5, lower.tail = FALSE)
```

**Trap:** the rate is not automatically the Poisson parameter. Independence of the two arrival streams is an assumption needed for the product.

## 8. Uniform probabilities and quantiles

**Recognise:** constant density over a finite interval. **Source:** [Lecture 2](../questions/probability-questions/lecture/Lecture2.pdf), hose model $X\sim U(85,165)$.

The PDF height is $1/(165-85)=1/80$. Thus

$$
P(X<120)=\frac{120-85}{80}=\boxed{0.4375}.
$$

For $99\%$ survival to age $c$,

$$
P(X>c)=\frac{165-c}{80}=0.99\quad\Rightarrow\quad\boxed{c=85.8\text{ h}}.
$$

Added summaries: $E[X]=125$ h, $\operatorname{SD}(X)=80/\sqrt{12}\approx23.0940$ h. On $85<t<165$, $R(t)=(165-t)/80$ and $h(t)=1/(165-t)$: a flat density does not mean constant hazard.

**Trap:** clip probability intervals to the support; the CDF is zero below $85$ and one above $165$.

## 9. Normal tails, quantiles and unknown parameters

**Recognise:** standardise a boundary for a probability; invert a CDF for a boundary. **Sources:** [Lecture 2](../questions/probability-questions/lecture/Lecture2.pdf), [Stats Quiz 2 Q2](../questions/probability-questions/quizes/stat-quiz-2.md).

For $X\sim N(125,14^2)$,

$$
P(X<120)=\Phi\left(\frac{120-125}{14}\right)=\boxed{0.3605}.
$$

For $P(X>c)=0.99$, only $0.01$ lies below $c$:

$$
c=125+14\Phi^{-1}(0.01)=\boxed{92.43\text{ h}}.
$$

For $P(|Z|>z)=0.85$, each tail is $0.425$, so $z=\Phi^{-1}(0.575)=\boxed{0.1891\approx0.19}$.

**Adapted parameter-finding subpart:** if $X\sim N(\mu,10^2)$ and $P(X<400)=0.05$, then $(400-\mu)/10=z_{0.05}=-1.64485$, giving $\mu=416.4485$.

More generally two known quantiles $x_1,x_2$ at probabilities $p_1,p_2$ give

$$
\sigma=\frac{x_2-x_1}{z_{p_2}-z_{p_1}},\qquad \mu=x_1-\sigma z_{p_1}.
$$

**Trap:** R's `sd` is the standard deviation. A normal lifetime model allows negative values; check whether that is negligible for the application.

## 10. Lognormal moments, tails and survival given age

**Recognise:** $\ln T$ is normal or $T=\exp(X)$ for normal $X$. **Sources:** [2025 Q16](../questions/midsem/Mid-Sem-2025-Sem-1-questions-and-answers.md), [Prac 3 Q5](../questions/probability-questions/prac/prac-sheet-3.pdf).

For a repair time $T=e^X$ with $X\sim N(1.2,4.3)$,

$$
P(T>4)=P(X>\ln4)=1-\Phi\left(\frac{\ln4-1.2}{\sqrt{4.3}}\right)
=\boxed{0.464207\approx0.464}.
$$

For the light-bulb problem $\ln T\sim N(10,0.2^2)$ (log-scale parameters; $T$ measured in hours):

$$
E[T]=e^{10+0.2^2/2}=22471.43\text{ h},
$$

$$
\operatorname{SD}(T)=e^{10+0.2^2/2}\sqrt{e^{0.2^2}-1}=4539.61\text{ h}.
$$

Also $E[\ln T]=10$ and $\operatorname{Var}(\ln T)=0.04$. The probability of surviving to $30000$ h is

$$
R(30000)=1-\Phi\left(\frac{\ln30000-10}{0.2}\right)=0.061202.
$$

Given survival to $20000$ h, survival to a **total age** of $30000$ h has probability

$$
\frac{R(30000)}{R(20000)}=\boxed{0.089307}.
$$

**Trap:** “another $30000$ h after $20000$ h” would instead require $R(50000)/R(20000)$. The lognormal is not memoryless; $e^\mu$ is its median, not its mean.

## 11. Gamma tails, quantiles and expected cost

**Recognise:** a positive gamma variable, often evaluated by software. **Sources:** [Stats Quiz 2 Q5–6](../questions/probability-questions/quizes/stat-quiz-2.md), [Prac 1 Q3](../questions/probability-questions/prac/prac-sheet-1.pdf).

With shape $\alpha=2.27$ and rate $\lambda=1.22$,

```r
pgamma(2.48, shape = 2.27, rate = 1.22, lower.tail = FALSE)
# 0.2506520
```

Hence $P(X>2.48)=\boxed{0.251}$. For shape $2.26$, rate $1.27$, and $P(X\le c)=0.78$:

```r
qgamma(0.78, shape = 2.26, rate = 1.27)
# 2.519904
```

For the effluent model $X\sim\operatorname{Gamma}(2,\text{rate}=1)$, integration by parts gives

$$
f(x)=xe^{-x},\qquad F(x)=\int_0^xue^{-u}\,du=1-(1+x)e^{-x},\quad x>0.
$$

Mean and variance are both $2$. A test exceeds threshold $a$ with probability $(1+a)e^{-a}$. If each exceedance costs $C$, two weekly tests at threshold $4$ have expected fortnightly cost

$$
2C(1+4)e^{-4}=\boxed{0.183156C},
$$

whereas one fortnightly test at threshold $3$ costs $\boxed{4Ce^{-3}=0.199148C}$ on average. The first has lower expected cost under these assumptions.

**Trap:** `scale = 1/rate`. The expected number of fines can be fractional; linearity of expectation does not require independent tests.

## 12. Exponential parameter finding and memorylessness

**Recognise:** constant hazard or an exponential lifetime, with a survival probability supplied. **Source:** [Week 5 Quiz Q3](../questions/week5-quiz.md); added summaries and conditional-survival subparts.

Given $R(1000)=0.46$,

$$
0.46=e^{-1000\lambda}\quad\Rightarrow\quad
\lambda=-\frac{\ln0.46}{1000}=0.000776529\text{ h}^{-1}.
$$

$$
P(T\le336)=1-e^{-336\lambda}=\boxed{0.229653\approx0.230}.
$$

Mean life and standard deviation are both $1/\lambda=1287.78$ h; median life is $\ln2/\lambda=892.62$ h.

For an item already aged $1000$ h,

$$
P(T>1336\mid T>1000)=\frac{e^{-1336\lambda}}{e^{-1000\lambda}}
=e^{-336\lambda}=0.770347.
$$

Its chance of failing in the next $336$ h is again $0.229653$. By contrast, the unconditional chance of failing between ages $1000$ and $1336$ is $R(1000)-R(1336)=0.46(0.229653)\approx0.105640$.

**Trap:** an unconditional interval probability is a difference of survivals; a conditional probability divides by survival to the starting age. “Good as new after repair” alone does not establish exponential lifetimes.

## 13. Weibull lifetime calculations

**Recognise:** given shape $\beta$ and characteristic life $\eta$. **Sources:** [Prac 3 Q3](../questions/probability-questions/prac/prac-sheet-3.pdf), [Lecture 3](../questions/probability-questions/lecture/Lecture3.pdf), [2025 Q8](../questions/midsem/Mid-Sem-2025-Sem-1-questions-and-answers.md).

For solar cells with $\beta=2.5$, $\eta=10$ years:

$$
R(t)=e^{-(t/10)^{2.5}},\qquad h(t)=\frac{2.5}{10}(t/10)^{1.5}.
$$

| Age | Hazard, year$^{-1}$ |
|---:|---:|
| 5 yr | 0.088388 |
| 10 yr | 0.250000 |
| 20 yr | 0.707107 |

The increasing hazard represents wear-out. The mean and standard deviation are

$$
E[T]=10\Gamma(1.4)=\boxed{8.87264\text{ yr}},
$$

$$
\operatorname{SD}(T)=10\sqrt{\Gamma(1.8)-\Gamma(1.4)^2}=\boxed{3.79667\text{ yr}}.
$$

The supplied rounded gamma values yield slightly different final decimals. Use the precision requested by the question.

For the 2025 foundation model, $\beta=1.2$, $\eta=14$ yr:

$$
F(39)=1-e^{-(39/14)^{1.2}}=\boxed{0.967261\approx0.967}.
$$

For any Weibull, the $p$th failure quantile is $t_p=\eta[-\ln(1-p)]^{1/\beta}$. The lecture's $\beta=0.5,\eta=125$ model gives median $125(\ln2)^2=60.06$ h, mean $125\Gamma(3)=250$ h, and decreasing hazard. In both models $F(\eta)=1-e^{-1}=0.632121$.

**Adapted residual-life check:** for $\beta=2,\eta=5$, compare

$$
P(T>6\mid T>4)=e^{-[(6/5)^2-(4/5)^2]}=e^{-0.8}=0.449329
$$

with $P(T>2)=e^{-0.16}=0.852144$. The Weibull is memoryless only at $\beta=1$.

**Trap:** $\eta$ is neither generally the mean nor the median. Hazard is a rate conditional on survival, not a failure probability.

## 14. Convert reliability to density, hazard and MTTF

**Recognise:** a function is supplied instead of a named distribution. **Source:** [Stats Quiz 3 Q1, Q2, Q10](../questions/probability-questions/quizes/stat-quiz-3.md).

With $R(t)=3.24/[(t+2.7)(t+1.2)]$, $t\ge0$, differentiate:

$$
f(t)=-R'(t)=\frac{3.24(2t+3.9)}{(t+2.7)^2(t+1.2)^2},
\qquad f(2.2)=\boxed{0.096889\approx0.10}.
$$

For $R(t)=2.08/[(t+1.6)(t+1.3)]$, logarithmic differentiation is easier:

$$
h(t)=-\frac{d}{dt}\ln R(t)=\frac1{t+1.6}+\frac1{t+1.3},
\qquad h(2)=\boxed{0.580808\approx0.58}.
$$

For $R(t)=(1+t)^{-7}$,

$$
\operatorname{MTTF}=\int_0^\infty R(t)\,dt
=\left[-\frac{(1+t)^{-6}}6\right]_0^\infty
=\boxed{\frac16\approx0.17}.
$$

**Adapted reverse-direction check:** if $h(t)=2t/9$, then $H(t)=\int_0^t2u/9\,du=t^2/9$, $R(t)=e^{-t^2/9}$, $F(t)=1-R(t)$ and $f(t)=(2t/9)e^{-t^2/9}$. This is Weibull $(\beta=2,\eta=3)$.

**Trap:** $f=hR$, not $F=hR$. Check $R(0)=1$, non-increasing survival, and total density area one. The survival-integral MTTF formula assumes nonnegative lifetimes.

## 15. Series systems and minimum lifetime

**Recognise:** the system fails as soon as any required component fails. **Sources:** [Week 5 Quiz Q4](../questions/week5-quiz.md), [Prac 2 Q7](../questions/probability-questions/prac/prac-sheet-2.pdf), [Week 4 quiz](../questions/week4-quiz.md).

For independent exponential component lifetimes with mean lives $15020,1200,10000,11000$ h,

$$
\lambda_{\rm sys}=\sum_i\lambda_i=\frac1{15020}+\frac1{1200}+\frac1{10000}+\frac1{11000},
$$

$$
R_{\rm sys}(500)=e^{-500\lambda_{\rm sys}}=\boxed{0.579604\approx0.580}.
$$

The same argument handles $Y=\min(X_1,X_2,X_3)$ with rates $0.002,0.003,0.005$: $Y\sim\operatorname{Exp}(0.010)$, $P(Y>300)=e^{-3}=0.049787$, and $E[Y]=100$ h. The Prac 2 solution's printed $0.0005$ in one product is inconsistent with its stated $0.005$ and numerical result.

**Units/checking variant:** five sensors each at $1.91$ failures per million hours give $\lambda_{\rm module}=9.55\times10^{-6}$ h$^{-1}$. Using $365.25$ days/year,

$$
R(10\text{ yr})=e^{-9.55\times10^{-6}(10)(365.25)(24)}=\boxed{0.432941}.
$$

The local Week 4 quiz lists $0.426$ as its selected answer, but that does not follow exactly from its stated $1.91$ rate. The workshop data instead give about $1.95$ per million h; using $1.95$ and $365$ days/year gives $0.425666$, explaining the selected option. See the [engineering notes](engineering-content.md) for the source-data calculation. Its stated whole-system rate $15.44$ per million h gives mean life $10^6/15.44=64766.84$ h $=7.3884$ yr, below the ten-year requirement.

**Trap:** multiply reliabilities, not component mean lives. Sum hazards for independent series components; summing constant rates yields an exponential system only when the component hazards are constant.

## 16. Parallel and mixed systems

**Recognise:** redundancy means the subsystem fails only if all alternative paths fail. **Sources:** [2025 Q4](../questions/midsem/Mid-Sem-2025-Sem-1-questions-and-answers.md), [Stats Quiz 4 Q1](../questions/probability-questions/quizes/stat-quiz-4.md).

Three independent $a$ components in parallel, then $b$ and $c$ in series, with $a=0.62,b=0.91,c=0.70$:

$$
R_a=1-(1-a)^3=1-0.38^3,
$$

$$
R_{\rm sys}=R_a\,b\,c=(1-0.38^3)(0.91)(0.70)=\boxed{0.602047\approx0.60}.
$$


For independent exponential $A,B$ in parallel and $C$ in series, rates $a=0.14,b=0.04,c=0.23$:

$$
R_{\rm sys}(t)=[e^{-at}+e^{-bt}-e^{-(a+b)t}]e^{-ct}.
$$

The parallel lifetime is $\max(T_A,T_B)$; the complete system lifetime is $\min(\max(T_A,T_B),T_C)$. Integrating survival gives

$$
E[T_{\rm sys}]=\frac1{a+c}+\frac1{b+c}-\frac1{a+b+c}
=\boxed{3.967382}.
$$

**Trap:** the final exponential term is subtracted. Adding all three gives $R(0)=3$, impossible. A parallel combination of exponentials is generally not exponential, so $1/h(t)$ is not generally its MTTF.

## 17. Condition on a bridge component

**Recognise:** a cross-link prevents immediate series/parallel reduction. **Toy example for the conditional-network method in the engineering reliability material.**

Five independent links have reliability $0.9$. Two paths connect source $S$ to destination $D$: upper $S\!\to U\!\to D$ has links $A,B$; lower $S\!\to V\!\to D$ has $C,D_1$. A bidirectional bridge link $E$ joins $U$ and $V$.

When $E$ fails, the two series paths act in parallel:

$$
R_{\rm sys\mid E'}=1-(1-R_AR_B)(1-R_CR_{D_1})
=1-(1-0.9^2)^2=0.9639.
$$

When $E$ works, $U$ and $V$ effectively merge. The input links $A,C$ are parallel, followed in series by parallel output links $B,D_1$:

$$
R_{\rm sys\mid E}=[1-(1-0.9)^2]^2=0.9801.
$$

Total probability gives

$$
R_{\rm sys}=R_E R_{\rm sys\mid E}+(1-R_E)R_{\rm sys\mid E'}
=0.9(0.9801)+0.1(0.9639)=\boxed{0.97848}.
$$

**Trap:** paths sharing a component are not independent, even if components are independent. Condition on the shared component or bridge, simplify each state, then combine.

## 18. Complete-data parameter estimation and model choice

**Recognise:** observed times are data, not supplied population parameters. **Source:** [Lecture 4](../questions/probability-questions/lecture/Lecture4.pdf), fabricated hose repair data in the Westralia teaching case.

For $x=(10,17,24,30,14,18,15,13,21)$ minutes, $n=9$ and $\bar x=18$.

| Model | Maximum-likelihood estimates |
|---|---|
| Normal | $\widehat\mu=18$; $\widehat\sigma=\sqrt{\sum(x_i-18)^2/9}=5.811865$ |
| Lognormal | $\widehat\mu=\operatorname{mean}(\ln x)=2.840222$; $\widehat\sigma=\sqrt{\sum(\ln x_i-\widehat\mu)^2/9}=0.315505$ |
| Exponential | $\widehat\lambda=n/\sum x_i=1/18=0.055556$ min$^{-1}$ |

The ordinary sample standard deviation is $s=\sqrt{\sum(x_i-18)^2/8}=6.164414$ min. Report which estimator is requested; R's `sd(x)` uses $n-1$.

For model checking, plot a density histogram and fitted density; check positivity, skewness and tail fit. Here $s/\bar x=0.3425$ is far below the exponential model's population SD/mean of $1$. That is a reason to question exponential fit, although nine observations cannot decisively identify the true distribution.

**Simulation and graphical-summary subpart:** [Stats Quiz 1 Q5](../questions/probability-questions/quizes/stat-quiz-1.md) asks for a reproducible sample of twenty $N(10,5^2)$ observations. Generate once and retain the vector:

```r
set.seed(5507)
x <- rnorm(20, mean = 10, sd = 5)
c(mean = mean(x), median = median(x), sd = sd(x))
# mean 11.366560; median 11.349722; sd 6.036354
hist(x, probability = TRUE)
curve(dnorm(x, mean = 10, sd = 5), add = TRUE, col = "red")
boxplot(x)
```

The requested median is $\boxed{11.350}$. The realised sample mean and SD differ from the population values $10$ and $5$ because this is one finite random sample. A density histogram, rather than raw counts, makes the theoretical density overlay comparable. Resetting the seed reproduces the sample; repeatedly calling `rnorm` without resetting generates new data.

**Trap:** lognormal parameters are estimated from **logs of the observations**, not the log of the sample mean. A histogram suggests candidate models; it does not prove the hazard shape.

## 19. Total time on test and censored exponential estimation

**Recognise:** surviving units contribute time but no failure. **Source:** [2025 Q3 and Q10](../questions/midsem/Mid-Sem-2025-Sem-1-questions-and-answers.md).

Seven systems start together. Four fail at $3,13,25,40$ months; three survive to $48$ months without replacement. Total exposure is

$$
\mathcal T=3+13+25+40+3(48)=225\text{ component-months}.
$$

With four failures and an exponential model,

$$
\widehat\lambda=\frac4{(225/12)(365.25)(24)}
=\boxed{24.33645\text{ failures per million h}}.
$$

The fitted mean life is $\mathcal T/4=56.25$ months. This is a model-based estimate incorporating censored exposure, not the average of the four observed failure ages.

**Failed-test variant:** 113 foundation tests include five unsuccessful equipment tests with no usable durations supplied. Excluding these leaves 108 valid foundations: five fail at $3,5,6,8,12$ months and 103 survive to 24 months.

$$
\mathcal T=3+5+6+8+12+103(24)=\boxed{2506\text{ months}}.
$$

The answer follows the paper's exclusion convention. If usable observation durations for the unsuccessful tests were known, they would require a stated censoring/data-quality decision.

**Trap:** do not use $7\times48$ when failed units leave the test, and do not divide failures by calendar duration alone when multiple units are observed. $\sum t_i/r$ estimates MTTF under an exponential model; it is not a universal censored-data mean estimator.

## 20. Repairable systems and interfailure times

**Recognise:** timestamps describe repeated failures of one operating asset. **Source:** [Stats Quiz 4 Q6–7](../questions/probability-questions/quizes/stat-quiz-4.md).

Five failures occur at operating times $1,2,3,5,8$ and observation continues to $17.5$. Total operating exposure is $17.5$, so

$$
\widehat{\operatorname{MTBF}}=\frac{17.5}{5}=\boxed{3.5}.
$$

For the separate timestamps $2,3,6,9,10$, observed to $11$, completed interfailure durations are

$$
2,\ 3-2,\ 6-3,\ 9-6,\ 10-9=2,1,3,3,1.
$$

Their mean is $2$. The population-divisor descriptive SD used in the local answer is $\sqrt{4/5}=\boxed{0.894427}$. The conventional sample SD, which R's `sd` returns, is $\sqrt{4/4}=\boxed{1}$.

The final one-unit interval is right-censored, so it is not an observed complete duration. Under an exponential renewal model, all eleven exposure units give fitted mean $11/5=2.2$ and fitted lifetime SD $2.2$, a different quantity from the descriptive SD of completed intervals.

**Trap:** do not take the SD of absolute timestamps. Include final censored exposure in an exposure-based rate estimate. If times are calendar time with repair downtime, establish operating time before using it as exposure.

## 21. Kaplan–Meier with censoring and tied failures

**Recognise:** estimate survival without selecting a parametric lifetime distribution. **Toy dataset illustrating** [Prac 4 Q3](../questions/probability-questions/prac/prac-sheet-4.pdf); the LMS `exa1.csv` is not supplied locally.

Five units have observations $(2,F),(3,C),(4,F),(4,F),(5,C)$, where $F$ means failure and $C$ censoring.

| Time | At risk just before time | Failures | Censored | Survival after time |
|---:|---:|---:|---:|---:|
| 2 | 5 | 1 | 0 | $1(1-1/5)=0.8$ |
| 3 | 4 | 0 | 1 | $0.8$ |
| 4 | 3 | 2 | 0 | $0.8(1-2/3)=0.266667$ |
| 5 | 1 | 0 | 1 | $0.266667$ |

Thus $\widehat R(3.5)=0.8$, $\widehat R(4)=0.266667$ and $\widehat F(4)=\boxed{0.733333}$. Censoring changes the next risk set but does not itself cause a drop.

```r
library(survival)
d <- data.frame(time = c(2,3,4,4,5), status = c(1,0,1,1,0))
fit <- survfit(Surv(time, status) ~ 1, data = d)
summary(fit, times = c(3.5, 4))
```

**Trap:** using $1-3/5=0.4$ ignores censoring before the final failures. A positive KM tail beyond the last observation does not identify the full mean lifetime. Standard KM relies on non-informative censoring; recorded suspensions are not automatically harmless.

## 22. Ranks and Weibull probability plots

**Recognise:** the question explicitly asks for a plotting position or parameters from a straight line. **Sources:** [Stats Quiz 4 Q3](../questions/probability-questions/quizes/stat-quiz-4.md), [Prac 3 Q4](../questions/probability-questions/prac/prac-sheet-3.pdf).

Eleven units are tested until the ninth failure at $13.48$. The requested **mean rank** is

$$
\widehat F(t_9)=\frac9{11+1}=\boxed{0.75}.
$$

For comparison, the empirical/KM fraction with no earlier censoring would be $9/11=0.818182$, while the approximate median rank is $(9-0.3)/(11+0.4)=0.763158$. These are different estimators, so use the named method.

For Weibull data, define $x=\ln t$ and $y=\ln[-\ln(1-F(t))]$. Then

$$
y=\beta x-\beta\ln\eta.
$$

**Toy fitted line:** $y=2x-3.218876$. Reading slope and intercept gives $\widehat\beta=2$ and

$$
\widehat\eta=e^{-(-3.218876)/2}\approx\boxed{5}.
$$

Straightness supports a two-parameter Weibull fit; curvature can indicate a shift, mixture or poor model choice. In the supplied mixed plot in [Week 5 Quiz Q6](../questions/week5-quiz.md), the earlier segment has $\beta_1=1.5278>\beta_2=1.3554$.

**Adjusted median-rank subpart with suspensions:** a toy dataset following the method in the [Weibull slides](../probability-content/slides-pdf/Weibull-analysis.pdf) is $(2,F),(3,C),(4,F),(5,F),(6,C)$. Here $n=5$. Start with adjusted rank $j_{\rm prev}=0$; for each failure let $m$ count all preceding observations and calculate

$$
\mathrm{INC}=\frac{n+1-j_{\rm prev}}{1+n-m},\qquad
j=j_{\rm prev}+\mathrm{INC},\qquad
\widehat F=\frac{j-0.3}{n+0.4}.
$$

| Failure time | $m$ | Increment | Adjusted rank $j$ | Median-rank estimate |
|---:|---:|---:|---:|---:|
| 2 | 0 | $(6-0)/6=1$ | 1 | $0.7/5.4=0.129630$ |
| 4 | 2 | $(6-1)/4=1.25$ | 2.25 | $1.95/5.4=0.361111$ |
| 5 | 3 | $(6-2.25)/3=1.25$ | 3.50 | $3.2/5.4=0.592593$ |

The suspension at time 3 receives no failure point but increases $m$ for the next update. Continue from the previous **adjusted** rank rather than resetting to the observed failure number. These are plotting positions, distinct from Kaplan–Meier estimates.

**Trap:** check which variable is on each axis; swapping axes changes the slope. Do not transform $F=0$ or $F=1$ because the logs diverge. With interspersed censoring use a censoring-aware CDF estimator, not unadjusted failure ranks.

## 23. Weibull maximum-likelihood estimation

**Recognise:** asked to fit shape and scale numerically. **Source:** [Stats Quiz 4 Q10](../questions/probability-questions/quizes/stat-quiz-4.md), which explicitly instructs omission of censored values.

Use these twenty observed failures:

```r
x <- c(8,21.3,25.5,8.1,4.5,4.2,13.2,9.9,27,25.7,
       25.8,28.6,13.5,7,20.9,9.6,33.9,16.5,4.4,19.2)
score <- function(beta) {
  1/beta + mean(log(x)) - sum(x^beta * log(x))/sum(x^beta)
}
beta_hat <- uniroot(score, c(0.1, 10), tol = 1e-12)$root
eta_hat <- mean(x^beta_hat)^(1/beta_hat)
c(shape = beta_hat, scale = eta_hat)
# shape 1.888809; scale 18.459323
```

The score equation is

$$
\frac1\beta+\frac1n\sum\ln x_i-
\frac{\sum x_i^\beta\ln x_i}{\sum x_i^\beta}=0,
$$

with $\widehat\eta=[\sum x_i^{\widehat\beta}/n]^{1/\widehat\beta}$. Therefore the requested shape is $\boxed{1.889}$.

If censored observations are to be retained, use their survival contribution. For observed times $t_i$ and failure indicators $\delta_i$:

$$
\ell(\beta,\eta)=\sum_i\delta_i\left[\ln\beta-\beta\ln\eta+(\beta-1)\ln t_i\right]
-\sum_i(t_i/\eta)^\beta.
$$

**Trap:** omitting suspensions is required for this particular quiz calculation, but is generally a biased way to fit censored lifetime data. Never relabel a suspension as a failure. See the [R guide](R.md) for the censoring-aware fit.

## 24. Normal sample mean, sum and standard error

**Recognise:** the random variable is an average of $n$ measurements. **Source:** [2025 Q17](../questions/midsem/Mid-Sem-2025-Sem-1-questions-and-answers.md); sum subpart added from the Prac 5 method.

Loaded bucket volumes are iid $N(11.5,1.4^2)$ m$^3$. For $n=12$:

$$
\bar X\sim N\left(11.5,\frac{1.4^2}{12}\right),\qquad
\operatorname{SE}(\bar X)=\frac{1.4}{\sqrt{12}}.
$$

$$
P(\bar X<10.88)=\Phi\left(\frac{10.88-11.5}{1.4/\sqrt{12}}\right)
=\boxed{0.062502\approx0.063}.
$$

For total volume $S=\sum X_i$, $S\sim N(138,23.52)$, and $P(S<130.56)$ is the same probability because $130.56=12(10.88)$.

**Trap:** the sample mean uses SD $\sigma/\sqrt n$; the sum uses SD $\sigma\sqrt n$. Both results are exact for independent normal observations, even when $n<30$.

## 25. Minimum sample size

**Recognise:** find $n$ to meet a probability or precision requirement. **Sources:** [Stats Quiz 5 Q4](../questions/probability-questions/quizes/stat-quiz-5.md), [Lecture 5](../questions/probability-questions/lecture/Lecture5.pdf).

Normal observations have variance $16$, so $\sigma=4$. Require $P(|\bar X-\mu|<2)\ge0.99$. The middle $99\%$ leaves $0.005$ in each tail:

$$
\frac{2}{4/\sqrt n}\ge z_{0.995}=2.575829,
\qquad
n\ge\left(\frac{4z_{0.995}}2\right)^2=26.539586.
$$

Hence $\boxed{n_{\min}=27}$. Check: $n=26$ gives $0.989213$, below the requirement; $n=27$ gives $0.990625$, above it.

For the lecture's **one-sided** requirement with mean $300$, SD $15$, and $P(\bar T\ge310)\le0.005$:

$$
n\ge\left(\frac{15z_{0.995}}{310-300}\right)^2=14.928517,
\qquad\boxed{n_{\min}=15}.
$$

**Trap:** the first problem divides its total tail probability by two; the second already specifies one tail. Always round the required sample size up.

## 26. Student's t and two-sided critical values

**Recognise:** unknown population SD is estimated by $S$, or a $t$ distribution is explicitly given. **Sources:** [2025 Q18](../questions/midsem/Mid-Sem-2025-Sem-1-questions-and-answers.md), [Stats Quiz 5 Q5](../questions/probability-questions/quizes/stat-quiz-5.md).

For twenty independent normal lifetimes with unknown mean and variance,

$$
\frac{\bar X-\mu}{S/\sqrt{20}}\sim\boxed{t_{19}\text{ exactly}}.
$$

For $T\sim t_5$, find positive $c$ satisfying $P(|T|>c)=0.0125$. Each tail has area $0.00625$, so

$$
c=t_{5,0.99375}=\boxed{3.810005\approx3.810}.
$$

```r
qt(1 - 0.0125/2, df = 5)
2 * pt(3.810004700, df = 5, lower.tail = FALSE) # about 0.0125
```

**Trap:** normality of the population makes the $t$ result exact. A large sample from an unspecified distribution supports approximate normal inference, not an exact $t$ law. When $\sigma$ is known, the normal-population standardised mean uses $Z$, not $t$.

## 27. CLT for Weibull lifetimes

**Recognise:** the individual distribution is non-normal, but the question concerns a mean of many independent observations. **Source:** [Prac 5 Q5](../questions/probability-questions/prac/prac-sheet-5.pdf).

For $T_i\sim\operatorname{Weibull}(2,5)$ and $n=50$, first calculate the individual moments:

$$
\mu=5\Gamma(1.5)=4.431135,\quad
\sigma^2=25[\Gamma(2)-\Gamma(1.5)^2]=5.365046.
$$

For **one** board, $P(T_1>5)=e^{-1}=0.367879$. For the **sample average**, the CLT gives

$$
\bar T\ \dot\sim\ N\left(4.431135,\frac{5.365046}{50}\right),
$$

$$
P(\bar T>5)\approx1-\Phi\left(\frac{5-4.431135}{\sqrt{5.365046/50}}\right)
=\boxed{0.041226}.
$$

For $P(|\bar T-\mu|<0.5)>0.95$, the CLT sample-size calculation is

$$
n>\left(\frac{z_{0.975}\sqrt{5.365046}}{0.5}\right)^2=82.438412,
\qquad\boxed{n_{\min}\approx83}.
$$

**Trap:** a mean of Weibull observations is not itself generally Weibull. This calculation is approximate; a “30 observations” rule does not guarantee accurate tail probabilities. Normal populations give exact normal sample means; here the CLT is doing the work.

## 28. Shifted Weibull and age-replacement cost

**Recognise:** replace at failure or scheduled age, whichever happens first. **Source:** [Week 5 Quiz Q5](../questions/week5-quiz.md).

A cable has shape $\beta=1.8$, scale $\eta=500$ h and threshold $\gamma=50$ h. Corrective replacement costs \$6000, scheduled replacement \$600; operation is $H=5000$ h/year. Candidate ages are $50,75,\ldots,300$ h.

$$
R(t)=\begin{cases}1,&t<50,\\e^{-((t-50)/500)^{1.8}},&t\ge50.\end{cases}
$$

Each replacement restores the cable to new condition. Ignoring downtime, the long-run annual cost is

$$
C(m)=5000\frac{6000[1-R(m)]+600R(m)}{\int_0^mR(t)\,dt}.
$$

At $m=175$ h, $F(m)=0.07916024$ and expected cycle length is $171.40895$ h. Therefore

$$
C(175)=5000\frac{6000(0.07916024)+600(0.92083976)}{171.40895}
\approx\boxed{\text{\$29,971.17 per year}}.
$$

| Candidate age (h) | Annual cost, rounded to nearest dollar |
|---:|---:|
| 50 | 60,000 |
| 75 | 41,657 |
| 100 | 34,342 |
| 125 | 31,205 |
| 150 | 30,053 |
| **175** | **29,971** |
| 200 | 30,510 |
| 225 | 31,425 |
| 250 | 32,571 |
| 275 | 33,860 |
| 300 | 35,231 |

Thus $\boxed{175\text{ h}}$ is the minimum **among the specified candidates**. Compute the whole grid, not only neighbouring values. For accurate numerical integration, split at the threshold $50$ or use tight tolerances.

**Trap:** dividing by scheduled age $m$ ignores cycles ending early at failure. A fixed calendar/block replacement policy has a different cost model. Do not claim this grid optimum is the unconstrained continuous optimum.

## 29. Engineering calculations and short-answer patterns

**Recognise:** the task asks for an engineering decision, financial metric or classification. **Sources:** [2025 Q1, Q5–7, Q9, Q12](../questions/midsem/Mid-Sem-2025-Sem-1-questions-and-answers.md); see [engineering notes](engineering-content.md) for full slide coverage and further case examples.

**Discounted maintenance costs:** four end-of-year payments of \$150000 at an $8\%$ real discount rate give

$$
\operatorname{NPC}=150000\sum_{t=1}^4(1.08)^{-t}=496819.03,
\qquad\boxed{\text{\$496,819}}.
$$

A time-zero investment would be added without discounting. Positive costs are summed for NPC; NPV requires consistent signs for cash inflows and outflows.

**Toy availability calculation:** an asset averages $100$ operating hours between failures and $5$ repair hours per failure. Its long-run availability is

$$
A=\frac{100}{100+5}=\boxed{0.952381}.
$$

Availability allows repair and return to operation; mission reliability is the probability of no failure over a specified duration.

**Short-answer examples:**

| Problem type | Worked reasoning → answer | Trap |
|---|---|---|
| Classify a control | Sealing nitrocellulose packaging physically retains its damping agent → **engineering control** | A written instruction to check the seal would be administrative |
| Failure vocabulary | “Engine fails to start” describes lost function → **failure mode**; a flat battery can be a cause | Mode, cause and mechanism answer different questions |
| Prioritise FMEA | Cable connections have $S=6,O=7,D=4$: $\mathrm{RPN}=168$, exceeding leakage's $7(6)(3)=126$ → select cable connections in this question | RPN is an ordinal prioritisation tool, not failure probability or expected monetary loss |
| Select maintenance | Vibration/infrared evidence of deterioration → **condition-based maintenance** | The measuring technique supports the tactic; it does not itself define a fixed replacement age |
| Rate a scenario | In the supplied paper's matrix, event heard of in industry → likelihood B; multiple fatalities → consequence 5; answer **B5** | Use the provided matrix definitions, not invented numerical probabilities |
| Hidden protection failure | **Toy:** a standby trip can fail undetected until demanded; a feasible proof test reveals loss of protection → **failure-finding task** | A hidden failed device may show no developing P–F warning |
| Explain a P–F interval | **Toy:** detectable deterioration at day 10, functional failure at day 30 → interval 20 days; inspect sufficiently often to detect and act within it | Inspection spacing alone is insufficient if repair preparation takes longer than the remaining warning time |

Engineering answers should connect the observed fact to the definition, then state the decision. Where a decision uses failure probability, hazard, reliability, availability, expected cost or uncertainty, the statistical calculations in this document provide the quantitative input.
