#set page(paper: "a4")

#set text(font: ("Helvetica", "Arial",))
#set page(margin: 15mm)
#set page(numbering: "1")
#set text(size: 12pt)

= R Probability and Statistics Cheat Sheet

#outline(title: [Table of contents])

This is the working subset of R used in the probability notes\. Start with the syntax section, then use the remaining sections as lookup tables and calculation patterns\.

In RStudio, place code in an R script and run the current line or selection with #raw("Ctrl+Enter") (#raw("Cmd+Enter") on macOS)\. A bare object name displays its value\:

#raw(lang: "r", "life_time", block: true)


== Minimum R syntax

#raw(lang: "r", "# A comment starts with #\nx <- 5                         # assign 5 to x\nanswer <- sqrt(x)              # call a function\npnorm(2, mean = 0, sd = 1)     # named function arguments\n\nvalues <- c(4.8, 3.9, 2.2)     # combine values into a vector\nvalues[1]                      # first value; R counts from 1\nvalues[values > 3]             # values satisfying a condition", block: true)

#table(
  columns: 2,
  align: (auto, auto,),
  stroke: (x: none, y: 0.5pt),
  table.header(
    [*Syntax*],
    [*Meaning*],
  ),
  [#raw("name <- value")],
  [Store a value\. Prefer #raw("<-") for assignment\.],
  [#raw("function_name(arguments)")],
  [Call a function\.],
  [#raw("c(a, b, c)")],
  [Combine values into a vector\.],
  [#raw("x[i]")],
  [Select element #raw("i"); the first element is #raw("x[1]")\.],
  [#raw("x[a:b]")],
  [Select positions #raw("a") through #raw("b")\.],
  [#raw("data$time")],
  [Select the #raw("time") column of a data frame\.],
  [#raw("package::function()")],
  [Use a function without first calling #raw("library(package)")\.],
  [#raw("# comment")],
  [R ignores the rest of the line\.],
  [#raw("?pnorm")],
  [Open help for a function\.],
)
R is case\-sensitive\: #raw("x"), #raw("X") and #raw("mean_x") are different names\. A decimal uses a full stop, and scientific notation such as #raw("2.5e-3") means $2.5 times 10^(-3)$\.


=== Operators

#table(
  columns: 2,
  align: (auto, auto,),
  stroke: (x: none, y: 0.5pt),
  table.header(
    [*Operation*],
    [*R*],
  ),
  [Add, subtract, multiply, divide],
  [#raw("+"), #raw("-"), #raw("*"), #raw("/")],
  [Power],
  [#raw("x^2")],
  [Integer sequence],
  [#raw("1:10")],
  [Equal \/ not equal],
  [#raw("=="), #raw("!=")],
  [Less \/ greater],
  [#raw("<"), #raw(">"), #raw("<="), #raw(">=")],
  [And \/ or \/ not],
  [#raw("&"), #raw("|"), #raw("!")],
  [Is one of these values],
  [#raw("x %in% c(1, 3, 5)")],
)
Use parentheses to make the order explicit\:

#raw(lang: "r", "standard_error <- sigma / sqrt(n)\nz <- (boundary - mu) / standard_error", block: true)


=== Common mathematical functions

#raw(lang: "r", "sqrt(x)          # square root\nabs(x)           # absolute value\nlog(x)           # natural logarithm, ln(x)\nexp(x)           # e^x\ngamma(x)         # Gamma(x)\nfactorial(n)     # n!\nchoose(n, k)     # n choose k\nceiling(x)       # round up\nround(x, 3)      # round to 3 decimal places", block: true)

R applies arithmetic and most functions to every element of a vector\:

#raw(lang: "r", "x <- c(1, 2, 3)\nx^2                 # 1, 4, 9\n(x - mean(x))^2     # squared deviation of each observation", block: true)


== Creating and selecting data

#raw(lang: "r", "x <- c(10, 17, 24, 30, 14)\n1:5\nseq(0, 1, by = 0.2)\nrep(4, times = 3)\n\nlength(x)\nsort(x)\nx[2]\nx[c(1, 3, 5)]\nx[x >= 17]", block: true)

Useful special values are #raw("NA") for a missing value, #raw("NaN") for an undefined numeric result and #raw("Inf") for infinity\. Many summaries need #raw("na.rm = TRUE") when missing values are present\.

#raw(lang: "r", "x <- c(2, 4, NA, 8)\nis.na(x)\nmean(x, na.rm = TRUE)", block: true)


== Describing a sample

#raw(lang: "r", "life_time <- c(4.8, 3.9, 2.2, 5.1, 4.6,\n               5.3, 6.3, 4.3, 6.8, 4.7)\n\nlength(life_time)\nmean(life_time)\nmedian(life_time)\nvar(life_time)\nsd(life_time)\nmin(life_time)\nmax(life_time)\nrange(life_time)\nquantile(life_time)\nsummary(life_time)", block: true)

#raw("var(x)") and #raw("sd(x)") use denominator $n-1$\. For the normal maximum\-likelihood estimate of σ, the denominator is $n$\:

#raw(lang: "r", "sigma_sample <- sd(life_time)\nsigma_mle <- sqrt(mean((life_time - mean(life_time))^2))", block: true)


== Quick plots

#raw(lang: "r", "hist(life_time,\n     main = \"Histogram of lifetimes\",\n     xlab = \"Lifetime (years)\")\n\nboxplot(life_time, horizontal = TRUE)\nstem(life_time)\nplot(life_time, type = \"o\")", block: true)

To draw a mathematical function\:

#raw(lang: "r", "f_X <- function(x) {\n  ifelse(x <= 0 | x >= 80, 0,\n         ifelse(x <= 40, x / 1600, (80 - x) / 1600))\n}\n\ncurve(f_X, from = -5, to = 85,\n      xlab = \"x\", ylab = \"f_X(x)\")", block: true)

#raw("par(mfrow = c(1, 2))") divides the plotting window into one row and two columns\. In #raw("curve()"), #raw("add = TRUE") draws on the current plot\.


== Reading tabular data

These commands assume the required packages are already available\.

#raw(lang: "r", "# CSV with column headings\nfailure_data <- read.csv(\"exa1.csv\")\n\n# Whitespace- or tab-separated text with column headings\nmicrowaves <- read.table(\"microwaves.txt\", header = TRUE)\n\n# Excel workbook\nstreetlamps <- readxl::read_excel(\"streetlamps.xlsx\")\n\nhead(failure_data)\nnames(failure_data)\nstr(failure_data)\nsummary(failure_data)\n\nfailure_data$time\nfailure_data$status\nfailure_data[failure_data$status == 1, ]", block: true)

Relative file paths start from #raw("getwd()")\. Use #raw("getwd()") to check the current working directory and prefer project\-relative paths over changing it in a script\.


== R distribution functions\: #raw("d"), #raw("p"), #raw("q"), #raw("r")

R uses the same four prefixes for nearly every distribution\.

#table(
  columns: 3,
  align: (auto, auto, auto,),
  stroke: (x: none, y: 0.5pt),
  table.header(
    [*Prefix*],
    [*Question answered*],
    [*Normal example*],
  ),
  [#raw("d")],
  [What is the PMF\/PDF value at $x$?],
  [#raw("dnorm(x, mean, sd)")],
  [#raw("p")],
  [What is $P(X <= x)$?],
  [#raw("pnorm(x, mean, sd)")],
  [#raw("q")],
  [Which $x$ has a given lower\-tail probability?],
  [#raw("qnorm(p, mean, sd)")],
  [#raw("r")],
  [Generate random observations\.],
  [#raw("rnorm(N, mean, sd)")],
)
#quote[
Given a boundary, use #raw("p")\. Given a probability and asked for the boundary, use #raw("q")\. Use #raw("d") only for a PMF\/PDF height, not an accumulated probability\.
]


=== Tail and interval patterns

#raw(lang: "r", "# P(X <= x)\npnorm(x, mean = mu, sd = sigma)\n\n# P(X > x): use the upper tail directly\npnorm(x, mean = mu, sd = sigma, lower.tail = FALSE)\n\n# P(a < X <= b)\npnorm(b, mean = mu, sd = sigma) -\n  pnorm(a, mean = mu, sd = sigma)\n\n# x such that P(X <= x) = p\nqnorm(p, mean = mu, sd = sigma)\n\n# x such that P(X > x) = alpha\nqnorm(alpha, mean = mu, sd = sigma, lower.tail = FALSE)", block: true)

For a discrete variable, the CDF includes its boundary\:

#raw(lang: "r", "# X ~ Binomial(10, 0.08)\npbinom(1, size = 10, prob = 0.08)                    # P(X <= 1)\npbinom(1, size = 10, prob = 0.08, lower.tail = FALSE) # P(X > 1)\npbinom(4, size = 10, prob = 0.08) -\n  pbinom(1, size = 10, prob = 0.08)                  # P(2 <= X <= 4)", block: true)


=== Course distribution lookup

Replace the first letter with #raw("d"), #raw("p"), #raw("q") or #raw("r")\. For an #raw("r") function, the first argument is the number of observations #raw("N") rather than #raw("x") or a probability\.

#table(
  columns: 3,
  align: (auto, auto, auto,),
  stroke: (x: none, y: 0.5pt),
  table.header(
    [*Distribution*],
    [*R pattern*],
    [*Parameter note*],
  ),
  [Discrete uniform],
  [#raw("sample(values, N, replace = TRUE)")],
  [Each listed value is equally likely\.],
  [Continuous uniform],
  [#raw("punif(x, min = a, max = b)")],
  [Bounds are (a,b)\.],
  [Binomial],
  [#raw("pbinom(x, size = n, prob = p)")],
  [Trials $n$, success probability $p$\.],
  [Poisson],
  [#raw("ppois(x, lambda = mu)")],
  [#raw("lambda") is the expected count for the interval\.],
  [Normal],
  [#raw("pnorm(x, mean = mu, sd = sigma)")],
  [#raw("sd") is σ, not σ²\.],
  [Student\'s t],
  [#raw("pt(x, df = nu)")],
  [Degrees of freedom #raw("df")\.],
  [Lognormal],
  [#raw("plnorm(x, meanlog = mu, sdlog = sigma)")],
  [#raw("mu") and #raw("sigma") describe #raw("log(X)")\.],
  [Weibull],
  [#raw("pweibull(x, shape = beta, scale = eta)")],
  [Shape β, characteristic life η\.],
  [Exponential],
  [#raw("pexp(x, rate = lambda)")],
  [Mean and scale are $1/lambda$\.],
  [Gamma],
  [#raw("pgamma(x, shape = beta, rate = lambda)")],
  [Scale θ is $1/lambda$\. Do not supply both\.],
  [Beta],
  [#raw("pbeta(x, shape1 = alpha, shape2 = beta)")],
  [Support is $0 <= x <= 1$\.],
)
Examples of the other prefixes\:

#raw(lang: "r", "dweibull(t, shape = beta, scale = eta)\nqgamma(0.78, shape = beta, rate = lambda)\nrlnorm(1000, meanlog = mu, sdlog = sigma)", block: true)


== Reliability and hazard

For a lifetime $T$, reliability is the upper tail\:

#raw(lang: "r", "# R(t) = P(T > t)\nR_exponential <- pexp(t, rate = lambda, lower.tail = FALSE)\nR_weibull <- pweibull(t, shape = beta, scale = eta,\n                      lower.tail = FALSE)\nR_lognormal <- plnorm(t, meanlog = mu, sdlog = sigma,\n                     lower.tail = FALSE)", block: true)

Common reliability formulas\:

#raw(lang: "r", "# Exponential\nh_exponential <- lambda\nmttf_exponential <- 1 / lambda\n\n# Weibull\nh_weibull <- (beta / eta) * (t / eta)^(beta - 1)\nmttf_weibull <- eta * gamma(1 + 1 / beta)\nsd_weibull <- eta * sqrt(\n  gamma(1 + 2 / beta) - gamma(1 + 1 / beta)^2\n)\n\n# Independent systems at one time t\nR_series <- prod(component_reliabilities)\nR_parallel <- 1 - prod(1 - component_reliabilities)", block: true)


== Choosing and fitting a distribution to data

To \"assign a distribution\" to data, choose a probability model for the variable and estimate its parameters from the observations\. The data do not uniquely determine a distribution\: use what the variable measures, its possible values, and the observed shape\. If a question specifies the distribution, use that model\.


=== 1\. Choose plausible distributions

#table(
  columns: 3,
  align: (auto, auto, auto,),
  stroke: (x: none, y: 0.5pt),
  table.header(
    [*What the data represent*],
    [*Candidate model*],
    [*What to check*],
  ),
  [Successes out of a fixed number of trials],
  [Binomial],
  [Independent trials with the same success probability; known trial count\.],
  [Event counts in equal exposure intervals],
  [Poisson],
  [Independent events at a constant rate; variance roughly equal to the mean\.],
  [Continuous measurements with roughly symmetric, bell\-shaped variation],
  [Normal],
  [No strong skew or outliers; negative model values must be acceptable or negligible\.],
  [Positive measurements with right skew and multiplicative variation],
  [Lognormal],
  [#raw("log(x)") is approximately normal\.],
  [Nonnegative waiting times or lifetimes],
  [Exponential],
  [Approximately constant failure\/event rate; standard deviation roughly equals the mean\.],
  [Positive lifetimes with a changing failure rate],
  [Weibull],
  [Can represent decreasing, constant or increasing hazard\.],
  [Positive, right\-skewed measurements or waiting times],
  [Gamma],
  [Flexible positive model; compare its fit with other plausible candidates\.],
  [Continuous proportions strictly between 0 and 1],
  [Beta],
  [Exact zeros and ones need separate treatment\.],
  [Values within known bounds with no favoured region],
  [Uniform],
  [Equal density throughout the interval is justified by the process\.],
)
A histogram is a starting point, not proof\. Check units, missing values and recording errors first\. Look at #raw("plot(x, type = \"o\")") if observations are in time order\: trends or dependence can invalidate a single independent, identically distributed model\. Do not remove valid outliers just to improve fit\.


=== 2\. Estimate parameters and check the fit in R

This example uses complete, uncensored observations and fits a normal model\. The estimates describe individual observations, so use the fitted standard deviation, not the standard error of the mean\.

#raw(lang: "r", "x <- life_time\nmu_hat <- mean(x)\nsigma_hat <- sqrt(mean((x - mu_hat)^2))   # normal MLE\n\n# Compare the fitted density with the observed histogram\nhist(x, probability = TRUE,\n     main = \"Normal fit to lifetimes\", xlab = \"Lifetime (years)\")\ncurve(dnorm(x, mean = mu_hat, sd = sigma_hat),\n      add = TRUE, col = \"red\", lwd = 2)\n\n# Normal Q-Q plot: points should be approximately on a straight line\nqqnorm(x)\nqqline(x, col = \"red\")\n\n# Compare the empirical CDF with the fitted CDF\nplot(ecdf(x), main = \"Observed and fitted CDF\", xlab = \"Lifetime (years)\")\ncurve(pnorm(x, mean = mu_hat, sd = sigma_hat),\n      add = TRUE, col = \"red\", lwd = 2)", block: true)

Systematic curvature in a Q\-Q plot suggests a mismatch; inspect the tails as well as the centre\. For a lognormal candidate with all #raw("x > 0"), use #raw("qqnorm(log(x))") and #raw("qqline(log(x))"), then estimate parameters on the log scale as shown below\. Small samples provide limited evidence about distribution shape\. Choose a model that matches both the data and the generating process; a good visual fit does not prove the model is correct\.


=== 3\. Use the fitted distribution

#raw(lang: "r", "# Under the fitted normal model: probability lifetime exceeds 6 years\npnorm(6, mean = mu_hat, sd = sigma_hat, lower.tail = FALSE)\n\n# Fitted 90th percentile\nqnorm(0.90, mean = mu_hat, sd = sigma_hat)\n\n# Observed fraction exceeding 6, for comparison\nmean(x > 6)", block: true)

These fitted probabilities treat the estimated parameters as fixed; they do not include parameter uncertainty\. Calling #raw("rnorm()") generates new simulated data, and calling #raw("dnorm()") evaluates a density; neither fits a distribution\. The usual one\-sample #raw("ks.test()") p\-value is not valid when its distribution parameters were estimated from the same sample\.


== Model estimates from complete data

#raw(lang: "r", "x <- c(10, 17, 24, 30, 14, 18, 15, 13, 21)\n\n# Normal model\nmu_normal <- mean(x)\nsigma_normal_mle <- sqrt(mean((x - mu_normal)^2))\nsigma_normal_sample <- sd(x)\n\n# Lognormal model: estimate on the log scale\nlog_x <- log(x)\nmu_lognormal <- mean(log_x)\nsigma_lognormal_mle <- sqrt(mean((log_x - mu_lognormal)^2))\n\n# Exponential model\nlambda_exponential <- 1 / mean(x)", block: true)

For exponential data with right\-censoring, let #raw("status") be 1 for failure and 0 for censored\:

#raw(lang: "r", "failures <- sum(failure_data$status)\ntotal_time <- sum(failure_data$time)\n\nlambda_hat <- failures / total_time\nmttf_hat <- total_time / failures", block: true)

Do not apply #raw("sd()") directly to censored recorded times as though every item failed\.


== Normal, t and CLT calculations

#raw(lang: "r", "# Sampling distribution of a mean when population sigma is known\nstandard_error <- sigma / sqrt(n)\nz <- (x_bar - mu) / standard_error\n\n# P(X_bar > boundary)\npnorm(boundary, mean = mu, sd = standard_error,\n      lower.tail = FALSE)\n\n# t statistic when sigma is unknown\nt_statistic <- (x_bar - mu) / (s / sqrt(n))\npt(t_statistic, df = n - 1, lower.tail = FALSE)\n\n# Required n for two-sided error E and confidence 1 - alpha\nz_critical <- qnorm(1 - alpha / 2)\nn_required <- ceiling((z_critical * sigma / E)^2)", block: true)

For $T tilde.op op("Weibull")(beta,eta)$, calculate the population mean and standard deviation before applying the CLT to a sample mean\:

#raw(lang: "r", "mu_T <- eta * gamma(1 + 1 / beta)\nsigma_T <- eta * sqrt(\n  gamma(1 + 2 / beta) - gamma(1 + 1 / beta)^2\n)\nstandard_error <- sigma_T / sqrt(n)", block: true)


== Random sampling and reproducible simulation

#raw(lang: "r", "set.seed(5507)\n\nrnorm(20, mean = 10, sd = 5)\nrexp(20, rate = 2)\nsample(1:6, size = 20, replace = TRUE)\n\nn <- 40\nrepetitions <- 10000\nsample_means <- replicate(\n  repetitions,\n  mean(rexp(n, rate = 2))\n)\n\nhist(sample_means, freq = FALSE,\n     main = \"Sampling distribution of the mean\",\n     xlab = \"Sample mean\")\n\ncurve(dnorm(x, mean = 1 / 2, sd = (1 / 2) / sqrt(n)),\n      add = TRUE, col = \"red\")", block: true)

#raw("set.seed()") makes the generated sequence repeatable\. Change or remove it when you want a different simulation\.


== Custom functions and conditions

#raw(lang: "r", "F_X <- function(x) {\n  if (x < 1) {\n    return(0)\n  } else {\n    return(1 - 2 / (x * (x + 1)))\n  }\n}\n\nprobability <- F_X(2.7) - F_X(2.2)", block: true)

Use #raw("if") when testing one condition\. Use vectorised #raw("ifelse(condition, yes, no)") when #raw("x") may contain many values\.


== Kaplan–Meier estimate for right\-censored data

This assumes the #raw("survival") package is already available and #raw("status") is 1 for failure and 0 for censored\.

#raw(lang: "r", "library(survival)\n\nfit <- survfit(Surv(time, status) ~ 1, data = failure_data)\n\nplot(fit,\n     xlab = \"Time\",\n     ylab = \"Estimated reliability R(t)\",\n     conf.int = TRUE)\n\nsummary(fit, times = c(20, 50, 100))", block: true)


== Printing a requested number of decimals

#raw(lang: "r", "p <- pnorm(0.21, lower.tail = FALSE)\nround(p, 2)                  # numeric value rounded for display\ncat(sprintf(\"%.2f\\n\", p))   # print exactly two decimal places", block: true)


== Fast error checks

#list(tight: true,
[
Check whether the question asks for a density, probability, quantile or random sample before choosing #raw("d"), #raw("p"), #raw("q") or #raw("r")\.
],
[
Use #raw("lower.tail = FALSE") for an upper tail instead of manually subtracting a value very close to 1\.
],
[
For a discrete CDF, #raw("pbinom(k, ...)") and #raw("ppois(k, ...)") include (k)\.
],
[
R\'s normal functions take standard deviation, not variance\.
],
[
R\'s exponential functions take a rate; mean $=1/lambda$\.
],
[
Lognormal parameters belong to #raw("log(X)"), not directly to #raw("X")\.
],
[
Weibull #raw("scale = eta") is characteristic life, not generally the mean\.
],
[
#raw("sd(x)") uses (n\-1); the normal MLE for σ uses (n)\.
],
[
Do not overwrite common function names with objects such as #raw("c"), #raw("mean"), #raw("sd"), #raw("F") or #raw("q")\.
],
)
