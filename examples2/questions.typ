#set page(paper: "a4", margin: 16mm, numbering: "1")
#set text(size: 10.5pt)
#show raw: set text(size: 8pt)
#show table: set text(size: 9pt)

= GENG5507 midsemester statistics question bank

This bank compiles the actual questions saved in this workspace and the distinct worked examples/prompts in the supplied statistics slides. Questions come first within each item, followed by clearly labelled worked answers. Original numbers, data and available answer choices are retained; some practical wording is tightened without removing subparts. Source ambiguities and corrections are flagged. Course convention: $N(mu,sigma^2)$ uses *variance* as its second parameter.


== Contents and source coverage

#table(
  columns: 3,
  align: (auto, auto, auto,),
  table.header(
    [*Section*],
    [*Coverage*],
    [*Status*],
  ),
  [#link("#lecture-problems")[Lecture problems]],
  [Lecture 0 background; Weeks 1–5: 3, 3, 2, 3, 4 questions (15 total)],
  [Existing Markdown question/answer files combined; PDFs linked],
  [#link("#practical-sheets-15")[Practical sheets]],
  [Sheets 1–5: 4, 8, 5, 3, 5 numbered questions (25 total), all subparts and explicit R exploration prompts],
  [Transcribed from question PDFs; answers checked against solution PDFs],
  [#link("#statistics-quizzes")[Statistics quizzes]],
  [Quizzes 1–5: 9, 11, 10, 10, 10 questions (50 total)],
  [Available wording/options and worked answers retained; incomplete Quiz 1 repaired and labelled],
  [#link("#2025-midsemester-paper--statistics-and-quantitative-reliability")[2025 midsemester paper]],
  [Q3, Q4, Q8, Q10 and Q13–20 (12 questions)],
  [Includes quantitative engineering/statistics overlap; other paper questions in engineering notes],
  [#link("#additional-questions-and-worked-examples-from-the-statistics-slides")[Slide questions and examples]],
  [All seven statistics decks; distinct prompts, examples and graphical-only cases indexed S0–S6],
  [Mirrored examples combined, image-only prompts inspected],
  [#link("#weekly-engineering-quizzes--quantitative-probability-questions")[Weekly engineering quizzes]],
  [All 3 saved Week 4 prompts; Week 5 Q3–Q6 (7 questions)],
  [Full quantitative prompts/options included; qualitative items in engineering notes],
)
There are *109 numbered lecture, practical, statistics-quiz, weekly-engineering-quiz and selected past-paper questions*, plus the separately indexed slide examples and R exploration prompts. This count treats a multi-part question as one question. The same problem appearing as both a sheet and its solution is included once. Similar questions with different data remain separate. Fresh generated practice is in #link("examples.md")[examples.md], not mixed into the historical bank.

*Answer provenance.* Lecture/quiz/past-paper Markdown already contained worked answers. They are retained as study solutions, with explicit local repairs where needed. Practical answer notes are concise reconciliations with supplied solution PDFs; data-dependent results are marked when quoted rather than recalculated. Missing multiple-choice options are not reconstructed or invented.


== Lecture problems


=== Lecture 0 — Westralia case background

*Source transcription:* #link("../questions/probability-questions/lecture/00-answer.md")[00-answer.md]. Existing worked answers are study solutions, not a claim of an official marking key.

Source: #link("../questions/probability-questions/lecture/Lecture0.pdf")[Lecture0.pdf]


==== Problem

The case-study document is required reading for the Week 2–5 lecture problems, but it does not contain standalone questions to solve. It supplies the engineering context and data used by those questions.


==== Relevant case-study information

The HMAS _Westralia_ fire began when diesel fuel from a burst flexible hose sprayed onto a hot engine component and ignited. The hose failed after fatigue cracking of its stainless-steel braid. The repeated pressure pulses in the fuel system had not been considered when the flexible hoses were selected.

This mechanism matters when choosing a lifetime model: fatigue normally suggests that failure risk changes with age rather than remaining constant.


===== Rigid-hose repair times

The repair times, in minutes, are

$ 10,thin 17,thin 24,thin 30,thin 14,thin 18,thin 15,thin 13,thin 21. $

These data are used in the Week 4 problems.


===== Rigid-hose times between leaks

The case study gives 21 observed times between leaks:

$ 15,17,30,39,45,80,85,90,120,150,160,190, \
240,250,300,400,510,531,601,753,812. $

Its fitted two-parameter Weibull model has approximately

$ beta=1.0107,
wide
eta=259.1574" hours". $

Because $beta$ is close to $1$, this fitted model has an almost constant hazard rate for the rigid-hose leak data.


===== Flexible-hose testing

- Supplier A claims a mean time to failure greater than $120$ hours.
- Supplier B's replacement test ran for $300$ hours and recorded four failures; the last occurred at $270$ hours.
- The case study instructs the reader to assume independent exponential lifetimes when using the Supplier B test data.


=== Lecture 1 — Week 1

*Source transcription:* #link("../questions/probability-questions/lecture/01-answer.md")[01-answer.md]. Existing worked answers are study solutions, not a claim of an official marking key.

Source: #link("../questions/probability-questions/lecture/Lecture1.pdf")[Lecture1.pdf]


==== L1.1 — Causes of an LNG tank explosion


===== Problem

An LNG tank explosion may result from static electricity ($A$), malfunctioning electrical equipment ($B$), an open flame ($C$), or sabotage ($D$). The estimated probabilities of the four causes are

$ P(A)=0.30,quad P(B)=0.40,quad P(C)=0.15,quad P(D)=0.15. $

The conditional probabilities of an explosion $E$ given each cause are

$ P(E ∣ A)=0.25,quad P(E ∣ B)=0.20,quad
P(E ∣ C)=0.40,quad P(E ∣ D)=0.75. $

+ Find the probability of an explosion.
+ Given that an explosion occurred, find the probability that static electricity caused it.


===== Solution

Assuming the four causes are mutually exclusive and exhaustive, the law of total probability gives

$ P(E)
=P(E ∣ A)P(A)+P(E ∣ B)P(B) \
quad+P(E ∣ C)P(C)+P(E ∣ D)P(D) \
=(0.25)(0.30)+(0.20)(0.40) \
quad +(0.40)(0.15)+(0.75)(0.15) \
=0.3275. $

Therefore,

$ P(E)=0.3275. $

For the second part, Bayes' theorem gives

$ P(A ∣ E)
=frac(P(E ∣ A)P(A), P(E)) \
=frac((0.25)(0.30), 0.3275) \
=0.2290. $

Thus,

$ P(A ∣ E)approx 0.229. $

The value $0.075$ is $P(A ∩ E)$; dividing it by $P(E)$ produces the required conditional probability.

#line(length: 100%)


==== L1.2 — LNG tank repair time


===== Problem

The repair time $X$, in hours, has probability density function

$ f_X(x)=
cases(frac(x, 1600) quad 0<x <= 40, [6"pt"]
frac(80-x, 1600) quad 40<x<80, [6"pt"]
0 quad "otherwise".) $

+ Plot the PDF and CDF.
+ Find $P(60 <= X <= 70)$.
+ Find the mean repair time.


===== Solution

Integrating the PDF gives the CDF

$ F_X(x)=
cases(0 quad x <= 0, [4"pt"]
frac(x^2, 3200) quad 0<x <= 40, [8"pt"]
1-frac((80-x)^2, 3200) quad 40<x<80, [8"pt"]
1 quad x >= 80.) $

The PDF is triangular: it increases linearly from $0$ to its peak at $x=40$, then decreases linearly to $0$ at $x=80$. The CDF increases from $0$ to $1$ and is continuous at $x=40$.

The following R code plots both functions over their full support:

```r
f_X <- function(x) {
  ifelse(x <= 0 | x >= 80, 0,
         ifelse(x <= 40, x / 1600, (80 - x) / 1600))
}

F_X <- function(x) {
  ifelse(x <= 0, 0,
         ifelse(x <= 40, x^2 / 3200,
                ifelse(x < 80, 1 - (80 - x)^2 / 3200, 1)))
}

par(mfrow = c(1, 2))
curve(f_X, from = -5, to = 85, xlab = "Repair time (hours)", ylab = "f_X(x)")
curve(F_X, from = -5, to = 85, xlab = "Repair time (hours)", ylab = "F_X(x)")
```

For a repair time between $60$ and $70$ hours,

$ P(60 <= X <= 70)
=F_X(70)-F_X(60) \
=( 1-frac(10^2, 3200))
 -( 1-frac(20^2, 3200)) \
=frac(300, 3200) \
=0.09375. $

Therefore,

$ P(60 <= X <= 70)=0.09375. $

The mean is

$ E[X]
=integral_0^(40)x frac(x, 1600)thin "dx"
 +integral_(40)^(80)x frac(80-x, 1600)thin "dx" \
=13.3333+26.6667 \
=40. $

Hence the mean repair time is

$ E[X]=40" hours". $

This also follows from the symmetry of the triangular density about $x=40$.

#line(length: 100%)


==== L1.3 — Car-battery lifetimes


===== Problem

The lifetimes, in years, of ten car batteries are

$ 4.8,thin 3.9,thin 2.2,thin 5.1,thin 4.6,thin 5.3,thin 6.3,thin 4.3,thin 6.8,thin 4.7. $

+ Draw a histogram of the data in RStudio.
+ Estimate the mean and standard deviation of battery lifetime.


===== Solution

```r
life.time <- c(4.8, 3.9, 2.2, 5.1, 4.6,
               5.3, 6.3, 4.3, 6.8, 4.7)

hist(life.time,
     main = "Histogram of Battery Lifetimes",
     xlab = "Lifetime (years)")

mean(life.time)
sd(life.time)
```

R returns

$ macron(x)=4.8000,
wide
s=1.2675. $

Therefore, the estimated mean and sample standard deviation are

$ macron(x)=4.80" years",
wide
s approx 1.27" years". $

R's `sd()` uses the sample standard deviation with denominator $n-1$.


=== Lecture 2 — Week 2

*Source transcription:* #link("../questions/probability-questions/lecture/02-answer.md")[02-answer.md]. Existing worked answers are study solutions, not a claim of an official marking key.

Source: #link("../questions/probability-questions/lecture/Lecture2.pdf")[Lecture2.pdf]

Let $Phi$ denote the standard normal CDF and $Phi^(-1)$ its quantile function.


==== L2.1 — Normal lifetime model


===== Problem

Suppose the flexible-hose lifetime is

$ X tilde.op N(125,14^2)" hours". $

Evaluate and interpret:

+ $P(X<120)$;
+ $P(X>130)$;
+ the value $c$ such that $P(X>c)=0.99$.


===== Solution

For $X<120$, standardising gives

$ P(X<120)
=Phi ( frac(120-125, 14)) \
=Phi(-0.3571) \
=0.3605. $

Thus, the model predicts that approximately

$ 36.05 % $

of flexible hoses fail before $120$ hours.

Similarly,

$ P(X>130)
=1-Phi ( frac(130-125, 14)) \
=1-Phi(0.3571) \
=0.3605. $

Approximately $36.05 %$ of hoses therefore last longer than $130$ hours. The two probabilities are equal because $120$ and $130$ are equally distant from the mean of $125$ hours.

For $P(X>c)=0.99$, the lower-tail probability is $P(X <= c)=0.01$. Hence

$ c
=125+14 Phi^(-1)(0.01) \
=125+14(-2.3263) \
=92.4311. $

Therefore,

$ c approx 92.43" hours". $

Under the model, $99 %$ of hoses last longer than about $92.43$ hours.

#line(length: 100%)


==== L2.2 — Uniform lifetime model


===== Problem

Suppose the flexible-hose lifetime is

$ X tilde.op op("Uniform")[85,165]" hours". $

Evaluate and interpret:

+ $P(X<120)$;
+ the value $c$ such that $P(X>c)=0.99$.


===== Solution

The total interval length is $165-85=80$ hours. Therefore,

$ P(X<120)=frac(120-85, 165-85)=frac(35, 80)=0.4375. $

The model predicts that

$ 43.75 % $

of hoses fail before $120$ hours.

For $85 <= c <= 165$,

$ P(X>c)=frac(165-c, 80). $

Setting this probability equal to $0.99$ gives

$ frac(165-c, 80)=0.99
quad =>quad
c=165-79.2=85.8. $

Thus,

$ c=85.8" hours". $

Under the model, $99 %$ of hoses last longer than $85.8$ hours.

#line(length: 100%)


==== L2.3 — Lognormal lifetime model


===== Problem

Suppose $X$ has a lognormal distribution with $mu=4.82$ and $sigma=0.03$. Evaluate and interpret:

+ $P(X<120)$;
+ the value $c$ such that $P(X>c)=0.99$.


===== Solution

For this parameterisation,

$ ln X tilde.op N(4.82,0.03^2). $

Therefore,

$ P(X<120)
=P(ln X<ln 120) \
=Phi ( frac(ln 120-4.82, 0.03)) \
=Phi(-1.0836) \
=0.1393. $

The model predicts that approximately

$ 13.93 % $

of hoses fail before $120$ hours.

For $P(X>c)=0.99$, $P(X <= c)=0.01$. Taking logarithms,

$ ln c=4.82+0.03 Phi^(-1)(0.01) \
=4.75021, $

so

$ c=e^(4.75021)=115.6085. $

Therefore,

$ c approx 115.61" hours". $

Under the lognormal model, $99 %$ of hoses last longer than about $115.61$ hours.


=== Lecture 3 — Week 3

*Source transcription:* #link("../questions/probability-questions/lecture/03-answer.md")[03-answer.md]. Existing worked answers are study solutions, not a claim of an official marking key.

Source: #link("../questions/probability-questions/lecture/Lecture3.pdf")[Lecture3.pdf]


==== L3.1 — Exponential lifetime model


===== Problem

Suppose the flexible-hose lifetime $X$, in hours, is exponentially distributed with failure rate

$ lambda=0.008" per hour". $

+ Write down the PDF.
+ Derive the survival and hazard-rate functions.
+ Find the median lifetime.
+ Find the proportion expected to fail before $125$ hours.
+ Derive the mean time to failure and variance.
+ Assess whether the model is reasonable for flexible-hose lifetimes.


===== Solution

The exponential PDF is

$ f_X(x)=
cases(lambda e^(-lambda x)=0.008e^(-0.008x) quad x >= 0, 0 quad x<0.) $

For $t >= 0$, the survival function is

$ S(t)
=P(X>t) \
=integral_t^infinity lambda e^(-lambda x)thin "dx" \
=e^(-lambda t)=e^(-0.008t). $

The hazard rate is therefore constant:

$ h(t)=frac(f_X(t), S(t))
=frac(lambda e^(-lambda t), e^(-lambda t))
=lambda
=0.008" per hour". $

If $m$ is the median, $P(X <= m)=0.5$, or equivalently $S(m)=0.5$. Thus,

$ e^(-0.008m)=0.5
quad =>quad
m=frac(ln 2, 0.008)=86.6434. $

Hence,

$ m approx 86.64" hours". $

The proportion that fails before $125$ hours is

$ P(X<125)
=1-S(125) \
=1-e^(-0.008(125)) \
=1-e^(-1) \
=0.6321. $

Thus, approximately

$ 63.21 % $

of hoses are expected to fail before $125$ hours.

For an exponential random variable,

$ E[X]=frac(1, lambda),
wide
E[X^2]=frac(2, lambda^2). $

Consequently,

$ op("Var")(X)
=E[X^2]-E[X]^2
=frac(1, lambda^2). $

Substituting $lambda=0.008$ gives

$ op("MTTF")=E[X]=125" hours" $

and

$ op("Var")(X)=15","625" hours"^2. $

The exponential model assumes a constant hazard and has the memoryless property. That is questionable here because the case study attributes the hose failures to fatigue caused by repeated pressure pulses; accumulated fatigue would normally make hazard increase with age. The exponential model could still be a useful approximation over a limited operating range if data showed an approximately constant failure rate, but the mechanism alone does not support that assumption.

#line(length: 100%)


==== L3.2 — Weibull lifetime model


===== Problem

Suppose the flexible-hose lifetime $X$, in hours, follows a Weibull distribution with shape $beta=0.5$ and scale $eta=125$.

+ Write down the PDF.
+ Write down the survival and hazard-rate functions.
+ Find the median lifetime.
+ Find the proportion expected to fail before $125$ hours.
+ Find the mean time to failure.
+ Assess whether the model is reasonable for flexible-hose lifetimes.


===== Solution

Using the shape-scale parameterisation, the Weibull PDF is

$ f_X(x)=
cases(frac(beta, eta)
( frac(x, eta))^(beta-1)
exp [-( frac(x, eta))^beta ] quad x>0, [10"pt"]
0 quad x <= 0.) $

With $beta=0.5$ and $eta=125$,

$ f_X(x)=frac(0.5, 125)
( frac(x, 125))^(-0.5)
exp [-( frac(x, 125))^(0.5)],
wide x>0. $

The survival function is

$ S(t)=exp [-( frac(t, 125))^(0.5)],
wide t >= 0, $

and the hazard rate is

$ h(t)=frac(0.5, 125)
( frac(t, 125))^(-0.5),
wide t>0. $

The median $m$ satisfies $S(m)=0.5$:

$ exp [-( frac(m, 125))^(0.5)]=0.5. $

Therefore,

$ m=125(ln 2)^(1/0.5)
=125(ln 2)^2
=60.0566, $

so

$ m approx 60.06" hours". $

At $t=125$ hours,

$ P(X<125)
=1-S(125) \
=1-exp[-(125/125)^(0.5)] \
=1-e^(-1) \
=0.6321. $

Thus, approximately

$ 63.21 % $

of hoses are expected to fail before $125$ hours.

The Weibull mean is

$ E[X]=eta thin Gamma ( 1+frac(1, beta)). $

Hence,

$ E[X]=125 thin Gamma(3)=125(2)=250, $

and

$ op("MTTF")=250" hours". $

Because $beta=0.5<1$, this model has a decreasing hazard rate: it implies that the hoses surviving early life become less likely to fail as they age. That can represent early manufacturing defects, but it is not consistent with a pure fatigue or wear-out mechanism, which would usually require $beta>1$ and an increasing hazard. The proposed parameter value is therefore not well supported by the failure mechanism unless separate evidence shows strong early-life failures.


=== Lecture 4 — Week 4

*Source transcription:* #link("../questions/probability-questions/lecture/04-answer.md")[04-answer.md]. Existing worked answers are study solutions, not a claim of an official marking key.

Source: #link("../questions/probability-questions/lecture/Lecture4.pdf")[Lecture4.pdf]

The rigid-hose repair times, in minutes, are

$ 10,thin 17,thin 24,thin 30,thin 14,thin 18,thin 15,thin 13,thin 21. $

The solutions below use maximum-likelihood estimates (MLEs). Because R's `sd()` uses the denominator $n-1$, the corresponding sample standard deviations are also reported where relevant.


==== L4.1 — Normal model


===== Problem

Fit a normal model $N(mu,sigma^2)$ to the repair-time data. Estimate $mu$ and $sigma$.


===== Solution

For a normal model, the MLEs are

$ hat(mu)=macron(x)
wide"and"wide
hat(sigma)
=sqrt(frac(1, n)sum_(i=1)^n(x_i-macron(x))^2). $

The sample mean is

$ macron(x)=frac(10+17+24+30+14+18+15+13+21, 9)=18. $

Therefore,

$ hat(sigma)
=sqrt(frac(1, 9)sum_(i=1)^9(x_i-18)^2)
=5.8119. $

The fitted normal model is

$ X tilde.op N(18,5.8119^2). $

If the question instead intends the usual sample standard deviation, then

$ s=sqrt(frac(1, 8)sum_(i=1)^9(x_i-18)^2)=6.1644" minutes". $

#line(length: 100%)


==== L4.2 — Lognormal model


===== Problem

Fit a lognormal model $L N(mu,sigma^2)$ to the repair-time data. Estimate $mu$ and $sigma$.


===== Solution

For this parameterisation,

$ Y=ln X tilde.op N(mu,sigma^2). $

The MLEs are therefore the mean and MLE standard deviation of the log-transformed observations:

$ hat(mu)=frac(1, n)sum_(i=1)^n ln x_i
=2.84022 $

and

$ hat(sigma)
=sqrt(frac(1, n)sum_(i=1)^n(ln x_i-hat(mu))^2)
=0.31551. $

Thus, the fitted model is

$ X tilde.op L N(2.84022,0.31551^2). $

Using the $n-1$ denominator instead gives a log-scale sample standard deviation of

$ s_(ln X)=0.33464. $

#line(length: 100%)


==== L4.3 — Exponential model


===== Problem

Fit an exponential model $op("Exp")(lambda)$ to the repair-time data. Estimate $lambda$ and explain whether the model appears suitable.


===== Solution

For an exponential model parameterised by rate, the MLE is

$ hat(lambda)=frac(1, macron(x)). $

Since $macron(x)=18$ minutes,

$ hat(lambda)=frac(1, 18)=0.05556" min"^(-1). $

The fitted exponential model has both mean and standard deviation equal to $18$ minutes. The observed sample standard deviation is only $6.1644$ minutes, giving an observed coefficient of variation

$ frac(s, macron(x))=frac(6.1644, 18)=0.3425, $

whereas an exponential distribution has coefficient of variation $1$. An exponential density also places its greatest probability density near zero, while every observed repair time is between $10$ and $30$ minutes.

The exponential model therefore appears to be a poor fit to these data. The sample contains only nine observations, so this is a diagnostic conclusion rather than a definitive goodness-of-fit test.

The following R code reproduces all estimates:

```r
x <- c(10, 17, 24, 30, 14, 18, 15, 13, 21)

mu_normal <- mean(x)
sigma_normal_mle <- sqrt(mean((x - mu_normal)^2))
sigma_normal_sample <- sd(x)

log_x <- log(x)
mu_lognormal <- mean(log_x)
sigma_lognormal_mle <- sqrt(mean((log_x - mu_lognormal)^2))
sigma_lognormal_sample <- sd(log_x)

lambda_exponential <- 1 / mean(x)
```


=== Lecture 5 — Week 5

*Source transcription:* #link("../questions/probability-questions/lecture/05-answer.md")[05-answer.md]. Existing worked answers are study solutions, not a claim of an official marking key.

Source: #link("../questions/probability-questions/lecture/Lecture5.pdf")[Lecture5.pdf]

Let $T$ denote the time between rigid-hose failures, with $E[T]=mu$ and $op("Var")(T)=sigma^2$.


==== L5.1 — One normally distributed lifetime


===== Problem

Suppose

$ T tilde.op N(300,15^2)" hours". $

+ Find the probability that a rigid hose lasts at least $310$ hours.
+ Find $t$ such that $P(T>t)=0.025$.


===== Solution

For the first part,

$ P(T >= 310)
=P ( Z >= frac(310-300, 15)) \
=P(Z >= 0.6667) \
=0.2525. $

Therefore,

$ P(T >= 310)approx 0.2525. $

For $P(T>t)=0.025$, $t$ is the $97.5$th percentile of the normal distribution:

$ t
=300+15z_(0.975) \
=300+15(1.95996) \
=329.3995. $

Thus,

$ t approx 329.40" hours". $

#line(length: 100%)


==== L5.2 — Mean lifetime with known standard deviation


===== Problem

Suppose individual lifetimes are independent and normally distributed with mean $300$ hours and standard deviation $15$ hours. Let $macron(T)$ be the sample mean.

+ For $n=10$, specify the distribution of $macron(T)$.
+ For $n=10$, find $P(macron(T)>= 310)$.
+ Find the minimum sample size $n$ such that $P(macron(T)>= 310)<= 0.005$.


===== Solution

For independent normal observations,

$ macron(T)tilde.op N ( 300,frac(15^2, n)). $

When $n=10$,

$ macron(T)tilde.op N ( 300,frac(15^2, 10)), $

so the standard deviation of $macron(T)$ is $15/sqrt(10)=4.7434$ hours.

Therefore,

$ P(macron(T)>= 310)
=P ( Z >= frac(310-300, 15/sqrt(10))) \
=P(Z >= 2.1082) \
=0.01751. $

Thus,

$ P(macron(T)>= 310)approx 0.01751. $

For the required sample size,

$ P(macron(T)>= 310)
=1-Phi ( frac(10sqrt(n), 15))<= 0.005. $

Hence,

$ frac(10sqrt(n), 15)>= z_(0.995)=2.57583, $

which gives

$ n >= ( frac(15(2.57583), 10))^2
=14.9285. $

The minimum integer sample size is therefore

$ n=15. $

For $n=15$, the upper-tail probability is approximately $0.004912$, which is below $0.005$.

#line(length: 100%)


==== L5.3 — Mean lifetime with unknown standard deviation


===== Problem

Suppose individual lifetimes are independent and normally distributed with mean $300$ hours, but $sigma$ is unknown. Let $S$ be the sample standard deviation.

+ For $n=10$, specify the distribution of $frac(macron(T)-mu, S/sqrt(n))$.
+ For $n=10$, find $P ( frac(macron(T)-mu, S/sqrt(n))>2.262 )$.
+ Find the minimum $n$ such that $P ( frac(macron(T)-mu, S/sqrt(n))>2.947 )<= 0.005$.


===== Solution

For a normal population with unknown variance,

$ frac(macron(T)-mu, S/sqrt(n))tilde.op t_(n-1). $

When $n=10$,

$ frac(macron(T)-mu, S/sqrt(10))tilde.op t_9. $

Therefore,

$ P ( frac(macron(T)-mu, S/sqrt(10))>2.262 )
=P(t_9>2.262) \
approx 0.02501. $

Thus,

$ P ( frac(macron(T)-mu, S/sqrt(10))>2.262 ) approx 0.025. $

For the final part, find the smallest $n$ satisfying

$ P(t_(n-1)>2.947)<= 0.005. $

Checking successive degrees of freedom gives

$ P(t_(14)>2.947)=0.005304>0.005 $

but

$ P(t_(15)>2.947)=0.004997 <= 0.005. $

Since $n-1=15$, the minimum sample size is

$ n=16. $

#line(length: 100%)


==== L5.4 — Unknown lifetime distribution


===== Problem

Suppose individual lifetimes have mean $300$ hours and standard deviation $15$ hours, but their distribution is unknown. For $n=40$ independent hoses:

+ Specify the distribution of $macron(T)$.
+ Approximate $P(macron(T)>= 310)$.


===== Solution

The exact distribution of $macron(T)$ cannot be determined without the population distribution. By the central limit theorem, however,

$ macron(T)thin dot(tilde.op)thin N ( 300,frac(15^2, 40)), $

where $dot(tilde.op)$ denotes an approximate distribution. Its standard deviation is $15/sqrt(40)=2.3717$ hours.

Therefore,

$ P(macron(T)>= 310)
approx P ( Z >= frac(310-300, 15/sqrt(40))) \
=P(Z >= 4.2164) \
approx 1.2413 times 10^(-5). $

Hence,

$ P(macron(T)>= 310)approx 0.0000124. $

Because this is a very far-tail probability and the population distribution is unknown, the numerical value should be treated as a normal approximation rather than an exact probability.


== Practical sheets 1–5

The original PDFs contain background revision and R demonstrations as well as questions. Every numbered problem and subpart is retained below; repeated revision formulas are in #link("cheatsheet.md")[the cheat sheet], and the R demonstrations are in #link("R.md")[the R guide]. *Answer notes* are concise worked summaries checked against the supplied solution PDFs, with corrections distinguished explicitly. An unavailable data file is not an invitation to invent observations.


=== Practical 1 — conditional probability, Gamma and R

Sources: #link("../questions/probability-questions/prac/prac-sheet-1.pdf")[question sheet] · #link("../questions/probability-questions/prac/prac-sheet-1-solution.pdf")[supplied solutions].


==== P1.1 — corrosion test (Textbook Problem 3.79, adapted)

Engineers maintaining nuclear submarines must check cooling-system pipes for internal corrosion. A non-destructive test is not infallible. Let $A$ mean actual corrosion and $B$ mean the test indicates corrosion. The test detects corrosion with $P(B ∣ A)=0.7$ and falsely indicates corrosion with $P(B ∣ A^c)=0.2$. One in every four tests indicates corrosion: $P(B)=0.25$.

(a) Find $P(A)$, using a tree diagram and/or total probability. (b) Find the probability of corrosion given a positive test. (c) Find the probability of corrosion given a negative test.

*Answer notes.* $0.25=0.7p+0.2(1-p)$ gives $p=0.1$; $P(A ∣ B)=0.07/0.25=0.28$; $P(A ∣ B^c)=0.03/0.75=0.04$. Complement bars lost in PDF extraction have been restored.


==== P1.2 — printed circuit boards (Textbook Problem 3.80)

Let $A$ mean a board is defective and $B$ mean it passes an automated verification test. Of 900 completed boards, 890 passed. In a separate study, 5 of 30 deliberately defective boards passed. Interpret long-run relative frequencies as probabilities.

(a) Estimate $P(B ∣ A)$. (b) Assuming $P(B ∣ A^c)=1$ (a good board cannot fail), estimate $P(A)$ using total probability. (c) Estimate the probability that a board is defective given that it passed.

*Answer notes.* $P(B ∣ A)approx 1/6$; $890/900=p/6+(1-p)$ gives $p=1/75$; $P(A ∣ B)approx(1/450)/(89/90)=1/445 approx 0.002247$.


==== P1.3 — mercury discharge and financial risk

Mercury concentration $X$ (units/litre) in weekly tests of a water-treatment plant varies day to day without a long-term trend. Model it as Gamma with shape $alpha=2$ and scale $beta=1$.

(a) Verify that $f_X(x)="xe"^(-x)$ for $x >= 0$, zero otherwise, using $Gamma(alpha)=(alpha-1)!$ for positive integer $alpha$.

(b) Show that

$ F_X(x)=cases(1-(1+x)e^(-x) quad x>0, 0 quad x <= 0.) $

Hint: integration by parts gives $integral_0^x "ue"^(-u)thin "du"=[-"ue"^(-u)]_0^x+integral_0^x e^(-u)thin "du"$.

(c) Determine the mean and variance using the Gamma formulas.

A fine is imposed whenever the measured concentration exceeds $T$ units/litre.

(d) Comment on the fairness of fixed testing limits. Do short-term variations result in higher financial risk?

(e) Express the probability of financial loss in terms of $T$. Evaluate it for $T=4$ and $T=3$. Mark these probabilities on the graphs in (b) and (d). *Source issue:* those subparts do not explicitly request graphs; plots of the PDF/CDF are requested in P2.3.

(f) Compare expected total payments per fortnight for (i) weekly tests with a fine of $C$ each time $X>4$, and (ii) fortnightly tests with a fine of $C$ each time $X>3$.

*Answer notes.* $E(X)=2$, $op("Var")(X)=2$; $P(X>T)=(1+T)e^(-T)$ for $T >= 0$. At 4 this is $0.09158$, and at 3 it is $0.19915$. Expected fortnightly fines are $2C(5e^(-4))=0.18316C$ versus $C(4e^(-3))=0.19915C$, so weekly testing is cheaper under this model. A fixed limit penalises occasional exceedances even if average discharge is low; the exceedance probability, not just the mean, determines expected fines. Greater variability does not universally increase every tail probability at every threshold.


==== P1.R — explicit R demonstration prompts

Run and compare `pnorm(0.3)`, `pnorm(2, lower.tail=FALSE)`, and `pnorm(9, mean=6, sd=10)`. Explain why the first and third agree, and why `pnorm(9)` differs from the third. Run `qnorm(0.025)`, `qnorm(0.05, lower.tail=FALSE)` and `qnorm(0.1, mean=6, sd=10)`; sketch the Normal symmetry behind the opposite-tail quantiles. Run `rnorm(4)` twice, then `mean(rnorm(4))`; explain why these are different samples. Store `x <- rnorm(4)` and reuse `x`. Repeat `set.seed(5507); x <- rnorm(6, mean=10, sd=5)` to check reproducibility. For `y <- c(4,3,3,7,5,2,1,0,1,2,4,3,2)`, try `mean(y)`, `median(y)`, `sd(y)` and `summary(y)`.

*Answer notes.* Standardisation gives $(9-6)/10=0.3$; the default Normal has mean 0 and SD 1. Re-running a generator advances its random-number state; storing a sample or resetting the seed preserves reproducibility. See #link("R.md")[R guide] for executable examples.


==== P1.4 — Normal calculations and simulation

(a) For $Z tilde.op N(0,1)$ find using R: (i) $P(Z>2)$; (ii) $P(0.2<Z<0.57)$; (iii) $z$ such that $P(Z<z)=0.975$.

(b) For $X tilde.op N(3,2^2)$ find: (i) $P(X<3.5)$; (ii) $P(|X-3|>= 2)$; (iii) $x$ such that $P(X>x)=0.1$.

(c) Use `set.seed(1234)` and generate `x`, a sample of 100 observations from $N(20,5^2)$. (i) Calculate the sample mean, median and SD. (ii) Compare with the corresponding population parameters and explain whether the result is expected. (iii) Plot `boxplot(x)`. (iv) Plot a histogram and overlay the generating Normal density; run the following line by line:

```r
hist(x, freq=FALSE)
curve(dnorm(x, 20, 5), from=5, to=35, col="red", add=TRUE)
text(x=26, y=0.08, "N(20, 5^2) pdf", col="red")
```

*Answer notes.* (a) $0.02275$, $0.13640$, $1.95996$. (b) $0.59871$, $0.31731$, $5.56310$. For the specified seed, sample mean $19.21619$, median $18.07686$ and SD $5.02203$. Sample statistics fluctuate around the population mean/median 20 and SD 5; they need not equal them. The histogram must use density scale for a PDF overlay.


=== Practical 2 — probability distributions

Sources: #link("../questions/probability-questions/prac/prac-sheet-2.pdf")[question sheet] · #link("../questions/probability-questions/prac/prac-sheet-2-solution.pdf")[supplied solutions].


==== P2.1 — defective resistors (Textbook Problem 2.10)

A random sample of 10 resistors is tested; each has probability 0.08 of being defective. Let $X$ count defective resistors. (a) Recommend a distribution. (b) Find the probability of more than one defective resistor.

*Answer notes.* Assuming independent outcomes and a common defect probability, $X tilde.op op("Bin")(10,0.08)$ and $P(X>1)=1-0.92^(10)-10(0.08)0.92^9 approx 0.18788$.


==== P2.2 — elevator and passenger arrivals (Textbook Problem 2.24, adapted)

A proposed 10-passenger elevator arrives in the lobby on average once per minute. Five passengers per minute are expected to use it; the company rejects the proposal.

(a) Support the proposal by calculating the probability that, in a given minute, the elevator does not show up and at least 10 passengers arrive. Hint: $sum_(n=0)^9 5^n e^(-5)/n!approx 0.968$. (b) Find the probability that the elevator arrives only once in a five-minute period.

*Answer notes.* Model arrivals as independent Poisson processes with rates 1/min and 5/min. (a) $e^(-1)[1-P(op("Pois")(5)<= 9)]approx 0.01171$. (b) $5e^(-5)approx 0.03369$. The sheet's duplicated “not” is a typographical error; its solution uses no elevator arrival.


==== P2.3 — Gamma plots, continuing P1.3

For $f_X(x)="xe"^(-x)$ on $x >= 0$ and $F_X(x)=1-(1+x)e^(-x)$ on $x>0$ (zero outside their lower support), (a) plot the PDF using R; (b) plot the CDF using R.

*Answer notes.* Use `curve(dgamma(x, shape=2, scale=1), 0, 10)` and `curve(pgamma(x, shape=2, scale=1), 0, 10)`. The introductory exercise also asks you to define `fn <- function(x) x^2` and plot it from $-2$ to $2$, labelling the axis and title with `ylab` and `main=expression(f(x)==x^2)`.


==== P2.4 — chain-link lengths (Textbook Problem 2.22)

Individual chain-link lengths have the uniform PDF shown in the #link("../questions/probability-questions/prac/prac-sheet-2.pdf#page=2")[source figure, page 2]: a rectangle from $m-a/2$ to $m+a/2$.

(a) Determine the rectangle's height. (b) Find the CDF, sketch it and label the axes. (c) Calculate the mean and variance. *Numbering correction:* the source labels both final parts “(b)”.

*Answer notes.* Height $1/a$; CDF 0 below $m-a/2$, $(x-m+a/2)/a$ within the interval and 1 above $m+a/2$; mean $m$, variance $a^2/12$.


==== P2.5 — standard Normal and underweight cereal

For standard Normal $Z$: (a) find $P(-0.34<Z<0.68)$; (b) find $k$ such that $P(Z>k)=0.025$.

A cereal-filling machine gives Normally distributed weights with mean 405 g and SD 10 g. Labels state 400 g; boxes below 398 g are “underweight”. (c) Find the long-run proportion underweight. (d) With the same mean, to what SD must the manufacturer reduce variability to make the proportion underweight 1%?

*Answer notes.* (a) $Phi(0.68)-Phi(-0.34)approx 0.38482$; (b) $1.95996$; (c) $Phi(-0.7)=0.24196$; (d) $sigma=(398-405)/Phi^(-1)(0.01)approx 3.009$ g.


==== P2.6 — lognormal

$T$ is lognormal with log-scale parameters $mu=-1$, $sigma=2$. (a) Find $P(T<3)$. (b) Find the mean and SD of $T$.

*Answer notes.* $Phi((ln 3+1)/2)approx 0.8530$; $E(T)=e^1 approx 2.7183$; $op("SD")(T)=sqrt((e^4-1)e^2)approx 19.901$.


==== P2.7 — exponential cycles and a series system

A device's cycles-to-failure $T$ is exponential with rate $lambda=0.003$ failures/cycle. (a) Determine mean cycles to failure. (b) Given survival through 300 cycles, find the probability that it fails after 1000 cycles. (c) Find the probability that a new device does not fail in its first 700 cycles.

Independent $X_1 tilde.op op("Exp")(0.002)$, $X_2 tilde.op op("Exp")(0.003)$ and $X_3 tilde.op op("Exp")(0.005)$ are given. (d) For $Y=min(X_1,X_2,X_3)$, find $P(Y>300)$.

*Answer notes.* (a) $333.333$ cycles; (b) $P(T>1000 ∣ T>300)=e^(-0.003(700))=0.122456$; (c) the same by memorylessness; (d) $e^(-(0.002+0.003+0.005)300)=e^(-3)=0.049787$.


==== P2.8 — Weibull lifetime

A component's lifetime $T$ in years has shape $beta=0.5$ and scale $eta=0.25$. (a) Write its PDF. (b) Graph the PDF in R. (c) Find its mean and variance, using $Gamma(n)=(n-1)!$. (d) Find the probability of failure within one year.

*Answer notes.* For $t>0$, $f(t)=t^(-1/2)e^(-2sqrt(t))$, and zero for $t<0$; plot away from zero because the density diverges there. Mean $0.25 Gamma(3)=0.5$ yr; variance $0.25^2[Gamma(5)-Gamma(3)^2]=1.25$ yr${}^2$; $F(1)=1-e^(-2)=0.864665$.


=== Practical 3 — hazard, MTTF and Weibull plots

Sources: #link("../questions/probability-questions/prac/prac-sheet-3.pdf")[question sheet] · #link("../questions/probability-questions/prac/prac-sheet-3-solution.pdf")[supplied solutions].


==== P3.1 — derive hazard functions

Use the expressions for PDF and CDF to derive hazard rates for (a) exponential lifetime with rate $1/eta$; (b) Weibull lifetime with shape $beta$ and characteristic life $eta$.

*Answer notes.* $h(t)=f(t)/[1-F(t)]$ gives $1/eta$ and $(beta/eta)(t/eta)^(beta-1)$, respectively. *Source correction:* the background's alternative Weibull parameterisation mixes incompatible PDF/CDF expressions. If the CDF is $1-e^(-alpha t^beta)$, then $eta=alpha^(-1/beta)$; if it is $1-e^(-(t/alpha)^beta)$, then $alpha=eta$.


==== P3.2 — exponential hazard interpretation

A component lifetime in years has $f(t)=lambda e^(-lambda t)$, $t>0$, with $lambda=2$. This is Weibull with $beta=1$, $eta=1/lambda$. (a) Write the hazard and interpret it. (b) Calculate MTTF and SD.

*Answer notes.* $h(t)=2$ per year: for small $Delta t$, conditional failure probability is approximately $2 Delta t$ given survival to $t$. It is a rate, not a probability of 2. MTTF and SD are both 0.5 years.


==== P3.3 — solar-cell Weibull hazards

(a) Solar-cell lifetime in years is Weibull with $beta=2.5$, $eta=10$. (i) Write the hazard and evaluate it at 5, 10 and 20 years; interpret the trend. (ii) Find MTTF using $Gamma(1.4)=0.8873$. (iii) Find SD using $Gamma(1.8)=0.9314$.

(b) Plot several Weibull hazards using Mathematica, MATLAB, R or another package. Explain changes caused by varying $beta$ at fixed $eta$, and varying $eta$ at fixed $beta$.

*Answer notes.* $h(t)=0.25(t/10)^(1.5)$; the three rates are $0.08839$, $0.25$, $0.70711$ yr${}^(-1)$, increasing with age. MTTF $8.873$ yr; SD $10sqrt(0.9314-0.8873^2)approx 3.796$ yr. $beta<1,=1,>1$ gives decreasing, constant, increasing hazard. Increasing $eta$ lowers the hazard at any fixed positive $t$ and fixed $beta$; changing $beta$ changes the curve's shape, not simply its vertical height everywhere.


==== P3.4 — reliability and Weibull probability plots

(a) A component has $R(t)=exp[-(t/eta)^beta]$, $t>0$, for $beta,eta>0$. Show that its lifetime is Weibull. (b) Express $log[-log(1-F(t))]$ as a function of $log t$. (c) Plot $log t$ against $log[-log(1-F(t))]$ for $beta=2$, $eta=1$. (d) Explain how a Weibull plot checks model suitability. (e) Derive the corresponding relation for exponential lifetime of rate $1/eta$.

*Answer notes.* Differentiating $F=1-R$ gives the Weibull PDF. Set $x=log t$, $y=log[-log(1-F(t))]$; then $y=beta x-beta log eta$. Thus $y=2x$ in (c), while the exponential case has $y=x-log eta$. Approximately straight empirical points support the model. *Axis clarification:* the usual Weibull plot puts $log t$ horizontally; literally reversing the source's “against” wording changes the slope to $1/beta$.


==== P3.5 — lognormal light bulbs (Problem 2.37, adapted)

A light-bulb lifetime $T$ is lognormal with $mu=10$, $sigma=0.2$ for $X=ln T$. (a) Find $E(T)$ and $E(X)$. (b) Find $op("Var")(T)$ and $op("Var")(X)$. (c) Find the probability a bulb lasts 30,000 hours. (d) Given that it has worked for 20,000 hours, find the probability it lasts 30,000 hours.

*Answer notes.* $E(T)=e^(10.02)$; $E(X)=10$; $op("Var")(T)=(e^(0.04)-1)e^(20.04)$; $op("Var")(X)=0.04$. Interpret “lasts” as *at least*: (c) $R(30000)=1-Phi((ln 30000-10)/0.2)$; (d) $R(30000)/R(20000)$. *Units correction:* the source labels $mu$ and $sigma$ “hrs”, but they are parameters of log lifetime, not the mean and SD of $T$ in hours. Part (d) asks for total lifetime 30,000 hours, not another 30,000.


=== Practical 4 — data, censoring, MLE and Kaplan–Meier

Sources: #link("../questions/probability-questions/prac/prac-sheet-4.pdf")[question sheet] · #link("../questions/probability-questions/prac/prac-sheet-4-solution.pdf")[supplied solutions].


==== P4.setup — explicit software exploration

Install/run RStudio; set the working directory to the downloaded data folder and inspect it using `getwd()`. Import text with `read.table(..., header=TRUE)` or CSV with `read.csv`; examine `sep` for text files. Review `write.csv` and `write.table`. Load `microwaves <- read.table("microwaves.txt", header=TRUE)`, then run `microwaves`, `head(microwaves)`, `head(microwaves,10)`, `microwaves$FailureTimes`, `class(microwaves)` and `class(microwaves$FailureTimes)`.

*Source issue.* The sheet alternates between `microwave.txt` and `microwaves.txt`; use the actual filename. A dataframe and one numeric column are different object types.


==== P4.1 — microwave-transmitter lifetime and street lamps

(a) A life test on 200 microwave transmitters gives iid failure times in `microwave.txt`. (i) Construct a histogram in RStudio, trying `xlab`, `main` and `col="blue"`. (ii) Choose and justify a probability model from its shape.

(b) Ninety-nine street-lamp bulbs are observed from time zero. Seventy fail by $t=18.34$, and observation stops at that 70th failure. Estimate (i) $F(18.34)$ and (ii) $R(18.34)$, interpreting both.

*Answer notes.* The supplied solution describes the microwave histogram as right-skewed, suggesting an exponential model (shape alone does not prove constant hazard). For (b) the course's *mean-rank* estimates are $70/(99+1)=0.70$ and $0.30$. The empirical proportion/Kaplan–Meier estimate without earlier censoring would instead be $70/99$ and $29/99$; state which estimator you use.


==== P4.2 — street-lamp exponential MLE

The bulbs in P4.1(b) have exponential lifetimes; right-censored data are in `streetlamps.xlsx`.

(a) Sketch or plot a relative-frequency histogram with bin width 1.5 and explain its rightmost spike. Install/load `readxl`, import the spreadsheet, and rename its second column (“Street Lamp Failure Time (Years)”) to something manageable.

(b) Find the maximum-likelihood estimate $hat(lambda)$. Hint: the total exposure is the sum of the right-censored data recorded in the spreadsheet.

(c) Write $hat(f)(t)=hat(lambda) e^(-hat(lambda) t)$ and overlay it on the histogram. The source suggests $99hat(f)(t)$ if plotting counts.

*Answer notes.* Survivors are recorded at the censoring time 18.34, causing the artificial spike; these are not failures. The supplied exposure is 1076.4 years, giving $hat(lambda)=70/1076.4 approx 0.065032$ yr${}^(-1)$. *Plotting corrections:* `nclass` is only a suggested number of bins; specify `breaks` to enforce width 1.5. For equal-width count bins of width $w$, the matching density overlay is $"nw" hat(f)(t)$, not merely $n hat(f)(t)$ unless $w=1$. A density histogram (`freq=FALSE`) avoids that scale issue.


==== P4.3 — excavator ground-engaging tools (GET)

The LMS file `exa1.csv` has 127 time-to-failure/censoring observations from one hard-rock excavator over eight years. Bucket teeth functionally fail when their ability to penetrate rock and required power become unacceptable. There are usually five to eight teeth per bucket; each recorded replacement may involve one or more teeth, but the records do not specify how many. Columns are `time` and `status`, where 0 means censored and 1 means failed.

The sheet recommends inspecting the accompanying reliability analysis and R/Python notebooks: #link("https://systemhealthlab.com/research-tools/example-of-a-reliability-analysis-in-r/")[System Health Lab], #link("https://github.com/uwasystemhealth/weibull-R")[R repository], #link("https://github.com/uwasystemhealth/weibull-python")[Python repository]. These are source-supplied further-reading links, not additional question sources inspected for this compilation.

Start RStudio; use `getwd()`, `list.files()` and, if needed, `setwd()`. Read `q3data <- read.csv("exa1.csv")`, inspect it, and install/load `survival`.

(a) Plot histograms with and without suspensions and comment on the distribution: `hist(q3data$time)` and `hist(subset(q3data,status=="1")$time)`.

(b) Estimate MTTF using `sum(q3data$time)/sum(q3data$status)`.

(c) Calculate and plot the Kaplan–Meier survival estimate, evaluating $R(t)$ at 20, 50 and 100. The sheet gives both `Rt <- Surv(q3data$time,q3data$status); plot(Rt)` and `fit <- survfit(Surv(time,status) ~ 1,data=q3data); plot(fit)`; then `summary(fit,times=...)`.

(d) Using `weibullness`, estimate Weibull parameters with and without suspensions and comment on the difference. The source calls `weibull.mle(q3data$time,0)` and `weibull.mle(subset(q3data,status=="1")$time,0)`.

(e) Using `weibulltools`, draw a Weibull probability plot based on Kaplan–Meier CDF estimates; the source calls `estimate_cdf(q3data$time,status=q3data$status,methods="kaplan")` and `plot_prob(cdf,"weibull")`.

*Answer notes and source corrections.* The supplied solution reports KM values about $R(20)=0.333$, $R(50)=0.11$ and $R(100)=0.0113$. The MTTF formula in (b) is an exponential total-exposure estimate, not a general Weibull/KM mean. `Surv()` encodes outcomes; `survfit()` estimates KM. Calling a fit with all times but without their censoring status treats suspension times as failures and does *not* fit censored observations correctly. Dropping suspensions also wastes exposure and biases the sample towards observed failures. Use a fitting method that accepts the event indicator, as explained in #link("R.md")[the R guide]. Preserve the comparison as a diagnostic exercise, not as a recommended estimation method.


=== Practical 5 — sampling distributions and CLT

Sources: #link("../questions/probability-questions/prac/prac-sheet-5.pdf")[question sheet] · #link("../questions/probability-questions/prac/prac-sheet-5-solution.pdf")[supplied solutions].


==== P5.1 — know your Z-tables

For $Z tilde.op N(0,1)$ evaluate (a) $P(Z<1.282)$; (b) $P(Z>2.326)$; (c) $P(|Z|<0.1)$; (d) $z$ satisfying $P(|Z|<z)=0.95$.

*Answer notes.* Approximately $0.900$, $0.010$, $0.07966$, $1.95996$.


==== P5.2 — carbide drilling tips

Drilling-depth lifetimes of 36 carbide tips are an iid Normal sample with unknown mean $mu$ and known SD $sigma=12$.

(a) State the distribution of $macron(X)$ in terms of $mu$. (b) Find the probability that the sample mean lies within 4 units of the true mean. (c) Find the minimum sample size giving probability 0.99 of lying within 4 units.

*Answer notes.* $macron(X)tilde.op N(mu,4)$, exactly; $P(|macron(X)-mu|<4)=P(|Z|<2)=0.95450$; $n="ceil".l(12 Phi^(-1)(0.995)/4)^2 "ceil".r=60$.


==== P5.3 — know your t-tables

For $T tilde.op t_n$ evaluate (a) $P(T<2.160)$ with $n=13$; (b) $P(T>1.943)$ with $n=6$; (c) $P(|T|<2.750)$ with $n=30$; (d) $t$ such that $P(T<t)=0.01$ with $n=29$.

*Answer notes.* Approximately $0.975$, $0.05$, $0.99$, $-2.462$. Here $n$ labels the degrees of freedom in the question, not a sample size that needs another subtraction of one.


==== P5.4 — hole-punch machine

Hole diameters $X_1,dots,X_n$ are iid Normal with unknown mean $mu$ and unknown variance $sigma^2$. (a) State the distribution of $macron(X)=n^(-1)sum_i X_i$. (b) State the distribution of $(macron(X)-mu)/(S/sqrt(n))$. (c) Say whether each is exact or approximate and why.

*Answer notes.* (a) $N(mu,sigma^2/n)$ exactly, even though parameters are unknown; (b) $t_(n-1)$ exactly, because the parent distribution is Normal and $S$ is its usual sample SD. Unknown parameters do not make the underlying Normal sampling law approximate.


==== P5.5 — Weibull circuit-board CLT

Fifty iid electronic circuit-board lifetimes $T_1,dots,T_(50)$ are Weibull with shape $beta=2$ and characteristic life $eta=5$.

(a) Find $P(T_1>5)$. (b) State the distribution and numerical parameters of $macron(T)=50^(-1)sum_i T_i$, using $Gamma(1.5)=0.8862$. (c) Is the distribution exact or approximate? Explain. (d) Approximate $P(macron(T)>5)$. (e) Find the minimum sample size needed so that $P(|macron(T)-mu|<0.5)>0.95$, where $mu=E(T)$.

*Answer notes.* (a) $e^(-1)=0.367879$. (b) $mu=4.431$, $sigma^2=25(1-0.8862^2)=5.366239$; $macron(T)thin dot(tilde.op)thin N(4.431,0.10732478)$. (c) CLT approximation because individual lifetimes are Weibull. (d) $1-Phi((5-4.431)/sqrt(0.10732478))approx 0.0412$. (e) $n>(Phi^(-1)(0.975)sigma/0.5)^2 approx 82.46$, hence 83 using the CLT. This is an approximate design calculation, not an exact probability guarantee for Weibull data.


== Statistics quizzes

Quiz numbers refer to the saved source Markdown, not newly generated practice.


=== Statistics Quiz 1

*Source transcription:* #link("../questions/probability-questions/quizes/stat-quiz-1.md")[stat-quiz-1.md]. Existing worked answers are study solutions, not a claim of an official marking key.


==== Q1.1 — disjoint events

*Original prompt:* “Which is true about disjoint sets?” The saved note includes $P(A union B^c)=1-P(B^c)$, but does not save the answer options.

*Correction / answer status.* The saved expression is not generally true. For disjoint $A,B$, $A subset.eq B^c$, so $P(A union B^c)=P(B^c)=1-P(B)$. Also $P(A ∩ B)=0$ and $P(A union B)=P(A)+P(B)$. Without the missing choices an original option letter cannot be recovered.


==== Q1.2 — union of independent events

$A_1,dots,A_(20)$ are independent events, each with probability $p$. Which expression for $P(A_1 union dots.c union A_(20))$ is correct?

*Answer added.* $1-(1-p)^(20)$. Original choices were not saved.


==== Q1.3 — independent intersection

What is the intersection probability of two independent events?

*Answer.* $P(A ∩ B)=P(A)P(B)$.


==== Q1.4 — reverse conditioning

$P(A ∣ B)=0.3$, $P(B ∣ A)=0.1$ and $P(B)=0.1$. Find $P(A)$.

*Answer added.* $P(A ∩ B)=0.3(0.1)=0.03$, hence $P(A)=0.03/0.1=0.3$.


==== Q1.5 — seeded Normal sample median

Set the R random seed to 5507 and generate 20 observations from a Normal distribution with mean 10 and SD 5. Find the sample median to three decimal places.

*Answer checked in R:* median $11.34972 dots$, hence *11.350*.

```r
set.seed(5507)
sample_data <- rnorm(20, mean=10, sd=5)
round(median(sample_data), 3)
```


==== Q1.6 — interval probability from a CDF

Given the CDF below, find $P(2.2<X<2.7)$:

$ F(x)=cases(0 quad x <= 1, 1-frac(2, x(x+1)) quad x>1.) $

*Formatting repair.* The source omitted the closing cases environment and value at 1; continuity supplies $F(1)=0$.

*Answer.* $F(2.7)-F(2.2)=2/(2.2 dot 3.2)-2/(2.7 dot 3.7)approx 0.08389$.

```r
F <- function(x) ifelse(x <= 1, 0, 1 - 2/(x*(x+1)))
F(2.7) - F(2.2)
```


==== Q1.7 — PDF from a CDF

Find the PDF for

$ F(x)=cases(0 quad x <=-1, (x^2+2x+1)/9 quad -1<x <= 2, 1 quad x>2.) $

*Answer.* Differentiate on each interval:

$ f(x)=cases((2x+2)/9 quad -1<x<2, 0 quad "otherwise".) $


==== Q1.8 — integrating a PDF

A continuous random variable has $f(x)=x/32$ on $0<x<8$, zero elsewhere. Find $P(1.6<X<4.1)$ to two decimal places.

*Answer completed.* Within the support, $F(x)=x^2/64$, so the probability is $(4.1^2-1.6^2)/64=0.22265625 approx 0.22$.


==== Q1.9 — reliability tail

Given $R(t)=e^(-2t)$, find the chance that the component lasts more than 2.5 time units.

*Answer.* $R(2.5)=e^(-5)=0.00673795$, approximately 0.67%.


=== Statistics Quiz 2

*Source transcription:* #link("../questions/probability-questions/quizes/stat-quiz-2.md")[stat-quiz-2.md]. Existing worked answers are study solutions, not a claim of an official marking key.


==== Q2.1

$Z tilde.op N(0,1)$. Find (to 2 decimal places): $P(Z>0.21)$


===== Answer

```python
import scipy.stats as stats

z = 0.21
p = 1 - stats.norm.cdf(z)
print(f"{p:.2f}")
```

```r
z <- 0.21
p <- pnorm(z, lower.tail = FALSE)
cat(sprintf("%.2f\n", p))
```


==== Q2.2

$Z tilde.op N(0,1)$. Find (to 2 decimal places): Find the positive $z$ such that $P(|Z|>z)=0.85$.


===== Answer

```python
import scipy.stats as stats

tail_probability = 0.85 / 2
z = stats.norm.ppf(1 - tail_probability)
print(f"{z:.2f}")
```

```r
tail_probability <- 0.85 / 2
z <- qnorm(1 - tail_probability)
cat(sprintf("%.2f\n", z))
```


==== Q2.3

$X tilde.op N(9,100)$.

Evaluate the following (give answers correct to 4 decimal places):

$P(X<14.79)$


===== Answer

```python
import scipy.stats as stats

mean = 9
standard_deviation = 100*0.5
p = stats.norm.cdf(14.79, loc=mean, scale=standard_deviation)
print(f"{p:.4f}")
```

```r
mean <- 9
standard_deviation <- sqrt(100)
p <- pnorm(14.79, mean = mean, sd = standard_deviation)
cat(sprintf("%.4f\n", p))
```


==== Q2.4

X has a Uniform distribution on the interval from 0 to 13. Find $P(3.2<X<8.9)$. (Give your answer to 3 decimal places.)


===== Answer

```python
import scipy.stats as stats

lower_bound = 0
upper_bound = 13
distribution = stats.uniform(
    loc=lower_bound,
    scale=upper_bound - lower_bound,
)
p = distribution.cdf(8.9) - distribution.cdf(3.2)
print(f"{p:.3f}")
```

```r
lower_bound <- 0
upper_bound <- 13
p <- punif(8.9, min = lower_bound, max = upper_bound) -
    punif(3.2, min = lower_bound, max = upper_bound)
cat(sprintf("%.3f\n", p))
```


==== Q2.5

The Gamma distributions were seen in the Week 2 lecture. The cdf of these distributions cannot generally be expressed as an elementary function, so we need to use software to evaluate Gamma probabilities and quantiles (just as we have already seen for the Normal distribution, in Practical Sheet 1). We can perform the calculation of Gamma probabilities and quantiles using the functions pgamma() and qgamma(). Use the command help(pgamma), or Google, to see how these functions are used.

Suppose that X has a Gamma distribution with shape parameter $beta=2.27$ and rate parameter $lambda=1.22$. Find $P(X>2.48)$, giving your answer to 3 d.p. accuracy.


===== Answer

```python
import scipy.stats as stats

shape = 2.27
rate = 1.22
p = stats.gamma.sf(2.48, a=shape, scale=1 / rate)
print(f"{p:.3f}")
```

```r
shape <- 2.27
rate <- 1.22
p <- pgamma(2.48, shape = shape, rate = rate, lower.tail = FALSE)
cat(sprintf("%.3f\n", p))
```


==== Q2.6

The Gamma distributions were seen in the Week 2 lecture. The cdf of these distributions cannot generally be expressed as an elementary function, so we need to use software to evaluate Gamma probabilities and quantiles (just as we have already seen for the Normal distribution, in Practical Sheet 1). We can perform the calculation of Gamma probabilities and quantiles using the functions pgamma() and qgamma(). Use the command help(pgamma), or Google, to see how these functions are used.

X has a Gamma distribution with shape parameter $beta=2.26$ and rate parameter $lambda=1.27$. Find the value c such that $P(X <= c)=0.78$, giving your answer to 2 d.p. accuracy.


===== Answer

```python
import scipy.stats as stats

shape = 2.26
rate = 1.27
c = stats.gamma.ppf(0.78, a=shape, scale=1 / rate)
print(f"{c:.2f}")
```

```r
shape <- 2.26
rate <- 1.27
c <- qgamma(0.78, shape = shape, rate = rate)
cat(sprintf("%.2f\n", c))
```


==== Q2.7

Suppose that $X tilde.op N(5,1)$ and $T=e^X$.

Find the standard deviation of T (give answers correct to 2 decimal places).

Because $T=e^X$, taking the natural logarithm gives

$ ln(T)=X tilde.op N(mu,sigma^2). $

A positive random variable whose logarithm is normally distributed has a lognormal distribution. Therefore, $T$ is lognormal with $mu=5$ and $sigma^2=1$. In SciPy, `stats.lognorm` uses `s` for $sigma$ and `scale` for $e^mu$.

The standard deviation of a lognormal random variable is

$ op("SD")(T)
 = e^(mu+sigma^2/2)sqrt(e^(sigma^2)-1) \
= e^(5+1/2)sqrt(e^1-1) \
approx 320.75. $


===== Answer

```python
from math import exp

import scipy.stats as stats

mean = 5
standard_deviation = 1*0.5
sd_t = stats.lognorm.std(
    s=standard_deviation,
    scale=exp(mean),
)
print(f"{sd_t:.2f}")
```

```r
mean <- 5
variance <- 1
sd_t <- exp(mean + variance / 2) * sqrt(exp(variance) - 1)
cat(sprintf("%.2f\n", sd_t))
```


==== Q2.8

Suppose that $X tilde.op N(6,16)$ and $T=e^X$.

Find $P(T>35)$ (give answers correct to 2 decimal places).


===== Answer

```python
from math import log

import scipy.stats as stats

mean = 6
standard_deviation = 16*0.5
p = stats.norm.sf(
    log(35),
    loc=mean,
    scale=standard_deviation,
)
print(f"{p:.2f}")
```

```r
mean <- 6
standard_deviation <- sqrt(16)
p <- pnorm(
    log(35),
    mean = mean,
    sd = standard_deviation,
    lower.tail = FALSE
)
cat(sprintf("%.2f\n", p))
```


==== Q2.9

X observes a Weibull distribution with shape parameter

$beta=7$

and characteristic life

$eta=91$

Find the standard deviation of X (answers to 2 decimal places).


===== Answer

```python
import scipy.stats as stats

shape = 7
characteristic_life = 91
sd_x = stats.weibull_min.std(
    c=shape,
    scale=characteristic_life,
)
print(f"{sd_x:.2f}")
```

```r
shape <- 7
characteristic_life <- 91
sd_x <- characteristic_life * sqrt(
    gamma(1 + 2 / shape) - gamma(1 + 1 / shape)^2
)
cat(sprintf("%.2f\n", sd_x))
```


==== Q2.10

X observes a Weibull distribution with shape parameter

$beta=0.4$

and characteristic life

$eta=1.3$

Find the following probability (to 3 decimal places):

$P(X>4.7)$


===== Answer

```python
import scipy.stats as stats

shape = 0.4
characteristic_life = 1.3
p = stats.weibull_min.sf(
    4.7,
    c=shape,
    scale=characteristic_life,
)
print(f"{p:.3f}")
```

```r
shape <- 0.4
characteristic_life <- 1.3
p <- pweibull(
    4.7,
    shape = shape,
    scale = characteristic_life,
    lower.tail = FALSE
)
cat(sprintf("%.3f\n", p))
```


==== Q2.11

X is an exponential random variable with $P(X<6.21)=0.632$. Find the mean of X (give answers correct to 2 decimal places).

For an exponential distribution with mean $mu$,

$ P(X < x) = 1 - e^(-x/mu). $

Substitute $x = 6.21$ and $P(X < x) = 0.632$:

$ 0.632 = 1 - e^(-6.21/mu) \
e^(-6.21/mu) = 0.368 \
-frac(6.21, mu) = ln(0.368) \
mu = -frac(6.21, ln(0.368)) \
approx 6.21. $


===== Answer

```python
from math import log

x = 6.21
p = 0.632
mean = -x / log(1 - p)
print(f"{mean:.2f}")
```

```r
x <- 6.21
p <- 0.632
mean <- -x / log(1 - p)
cat(sprintf("%.2f\n", mean))
```

Answers 0.42, 0.19, 0.7187, 0.438, 0.251, 2.52, 320.75, 0.73, 14.30, 0.188, 6.21.


=== Statistics Quiz 3

*Source transcription:* #link("../questions/probability-questions/quizes/stat-quiz-3.md")[stat-quiz-3.md]. Existing worked answers are study solutions, not a claim of an official marking key.


==== Q3.1

_1 point_

The lifetime of a component follows a probability distribution with reliability function

$ R(t) = frac(3.24, (t + 2.7)(t + 1.2)). $

Let $f(t)$ denote the PDF for the failure time of the component. Find the value of $f(2.2)$, giving your answer correct to two decimal places.


===== Answer

The PDF is the negative derivative of the reliability function:

$ f(t) = -frac(d R(t), "dt"). $

Writing the reliability function as

$ R(t) = 3.24 [(t + 2.7)(t + 1.2)]^(-1), $

gives

$ f(t)
= frac(3.24(2t + 3.9), (t + 2.7)^2(t + 1.2)^2). $

At $t = 2.2$,

$ f(2.2)
= frac(3.24 ( 2(2.2) + 3.9 ), (2.2 + 2.7)^2(2.2 + 1.2)^2) \
= 0.096888 dots $

Therefore,

$ f(2.2) = 0.10. $


==== Q3.2

_1 point_

The lifetime of a component follows a probability distribution with reliability function

$ R(t) = frac(2.08, (t + 1.6)(t + 1.3)). $

Let $h(t)$ denote the hazard rate function for this distribution. Find the value of $h(2)$, giving your answer correct to two decimal places.


===== Answer

The hazard rate is related to the reliability function by

$ h(t) = -frac(d, "dt")ln R(t). $

For the given reliability function,

$ ln R(t)
= ln(2.08) - ln(t + 1.6) - ln(t + 1.3). $

Therefore,

$ h(t) = frac(1, t + 1.6) + frac(1, t + 1.3). $

At $t = 2$,

$ h(2)
= frac(1, 2 + 1.6) + frac(1, 2 + 1.3) \
= 0.580808 dots $

Hence,

$ h(2) = 0.58. $


==== Q3.3

_1 point_

A component has reliability function $R(t)$ and hazard rate function $h(t)$.

Which of the following statements is correct?

A. When $h(t)$ is constant, the failures tend to accelerate (or the items wear out more quickly) as time increases.

B. $h(t)$ measures the tendency or rate of failure at time $t$, relative to (or conditioned on) the reliability at $t$.

C. When $h(t)$ is constant, the failures tend to decelerate (or the durability of the item increases) as time increases.


===== Answer

The hazard rate $h(t)$ is the instantaneous rate of failure at time $t$, conditional on the component having survived to time $t$.

Therefore, the correct statement is

$ "Option B". $

A constant hazard rate means the failure tendency remains constant over time; it neither accelerates nor decelerates.


==== Q3.4

_1 point_

The failure time of a particular component is an exponential random variable with hazard rate

$ h(t) = 0.51. $

What is the mean time to failure?

Give your answer to two decimal places.

_Integer, decimal, or E notation allowed._


===== Answer

For an exponential distribution with constant hazard rate $lambda$, the mean time to failure is

$ op("MTTF") = frac(1, lambda). $

Using $lambda = 0.51$,

$ op("MTTF")
= frac(1, 0.51) \
= 1.960784 dots $

Therefore,

$ op("MTTF") = 1.96. $


==== Q3.5

_1 point_

The failure time $T$ (in weeks) of a particular component has an exponential distribution with rate $0.13$. The component has already been in use for some time and is still operational at time $t = 7.9$ weeks. Given this information, find the probability that the component survives until time $t = 17$ weeks.

Give your answer correct to two decimal places.


===== Answer

The required conditional probability is

$ P(T > 17 ∣ T > 7.9). $

The exponential distribution has the memoryless property, so

$ P(T > 17 ∣ T > 7.9)
= P(T > 17 - 7.9). $

Using the exponential reliability function $R(t) = e^(-lambda t)$,

$ P(T > 17 ∣ T > 7.9)
= e^(-0.13(17 - 7.9)) \
= e^(-1.183) \
= 0.306358 dots $

Therefore,

$ P(T > 17 ∣ T > 7.9) = 0.31. $


==== Q3.6

_1 point_

A component has lifetime $T$, which has an exponential distribution with rate $2.7$.

What is the value of the hazard rate function at time $t = 0.8$?


===== Answer

For an exponential distribution with rate $lambda$, the hazard rate is constant:

$ h(t) = lambda. $

Since $lambda = 2.7$,

$ h(0.8) = 2.7. $


==== Q3.7

_1 point_

A component lifetime $T$ has a Weibull distribution with:

- shape parameter $beta = 2$
- characteristic life $eta = 3$

Which of the following is a correct expression for the hazard function?

A. $0.5$

B. $e^(-(t/3)^2)$

C. $0.375t^2$

D. $0.22222t^1$


===== Answer

For a Weibull distribution with shape parameter $beta$ and characteristic life $eta$, the hazard function is

$ h(t) = frac(beta, eta)( frac(t, eta))^(beta - 1). $

Substituting $beta = 2$ and $eta = 3$ gives

$ h(t)
= frac(2, 3)( frac(t, 3))^(2 - 1) \
= frac(2t, 9) \
= 0.22222 dots t^1. $

Therefore, the correct expression is

$ "Option D". $


==== Q3.8

_1 point_

Let $T$ be the time to failure for a particular computer system. The system functions with the “good as new” property, namely, a constant hazard rate $h(t) = 0.6$.

Find $P(1 < T < 2)$, giving your answer to three decimal places.


===== Answer

A constant hazard rate $h(t) = lambda$ gives the exponential reliability function

$ R(t) = P(T > t) = e^(-lambda t). $

The probability of failure between times $1$ and $2$ is

$ P(1 < T < 2) = R(1) - R(2). $

Using $lambda = 0.6$,

$ P(1 < T < 2)
= e^(-0.6(1)) - e^(-0.6(2)) \
= e^(-0.6) - e^(-1.2) \
= 0.247617 dots $

Therefore,

$ P(1 < T < 2) = 0.248. $


==== Q3.9

_1 point_

The failure time of a particular component is a Weibull random variable with:

- shape parameter $beta = 4$
- characteristic life $eta = 1$

Determine the mean time to failure to two decimal places.

Use $Gamma(1.25) = 0.9064$.

_Integer, decimal, or E notation allowed._


===== Answer

For a Weibull distribution with shape parameter $beta$ and characteristic life $eta$, the mean time to failure is

$ op("MTTF")
= eta thin Gamma ( 1 + frac(1, beta)). $

Substituting $beta = 4$ and $eta = 1$ gives

$ op("MTTF")
= 1 times Gamma ( 1 + frac(1, 4)) \
= Gamma(1.25) \
= 0.9064. $

Therefore,

$ op("MTTF") = 0.91. $


==== Q3.10

_1 point_

A component has reliability function

$ R(t) = frac(1, (1 + t)^a), wide t > 0, $

where $a = 7$.

Determine its mean time to failure. Give your answer correct to two decimal places.


===== Answer

The mean time to failure can be found by integrating the reliability function:

$ op("MTTF") = integral_0^infinity R(t)thin "dt". $

With $a = 7$,

$ op("MTTF")
= integral_0^infinity frac(1, (1 + t)^7)thin "dt" \
= [-frac(1, 6)(1 + t)^(-6)]_0^infinity \
= frac(1, 6) \
= 0.166666 dots $

Therefore,

$ op("MTTF") = 0.17. $


=== Statistics Quiz 4

*Source transcription:* #link("../questions/probability-questions/quizes/stat-quiz-4.md")[stat-quiz-4.md]. Existing worked answers are study solutions, not a claim of an official marking key.


==== Q4.1

_1 point_

A system has reliability function

$ R(t)
= e^(-(a+c)t)+e^(-(b+c)t)-e^(-(a+b+c)t), $

where

$ a=0.14,wide b=0.04,wide c=0.23. $

Determine the mean time to failure, giving your answer correct to three decimal places.


===== Answer

The mean time to failure is the integral of the reliability function:

$ op("MTTF")=integral_0^infinity R(t)thin "dt". $

Therefore,

$ op("MTTF")
=integral_0^infinity
( e^(-(a+c)t)+e^(-(b+c)t)-e^(-(a+b+c)t)) "dt" \
=frac(1, a+c)+frac(1, b+c)-frac(1, a+b+c) \
=frac(1, 0.14+0.23)
 +frac(1, 0.04+0.23)
 -frac(1, 0.14+0.04+0.23) \
=3.967382 dots $

Hence,

$ op("MTTF")=3.967. $

#quote[
*Note:* The unformatted question text showed a plus sign before all three terms. The final term must be subtracted; otherwise $R(0)=3$, so the given expression could not be a reliability function.
]


==== Q4.2

_1 point_

A statistical life test is carried out on a particular type of component. Failure times for a large number of identical components are represented by the histogram shown in the quiz.

Which of the following models might be a reasonable first choice?

A. Weibull with $beta>1$

B. Exponential

C. Normal


===== Answer

The histogram has a positive failure time, an interior peak, and a right-skewed tail. A Weibull distribution with $beta>1$ can have this shape and represents an increasing hazard rate.

An exponential density decreases from its maximum at zero, while a normal density is symmetric and permits negative values.

Therefore, a reasonable first choice is

$ "Option A: Weibull with "beta>1. $


==== Q4.3

_1 point_

We observe $11$ independent components, starting from time $t=0$. Observation ends immediately following the ninth failure, which occurs at $t=13.48$.

Using the mean-rank method, give an appropriate estimate of $F(13.48)$ correct to two decimal places.


===== Answer

The mean-rank estimate at the $i$th ordered failure among $n$ components is

$ hat(F)(t_i)=frac(i, n+1). $

Here, $i=9$ and $n=11$, so

$ hat(F)(13.48)
=frac(9, 11+1)
=frac(9, 12)
=0.75. $

Therefore,

$ hat(F)(13.48)=0.75. $


==== Q4.4

_1 point_

A lifetime test is carried out on $10$ components, with failure times

$ 9.7,thin 3.3,thin 5.4,thin 2.5,thin 8.7,thin 2.2,thin 5.5,thin 7.9,thin 0.4,thin 8.1. $

The failure times are assumed to be iid exponential random variables with hazard rate $lambda$.

Determine the maximum-likelihood estimate of $lambda$, giving your answer to three decimal places.

_Integer, decimal, or E notation allowed._


===== Answer

For complete exponential lifetime data, the MLE of the hazard rate is

$ hat(lambda)
=frac(n, sum_(i=1)^n t_i)
=frac(1, macron(t)). $

Using R:

```r
failure_times <- c(9.7, 3.3, 5.4, 2.5, 8.7,
                   2.2, 5.5, 7.9, 0.4, 8.1)

n <- length(failure_times)
lambda_hat <- n / sum(failure_times)

lambda_hat
# [1] 0.1862197

round(lambda_hat, 3)
# [1] 0.186
```

Therefore,

$ hat(lambda)=0.186. $


==== Q4.5

_1 point_

A total of $15$ components are observed from $t=0$ until $t=50$. Ten components fail during this interval, at the following times:

$ 5.3,thin 5.1,thin 9.4,thin 6.9,thin 3.7,thin 5.0,thin 6.0,thin 8.8,thin 9.9,thin 7.7. $

The remaining five components are right-censored at $t=50$. The component lifetimes are assumed to be iid exponential random variables with hazard rate $lambda$.

Determine the maximum-likelihood estimate of $lambda$, giving your answer to three decimal places.

_Integer, decimal, or E notation allowed._


===== Answer

For $r$ failures and right-censored exponential data, the MLE is

$ hat(lambda)
=frac(r, "total time on test"). $

The ten failure times sum to

$ sum_(i=1)^(10)t_i=67.8. $

Each of the five surviving components contributes $50$ units of test time, so

$ "total time on test"
=67.8+5(50)
=317.8. $

Therefore,

$ hat(lambda)
=frac(10, 317.8) \
=0.031466 dots $

and hence

$ hat(lambda)=0.031. $


==== Q4.6

_1 point_

A repairable component fails at times

$ t=1,thin 2,thin 3,thin 5,thin 8. $

No further failures are observed during the observation period, which ends at $t=17.5$.

Determine the mean time between failures (MTBF), giving your answer to three decimal places.

_Integer, decimal, or E notation allowed._


===== Answer

For a repairable component,

$ hat(op("MTBF"))
=frac("total operating time", "number of failures"). $

There are five failures in $17.5$ units of operating time. Therefore,

$ hat(op("MTBF"))
=frac(17.5, 5)
=3.5. $

Thus,

$ hat(op("MTBF"))=3.500. $


==== Q4.7

_1 point_

A repairable component fails at times

$ t=2,thin 3,thin 6,thin 9,thin 10. $

No further failures are observed during the observation period, which ends at $t=11$.

Determine the standard deviation of the time between failures, giving your answer to three decimal places.

_Integer, decimal, or E notation allowed._


===== Answer

Starting from $t=0$, the five completed times between failures are

$ 2,thin 3-2,thin 6-3,thin 9-6,thin 10-9
=2,thin 1,thin 3,thin 3,thin 1. $

The interval from $t=10$ to $t=11$ is right-censored because no failure occurs at its end, so it is not a completed time between failures.

The mean of the five completed times is

$ macron(t)=frac(2+1+3+3+1, 5)=2. $

Using the empirical standard deviation with divisor $5$,

$ hat(sigma)
=sqrt(frac((2-2)^2+(1-2)^2+(3-2)^2+(3-2)^2+(1-2)^2, 5)) \
=sqrt(0.8) \
=0.894427 dots $

Therefore,

$ hat(sigma)=0.894. $

*Ambiguity note for Q4.7.* The saved answer uses divisor $n=5$ on completed intervals only. R's usual sample SD uses $n-1$ and would give 1.000. Neither descriptive calculation corrects for right censoring. Because the prompt does not specify a divisor or lifetime model, preserve 0.894 as the existing study answer rather than claiming a unique official answer.


==== Q4.8

_1 point_

Use the R packages `survival` and `survminer` for Questions 8--10. The following data give the lifetimes, in operating hours, of $23$ identical components. Measurements marked with an asterisk are suspensions:

$ 8.0,thin 21.3,thin 25.5,thin 8.1,thin 4.5,thin 4.2,thin 13.2,thin 9.9,thin 11.9^ast, \
27.0,thin 25.7,thin 25.8,thin 28.6,thin 14.5,thin 8.0,thin 21.9,thin 10.0^ast, \
10.6,thin 16.5^ast,thin 34.9,thin 17.5,thin 5.4,thin 20.2. $

Calculate the Kaplan--Meier estimate of $R(18)$, giving your answer to three decimal places.

_Integer, decimal, or E notation allowed._


===== Answer

Use `status = 1` for a failure and `status = 0` for a suspension:

```r
library(survival)
library(survminer)

q8_data <- data.frame(
    status = c(
        1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1,
        1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1
    ),
    time = c(
        8.0, 21.3, 25.5, 8.1, 4.5, 4.2, 13.2, 9.9, 11.9,
        27.0, 25.7, 25.8, 28.6, 14.5, 8.0, 21.9, 10.0,
        10.6, 16.5, 34.9, 17.5, 5.4, 20.2
    )
)

fit_q8 <- survfit(Surv(time, status) ~ 1, data = q8_data)
summary(fit_q8, times = 18)
```

R gives

$ hat(R)(18)=0.4944482 dots $

Therefore,

$ hat(R)(18)=0.494. $


==== Q4.9

_1 point_

The following data give the lifetimes, in operating hours, of $23$ identical components. Measurements marked with an asterisk are suspensions:

$ 8.0,thin 21.3,thin 25.5,thin 8.1,thin 4.5,thin 4.2,thin 13.2,thin 9.9,thin 11.9^ast, \
27.0,thin 25.7,thin 25.8,thin 28.6,thin 15.5,thin 9.0,thin 22.9,thin 11.0^ast, \
11.6,thin 17.5^ast,thin 35.9,thin 18.5,thin 6.4,thin 21.2. $

Use the Kaplan--Meier approach to estimate $F(14)$, giving your answer to three decimal places.

_Integer, decimal, or E notation allowed._


===== Answer

```r
library(survival)
library(survminer)

q9_data <- data.frame(
    status = c(
        1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1,
        1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1
    ),
    time = c(
        8.0, 21.3, 25.5, 8.1, 4.5, 4.2, 13.2, 9.9, 11.9,
        27.0, 25.7, 25.8, 28.6, 15.5, 9.0, 22.9, 11.0,
        11.6, 17.5, 35.9, 18.5, 6.4, 21.2
    )
)

fit_q9 <- survfit(Surv(time, status) ~ 1, data = q9_data)
r14 <- summary(fit_q9, times = 14)$surv
f14 <- 1 - r14
f14
```

The Kaplan--Meier estimate is

$ hat(R)(14)=0.5993311 dots $

Since $F(t)=1-R(t)$,

$ hat(F)(14)
=1-hat(R)(14) \
=1-0.5993311 dots \
=0.4006689 dots $

Therefore,

$ hat(F)(14)=0.401. $


==== Q4.10

_1 point_

The following data give the lifetimes, in operating hours, of $23$ identical components. Measurements marked with an asterisk are suspensions:

$ 8.0,thin 21.3,thin 25.5,thin 8.1,thin 4.5,thin 4.2,thin 13.2,thin 9.9,thin 11.9^ast, \
27.0,thin 25.7,thin 25.8,thin 28.6,thin 13.5,thin 7.0,thin 20.9,thin 9.0^ast, \
9.6,thin 15.5^ast,thin 33.9,thin 16.5,thin 4.4,thin 19.2. $

Evaluate the MLE of $beta$ for a two-parameter Weibull model with threshold zero. Omit the censored data from the calculation and give your answer to three decimal places.

_Integer, decimal, or E notation allowed._


===== Answer

*Scope note.* This question explicitly instructs you to omit censored data, so follow that instruction for its requested calculation. A full reliability analysis should generally retain their survival information in a censor-aware likelihood.

After omitting the three censored observations $11.9$, $9.0$, and $15.5$, the calculation uses $20$ failure times.

For complete Weibull data, the MLE of $beta$ solves

$ frac(1, beta)
+frac(1, n)sum_(i=1)^n ln t_i
-frac(sum_(i=1)^n t_i^beta ln t_i, sum_(i=1)^n t_i^beta)
=0. $

This equation requires a numerical solution, so it is appropriate to use R:

```r
failure_times <- c(
    8.0, 21.3, 25.5, 8.1, 4.5, 4.2, 13.2, 9.9,
    27.0, 25.7, 25.8, 28.6, 13.5, 7.0, 20.9, 9.6,
    33.9, 16.5, 4.4, 19.2
)

weibull_score <- function(beta) {
    1 / beta + mean(log(failure_times)) -
        sum(failure_times^beta * log(failure_times)) /
        sum(failure_times^beta)
}

beta_hat <- uniroot(
    weibull_score,
    interval = c(0.1, 10),
    tol = 1e-12
)$root
beta_hat
```

This gives

$ hat(beta)=1.888809 dots $

Therefore,

$ hat(beta)=1.889. $


=== Statistics Quiz 5

*Source transcription:* #link("../questions/probability-questions/quizes/stat-quiz-5.md")[stat-quiz-5.md]. Existing worked answers are study solutions, not a claim of an official marking key.

The source references a Python verification script that is absent from this workspace; no verification claim is carried over from that reference. In the Normal notation below, the second parameter is the variance.


==== Q5.1

_1 point_

We have a simple random sample $X_1,dots,X_8$ from a normal population with mean $49$ and standard deviation $2$.

Select the probability distribution of

$ macron(X)=frac(1, 8)(X_1+dots.c+X_8). $

A. $N(0,1)$

B. $N(0,0.5)$

C. $N(49,0.5)$

D. $N(49,4)$

E. $N(49,0.06)$


===== Answer

Because the population is normal, the sample mean is exactly normal. Its mean and variance are

$ E[macron(X)]=49,
wide
op("Var")(macron(X))=frac(2^2, 8)=0.5. $

Therefore,

$ macron(X)tilde.op N(49,0.5)", so the answer is Option C". $


==== Q5.2

Let $X_1,dots,X_(14)$ be a simple random sample from a normal population with mean $14$ and variance $25$. Find

$ P(macron(X)>13). $

Give the answer correct to two decimal places.


===== Answer

The population standard deviation is $sigma=sqrt(25)=5$, so

$ macron(X)tilde.op N ( 14,frac(25, 14)) $

and the standard error is

$ op("SE")(macron(X))=frac(5, sqrt(14))=1.336306 dots. $

Therefore,

$ P(macron(X)>13)
=P ( Z>frac(13-14, 5/sqrt(14))) \
=P(Z>-0.748331 dots) \
=0.772869 dots. $

Hence,

$ P(macron(X)>13)=0.77. $


==== Q5.3

_1 point_

Let $X_1,dots,X_(49)$ be a simple random sample from a normal population with mean $mu$ and standard deviation $52$. Find

$ P (|macron(X)-mu|>0.41 ). $

Give the answer correct to four decimal places.


===== Answer

The standard error of the sample mean is

$ op("SE")(macron(X))
=frac(52, sqrt(49))
=frac(52, 7)
=7.428571 dots. $

Using symmetry,

$ P (|macron(X)-mu|>0.41 )
=P (|Z|>frac(0.41, 52/7)) \
=2 [ 1-Phi(0.055192 dots)] \
=0.955985 dots. $

Therefore,

$ P (|macron(X)-mu|>0.41 )=0.9560. $


==== Q5.4

_1 point_

Let $X_1,dots,X_n$ be a simple random sample from a normal population with mean $mu$ and variance $16$. Find the minimum sample size needed to ensure that

$ P (|macron(X)-mu|<2 )>= 0.99. $


===== Answer

Here $sigma=4$. The middle probability must be at least $0.99$, leaving $0.005$ in each tail. Thus the required critical value is $z_(0.995)=2.575829 dots$.

Since

$ frac(2, 4/sqrt(n))=frac(sqrt(n), 2), $

the requirement is

$ frac(sqrt(n), 2)>= z_(0.995). $

Therefore,

$ n
>= ( frac(z_(0.995)(4), 2))^2 \
=26.539586 dots. $

Always rounding a required sample size up gives

$ n_(min)=27. $

Indeed, the middle probabilities for $n=26$ and $n=27$ are approximately $0.98921$ and $0.99063$, respectively, confirming that $27$ is the minimum.


==== Q5.5

_1 point_

Suppose that $T$ follows a $t$ distribution with $5$ degrees of freedom. Find the positive value $t$ such that

$ P(|T|>t)=0.0125. $

Give the answer correct to three decimal places.


===== Answer

The $t$ distribution is symmetric, so each tail must have probability

$ frac(0.0125, 2)=0.00625. $

Consequently,

$ P(T<t)=1-0.00625=0.99375, $

and the required critical value is

$ t=t_(5,thin 0.99375)=3.810004 dots. $

Therefore,

$ t=3.810. $


==== Q5.6

_1 point_

Suppose that $T$ follows a $t$ distribution with $11$ degrees of freedom. Find

$ P(T<2.718). $

Give the answer correct to three decimal places.


===== Answer

Using the $t_(11)$ cumulative distribution,

$ P(T<2.718)=0.989998 dots. $

Hence,

$ P(T<2.718)=0.990. $


==== Q5.7

_1 point_

Suppose that $T$ follows a $t$ distribution with $23$ degrees of freedom. Find

$ P(T>2.069). $

Give the answer correct to three decimal places.


===== Answer

Using the upper tail of the $t_(23)$ distribution,

$ P(T>2.069)=0.024982 dots. $

Therefore,

$ P(T>2.069)=0.025. $


==== Q5.8

_1 point_

The random variables $Y_1,Y_2,dots,Y_(98)$ are independent and identically distributed, with mean $0.74$ and variance $1.1$.

What is the approximate distribution of

$ macron(Y)=frac(1, 98)(Y_1+dots.c+Y_(98))? $

A. $N(0.74,0.0112)$

B. $N(0.74,1.1)$

C. $N(0.74,0.1059)$

D. $N(0.74,1.12)$


===== Answer

By the central limit theorem, the sample mean is approximately normal because $n=98$ is large. Its mean and variance are

$ E[macron(Y)]=0.74,
wide
op("Var")(macron(Y))
=frac(1.1, 98)
=0.011224 dots. $

Thus,

$ macron(Y)thin dot(tilde.op)thin N(0.74,0.0112)", so the answer is Option A". $

The value $0.1059$ in Option C is the standard error, not the variance.


==== Q5.9

_1 point_

The random variables $Y_1,Y_2,dots,Y_(64)$ are independent and identically distributed, and each follows a normal distribution with mean $0.60$ and variance $0.16$.

The distribution of $macron(Y)$ is stated to be approximately normal. Why is this an approximation?

A. The true population distribution is unknown; however, because the sample size is large, the sample mean is approximately normally distributed.

B. The true population distribution is unknown, so it must be assumed that the population is normal.

C. It is not an approximation; the true distribution of $macron(Y)$ is normal.

D. The mean of a simple random sample is always normally distributed.


===== Answer

A mean of independent normal random variables is exactly normal for any sample size. In this case,

$ macron(Y)tilde.op N ( 0.60,frac(0.16, 64))
=N(0.60,0.0025). $

Therefore,

$ "Option C: the distribution is exactly normal". $


==== Q5.10

_1 point_

Suppose that $T_1,T_2,dots,T_(48)$ are iid failure times with mean $18$ and variance $63$. Using a suitable approximation, evaluate

$ P(macron(T)>20.2). $

Give the answer correct to three decimal places.


===== Answer

The population distribution is not specified, but $n=48$ is large. The central limit theorem gives

$ macron(T)thin dot(tilde.op)thin N ( 18,frac(63, 48)). $

The standard error and corresponding $z$-score are

$ op("SE")(macron(T))
=sqrt(frac(63, 48))
=1.145644 dots, $

$ z
=frac(20.2-18, sqrt(63/48))
=1.920317 dots. $

Therefore,

$ P(macron(T)>20.2)
approx P(Z>1.920317 dots) \
=0.027408 dots. $

Hence,

$ P(macron(T)>20.2)approx 0.027. $


== 2025 midsemester paper — statistics and quantitative reliability

Sources: #link("../questions/midsem/Mid%20Sem%202025%20Sem-1.pdf")[original paper] · #link("../questions/midsem/Mid-Sem-2025-Sem-1-questions-and-answers.md")[complete existing transcription]. Questions 1, 2, 5–7, 9 and 11–12 are engineering and appear in #link("engineering-content.md")[engineering notes].


=== M2025.3 — original Question 3

In the week 4 case study, we discussed the potential reliability of a meteorology telemetry system being designed by the New Products section of Electrosystems. Let’s assume that they won the contract and installed 7 systems. After 4 years of operation, they conduct a review of the performance of these systems.

They found that the first system failed at 3 months, the 2nd at 13 months, the 3rd at 25 months and the 4th at 40 months. The remaining systems survived the 4 years of operation. Systems that failed were not replaced. Calculate the failure rate of the system in failure rate per million hours. Give your answer to 2 d.p. and use the conversion 365.25 days = 1 year.

- A. 20.06
- B. 13.13
- C. 24.34
- D. 17.54
- E. None of the above

*Answer: C. 24.34 failures per million hours.*

Total time on test:

$ T = 3+13+25+40+3(48)=225" months". $

Therefore,

$ lambda
=frac(4, (225/12)(365.25)(24))times 10^6
=24.336 approx 24.34 $

failures per million hours.


=== M2025.4 — original Question 4

The reliability block diagram of a system is shown in the following figure with component reliability noted in each block, where $a=0.62$, $b=0.91$ and $c=0.70$. What is the reliability of the system? Give your answer to 2 d.p.

#figure(image("assets/question-04-reliability-block-diagram.jpg", width: 85%), caption: [Reliability block diagram for Question 4])

_Figure 2: Figure for Q4_

- A. 0.60
- B. 0.39
- C. 0.47
- D. 0.82
- E. None of the above

*Answer: A. 0.60.* The three $a$ components are in parallel, followed by $b$ and $c$ in series:

$ R_(upright("system"))
=[ 1-(1-0.62)^3 ](0.91)(0.70)
=0.602 approx 0.60. $


=== M2025.8 — original Question 8

A geotechnical engineering team is assessing the long-term reliability of offshore wind turbine foundations subjected to cyclic loading. They use Weibull analysis to model the time to failure based on historical data and laboratory test results. The team gathers failure data from past projects and laboratory tests on monopile foundations under cyclic loading. The dataset includes time to failure (in years) for different foundations. They plot the data using Weibull analysis and obtain a shape function = 1.2 and scale factor = 14.

For a design life of 39 years for the offshore wind turbine foundations, estimate the failure probability? Give your answer to 3 d.p.

- A. 0.808
- B. 0.967
- C. 0.859
- D. 0.634
- E. None of the above

*Answer: B. 0.967.* For a two-parameter Weibull distribution,

$ F(39)=1-exp [-( frac(39, 14))^(1.2)]
=0.967261 approx 0.967. $


=== M2025.10 — original Question 10

A geotechnical engineering team is assessing the long-term reliability of offshore wind turbine foundations subjected to cyclic loading. The team gathers failure data from past projects and laboratory tests on monopile foundations under cyclic loading. The dataset includes time to failure (in years) for different foundations. The team finds information for 113 foundation field tests. Five tests were unsuccessful because the equipment broke during testing. Five foundations failed under cyclic loading after 3, 5, 6, 8, 12 months, respectively. The remaining tests were carried out for 24 months and the foundations did not fail.

What is the total time on test for the foundations? Give your answer in months.

- A. 2618
- B. 2356
- C. 2189
- D. 2506
- E. None of the above

*Answer: D. 2506 months.* Excluding the five unsuccessful tests leaves $113-5=108$ valid tests. Of these, five failed and 103 were censored at 24 months:

$ T=(3+5+6+8+12)+103(24)=34+2472=2506" months". $


=== M2025.13 — original Question 13

Events $A$, $B$ and $C$ have respective probabilities $P(A)=0.2$, $P(B)=0.1$, and $P(C)=0.4$. Given that $A$ and $B$ are disjoint, that $B$ and $C$ are independent, and that $P(A ∩ C)=0.1$, which ONE of the following is the correct value for $P(A union B ∣ C)$? (2dp)

- A. 0.30
- B. 0.35
- C. 0.75
- D. 0.70
- E. None of the above

*Answer: B. 0.35.* Since $B$ and $C$ are independent, $P(B ∩ C)=0.1(0.4)=0.04$. Since $A$ and $B$ are disjoint,

$ P(A union B ∣ C)
=frac(P(A ∩ C)+P(B ∩ C), P(C))
=frac(0.10+0.04, 0.40)
=0.35. $


=== M2025.14 — original Question 14

If $A$ and $B$ are two events, which ONE of the following assignments of probabilities is valid?

- A. $P(A)=0.5$, $P(B)=0.7$, $P(A ∩ B)=0.1$
- B. $P(A)=0.4$, $P(B)=0.3$, $P(A union B)=0.2$
- C. $P(A)=0.1$, $P(B)=0.3$, $P(A union B)=0.5$
- D. $P(A)=0.7$, $P(B)=0.2$, $P(A ∩ B)=0.1$
- E. None of the above

*Answer: D.* It gives

$ P(A union B)=0.7+0.2-0.1=0.8, $

which is valid. The other assignments violate the bounds on intersections or unions.


=== M2025.15 — original Question 15

The arrival of requests for repair of excavators from a mining site can be approximated as a Poisson process with rate of 1 request per week. What is the probability that there will be 3 requests for repair in a 4 weeks period? (3dp)

- A. 0.016
- B. 0.018
- C. 0.195
- D. 0.368
- E. None of the above

*Answer: C. 0.195.* The mean number of requests in four weeks is $mu=1 times 4=4$:

$ P(X=3)=frac(4^3 e^(-4), 3!)=0.195367 approx 0.195. $


=== M2025.16 — original Question 16

A maintenance planner looks back on time taken to repair a centrifugal pump. The past data indicates that the repair time $T$ is distributed as $T=exp(X)$, where $X tilde.op N(1.2,4.3)$. There is a shutdown coming up and the operations supervisor wants to know the probability that a repair will take more than 4 hours. Which of the following is the correct value for this probability? (3dp)

- A. 0.159
- B. 0.464
- C. 0.536
- D. 0.841
- E. None of the above

*Answer: B. 0.464.* Using the course convention $N(mu,sigma^2)$, $X$ has mean $1.2$ and variance $4.3$. Since $T=exp(X)$,

$ P(T>4)
=P(exp(X)>4) \
=P(X>ln 4) \
=1-Phi ( frac(ln 4-1.2, sqrt(4.3))) \
=0.464207 approx 0.464. $


=== M2025.17 — original Question 17

An excavator bucket has a bucket capacity of $11.5 thin upright(m)^3$ with a standard deviation of $1.4 thin upright(m)^3$. Assume that the volume of material in a loaded bucket is Normally distributed. A bucket is considered “underloaded” if its material volume is less than $10.88 thin upright(m)^3$. Let $overline(X)$ denote the average material volume of 12 randomly chosen loaded buckets. What is the probability that $overline(X)$ is less than $10.88 thin upright(m)^3$? (3dp)

- A. 0.937
- B. 0.670
- C. 0.330
- D. 0.063
- E. None of the above

*Answer: D. 0.063.* The sample mean is Normally distributed with standard error $1.4/sqrt(12)$:

$ P(overline(X)<10.88)
=Phi ( frac(10.88-11.5, 1.4/sqrt(12)))
=0.062502 approx 0.063. $


=== M2025.18 — original Question 18

A hydraulic pump used in an excavator has MTTF of $mu$ hours and standard deviation $sigma$ hours. Assume that the lifetime of a hydraulic pump is Normally distributed. Let $overline(X)$ and $S$ denote the average lifetime and standard deviation of 20 randomly chosen hydraulic pumps.

What is the distribution of

$ frac(overline(X)-mu, S/sqrt(n))thin? $

- A. $t$ distribution with 19 degrees of freedom and it is exact.
- B. $t$ distribution with 19 degrees of freedom and it is approximate.
- C. $N(0,1)$ distribution and it is exact.
- D. $N(0,1)$ distribution and it is approximate.
- E. None of the above.

*Answer: A. $t$ distribution with 19 degrees of freedom, exactly.* The population is Normal, its standard deviation is estimated using $S$, and $n=20$, so the statistic has an exact $t_(n-1)=t_(19)$ distribution.


=== M2025.19 — original Question 19

Suppose the life time, $X$, of a component is modelled as $op("Weibull")(beta,eta)$, with $beta != 1$. Let $F(t)$, $R(t)$ and $h(t)$ be its CDF, reliability function and hazard rate function, respectively. Which ONE of the following is true?

- A. $P(X>t+s ∣ X>s)=P(X>t)$, for $s,t>0$.
- B. $F(t+s)=R(t+s)h(t+s)$, for $s,t>0$.
- C. $R(t+s)=R(t)R(s)$, for $s,t>0$.
- D. $F(t+s)=F(t)F(s)$, for $s,t>0$.
- E. None of the above

*Answer: E. None of the above.* For $beta != 1$, a Weibull lifetime is not memoryless, so A and C are false. The hazard identity is $f(t)=R(t)h(t)$, using the density $f$, not the CDF $F$, so B is false; D is not a CDF identity.


=== M2025.20 — original Question 20

An electronic component is assumed to have a constant hazard rate. The mean life time of the component is 0.125 years. What is the hazard rate of the component?

- A. 12.5
- B. 0.125
- C. 1.25
- D. 8
- E. None of the above

*Answer: D. 8 per year.* For a constant hazard rate, the lifetime is exponential and $upright("MTTF")=1/lambda$. Thus,

$ lambda=frac(1, 0.125)=8" year"^(-1). $


== Weekly engineering quizzes — quantitative probability questions


=== Week 4 quiz — series reliability and MTBF

Source: #link("../questions/week4-quiz.md")[saved Week 4 quiz]. The source saves three prompts, referencing an earlier Q1 that is not present in this file. The module-rate background is discussed in #link("engineering-content.md")[engineering notes].


==== E4.1 — reliability of five sensors

We know from Q1 that the failure rate of an instrument module is 1.91 failures per million hours and that an instrument module is considered failed if a single sensor on the module has failed. For the purposes of this question assume that the failure rate of a single sensor is therefore 1.91 failures per million hours.

The customer's requirement is that there are five critical sensors and if one fails then the unit is considered failed. What is the reliability of the instrument module over ten years?

- A. 0.426
- B. 0.843
- C. 2.718
- D. 0.574

*Recorded answer: A. Source inconsistency:* with independent exponential sensors and 365 days/year, the literal data give $R=e^(-5(1.91 times 10^{-6})(87600))approx 0.433$. The keyed 0.426 uses the workshop's rounded 1.95 failures/million hours: $e^(-5(1.95 times 10^{-6})(87600))approx 0.426$. Do not change 1.91 silently. In practice a module rate cannot simply be assigned to every sensor, but the prompt explicitly makes that assumption.


==== E4.2 — whole-system failure rate

What is the failure rate of the proposed meteorological system? Assume the system includes the instrument module, signal-processing board, transmission module (comms board), power supply and battery. Give the result in failures per million hours.

- A. 15.44
- B. 9.75
- C. 5.69
- D. 7.64

*Recorded answer: A.* Add the independent series failure rates. The workshop uses five sensor rates of 1.95 and a combined other-board rate of 5.69, giving $5(1.95)+5.69=15.44$. Literal use of 1.91 instead gives 15.24; this is the same source-rate mismatch as E4.1. The prompt alone omits the board-rate table, so its numerical answer depends on the accompanying workshop context.


==== E4.3 — meeting the MTBF requirement

The design meets the customer's requirement of “A 10 year MTBF is required for the loss of any one parameter?” True or False?

- True
- False

*Recorded answer: False.* With total constant rate $15.44 times 10^(-6)$ per hour, $op("MTBF")=10^6/15.44 approx 64766.84$ h $approx 7.39$ years, below ten years.


=== Week 5 quiz — quantitative reliability and maintenance

Source: #link("../questions/week5-quiz.md")[saved Week 5 quiz]. Original Q3–Q6 appear below; qualitative Q1–Q2 and Q7–Q8 belong in #link("engineering-content.md")[engineering notes]. The bathtub-curve concept in Q2 is also explained in the cheat sheet.


==== E5.3 — original Question 3

In a study to improve the life of ground-engaging tools on an excavator, a reliability engineer modelled the lifetime of the teeth using an exponential distribution. The data indicated that the probability that a tooth lasts more than 1,000 working hours is 0.46. What is the probability that a tooth fails within a fixed replacement period of two weeks (336 hours)? Give the answer to three decimal places.


===== Solution

For an exponential lifetime,

$ R(t)=e^(-lambda t). $

Use the given survival probability to calculate the failure rate:

$ 0.46=e^(-1000 lambda)
quad =>quad
lambda=-frac(ln(0.46), 1000)
=0.000776529 thin"h"^(-1). $

The probability of failure within 336 hours is

$ F(336)
=1-R(336) \
=1-e^(-0.000776529(336)) \
=0.229653. $

Therefore, to three decimal places,

$ P(T <= 336)=0.230. $


==== R

```r
survival_at_1000 <- 0.46
failure_rate <- -log(survival_at_1000) / 1000
probability_of_failure <- pexp(336, rate = failure_rate)

sprintf("%.3f", probability_of_failure)  # "0.230"
```


==== E5.4 — original Question 4

Before the excavators were purchased, a reliability engineer modelled the subsystem comprising the bucket, teeth, lift-cylinder system and hydraulic pump. Each component lifetime was assumed to be exponentially distributed. The MTBF values are:

#table(
  columns: 2,
  align: (auto, right,),
  table.header(
    [*Component*],
    [*MTBF (h)*],
  ),
  [Bucket],
  [15,020],
  [Teeth],
  [1,200],
  [Lift-cylinder system],
  [10,000],
  [Hydraulic pump],
  [11,000],
)
What is the reliability of the subsystem over a 500-hour period? The subsystem fails if any component fails. Give the answer to three decimal places.


===== Solution

For independent components in series,

$ R_("sys")(t)=product_(i=1)^(4)R_i(t). $

Since each component has an exponential lifetime,

$ R_i(t)=exp (-frac(t, op("MTBF")_i)). $

Therefore,

$ R_("sys")(500)
=exp [-500 (
frac(1, 15020)
+frac(1, 1200)
+frac(1, 10000)
+frac(1, 11000)
)] \
=0.579604. $

Thus,

$ R_("sys")(500)=0.580. $


==== E5.5 — original Question 5

A cable has a three-parameter Weibull failure distribution with $beta=1.8$, $eta=500 thin"h"$ and $gamma=50 thin"h"$.

- Corrective replacement cost: $C_f=\$6","000$
- Scheduled replacement cost: $C_s=\$600$
- Annual operating time: $H=5","000 thin"h"$

Both maintenance actions replace the cable. Which scheduled replacement interval $m$ minimizes the annual cost when $m=50,75,100,dots,300 thin"h"$?


===== Solution

For the shifted Weibull model,

$ F(t)=
cases(0 quad t<gamma, 1-exp [-( frac(t-gamma, eta))^beta ] quad t >= gamma)
wide
R(t)=1-F(t). $

A replacement cycle ends at failure or at age $m$, whichever occurs first. The expected replacement cost per cycle is

$ E[C(m)]=C_f F(m)+C_s R(m), $

and the expected cycle length is

$ E[min(T,m)]=integral_0^m R(t)thin "dt". $

The annualized cost is therefore

$ C_("annual")(m)
=H frac(C_f F(m)+C_s R(m), integral_0^m R(t)thin "dt"). $

The expected cycle length must be used in the denominator because a corrective failure can end a cycle before the scheduled age $m$.

#table(
  columns: 4,
  align: (right, right, right, right,),
  table.header(
    [*$m$ (h)*],
    [*$F(m)$*],
    [*Expected cycle (h)*],
    [*Annual cost*],
  ),
  [50],
  [0.0000],
  [50.000],
  [\$60,000.00],
  [75],
  [0.0045],
  [74.959],
  [\$41,657.32],
  [100],
  [0.0157],
  [99.718],
  [\$34,342.21],
  [125],
  [0.0323],
  [124.128],
  [\$31,204.80],
  [150],
  [0.0537],
  [148.062],
  [\$30,053.26],
  [*175*],
  [*0.0792*],
  [*171.409*],
  [*\$29,971.17*],
  [200],
  [0.1082],
  [194.074],
  [\$30,509.81],
  [225],
  [0.1403],
  [215.974],
  [\$31,424.61],
  [250],
  [0.1748],
  [237.040],
  [\$32,571.38],
  [275],
  [0.2115],
  [257.215],
  [\$33,859.86],
  [300],
  [0.2496],
  [276.454],
  [\$35,230.83],
)
The minimum occurs at

$ m=175 thin"h". $


==== E5.6 — original Question 6

Examine the plot for EXB8 shown in Figure 5 of an analysis of ground-engaging tools on an excavator. Which statement is true?

#figure(image("assets/w5q6.PNG", width: 85%), caption: [Mixed Weibull plot for excavator EXB8])

- *Option A:* The Weibull shape parameter for early life is higher than for later life.
- *Option B:* The Weibull shape parameter for early life is lower than for later life.
- *Option C:* About 50% of the distribution is characterized by the later fitted line.
- *Option D:* The estimated life is about 10 days.


===== Solution

*Option A.* The plot reports $beta_1=1.5278$ for the earlier-life component and $beta_2=1.3554$ for the later-life component. Therefore, $beta_1>beta_2$.


== Additional questions and worked examples from the statistics slides

These are distinct prompts/examples in the supplied slide decks. Repeated worked steps are combined. Illustrations without a numerical question are explicitly identified. The original slide links preserve graphical evidence and any image-only detail.


=== S0 — introductory overview

#link("../probability-content/slides-pdf/01-GENG5507-STATS-Basics.pdf")[Basics slides] introduce the unit and refer to textbook exercises, but supply no additional standalone numerical question. #link("../questions/probability-questions/lecture/Lecture0.pdf")[Lecture 0] is the Westralia case background reproduced in the lecture-problem section above.


=== S1 — set operations and elementary probability

Source: #link("../probability-content/slides-pdf/02-GENG5507-STATS-extra-slides.pdf")[extra probability slides].

*S1.1 — complements and unions.* For $S={ 1,2,5,10 }$ and $A={ 2,5 }$ identify the complement. For $S={ t:t>10 }$ and $A={ t:10<t <= 100 }$ identify the complement. For $A=(100,1000)$ and $B=(0,200)$ find intersection and union. For integer sets $A={ 0,dots,100 }$, $B={ 50,dots,150 }$ and $C={ 101,dots,200 }$ find $A ∩ B$, $A union B$, $A ∩ C$, $B ∩ C$, $A ∩ B ∩ C$, $A union B union C$ and $A union C$.

*Answer.* Complements ${ 1,10 }$ and ${ t:t>100 }$; interval intersection $(100,200)$ and union $(0,1000)$. Integer answers: ${ 50,dots,100 }$; ${ 0,dots,150 }$; $nothing$; ${ 101,dots,150 }$; $nothing$; ${ 0,dots,200 }$; ${ 0,dots,200 }$.

*S1.2 — probability definitions.* A fair die has six outcomes, three odd. A pump fails to start on 20 of 2000 starts. Calculate the classical odd-outcome probability and the empirical failed-start probability. Show that $P(E^c)=1-P(E)$.

*Answer.* $3/6=0.5$; $20/2000=0.01$; $E,E^c$ partition the sample space, so their probabilities sum to one. The frequency estimate assumes sufficiently comparable trials.

*S1.3 — defective bolts.* One bolt from each of two independent suppliers is selected; defect probabilities are 0.05 and 0.07. Find the probabilities that both are defective and that at least one is defective.

*Answer.* $0.05(0.07)=0.0035$; $0.05+0.07-0.0035=0.1165$.

*S1.4 — sample combinations.* How many samples of four can be selected without replacement from 20 bulbs? If exactly two of the 20 are defective, what is the probability of exactly one defective in the sample?

*Answer.* $binom(20, 4)=4845$; $binom(2, 1)binom(18, 3)/binom(20, 4)=1632/4845 approx 0.33684$. This is sampling without replacement (hypergeometric), not independent binomial sampling.

*S1.5 — tractors and assembly lines.* Red, White and Blue lines have failure-to-start probabilities 6%, 11% and 8%. Red makes 48% and Blue 31% of tractors. Find the overall proportion that fails to start; find the tree's joint probabilities $P(R ∩ D)$, $P(W ∩ D)$ and $P(B ∩ D)$. The slide also displays the Bayes expression for $P(R ∣ D)$.

*Answer.* White makes 21%. The joints are $0.0288$, $0.0231$, $0.0248$, giving $P(D)=0.0767 approx 0.077$; $P(R ∣ D)=0.0288/0.0767 approx 0.37549$.

*S1.6 — defective transistor origin.* Systems $S_1,S_2,S_3$ make 20%, 30%, 50% of transistors, with defect rates 0.01, 0.02, 0.05. A selected transistor is defective: find the probability it came from $S_1$ (and the analogous probabilities for $S_2,S_3$).

*Answer.* $P(D)=0.033$; posterior probabilities $0.002/0.033=0.06061$, $0.006/0.033=0.18182$, $0.025/0.033=0.75758$.

*S1.7 — two equally credible experts.* Experts propose reliability values 0.98 and 0.60. Update their equal prior credibility after one successful reliability test, then after two successful tests.

*Answer and wording correction.* Treat the experts' predictions as alternative models with priors 0.5 each and assume tests conditionally independent given a model. The posterior for the first model is $0.98/(0.98+0.60)=0.62025$, then $0.98^2/(0.98^2+0.60^2)=0.72736$. The slide's words incorrectly conflate model prior credibility with the conditional success probabilities 0.98 and 0.60.

*S1.8 — coin sequence.* A fair coin gives three heads in three tosses. What is the probability of heads next? Repeat for a coin whose known head probability is 0.6.

*Answer.* 0.5 and 0.6, assuming independent tosses and a known fixed head probability; the previous sequence does not change it.


=== S2 — distribution-model examples

Source: #link("../probability-content/slides-pdf/03-GENG5507-STATS-ProbabilityModels.pdf")[probability-model slides].

*S2.1 — graphical model illustrations (Examples 2.1 and 2.2).* Slides 5–9 show rework-cost survey distributions (% of project contract value). Slides 10–13 compare histogram bins for loader-engine times to first failure. These are graphical examples, with no additional explicit numerical question or complete raw dataset in their text. The loader dataset is supplied in S4.3 below, where its 35 observations and histogram task are retained.

*S2.2 — fair die (Example 2.3).* A fair die has values $1,dots,6$. Its discrete-uniform PMF is $1/6$ on these values, with mean 3.5 and variance $35/12$. This is a worked distribution illustration, not a separately worded assessment problem.

*S2.3 — surviving bulbs (Example 2.4).* Each bulb survives a 500-hour mission with probability 0.9. For four independent bulbs calculate the probabilities of 0, 1, 2, 3 and 4 survivors.

*Answer.* $X tilde.op op("Bin")(4,0.9)$; probabilities are $0.0001$, $0.0036$, $0.0486$, $0.2916$, $0.6561$.

*S2.4 — machine-component failures (Example 2.5).* Components fail according to a Poisson process with rate 1/week. What is the probability of one failure in four weeks?

*Answer.* $N tilde.op op("Pois")(4)$ and $P(N=1)=4e^(-4)=0.073263$.

*S2.5 — bottle filling (Example 2.6).* A machine is intended to fill plastic bottles to 16.0 ounces. Quality engineers investigate the volume using this random sample:

$ 16.03,16.01,16.02,16.03,16.04,15.96,15.97,16.04,16.05,15.98, \
15.96,16.02,16.05,16.02,16.01,16.01,16.02,15.99,15.99,16.00. $

The slides display a histogram/Normal illustration; they do not specify a hypothesis-test question. *Study interpretation:* describe the distribution and compare its centre with 16.0; do not invent a required test or significance level.

*S2.6 — Gamma function (Example 2.7).* Evaluate $Gamma(4)$ using the positive-integer identity. *Answer:* $(4-1)!=6$.

*S2.7 — Weibull calculations (Example 2.8).* A lifetime has Weibull shape 2 and scale 1000 hours. Find (a) mean; (b) SD; (c) median; (d) $P(800 <= T <= 1200)$; (e) the time the lifetime exceeds with probability 0.9.

*Answer.* $1000 Gamma(1.5)=886.227$ h; $1000sqrt(1-Gamma(1.5)^2)=463.251$ h; $1000sqrt(ln 2)=832.555$ h; $e^(-0.8^2)-e^(-1.2^2)=0.290365$; $1000sqrt(-ln 0.9)=324.593$ h. Part (e) is the lower 10th percentile, not the lower 90th percentile.

The final exponential slide invites exploration of the Poisson/exponential connection: at a constant Poisson event rate $lambda$, the waiting time to the next event is exponential with $P(T>t)=P(N(t)=0)=e^(-lambda t)$.


=== S3 — hazard-rate examples

Source: #link("../probability-content/slides-pdf/04-GENG5507-STATS-HazardRate.pdf")[hazard-rate slides].

*S3.1 — conditional failure and density.* Given survival up to $t$, what is the chance of failure in the next short interval $Delta t$? *Answer:* $[F(t+Delta t)-F(t)]/R(t)approx h(t)Delta t$.

*S3.2 — exponential interval.* A component has exponential life with rate 0.002/hour. What is the probability of failure between 510 and 515 hours? *Answer:* $e^(-0.002(510))-e^(-0.002(515))approx 0.003588$.

*S3.3 — derive lifetime functions from constant hazard.* Assuming $h(t)=lambda$, find $f(t)$, $F(t)$ and $R(t)$. Which are probabilities? Can any exceed 1?

*Answer.* $R(t)=e^(-lambda t)$; $F(t)=1-e^(-lambda t)$; $f(t)=lambda e^(-lambda t)$. CDF and reliability are probabilities in $[0,1]$. Density and hazard are rates per unit time and may exceed 1.

*S3.4 — exponential location and spread (Example 1).* For $f(t)=0.002e^(-0.002t)$, find MTTF, median, mode and SD.

*Answer.* 500 h; $ln 2/0.002=346.574$ h; boundary mode 0; 500 h. *Source correction:* the median calculation accidentally prints 0.02 instead of 0.002; the quoted median uses 0.002.

*S3.5 — equal means, different reliability (Examples 2 and 2b).* Compare $R_1(t)=e^(-0.002t)$ and $R_2(t)=(1000-t)/1000$ for $0 <= t <= 1000$ (with $R_2=0$ thereafter). Find each MTTF, $R(400)$ and SD. Why might smaller SD be preferred?

*Answer.* Both means are 500 h. Reliabilities at 400 h are $e^(-0.8)=0.449329$ and $0.6$. SDs are 500 h and $1000/sqrt(12)=288.675$ h. Smaller spread can make lifetime more predictable, but mission reliability depends on the whole distribution and the mission time; a smaller SD alone does not dominate at all times.

*S3.6 — Weibull linearisation.* The final slide asks what the Weibull straight-line identity is useful for. *Answer:* a probability plot can check approximate Weibull fit and estimate shape from slope and scale from intercept; see P3.4.


=== S4 — model-estimation examples

Source: #link("../probability-content/slides-pdf/05-GENG5507-STATS-ModelEstimation.pdf")[model-estimation slides].

*S4.1 — 20-unit censored test.* Twenty units are tested for 50 h. Earlier failure/censoring times are $10.8,12.6^+,15.7,28.1,30.5,36.0^+,42.1,48.2$ hours; the other 12 units survive to 50 h. Find exposure $T$ and estimated MTTF assuming exponential lifetimes. Repeat if 12.6 and 36.0 are failures instead of suspensions.

*Answer.* The listed durations sum to 224 h; total exposure $224+12(50)=824$ h. With six failures, $hat(upright("MTTF"))=824/6=137.333$ h. Changing the two outcomes to failures leaves exposure unchanged but gives eight failures: MTTF 103 h. A plus sign means right-censored.

*S4.2 — repairable-system event times.* Failures occur at 452, 752, 967, 1256, 1432, 1999 and 2383 h; observation ends at 3000 h. Find MTBF and SD. First derive inter-failure durations.

*Answer with censoring caveat.* Durations are $452,300,215,289,176,567,384,617^+$. The exponential/constant-rate MTBF estimate is $3000/7=428.571$ h. The slide computes the ordinary SD of all eight recorded durations around their arithmetic mean 375: $sqrt(179660/7)=160.205$ h. *That is a descriptive SD of observed durations, not an unbiased lifetime SD*, because the final interval is censored. Under the exponential model, fitted lifetime SD equals fitted MTBF, 428.571 h.

*S4.3 — 35 field failure times.* Plot these failure times in operating hours, collected over six months, and consider the underlying distribution:

$ 20,31,36,47,98,157,182,185,210,210,214,221,246,247,279,284,289,300, \
400,401,428,438,442,467,499,552,553,597,767,796,1024,1297,1476,1563,2025. $

*Source worked approach.* Compare histogram class choices; a right-skewed shape suggests considering an exponential distribution, followed by a proper model check. If fitting an uncensored exponential, use $hat(lambda)=35/sum t_i$.

*S4.4 — mean-rank plotting positions.* For ordered times $12.2,13.1,14.0,14.1,14.6,14.7,14.7,15.1,15.7,15.8,16.3,16.9$, compare cumulative percentages and estimated CDF positions.

*Answer.* Empirical cumulative ranks are $i/12$; mean-rank positions are $i/13$, $i=1,dots,12$; Bernard/Benard approximate median ranks are $(i-0.3)/12.4$. The two 14.7 observations share a time but have separate ordered plotting positions; a proper ECDF has one combined jump at that time.

*S4.5 — Kaplan–Meier, refinery pumps.* A refinery has 100 independent identical pumps. At each monthly inspection failures are recorded, then two surviving pumps are randomly removed for external testing and not replaced. Monthly failures for months 1–5 are 5, 6, 4, 8, 3. Estimate reliability using Kaplan–Meier.

*Answer.* Risk-set sizes before failures are $100,93,85,79,69$; multiply conditional survival factors $95/100$, $87/93$, $81/85$, $71/79$, $66/69$. Removals affect later denominators, not the survival curve at the censoring time.

*S4.6 — Kaplan–Meier, IPP pumps.* Irving Pulp and Paper monitored 36 pumps: 12 bearing failures, 20 suspensions and four corrupted records excluded from analysis. The slide example shows observation timelines and a KM curve. Use 32 valid records, retaining both failures and suspensions. *Data limit:* exact event times are shown graphically rather than supplied as a numerical table; use #link("../probability-content/slides-pdf/05-GENG5507-STATS-ModelEstimation.pdf#page=43")[slides 43–45] for the original plot. No new numerical target is stated, and exact values should not be invented from the graphic.

The final R example uses the same `exa1.csv` analysis as P4.3 and is deduplicated there.


=== S5 — sampling and CLT examples

Source: #link("../probability-content/slides-pdf/06-GENG5507-STATS-lecture-week5-CLT.pdf")[random-sampling and CLT slides].

*S5.0 — why sample?* How can we obtain MTTF of mining equipment, the proportion failing before warranty expiry, mean repair time, defective-production proportion, ore/oil quantity, quality compliance and the total number of tuna in Australian waters? Could we measure every item? What issues arise?

*Slide answer.* A census can be costly, slow, impractical or destructive. Use a suitable representative sampling design and account for sampling uncertainty and bias.

*S5.1 — cereal sample mean.* Box weights are Normal with mean 500 g and SD 5 g. What is the probability that a random sample of 25 boxes has mean weight below 495 g?

*Answer.* $macron(X)tilde.op N(500,1)$ exactly, so $P(macron(X)<495)=Phi(-5)approx 2.8665 times 10^(-7)$.

*S5.2 — linear combinations.* For random variables $X,Y$ and $U="aX"+"bY"$, can you determine the distribution, mean and variance of $U$?

*Answer and assumption correction.* $E(U)=a E(X)+b E(Y)$; $op("Var")(U)=a^2 op("Var")(X)+b^2 op("Var")(Y)+2"ab" op("Cov")(X,Y)$. The slide's shorter formula assumes independence (or zero covariance). A full distribution needs further information: independent Normal variables give a Normal linear combination.

*S5.3 — bank service times.* A teller's service time is Normal with mean 150 s and variance 900 s${}^2$. Find the chance that mean service time exceeds 160 s for samples of (a) 25 customers; (b) 100 customers.

*Answer.* $1-Phi((160-150)/(30/5))approx 0.04779$; $1-Phi((160-150)/(30/10))approx 0.0004291$.

*S5.4 — long-life bulbs (image-only example, slide 25).* A long-life bulb has mean life 1500 h and SD 300 h. What is the probability that a random sample of 200 bulbs has mean life less than 1450 h?

*Answer.* By CLT, $Phi((1450-1500)/(300/sqrt(200)))approx 0.00921$. This is approximate when the population is not stated to be Normal.

*S5.5 — simulation demonstration.* Try the slides' R code simulating 1000 means of exponential samples of size 20 with rate 2, then histograms with 50 classes and density overlays. The subsequent demonstration does the same for Weibull samples of size 100. Compare the original skewed population shape with the approximately Normal sampling distribution of means. See #link("R.md")[R guide] for repaired reproducible code; this is an exploration prompt, not an extra numerical assessment question.


=== S6 — additional Weibull-analysis deck

Source: #link("../probability-content/slides-pdf/Weibull-analysis.pdf")[Weibull analysis].

*S6.1 — ignoring suspensions changes a cost forecast.* A hydraulic-cylinder replacement costs AUD 5000. Ignoring suspensions gives MTBF 72 days and about 25 replacements in five years; retaining suspensions gives about 13 replacements. Compare costs.

*Answer.* The displayed rounded-count calculation gives AUD 125,000 versus AUD 65,000. This is the slide's illustrative cost comparison; the broader maintenance decision belongs in #link("engineering-content.md")[engineering notes].

*S6.2 — O'Connor Example 3.2, 50-item censored Weibull exercise (slides 31–32, repeated on 38).* List failure order numbers, ordered failure lifetimes and numbers of preceding observations; calculate adjusted ranks, median ranks and a Weibull plot. `F` denotes failed and `S` suspended. The complete table shown on slide 31 is transcribed below (hours):

#table(
  columns: 6,
  align: (auto, right, auto, right, auto, right,),
  table.header(
    [*Item*],
    [*Time*],
    [*Item*],
    [*Time*],
    [*Item*],
    [*Time*],
  ),
  [S1],
  [40],
  [S10],
  [141],
  [S25],
  [165],
  [S2],
  [51],
  [S11],
  [147],
  [S26],
  [165],
  [F1],
  [54],
  [S12],
  [147],
  [S27],
  [166],
  [F2],
  [70],
  [S13],
  [150],
  [S28],
  [166],
  [S3],
  [73],
  [F9],
  [153],
  [S29],
  [166],
  [S4],
  [73],
  [S14],
  [153],
  [S30],
  [168],
  [S5],
  [80],
  [S15],
  [153],
  [S31],
  [168],
  [F3],
  [85],
  [S16],
  [154],
  [S32],
  [171],
  [S6],
  [90],
  [S17],
  [156],
  [F11],
  [173],
  [F4],
  [96],
  [S18],
  [156],
  [S33],
  [177],
  [S7],
  [102],
  [S19],
  [156],
  [S34],
  [181],
  [F5],
  [108],
  [S20],
  [158],
  [S35],
  [185],
  [F6],
  [118],
  [S21],
  [158],
  [S36],
  [188],
  [S8],
  [128],
  [S22],
  [158],
  [F12],
  [200],
  [S9],
  [128],
  [F10],
  [161],
  [S37],
  [202],
  [F7],
  [132],
  [S23],
  [162],
  [S38],
  [205],
  [F8],
  [141],
  [S24],
  [162],
  [—],
  [—],
)
*Worked start.* There are 50 items, 12 failures and 38 suspensions. For the first failure at ordered position 3, adjusted rank increment is $51/(50-3+2)=51/49=1.040816$. Its median rank is $(1.040816-0.3)/(50+0.4)=0.014699$. At each next failure at overall position $j$, update the previous adjusted rank $a$ to $a+(51-a)/(52-j)$; censoring leaves $a$ unchanged. The next adjusted ranks are about 2.081633, 3.193413 and 4.331663. Use the adjusted rank, not the count of observed failures alone, in $(a-0.3)/50.4$. The source's shortened working table is only an excerpt; the sample size remains 50.


=== Engineering/statistics overlap and exclusions

The seven quantitative prompts from the Week 4/5 engineering quizzes are included in the weekly-engineering-quiz section above. Purely qualitative quiz prompts and their engineering context are in #link("engineering-content.md")[engineering notes].

The Week 4/5 additional-statistics slides under `content/` are accounted for in the engineering notes where they frame failure-rate, Weibull, reliability and maintenance examples; their shared probability methods appear here and in the cheat sheet. Pure engineering workshop discussions, qualitative risk assessment, FMEA and life-cycle costing belong in the engineering document. Generated practice banks under `readrun-quizes` or `generated quizes`, and added explanatory examples in `probability-content/examples`, are *not labelled as actual asked course questions* and are excluded from this source bank; representative fresh practice belongs in #link("examples.md")[examples].
