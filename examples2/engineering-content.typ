#set page(paper: "a4", margin: 16mm, numbering: "1")
#set text(size: 10.5pt)
#show raw: set text(size: 8pt)
#show table: set text(size: 9pt)

= GENG5507 — Engineering midsemester notes

*Scope:* the engineering slides and workshops supplied for Weeks 1–5, the engineering quizzes, and engineering applications in the 2025 paper. This is a course revision document; references to standards/regulation describe the supplied teaching material. The detailed statistics formulas are in #link("cheatsheet.md")[the cheat sheet], complete statistical questions in #link("questions.md")[questions], R commands in #link("R.md")[the R guide], and selected worked problems in #link("examples.md")[examples].

Read in order: *safe systems → risk management → uncertainty/QRA → reliability in design → maintenance strategy → exam questions*. Numerical examples here explain engineering decisions and assumptions.

*Source status:* the core notes below synthesize the course PDFs and existing weekly notes. Additional interpretations and worked answers are identified as such. Some workshop PDFs contain prompts or diagrams without official solutions; missing assumptions are called out instead of inventing a unique answer.


== Week 1 - Factors Affecting Safety, Risk and Reliability


=== 1. Learning focus

The Week 1 material aims to:

- explain the engineer's role in delivering safe and reliable systems;
- identify organisational, social and human factors that contribute to safe systems; and
- use Piper Alpha to examine how accidents arise and influence safety regulation.

No statistical concepts are introduced in this topic.


=== 2. Safe systems require three forms of capital

The central model places *risk, reliability and safety practice - what actually happens -* at the interaction of three forms of capital.


==== Human capital

Human capital includes:

- people's skills;
- awareness; and
- experience.

People need the competence to recognise hazards, understand the system and act appropriately. Written procedures cannot compensate fully for missing knowledge or experience.


==== Organisational capital

Organisational capital includes:

- processes; and
- management systems describing what should be done and when.

This capital turns intent into repeatable work: responsibilities, operating processes, maintenance systems, assurance and escalation paths.


==== Social capital

Social capital includes:

- leadership;
- culture; and
- trust.

It affects whether people speak up, share information, follow or challenge practices, and believe that management will act on safety concerns.


==== Interaction is the key

None of the three is sufficient by itself:

- competent people can still be undermined by weak processes;
- good procedures can fail when culture discourages reporting or questioning;
- strong leadership cannot deliver safe operation without capable people and workable systems.

The model is best understood as an interacting system, not a checklist of independent factors. Engineering outcomes depend on the fit between people, formal systems and the way work is socially organised.


=== 3. The engineer's role

The material frames safety and reliability as engineering responsibilities extending beyond physical design. Engineers need to consider:

- whether the design is inherently safe and robust;
- how the system will actually be operated and maintained;
- whether people have the necessary capability and information;
- whether management systems identify and control risk; and
- whether leadership and culture support safe decisions.

A technically sound component does not guarantee a safe system. The operating organisation and human context form part of the system being engineered.


=== 4. Piper Alpha workshop structure

The Week 1 PDF uses the 1988 Piper Alpha disaster as a workshop. It states that 167 people died and divides the investigation into two stages.


==== Stage 1: factors contributing to the main explosion

The workshop asks students to classify observations as:

- *immediate events or contributions* - the actions or physical events close to the first explosion;
- *design factors* - features of equipment, layout or system design;
- *management-system factors* - weaknesses in formal processes and controls; and
- *cultural issues* - shared behaviours, priorities, assumptions and willingness to challenge unsafe conditions.


==== Stage 2: factors that aggravated the event

After the first explosion, the same systems perspective is applied to escalation. The workshop asks for:

- design factors;
- management-system factors;
- cultural issues; and
- aggravating events.

This distinction is important:

- *causal factors* help an event begin;
- *aggravating factors* allow its consequences to grow; and
- a factor may operate at more than one level or interact with other factors.


=== 5. How to analyse a major accident

For a case like Piper Alpha, use the following method:

+ Construct the event sequence without jumping immediately to blame.
+ Identify the immediate physical and operational events.
+ Ask what design conditions made those events possible.
+ Ask which management processes should have prevented, detected or controlled them.
+ Examine how leadership, culture and trust affected real behaviour.
+ Separate initiation from escalation and consequence severity.
+ Look for interactions across the human, organisational and social levels.
+ Convert lessons into design, management-system and cultural changes.


=== 6. Important limitation of the supplied material

The Week 1 PDF provides blank activity tables and points to an in-class video, but it does not provide completed Piper Alpha findings or model answers. The completed case interpretation in the supplement below is drawn from the existing supplementary Piper Alpha note, rather than being presented as an official workshop answer.


=== 7. Exam-ready takeaways

- Safety, risk and reliability are produced by a *socio-technical system*, not by hardware alone.
- Human capital means skills, awareness and experience.
- Organisational capital means processes and management systems.
- Social capital means leadership, culture and trust.
- Safe practice is what actually happens where these three forms of capital interact.
- Analyse both why an accident started and why it escalated.
- Avoid reducing a complex failure to a single worker's action; ask what design, management and cultural conditions shaped that action.
- Engineering responsibility includes the lifecycle operating context, not merely initial technical design.


== Week 2 - Risk Management


=== 1. Risk and related terms

ISO 31000 defines *risk* as the effect of uncertainty on objectives. The effect may be positive, negative or both, and risk is normally described using sources, potential events, consequences and likelihood.

Key terms:

- *Risk management:* coordinated activities used to direct and control an organisation with regard to risk.
- *Risk source:* an element that can give rise to risk by itself or in combination with other elements.
- *Event:* an occurrence or change in circumstances. It may have several causes and consequences; something expected may fail to happen, or something unexpected may happen.
- *Consequence:* an outcome that affects objectives. It may be direct or indirect, positive or negative, certain or uncertain, and may escalate through cascading or cumulative effects.
- *Likelihood:* the chance of something happening. It may be objective or subjective and expressed qualitatively, quantitatively, as probability or as frequency.
- *Control:* a measure that maintains or modifies risk. A control may not have the intended effect.
- *Stakeholder:* a person or organisation that can affect, be affected by, or perceive itself to be affected by a decision or activity.


=== 2. ISO 31000 purpose and applicability

ISO 31000 is an internationally recognised risk-management guideline. The 2018 version places stronger emphasis on senior-management involvement and integration of risk management into the organisation.

Its overall purpose is to help organisations *create and protect value* by improving performance, encouraging innovation and supporting the achievement of objectives.

It can be applied:

- by public, private or community organisations, groups and individuals;
- throughout an organisation's life;
- to strategies, decisions, operations, projects, products, services and assets; and
- to risks with positive or negative consequences.


=== 3. Risk-management principles and framework

The eight ISO 31000 principles are:

+ *Integrated:* risk management is part of organisational activities and decisions.
+ *Structured and comprehensive:* a consistent approach supports comparable and reliable results.
+ *Customised:* the framework and process fit the organisation's objectives and context.
+ *Inclusive:* appropriate stakeholder involvement brings knowledge and perspectives into decisions.
+ *Dynamic:* risk management anticipates and responds to changes and emerging risk.
+ *Best available information:* decisions use historical, current and expected information while recognising uncertainty and limitations.
+ *Human and cultural factors:* behaviour and culture influence every part of risk management.
+ *Continual improvement:* learning and experience are used to improve the framework and process.

Leadership and commitment sit at the centre of the framework. The framework cycles through integration, design, implementation, evaluation and improvement.


=== 4. ISO 31000 risk-management process

The main process is:

+ establish *scope, context and criteria*;
+ perform risk assessment:
  - identify risks;
  - analyse risks; and
  - evaluate risks;
+ treat risks.

Throughout the process, communicate and consult, monitor and review, and record and report.


==== 4.1 Scope, context and criteria

Define:

- what activity or decision is in scope;
- the objectives to be achieved and their link to organisational objectives;
- the internal and external operating context;
- stakeholders and resources; and
- criteria for judging the significance and acceptability of risk.

The process must be fit for purpose. A change in context can change both the risks and their significance.


==== 4.2 Risk identification

Purpose: find, recognise and describe risks that may help or prevent objectives being achieved.

Ask:

- What can happen?
- When and where can it happen?
- How and why can it happen?

Consider tangible and intangible sources, causes, events, threats, opportunities, vulnerabilities, capabilities, emerging risk, assets, consequences, time, information limits, assumptions and bias.


==== 4.3 Risk analysis

Purpose: understand the nature and characteristics of risk and, where appropriate, determine the level of risk.

Analyse:

- existing controls and their effectiveness;
- event and consequence likelihood;
- nature and magnitude of consequences;
- complexity, connectivity and dependence;
- time and volatility;
- sensitivity and confidence; and
- information quality, assumptions, exclusions and method limitations.

The influences on analysis should be documented and communicated rather than hidden behind a final number.


==== 4.4 Risk evaluation

Purpose: support decisions by comparing analysed risk against the established criteria.

Possible decisions include:

- do nothing further;
- maintain existing controls;
- consider treatment options;
- perform more analysis; or
- reconsider objectives.

The result should be recorded, communicated and validated at an appropriate organisational level.


==== 4.5 Risk treatment

Treatment is iterative:

+ formulate and select options;
+ plan and implement them;
+ assess effectiveness;
+ determine whether residual risk is acceptable; and
+ apply further treatment if it is not.

Options for negative outcomes include avoiding the risk, reducing likelihood, changing consequences, sharing the risk or retaining it. The control preference shown in the slides is:

$ "elimination" > "substitution" > "engineering controls" > "administrative controls" > "PPE" $

In this hierarchy:

- *elimination* removes the hazard;
- *substitution* replaces it with a less hazardous alternative;
- *engineering controls* physically isolate people or other receptors from the hazard;
- *administrative controls* change work through procedures, training, warnings or scheduling; and
- *personal protective equipment (PPE)* reduces exposure at the individual level.

Controls higher in the hierarchy are generally preferred because they rely less on continual correct human action. Multiple controls may still be needed, and their effectiveness must be verified in the actual operating context.

Options for positive outcomes include engaging in the activity, increasing likelihood or consequence, sharing the opportunity and retaining residual opportunity.

A treatment plan should state the rationale, benefits, accountable people, actions, resources, contingencies, performance measures, constraints, monitoring/reporting and completion dates.


=== 5. Risk matrices and risk registers

A risk matrix combines ordered likelihood and consequence categories. The course uses a 5-by-5 matrix with consequence dimensions including:

- environment;
- assets/business disruption;
- reputation; and
- health and safety.

Likelihood descriptors range from events not heard of in the industry to events expected in most circumstances at the location. The matrix assigns low, medium or high categories.


==== Correct use and limitations

- Define category criteria before scoring.
- Use the matrix appropriate to the context; matrices differ between organisations.
- Keep likelihood and consequence visible, not only a combined colour or number.
- Do not assume ordinal scores are precise physical measurements.
- A low-frequency, high-consequence event must not disappear inside a summary score.

A *risk register* records risks, likelihood, consequences, rankings, controls, owners and actions. High-ranked risks are normally prioritised, but the register must be reviewed when context, controls or evidence changes.


==== ALARP

*ALARP* means as low as reasonably practicable. The risk picture contains:

- an intolerable region, where risk is unjustifiable except in extraordinary circumstances;
- a tolerable/ALARP region, where further reduction is required unless reasonably impracticable; and
- a broadly acceptable region, where further reduction is not normally required.

An ALARP claim needs reasoned, supported evidence that no further practicable control could reasonably be adopted.


=== 6. Engineering risk assessment

The method should fit the context, objective and available resources. Quantitative is not automatically superior to qualitative analysis.


==== Qualitative

Uses descriptions rather than numerical risk values. Appropriate for screening, limited data, low-importance cases or when extra numerical precision would not affect decisions.


==== Semi-quantitative

Uses numerical scales to compare risks, such as a risk priority number. The scales may not be linear, so the numbers must not imply precision they do not possess.


==== Quantitative

Uses numerical likelihood/frequency and consequence estimates. Its context, assumptions and model limitations must be explicit.

For scenarios $i$, an expected risk measure may be written:

$ R=sum_i F_i C_i $

where $F_i$ is the probability or frequency of scenario $i$ and $C_i$ is its consequence measure.

Generic assessment steps are:

+ define the hazardous scenario;
+ estimate its likelihood or frequency;
+ estimate health, safety, environmental and/or economic consequences;
+ combine scenario estimates where an expected value is useful;
+ visualise the result while retaining likelihood and consequence; and
+ estimate and communicate uncertainty.


=== 7. Engineering analysis methods

- *HAZID:* broad scenario-based hazard identification, often early in a project.
- *HAZOP:* design-assurance method using guide words to find hazard and operability deviations.
- *FMEA/FMECA:* function-based analysis of failure modes, effects and criticality.
- *Fault tree analysis (FTA):* works backwards from a top event using AND/OR logic.
- *Event tree analysis (ETA):* works forward from an initiating event through success/failure branches.
- *Layer of protection analysis (LOPA):* evaluates protection layers for a nominated high-consequence event.
- *Functional safety assessment:* evaluates safety instrumented systems against tolerable failure probability.
- *Reliability block diagrams:* model success relationships between components.

Different methods fit different stages of product, process-plant, asset and software lifecycles.


=== 8. Hazards, controls and barriers

A *hazard* is a risk source. Engineering hazards may be chemical, thermal, mechanical, electrical, ionising radiation, non-ionising radiation or biological.

A *barrier* is an engineering control intended to separate people or other receptors from a hazard. It may use a physical boundary, distance or shielding.

Controls can fail because of:

- deformation, erosion, corrosion or changing material properties;
- equipment malfunction;
- human practices and decisions;
- poor design or maintenance; or
- adverse natural phenomena.

Therefore each control needs a defined function, performance standard, assurance activity and maintenance requirement. Assumed control performance must be tested.


=== 9. Failure modes and effects analysis (FMEA)

FMEA is a systematic process used to:

- recognise and evaluate potential failures and their effects;
- identify actions that eliminate or reduce failure likelihood; and
- document the analysis.

It starts with *function*, not with a generic event.


==== Main steps

+ Define scope and analysis level.
+ Identify required functions and functional failures.
+ Identify failure modes and their causes.
+ Identify effects and assign severity.
+ Assign occurrence/frequency.
+ Identify current controls and assign detectability.
+ Calculate and review risk priority.
+ Rank failure modes for action and analysis.
+ Assign actions, owners and dates.
+ Re-score after action to evaluate residual risk.

An FMEA needs a team that knows the asset and operating context, a functional breakdown, failure-mode knowledge, agreed rating tables and a recording system.


==== Risk priority number

$ op("RPN")=S times O times D $

where:

- $S$ = severity;
- $O$ = occurrence (sometimes $P$ for probability); and
- $D$ = detectability score, with a high score meaning poor detectability in the supplied example.

RPN is a prioritisation aid, not a physical quantity. Different combinations can produce the same RPN while representing very different risks, so severity, occurrence and detectability should also be reviewed separately.


==== Pump FMEA example

The lecture illustrates the function-first structure with a pump required to transfer at least 300 litres per minute from Tank A to Tank B:

#table(
  columns: 2,
  align: (auto, auto,),
  table.header(
    [*FMEA element*],
    [*Example*],
  ),
  [Required function],
  [Pump water from Tank A to Tank B at not less than 300 L/min.],
  [Functional failure],
  [No water is pumped, or flow is below 300 L/min.],
  [Failure mode/cause],
  [Bearing seizure from inadequate lubrication; coupling failure from fatigue; or efficiency loss from an impeller corroding.],
  [Failure effect],
  [The pump trips or cannot sustain production, Tank B's low-level alarm activates, the tank may run dry within 20 minutes, and repair takes about four hours.],
)
This example shows why a component name is not a failure mode. The analysis must distinguish the required function, loss of that function, the physical manner/cause of failure and the resulting system effects.


=== 10. Driverless-car workshop

The workshop applies ISO 31000 and FMEA to a proposed 12-month driverless-vehicle trial at UWA.

The example FMEA considers:

- LiDAR blocked by snow or mud;
- AI misclassifying a pedestrian;
- compute-node shutdown;
- steering-actuator failure; and
- stale construction-zone map data.

It assigns severity, occurrence and detectability, calculates RPN, and proposes controls such as redundant sensing/computing, improved perception, fail-operational behaviour, minimal-risk manoeuvres and real-time map validation.

Key lesson: highest RPN is not the only concern. A low-occurrence compute or actuator failure can still have very high severity and needs explicit treatment.


=== 11. Exam-ready takeaways

- Risk is tied to *uncertainty and objectives*.
- Risk assessment means identification, analysis and evaluation; treatment is a following step.
- Scope, context and criteria must be established before scoring risks.
- Communication, monitoring and recording run throughout the process.
- Controls must be verified because they may not perform as assumed.
- Use qualitative, semi-quantitative or quantitative analysis according to the decision need and evidence.
- FMEA starts with required function, then functional failure, failure mode, cause and effect.
- RPN supports prioritisation but does not replace engineering judgement.
- ALARP is an evidence-based demonstration, not simply a colour on a matrix.


== Week 3 - Uncertainty and Quantitative Risk Assessment


=== 1. Societal and individual risk


==== Societal risk

Societal risk concerns consequences to groups within a population exposed by hazardous events in a region or period. A simple measure is:

$ "societal risk"=frac("events", "time")times frac("consequences", "event") $

Sites that can create significant societal risk include chemical plants, facilities storing liquefied toxic chemicals, and large LPG or LNG storage facilities.


==== Individual risk

Individual risk is the annual probability of a specified adverse outcome for one person. In a simplified population-average calculation:

$ "individual risk"=frac("societal risk", "population at risk") $

The lecture example uses 155 road deaths in a Western Australian population of 2.67 million:

$ frac(155, 2.67 times 10^6)=5.81 times 10^(-5)" per person-year" $

This is about 5.8 deaths per 100,000 people per year.


=== 2. F-N curves

An F-N curve presents societal risk on log-log axes:

- horizontal axis $N$: number of fatalities; and
- vertical axis $F_N$: annual frequency of events causing *$N$ or more* fatalities.

For event scenarios $i$:

$ F_N=sum_(i:N_i >= N)f_i $

where $f_i$ is the frequency of scenario $i$ and $N_i$ is its fatality consequence.

Because $F_N$ is cumulative, it cannot increase as $N$ increases. Criteria vary by jurisdiction, so the same calculated risk may be treated differently in different places.


=== 3. Potential loss of life and fatality measures


==== Potential loss of life

Potential loss of life (PLL), also called expectation value in this context, is:

$ op("PLL")=sum_i f_i N_i $

Its unit is expected fatalities per year. PLL can support cost-benefit and ALARP analysis, but it compresses the distribution of consequences: two systems can have the same PLL while one has frequent small events and the other rare catastrophes. Retain the F-N picture as well.


==== Fatal accident rate

Fatal accident rate (FAR) is fatalities per $10^8$ exposed work-hours:

$ op("FAR")=frac("fatalities over the period"times 10^8, "total exposed work-hours over the period") $

It allows comparisons between activities with different workforce sizes and exposure times.


==== Fatality rate

The lecture uses the Safe Work Australia convention of fatalities per 100,000 workers. Always state the denominator and exposure period when comparing rates.


=== 4. What QRA is

Quantitative risk assessment is a systematic, model-based investigation of how a complex system operates. It can model interactions among hardware, software and people, identify major contributors to risk, and test whether societal and individual risk expectations are met.

Other industries may use terms such as probabilistic risk assessment or formal risk assessment. Confirm what a term means in its context.

QRA asks:

+ What can go wrong and expose a hazard?
+ How likely is the scenario?
+ What health, safety, environmental or economic consequences would follow?


=== 5. QRA workflow

A practical workflow is:

+ Define objective, scope, system boundaries and risk measures.
+ Become familiar with the system and operating context.
+ Identify initiating events and scenarios.
+ Model accident sequences and system interactions.
+ Model component, control and human failures.
+ Collect data and elicit justified expert judgement.
+ Quantify branch probabilities/frequencies and consequences.
+ Aggregate and rank scenarios without hiding extreme consequences.
+ assess sensitivity and uncertainty;
+ test risk-reduction options and communicate results.

Tools may include functional block diagrams, FMEA/FMECA, fault trees, event trees, bow-ties, reliability block diagrams, reliability analysis, Monte Carlo simulation and sensitivity analysis.


=== 6. Event trees and fault trees


==== Event tree analysis

An event tree starts with an initiating event and moves forward through pivotal success/failure branches to end states.

If conditional branch events are represented correctly, an end-state probability is the product of probabilities along its path:

$ P("path")=product_j P(B_j ∣ B_1,dots,B_(j-1)) $

Mutually exclusive end-state probabilities can then be summed for a consequence category.


==== Fault tree analysis

A fault tree works backward from an undesired top event to combinations of lower-level events. It uses:

- *AND gates:* every input event is required; and
- *OR gates:* any input event is sufficient.

A *minimal cut set* is a smallest combination of bottom events sufficient to produce the top event. Single-event cut sets deserve early attention because one failure alone can cause the top event.

Do not multiply probabilities blindly: dependence and common-cause failure must be modelled explicitly.


=== 7. Value and limitations of QRA

QRA can:

- reveal design and operational deficiencies;
- prioritise improvement resources;
- identify dominant contributors to risk;
- examine uncertainty; and
- test risk-reduction strategies.

Challenges include:

- weak or incomplete models;
- scarce or poor-quality data;
- estimation of rare, high-impact events;
- dependencies in complex systems;
- extreme operating conditions; and
- human-system interactions.

A numerical result is conditional on the model, evidence, scope and assumptions. It is not uncertainty-free truth.


=== 8. Expressing uncertainty

Every QRA uses approximations and assumptions. Good practice is to make them explicit using:

- parameter ranges or probability distributions;
- confidence/credible intervals and uncertainty bands;
- sensitivity analysis;
- alternative model/scenario assumptions; and
- clear statements of exclusions, dependencies and data quality.

The lecture's modelling examples show that changing a parameter can alter both the predicted trajectory and the width of uncertainty bounds.

Risk communication also matters. Stakeholders may perceive the same numerical risk differently because of trust, control, familiarity, fairness or dread. Engineering decisions need understandable explanation of what is known, uncertain and value-dependent.


=== 9. Safety cases and regulation

QRA is widely used in safety cases for high-hazard industries. The supplied material describes a safety case as including:

- the facility description;
- a formal safety assessment; and
- the safety management system.

Its purpose is to demonstrate that the operator understands the factors influencing risk and the controls critical to managing it. Engineers must also identify and comply with the legislation and regulator relevant to their jurisdiction.


=== 10. Highway-tunnel QRA example

The tunnel example uses QRA to prioritise potential safety investments for a two-kilometre twin-tube tunnel carrying about 43,000 vehicles per day.

The method:

+ defines the objective;
+ studies the system;
+ identifies initiating events;
+ models accident scenarios with an event tree;
+ models failure causes with fault trees;
+ collects quantification data;
+ calculates scenario risk; and
+ ranks scenarios.

The event tree divides fire/smoke response into detection and control functions, producing an acceptable state and four failure end states. The fault tree for fire and smoke detection identifies minimal cut sets so prevention can focus first on important single-event contributors.


=== 11. Rosia Montana tailings-facility case

The proposed mine-waste facility is screened for earthquake, intense rainfall, hillside slide, dam-crest slump and combinations of triggers. The supplied event tree then explores internal erosion.


==== Highest non-performance path

Interpreting non-performance as leakage large enough to unravel the toe, the larger branch is the no-core-defect/foundation-leakage route:

$ P=0.9 times 0.01 times 0.3 times 0.001=2.7 times 10^(-6) $

The defect-in-core route is smaller:

$ P=0.1 times 0.01 times 0.001 times 0.001=1.0 times 10^(-9) $

The first route therefore dominates the modelled non-performance probability.

*Interpretation limit:* these are path probabilities in the supplied tree, not automatically annual frequencies. Also, the tree labels its adverse outcomes as local contamination/material damage, not 2,500 deaths. The population at risk is 2,500, but population exposed is not the same as fatalities. An F–N placement needs an explicit fatality model and time basis. If a classroom calculation assumes all 2,500 people die and the probability is annual, state those assumptions before using the supplied ANCOLD graph. A project approval cannot be inferred from one failure mode alone.

For the tree's final consequence categories, multiply by the terminal branch: the dominant CC2 path is $2.7 times 10^(-6)(0.34)=9.18 times 10^(-7)$ and dominant CC3 path is $2.7 times 10^(-6)(0.33)=8.91 times 10^(-7)$. Adding the corresponding core-defect path gives $9.1834 times 10^(-7)$ for CC2 and $8.9133 times 10^(-7)$ for CC3. Thus “highest non-performance” needs a definition: toe-unravelling, contamination, and material damage are different endpoints.


=== 12. New Orleans levee workshop

The workshop describes 560 one-kilometre reaches and a nominal 100-year return period. A return period supplies an annual hazard-exceedance probability; it does not by itself give structural failure probability for each reach. The calculations below are illustrative assumptions, not a measured levee-system failure probability.

Under the simplified assumptions that annual exceedances are independent and stationary:

$ p_("annual")=frac(1, 100)=0.01 $

If every reach independently had that annual failure probability, the probability of at least one reach failing in a year would be:

$ P_("system")=1-(1-0.01)^(560)approx 0.9964 $

This extreme result exposes why the independence assumption is unrealistic: reaches share the same storm loading and may have correlated construction, ground and maintenance conditions.

For one location exposed over 50 years, the probability of at least one 100-year event is:

$ P=1-(1-0.01)^(50)approx 0.395 $

A 100-year return period does *not* mean the event happens exactly once every 100 years or that a person is safe for the next 99 years.


=== 13. Exam-ready takeaways

- Societal risk concerns groups; individual risk concerns one person's annual probability.
- F-N curves show cumulative frequency of $N$ or more fatalities.
- PLL is $sum f_i N_i$, but it does not preserve the shape of societal risk.
- FAR uses $10^8$ exposed work-hours; fatality rate needs a stated population denominator.
- Event trees move forward from an initiator; fault trees work backward from a top event.
- Multiply event-tree path probabilities only when conditional structure is correct.
- Check dependence and common-cause failure before multiplying component probabilities.
- QRA supports decisions but remains conditional on models, data and assumptions.
- Communicate uncertainty bands, sensitivity and limitations, not only a point estimate.
- Return period is an average rate concept, not a schedule.


== Week 4 - Reliability in Design


=== 1. Reliability definition

Reliability is the probability or ability of an item to perform its required function, under stated conditions, for a specified time interval.

An *item* may be a component, subsystem or system and may include hardware and software.

Every reliability claim therefore needs four elements:

+ the item/system boundary;
+ the required function and performance criterion;
+ the operating and environmental conditions; and
+ the time or usage interval.

Without these, a statement such as “99% reliable” is incomplete.


=== 2. Reliability in design

When developing an asset, ask:

- What function must it provide?
- What reliability is required?
- Who benefits and who is involved across the lifecycle?
- What risks are involved?
- What is the lifecycle cost?
- Who pays for acquisition, failure and support?

Reliability engineering priorities are to:

+ prevent failures or reduce their likelihood/frequency;
+ identify and correct causes of failures that occur;
+ cope with failures whose causes have not been removed; and
+ estimate new-design reliability and analyse reliability data.


==== Quality versus reliability

- *Quality* is conformity to specification at a point in time, such as factory acceptance.
- *Reliability* is continued conformity to the required function over time in the actual application.

A product can pass initial quality inspection and still have poor reliability.


=== 3. Systems, functions and performance standards

A structural view describes physical components and subsystems. A functional view describes what the system must do and how functions are fulfilled.

Operation and reliability analysis often need the functional view; manufacturing and maintenance may place more emphasis on structure. Both are necessary.


==== Function

A function is what the owner or user wants the asset or system to do. Functions include:

- primary output; and
- secondary requirements such as protection, control, containment, comfort, appearance, energy efficiency, structural integrity and regulatory compliance.

Each function needs a measurable performance standard. Failure can then be defined as loss of ability to perform as required.


=== 4. Failure terminology

- *Failure:* the event in which an item loses the ability to perform as required.
- *Fault:* the internal state in which the item is unable to perform as required. Failure is an event; fault is a state.
- *Failure mode:* the manner in which failure occurs.
- *Failure cause:* the circumstances leading to failure.
- *Failure effect:* the consequence of the failure mode for operation, function or item status.
- *Failure mechanism:* the physical or other process leading to failure.
- *Common-mode failure:* different items fail in the same manner.
- *Error:* a discrepancy between a computed, observed or measured state and the correct or specified state; it can arise from hardware, software or human action.

Failure criteria should be unambiguous and linked to a measurable parameter or clear indication.

Failure modes include failure to start, spurious stop, output outside limits, leakage, abnormal indication, loss of redundancy, vibration, overheating, blockage and failure to stop on demand.


=== 5. Why items fail

An item may fail because:

- its design is inherently incapable;
- applied stress exceeds capability;
- variation is greater than allowed;
- it wears out or degrades over time;
- a sneak path or unforeseen interaction exists; or
- an error occurs in specification, design, code, assembly, maintenance or operation.


==== Mechanical mechanisms

- *Stress-induced:* local stress causes deformation, buckling, yielding, impact damage or fracture.
- *Strength-reducing:* wear, corrosion, cracking, creep, diffusion or embrittlement reduces resistance.
- *Stress-increasing:* fatigue, thermal shock, impact or other processes raise applied stress.


==== Electrical mechanisms

- electrical overstress or electrostatic discharge;
- intrinsic mechanisms such as gate-oxide breakdown or ionic contamination; and
- extrinsic packaging/interconnection problems such as corrosion or bond failure.

ISO 14224 categories in the slides also include leakage, vibration, misalignment, sticking, cavitation, erosion, overheating, control/signal failures, short/open circuit, power faults, blockage and contamination.


=== 6. Conceptual failure models

- *Stress-strength:* failure occurs when stress exceeds strength.
- *Damage-endurance:* irreversible damage accumulates until endurance is exceeded.
- *Challenge-response:* a latent bad state becomes visible only when the function is demanded.
- *Tolerance-requirement:* performance is satisfactory only while tolerance remains within the requirement.

These models help connect physical behaviour to inspection, testing, redundancy and maintenance decisions.


=== 7. Hardware, software and human domains


==== Hardware

Analyse component failure modes/mechanisms and failure probability, then system functions, success/failure logic, dependencies and common causes.


==== Software

Software does not wear out like hardware. Identical copies contain the same defect, although environment and machine state can make behaviour appear different. Reliability work focuses on latent defects, operational profiles, interfaces and recovery.


==== Human factors

The slides use skill-, rule- and knowledge-based behaviour:

- skill-based errors include inattention or over-attention;
- rule-based errors include applying a good rule in the wrong context or using a bad rule; and
- knowledge-based errors include confirmation bias, overconfidence and difficulty reasoning about complexity or causality.

Reliability is a property of the combined hardware-software-human system.


=== 8. Time to first failure

For a non-repairable item, study ends at first failure. Time to failure $T >= 0$ may be measured in hours, distance, cycles, operations or another usage measure.

With density $f(t)$ and cumulative distribution $F(t)$:

$ F(t)=P(T <= t),wide R(t)=P(T>t)=1-F(t) $

and

$ R(t)=integral_t^infinity f(x)thin "dx" $

The mean time to failure is:

$ op("MTTF")=E[T]=integral_0^infinity R(t)thin "dt" $

Common life distributions include exponential, Weibull, normal, log-normal and gamma. Distribution choice must reflect failure behaviour and data.


=== 9. Hazard rate and failure behaviour

The hazard rate is the instantaneous conditional failure rate given survival to time $t$:

$ h(t)=frac(f(t), R(t))=frac(f(t), 1-F(t)) $


==== Conceptual bathtub curve

- *Infant mortality:* decreasing hazard due to early material, manufacturing, installation or start-up defects.
- *Useful life:* approximately constant hazard, commonly associated with random stresses/events.
- *Wear-out:* increasing hazard as degradation accumulates.

The bathtub curve is conceptual, not universal. The Nowlan and Heap patterns shown in the material demonstrate that many populations do not follow simple age-related wear-out. Maintenance tactics must be based on observed/credible failure behaviour, consequences and economics.


=== 10. Exponential distribution

For a constant hazard rate $lambda$:

$ f(t)=lambda e^(-lambda t) $

$ R(t)=e^(-lambda t) $

$ F(t)=1-e^(-lambda t) $

and

$ op("MTTF")=frac(1, lambda) $

At $t=op("MTTF")$:

$ R(t)=e^(-1)approx 0.367 $

so about 63.2% of the population has failed.


==== Memoryless property

For exponential lifetimes:

$ P(T>s+t ∣ T>s)=P(T>t) $

Age does not change the conditional probability of surviving the next interval. Among continuous lifetime distributions, this is the memoryless property of the exponential model. The discrete geometric model is also memoryless.


==== Important limitation

The inverse $op("MTTF")=1/lambda$ is valid for a constant-hazard exponential model. It must not be applied automatically to other distributions. The Week 4 treatment also concerns time to first failure/non-repairable items.


=== 11. Reliability block diagrams

RBDs model which combinations of item success allow the system function to succeed. They are functional success models, not necessarily physical wiring diagrams.


==== Series system

Every item must work. For statistically independent items:

$ R_("series")(t)=product_(i=1)^(n)R_i(t) $

For independent exponential items:

$ R_("series")(t)=e^(-t sum_i lambda_i) $

so

$ lambda_("system")=sum_i lambda_i,
wide
op("MTTF")_("system")=frac(1, sum_i lambda_i) $

Example: items with MTTFs of 200 h and 100 h have rates 0.005/h and 0.010/h. In series:

$ lambda_("system")=0.015/"h",wide
op("MTTF")_("system")=66.7" h" $


==== Parallel system

At least one item must work. For statistically independent items:

$ R_("parallel")(t)=1-product_(i=1)^(n)[ 1-R_i(t)] $

For independent exponential items:

$ R_("parallel")(t)=1-product_(i=1)^(n)( 1-e^(-lambda_"it")) $

Two items each with reliability 0.9 give:

$ R_("parallel")=1-(0.1)(0.1)=0.99 $

Parallel improvement depends on independence, successful switching/demand and genuine functional redundancy. Shared power, environment, software or maintenance can create common-cause failure and invalidate the simple formula.


=== 12. Telemetry-system case study

The proposed remote meteorology system must scan instruments once per minute and transmit data to a terminal station. Five weather inputs are major. Loss or gross inaccuracy of any major input, or failure of the processing, communications or power elements, causes system failure.


==== Instrument-module field data

There were 150 instrument modules observed for five years. Of 15 returns, three were grossly mistreated and excluded; 12 valid failures accumulated 324 months. The remaining 135 valid modules survived 60 months.

Total time on test:

$ T=324+135(60)=8424" module-months" $

Using 12 months/year and 8760 hours/year:

$ T=702" module-years"=6","149","520" h" $

Under a constant-rate model:

$ hat(lambda)=frac(12, 6","149","520)
=1.95 times 10^(-6)/"h" $

That is 1.95 failures per million hours.

Treating the module-derived rate as a single sensor rate, as explicitly requested in the Week 4 quiz, the ten-year reliability of one sensor is:

$ R(10" y")=e^(-(1.95 times 10^{-6})(87","600))approx 0.843 $


==== Proposed system failure rate

Using five major sensors and the supplied component rates, with independent constant-hazard failures and any single failure causing system loss:

$ lambda_("system")
=5(1.95)+2.0+2.4+0.79+0.50
=15.44" failures per million hours" $

Therefore:

$ op("MTTF")_("system")
=frac(10^6, 15.44)
approx 64","767" h"
approx 7.39" years" $

This is below the ten-year requirement. The corresponding ten-year survival probability under the same assumptions is approximately:

$ e^(-(15.44 times 10^{-6})(87","600))approx 0.259 $


==== Design implications

Potential responses include improving component reliability, adding appropriately independent redundancy, changing the architecture so one failure does not lose a major parameter, adding diagnostics, and clarifying whether repair/restoration changes the reliability measure.


=== 13. Contract risks and clarification

The draft requires “ten years MTBF” for loss of any major parameter and proof by reliability prediction, but it needs clarification on:

- whether the requirement is MTBF, MTTF, mission reliability or availability;
- the system boundary and whether each parameter or the whole station must meet it;
- operating profile, duty cycle and environmental exposure;
- what numerical tolerance makes a measurement “incorrect”;
- whether common-cause, handling and external damage count;
- acceptable evidence, confidence level and prediction method;
- repair times, preventive-maintenance assumptions and exclusions;
- warranty trigger, replacement scope and remote travel costs;
- component obsolescence, shelf life and spares quantities; and
- acceptance testing and responsibility for sensor calibration.

The temperature/humidity limits also need clear test conditions, duration and combined-environment interpretation.


=== 14. Exam-ready takeaways

- Reliability always needs function, conditions and time.
- Define measurable performance before defining failure.
- Failure is an event; fault is a state; mode, cause, effect and mechanism are different concepts.
- $R(t)=1-F(t)$ and $h(t)=f(t)/R(t)$.
- Constant hazard implies an exponential lifetime and $op("MTTF")=1/lambda$.
- Do not use $1/lambda$ for a non-exponential model without justification.
- Series reliability multiplies successes; parallel reliability is one minus the product of failures.
- Simple RBD formulas require independence and the stated functional logic.
- Include survivor exposure time when estimating a failure rate.
- Translate contract language into an explicit, testable reliability requirement before accepting it.


== Week 5 - Maintenance Strategy


=== 1. What maintenance means

Maintenance is the combination of technical, administrative and managerial actions used throughout an item's life to:

- retain it in a state where it can perform its required function; or
- restore it to that state after performance has been lost.

The focus is therefore *preserving required function*, not simply keeping equipment running or performing maintenance for its own sake. An asset can be in functional failure while still operating if it is no longer meeting its required output, quality, safety or service standard.


==== Maintenance objectives

Maintenance objectives normally fall into four classes:

+ *Safety:* prevent or control harm to people.
+ *Technical:* preserve required asset performance and reliability.
+ *Legal:* comply with legislation, regulations and mandatory standards.
+ *Financial:* manage lifecycle cost, downtime and business loss.

These objectives can compete. A low-cost tactic is not acceptable if it leaves an intolerable safety or environmental risk.


=== 2. Maintenance management system

A maintenance management system should:

+ identify objectives and priorities;
+ develop a strategy describing how objectives will be met, by whom and by when;
+ execute the strategy; and
+ control, measure and improve performance.


==== CMMS

A *computerised maintenance management system (CMMS)* is the information system used to organise and retain maintenance data, such as:

- the asset register and equipment hierarchy;
- work requests and work orders;
- planned-maintenance schedules;
- failure, inspection and repair history;
- labour and maintenance costs; and
- spare-parts and inventory records.

A CMMS supports maintenance decisions only when its asset structure and recorded data are sufficiently complete and accurate. Poor CMMS data can stall RCM and PMO analysis or lead analysts to select inappropriate tactics.


==== Work-management cycle

The maintenance work-management process links the organisation's mission and objectives to system performance:

+ identify work;
+ prioritise it;
+ plan and design the job;
+ schedule the work;
+ execute it;
+ collect inspection, measurement and work data;
+ analyse performance; and
+ feed results back into priorities and future work.

Good asset data is essential. Problems in the asset register or computerised maintenance management system (CMMS) can stop otherwise sound analyses from producing useful maintenance plans.


=== 3. Maintainability and availability


==== Mean time to repair

*Mean time to repair (MTTR)* is one measure of maintainability. It may be estimated using:

- a point estimate;
- algebraic calculations; or
- a fitted probability distribution.

Repair-time data are often log-normally distributed, meaning that the logarithm of repair time is approximately normally distributed.


==== Availability

Availability is the probability that an asset is functioning and ready for use when required. A point estimate is:

$ A = frac("uptime", "uptime"+"downtime") $

For a repairable asset under the usual steady-state assumptions:

$ A = frac("MTBF", "MTBF"+"MTTR") $

Here MTBF denotes mean operating time between failures, excluding repair downtime; for this simple intrinsic-availability model, MTTR accounts for restoration downtime. Broader availability measures may also include waiting, logistics and planned maintenance.

where:

- $A$ = availability;
- MTBF = mean operating time between failures; and
- MTTR = mean time to repair.

Availability depends on both *reliability* (how often failure occurs) and *maintainability* (how quickly service can be restored). Improving either MTBF or MTTR can improve availability.


=== 4. Maintenance strategy hierarchy

The strategy options in the slides can be organised as follows:

- *Design-out:* change the asset or its context so that the failure mode is removed or its consequence is controlled.
- *Preventive maintenance:* act before functional failure.
  - age/use-based maintenance;
    - routine service;
    - scheduled overhaul; and
    - scheduled replacement, either component or block replacement.
  - predictive maintenance;
    - condition monitoring; and
    - inspection.
  - opportunistic maintenance when a suitable access or shutdown opportunity arises.
- *Corrective maintenance (run to failure):* allow failure, then restore or replace the item.

The appropriate tactic depends on the *specific failure mode*, its behaviour, its consequences and the cost and feasibility of intervention. One asset can require different tactics for different failure modes.


=== 5. Reliability-centred maintenance (RCM)

*Reliability-centred maintenance (RCM)* is a structured method for selecting maintenance tactics. Its primary objective is to preserve asset function.

RCM is the *whole decision-making process*, not merely the decision-tree diagram. The complete sequence is:

$ "functions and standards"
-> "functional failures"
-> "failure modes and effects"
-> "consequences"
-> "task selection" $

The RCM II decision tree is used only after functions, failures, modes, effects and consequences have been defined. Its role is to test which proactive task is technically feasible and worth doing, and then determine whether failure finding, no scheduled maintenance or redesign is required.

RCM grew from evidence that people tend to overestimate age-related failure. The studies shown in the lecture found several failure patterns and indicated that a large proportion of failures are not simple wear-out failures. Consequently, scheduled overhaul or replacement is not automatically useful merely because an item is old.

Other ways organisations select tactics include:

- original equipment manufacturer (OEM) recommendations;
- copying the preventive-maintenance program from similar equipment;
- preventive-maintenance optimisation (PMO), also called reverse RCM; and
- experience or judgement.

These sources can inform a decision, but they do not remove the need to check the actual operating context and consequences.


==== Aims of tactic development

A maintenance program may aim to:

- detect and correct an incipient failure before functional failure or major damage;
- reduce the probability of failure;
- reveal hidden failures that have already occurred; and
- improve the cost-effectiveness of maintenance.


==== The seven RCM questions

RCM asks:

+ What functions and performance standards are required in the current operating context?
+ In what ways can the asset fail to fulfil those functions?
+ What failure modes cause each functional failure?
+ What effects occur when each failure mode happens?
+ Why does each failure matter - what are its consequences?
+ What can be done to predict or prevent the failure?
+ What should be done if no suitable proactive task can be found?

Questions 1-5 are closely related to functional and failure modes and effects analysis (FMEA). Questions 6-7 apply RCM task-selection logic.


=== 6. RCM consequence classification

The first decision is how a failure mode matters.


==== Hidden consequences

A failure is *hidden* when the loss of function does not become evident to the operating crew under normal circumstances. Protective devices and standby equipment often have hidden failures: the failure may only become apparent when another failure creates a demand.


==== Safety consequences

A failure has a safety consequence if it could kill or injure someone.


==== Environmental consequences

A failure has an environmental consequence if it could breach a known environmental standard or regulation.


==== Operational consequences

A failure has an operational consequence if it directly and adversely affects output, product quality, customer service or operating cost beyond the direct repair cost.


==== Non-operational consequences

A failure is non-operational when its material consequence is mainly the direct cost of repair and it does not fall into the categories above.

The classification matters because the standard for an acceptable tactic is consequence-dependent. A task that is merely economical may be adequate for a low-consequence failure but insufficient for a safety-critical failure.


=== 7. RCM II task-selection logic

For each consequence branch, test proactive tasks in this order:

+ *Scheduled on-condition task:* Can a developing failure be detected in time, and is doing so technically feasible and worth doing?
+ *Scheduled restoration task:* Can scheduled restoration reduce the failure rate, and is it technically feasible and worth doing?
+ *Scheduled replacement task:* Can scheduled replacement reduce the failure rate, and is it technically feasible and worth doing?

The final action depends on the consequence category:

- *Hidden failure:* consider a scheduled failure-finding task. If no task works and a multiple failure could affect safety or the environment, redesign is compulsory. Otherwise, no scheduled maintenance may be acceptable and redesign may be desirable.
- *Safety or environmental failure:* consider a technically feasible combination of tasks. If adequate risk control cannot be achieved, redesign is compulsory.
- *Operational failure:* no scheduled maintenance may be selected when no proactive task is worthwhile; redesign may be desirable.
- *Non-operational failure:* no scheduled maintenance may be selected when proactive work is not worthwhile; redesign may be desirable.

*Important:* “No scheduled maintenance” is a reasoned outcome, not evidence that the analysis failed. Many failure modes do not have a technically feasible or cost-effective preventive task.


=== 8. When each tactic is appropriate


==== Fixed-interval tasks

A fixed-interval task is suitable when:

- conditional probability of failure rises rapidly after a reasonably identifiable age;
- most items survive to that age; and
- the age can be estimated with useful confidence.

This logic fits a genuine wear-out pattern. It is weak for random failures because age does not provide a useful trigger.


==== Run to failure

Run to failure is applicable only when the failure mode has no safety or environmental consequence and it is cheaper in the long run to allow failure than to prevent it.

This still requires a planned corrective response, appropriate spares/resources and an understanding of downtime consequences.


==== Failure finding

Failure-finding tasks apply to hidden failures when:

- the device can be tested without destroying it;
- most or all of the device or system can be tested; and
- testing does not significantly increase the risk of causing the multiple failure being guarded against.


==== Condition monitoring

A condition-monitoring task is suitable when:

- a clearly defined *potential failure* condition exists;
- the *P-F interval* can be estimated; and
- inspection can be frequent enough to leave time for effective action before functional failure.

The P-F interval is the time between detecting a potential failure ($P$) and the point of functional failure ($F$). Task frequency must be selected from the P-F interval, not from convenience alone.


==== Redesign

Redesign is broader than an engineering modification. It can include:

- training;
- processes or systems;
- operating and maintenance procedures or practices;
- procurement and spare-parts decisions; and
- physical engineering changes.

For safety and environmental consequences, redesign becomes compulsory when maintenance tasks cannot adequately manage the risk.


=== 9. Pump example: operating context changes the tactic

The slides compare the same bearing-seizure failure mode in three contexts.


==== Standalone pump

If the only pump seizes, water delivery stops and downtime results. The failure is evident and has an operational consequence. The proposed task is monthly monitoring of bearing vibration and temperature.


==== Duty pump with automatic standby

If the duty pump seizes but a standby pump automatically starts and a low-level alarm is generated, the system may continue its required function. For the duty pump's bearing failure, the analysis proposes no scheduled maintenance.


==== Standby pump

Failure of the standby pump may remain hidden while the duty pump operates. The proposed failure-finding task is to switch to the standby pump monthly, confirm it can fulfil the function, and then return the system to normal.

*Lesson:* equipment identity alone does not determine maintenance. Function, redundancy, detectability and consequences in the actual operating context determine the tactic.


=== 10. RCM compared with PMO


==== RCM

RCM develops failure modes by systematically considering:

+ functions;
+ functional failures; and
+ failure modes associated with each functional failure.

Strength: rigorous, function-centred analysis that can identify failures not yet experienced.\
Limitations: time- and resource-intensive, difficult to value, vulnerable to loss of management support, and capable of distracting analysts from redesign while they focus on preventive tasks.


==== Preventive-maintenance optimisation (PMO/reverse RCM)

PMO develops failure modes from:

- the current maintenance program;
- known failures; and
- technical documentation.

Strength: begins with existing work and can be more practical for reviewing a mature program.\
Limitations: may miss failures that have not occurred, hidden failures and protective-device needs; may assume the existing program is complete; and may focus on workload reduction rather than plant performance.


==== Shared limitations

- Neither approach necessarily protects adequately against simultaneous failures.
- FMEA/RCM records are often not kept live as new failures and knowledge emerge.
- Poor asset registers and CMMS data can stall the process.
- Analysts may propose condition monitoring without proving that a detectable warning exists or that the P-F interval allows action.
- Predicted failure modes may not match field experience.
- Templates may be misleading because primary and standby items have different functions and consequences.


=== 11. Adopting and adapting existing tactics

Copying a tactic from similar or even identical equipment is risky unless the following match:

- operating context;
- failure causes and behaviour;
- consequences;
- duty and redundancy arrangements; and
- P-F intervals.

OEM recommendations should also be adapted to the real operating context. A recommendation is evidence to consider, not an automatic answer.


=== 12. Statistical information needed for maintenance decisions

Weibull shape describes the hazard trend: $beta<1$ decreases, $beta=1$ is constant, and $beta>1$ increases. Increasing hazard can support age-based replacement, but the decision also depends on consequences, cost, survival to the chosen age and restoration effectiveness. Characteristic life is not automatically mean life. In the shifted model, 63.2% have failed at $t=gamma+eta$, not at $eta$ alone.

A censored item contains useful survival information. A right-censored/suspended item survived to its last observation; an interval-censored failure occurred between two known times; a left-censored lifetime is known only to be below an upper bound. An unknown start time is a separate observation problem and is not by itself a definition of left censoring. Include exposure from surviving items when estimating reliability. The additional Week 5 slides illustrate how failure-only analysis can change an estimate from 13 replacements/\$65,000 to 25 replacements/\$125,000 over five years.

Use #link("cheatsheet.md")[the statistics cheat sheet] for full Weibull formulas and estimation, #link("questions.md")[questions] for calculations, and #link("R.md")[the R guide] for fitted models and censored-data examples. For repair times, a lognormal model is often plausible; for condition monitoring, the key statistical task is detecting meaningful degradation early enough to act.


=== 13. Exam-ready decision rules

- Start with the *required function and performance standard*, not the equipment name.
- Define the *functional failure*, then the particular *failure mode* and its effects.
- Classify consequences before choosing a task: hidden, safety, environmental, operational or non-operational.
- Use age-based work only where failure probability genuinely increases with age.
- Use condition monitoring only when a detectable potential failure and actionable P-F interval exist.
- Use failure finding for hidden failures, especially protective or standby functions.
- Run to failure cannot be justified for a safety or environmental consequence merely because repair is cheap.
- Redesign is compulsory when safety/environmental risk cannot be adequately controlled by feasible maintenance tasks.
- Include suspended items in reliability analysis; they contain survival information.
- Review the program as operating experience changes. RCM or PMO is not a one-off document to place on a shelf.


== Course-specific details and worked engineering questions


=== A. Piper Alpha: worked classification of initiation and escalation

The workshop asks for management-system, design, cultural and immediate-event factors before the first explosion, followed by factors that worsened the event. The following is a *supplementary interpretation* based on #link("../notes/piper-alpha.md")[the existing Piper Alpha case note], which includes its external validation sources. The supplied workshop itself has blank answer tables.

#table(
  columns: 4,
  align: (auto, auto, auto, auto,),
  table.header(
    [*Category*],
    [*Initiation example*],
    [*Escalation example*],
    [*Engineering lesson*],
  ),
  [Immediate events],
  [Duty pump B tripped; pump A was returned towards service while a pressure safety valve was absent; condensate most likely leaked at its temporary blind flange and ignited.],
  [Fire damaged equipment and heated gas risers; ruptures released large inventories.],
  [Separate the initiating event from the subsequent accident sequence.],
  [Design],
  [Inadequate positive isolation and verification of the temporary opening; gas-processing modifications introduced explosion exposure.],
  [Firewalls did not withstand blast; control/communication equipment and evacuation routes were vulnerable.],
  [Design for credible accident loads, isolation, common causes and survivable emergency functions.],
  [Management systems],
  [Related permits and maintenance status were not effectively linked or handed over.],
  [Weak emergency coordination and impairment control; delayed isolation of connected production.],
  [Verify actual permit use, handover, management of change, emergency drills and inter-facility shutdown responsibilities.],
  [Culture],
  [Informal communication and departures from procedures became normal.],
  [Familiar routine risks received more attention than catastrophic process hazards; warning signs did not produce enough organisational learning.],
  [Build reporting, questioning, learning and leadership that support safe operational decisions.],
)
The disaster killed 167 people, as stated in the workshop. Its teaching relevance is the move towards demonstrating understanding and control of major hazards through safety management and safety cases. Do not reduce this case to “operator error”: the operator's available information, physical safeguards and organisational context matter.


=== B. Exact course risk matrix

Source: #link("../content/02-risk-management/PW02%20-%20Risk%20Management.pdf#page=32")[Week 2 pre-work, slide 32]. Use this course matrix when a question names the handbook; do not substitute the different illustrative matrix from slide 30.

#table(
  columns: 6,
  align: (auto, auto, auto, auto, auto, auto,),
  table.header(
    [*Consequence*],
    [*A*],
    [*B*],
    [*C*],
    [*D*],
    [*E*],
  ),
  [1],
  [L],
  [L],
  [L],
  [M],
  [M],
  [2],
  [L],
  [L],
  [L],
  [M],
  [M],
  [3],
  [L],
  [L],
  [M],
  [M],
  [H],
  [4],
  [M],
  [M],
  [M],
  [H],
  [H],
  [5],
  [M],
  [M],
  [H],
  [H],
  [H],
)
#table(
  columns: 2,
  align: (auto, auto,),
  table.header(
    [*Likelihood*],
    [*Course descriptor, condensed*],
  ),
  [A],
  [Never heard of in industry; highly unlikely, possible in exceptional circumstances.],
  [B],
  [Heard of in industry; unlikely but possible during the lifecycle phase.],
  [C],
  [Happened several times in industry or happened in the company; could occur at the location.],
  [D],
  [Happened several times per year in industry, several times in the company, or at least once at the location; probably occurs in most circumstances.],
  [E],
  [Occurred several times at the location; expected in most circumstances.],
)
Health/safety consequences progress from *1: first aid/minor reversible effects*, *2: medical treatment/reversible effects of concern*, *3: lost-time injury/severe reversible effects*, *4: one fatality/permanent disability/irreversible effects*, to *5: multiple fatalities/multiple disabling illnesses leading to early mortality*. Environment, assets/business disruption and reputation are alternative consequence dimensions. Keep the scenario and relevant consequence dimension explicit.

*Past-paper Q9:* the given port-explosion history establishes “heard of in industry” and multiple fatalities: *B5*, option E. Its matrix colour is *M* in this supplied matrix. Do not change the label to H simply because the consequences sound severe; equally, the M label does not remove the need to evaluate controls and major-accident consequences.


=== C. Driverless-car trial: risk-management application and FMEA

The proposed UWA trial runs for 12 months, with selected staff/students driving on and off campus. A defensible plan establishes routes, operating conditions, trial boundaries, performance objectives, pedestrian exposure, responsibilities and acceptance criteria; consults users, pedestrians, university operations and other affected parties; identifies scenarios; analyses controls and uncertainty; evaluates against criteria; implements and verifies treatments; and monitors incidents and changes.

Source: #link("../content/02-risk-management/W02%20-%20Risk%20Management%20and%20Driverless%20Cars.pdf#page=5")[driverless-car workshop, slides 5–7].

#table(
  columns: 7,
  align: (auto, auto, right, right, right, right, auto,),
  table.header(
    [*Component / failure mode*],
    [*Effect*],
    [*S*],
    [*O*],
    [*D*],
    [*RPN*],
    [*Proposed slide mitigation*],
  ),
  [LiDAR obscured by mud/snow],
  [Reduced perception, sudden stop],
  [8],
  [3],
  [2],
  [48],
  [Radar/camera redundancy; self-cleaning wipers],
  [AI mistakes pedestrian for stationary object],
  [Collision/injury],
  [10],
  [2],
  [4],
  [80],
  [Multi-modal data fusion; improved behaviour prediction],
  [Compute-node shutdown],
  [Loss of control; emergency stop needed],
  [9],
  [1],
  [2],
  [18],
  [Redundant computing],
  [Steering actuator does not respond],
  [Cannot turn; possible veering],
  [10],
  [1],
  [3],
  [30],
  [Dual actuators; minimal-risk manoeuvre],
  [Stale map of construction zone],
  [Incorrect navigation],
  [6],
  [4],
  [3],
  [72],
  [Real-time map updates and sensor confirmation],
)
*Which mode is of most concern?* By the given RPN, AI perception ranks first (80), then mapping (72). *What is concerning about compute node and actuator?* Their effects have severity 9 and 10 despite low RPNs. The occurrence/detection scores and independence of redundancy need scrutiny. Safety-significant low-frequency modes must remain visible.


=== D. Failure descriptions, mechanisms and function breakdown

A good function statement includes a verb, object and performance standard: *deliver at least 300 L/min from Tank A to Tank B*. “Pump” is an item; “fails to start” is a mode; “inadequate lubrication” is a cause; “wear/seizure” describes the process/manner; “tank runs dry and production stops” is an effect. A running pump delivering 250 L/min has functionally failed against this requirement.

The lecture extinguisher example decomposes the system into containment, control/operation, extinguishing agent and information/safety functions. Components include body (contain suppressant), cartridge (contain/provide pressure), tube/hose/nozzle (deliver/direct suppressant), handle (safe holding), lever/rod/valves/spring (operate and seal), gauge (indicate pressure), and safety pin (prevent unintended activation). This demonstrates how secondary protection and information functions belong in an FMEA too. Source: #link("../content/02-risk-management/PW02%20-%20Risk%20Management.pdf#page=67")[Week 2 pre-work, slides 67–78].

#table(
  columns: 3,
  align: (auto, auto, auto,),
  table.header(
    [*Mechanism*],
    [*Typical cause/challenge in Week 4 slides*],
    [*Effect*],
  ),
  [Buckling],
  [Compressive loading or changed geometry],
  [Deflection; lost load-carrying ability],
  [Fatigue],
  [Fluctuating/cyclic force],
  [Cracking, deformation or fracture],
  [Corrosion],
  [Chemical action, dissimilar metals, poor welding, environment],
  [Reduced strength, cracks, fracture or geometry change],
  [Gate-oxide breakdown],
  [Electrical overstress/electrostatic discharge],
  [Degraded current–voltage characteristics],
  [Bonding failure],
  [Poor bond control],
  [Open circuit],
)
The ISO 14224 tables additionally group mechanical, material, instrument, electrical and external mechanisms. Instrument examples include no/false signal, calibration drift, control failure and software error. Electrical examples include short circuit, open circuit, absent/faulty voltage and insulation/earth faults. External examples include blockage, contamination, foreign objects and neighbouring-system/environmental effects. Model choices may combine physics of failure with data-driven prediction; neither physical insight nor a fitted distribution alone describes every interaction. Source: #link("../content/04-reliability-in-design/PW04%20-%20Reliability.pdf#page=24")[Week 4 pre-work, slides 24–44].


=== E. Telemetry exercise: numerical and contractual interpretation

The workshop's field data give 150 original modules, 3 excluded for gross mistreatment, 12 valid failures totalling 324 months and 135 valid survivors at 60 months. Excluded observations are not silently counted as survivors; exclusion must have an agreed, defensible basis. Total time is 8,424 module-months and, using 8,760 h/year, the rate is about *1.95 failures per million hours*.

*Important source inconsistency:* #link("../questions/week4-quiz.md")[the Week 4 quiz] says 1.91 failures per million hours, but its keyed reliability 0.426 and system rate 15.44 match the workshop's rounded *1.95* rate. With five independent critical sensors and the stipulated transfer of the module rate to each sensor:

$ R_("five sensors")(10" y")=e^(-5(1.95 times 10^{-6})(87600))approx 0.426. $

The *0.843* result is for *one sensor* under that convention. Literal use of 1.91 gives approximately 0.433 for five sensors; the difference is a source mismatch, not a different parallel/series rule. In practice a module-level rate cannot automatically be assigned to every sensor without disaggregating field data; this is a stated exercise assumption.

The system rate includes five critical sensors plus processing, communication, power supply and battery: *15.44 failures per million hours*, MTTF about *7.39 years*. It *does not meet* the stated 10-year mean-time requirement. Even a mean of 10 years would give only 36.8% ten-year survival for a constant-hazard model; a mean-time requirement is not a guarantee of ten years without failure.

The draft contract requests ten systems and includes 0–50°C/80% maximum relative humidity operation, loss or incorrect reading as failure, two years of replacement-cost refunds, labour/travel for unscheduled corrective visits (estimated \$2,000/visit), long-term component availability/spares information and comprehensive maintenance instructions. Clarify:

+ Mean time between failures versus first-failure mean, system boundary, mission duration and repair assumptions.
+ Sensor accuracy tolerance, calibration and what counts as “incorrect”; environmental test profile and combined humidity/temperature exposure.
+ Prediction method, confidence/evidence required, field-data exclusions and common-cause assumptions.
+ Warranty scope, visit triggers, travel/access costs, replacement responsibilities and scheduled-maintenance interactions.
+ Obsolescence, shelf life, spares quantities and documentation/acceptance criteria.

Solar charging and seven-day battery endurance are described in the case, but the numerical exercise expressly simplifies the included components and assumes any single failure loses a major parameter. A realistic design analysis must assess duty, backup duration and restoration rather than uncritically carry over that simplified series model. Sources: #link("../content/04-reliability-in-design/W04%20-%20Negotiating%20a%20Telemetry%20Contract%20-%20Part%201.pdf")[telemetry Part 1], #link("../content/04-reliability-in-design/W04%20-%20Negotiating%20a%20Telemetry%20Contract%20-%20Part%202.pdf")[Part 2], #link("../content/04-reliability-in-design/W04%20-%20Reliability%20Workshop%20-%20Student%20Version.pdf")[workshop].


=== F. Maintenance-selection questions and worked decisions

#table(
  columns: 2,
  align: (auto, auto,),
  table.header(
    [*Prompt from Week 5 or 2025 paper*],
    [*Answer and reason*],
  ),
  [Predictive maintenance can optimise maintenance effort.],
  [*True* when evidence of condition provides useful warning and action is feasible. It is not automatically suitable for every mode.],
  [Which bathtub phase represents random failures?],
  [Middle/useful-life phase with approximately constant hazard. The early phase decreases; wear-out increases.],
  [What is the RCM consequence order?],
  [First ask whether failure is evident. Hidden failures enter the hidden branch; evident failures are screened for safety, environmental, operational and then non-operational consequences. Quiz shorthand: *hidden → safety/environmental → operational → non-operational*.],
  [Compressor vibration-monitoring data support which tactic?],
  [*Condition-based maintenance*: evidence of degradation informs the action.],
  [Infrared thermography of switchgear supports which tactic?],
  [*Condition-based maintenance*, 2025 Q7 option B.],
  [Standby pump has no indication of failure while the duty pump operates.],
  [Hidden failure; periodically prove it can deliver its required function. The slide proposes a monthly operating test.],
  [No feasible maintenance task can adequately control a safety/environmental consequence.],
  [Redesign is compulsory under the supplied RCM II decision logic.],
  [Scheduled restoration is feasible, but cost exceeds the avoided repair/production loss for a non-safety mode.],
  [It may not be worth doing; consider other feasible tactics or no scheduled maintenance, with the appropriate consequence review.],
)
*P–F example (illustrative):* a vibration threshold detects deterioration at P, and functional failure F is credibly at least four weeks later. An inspection every six weeks cannot assure detection in time. Even inspection every two weeks needs enough remaining time for diagnosis, parts, access and repair. The inspection interval follows the actionable P–F interval, not simply component mean life.

*Replacement-cost problem (Week 5 Q5):* for Weibull cable life with shape 1.8, scale 500 h and location 50 h, corrective cost \$6,000, scheduled cost \$600 and 5,000 operating hours/year, compare ages 50, 75, …, 300 h using an age-replacement policy. A cycle ends at failure or the scheduled age, whichever occurs first:

$ C_(upright("annual"))(m)=5000frac(6000F(m)+600R(m), integral_0^m R(t)thin "dt"). $

The minimum among the offered ages is *175 h*, approximately *\$29,971/year*. Dividing by $m$ treats every cycle as reaching its scheduled age and misses early corrective renewals. This result assumes replacement restores the cable as new and ignores downtime unless included in costs. See #link("../questions/week5-quiz.md")[Week 5 checked solutions] for the full comparison and code.

*Weibull-plot question (Week 5 Q6):* the plotted early-life slope is 1.5278 and later-life slope is 1.3554, so *the early-life shape parameter is higher*, option A. Both are above one; “earlier life” in a mixture is not the same as decreasing infant-mortality hazard. A slope change can indicate different populations or mechanisms; engineering investigation is needed.


=== G. Other engineering questions from the 2025 paper

These are condensed prompts and explained answers. Full wording and supplied figures are in #link("../questions/midsem/Mid-Sem-2025-Sem-1-questions-and-answers.md")[the transcribed paper].

#table(
  columns: 3,
  align: (auto, auto, auto,),
  table.header(
    [*Question*],
    [*Answer*],
    [*Reason*],
  ),
  [Q1: sealing nitrocellulose packaging retains its damping agent; what control type?],
  [*B — engineering control*],
  [Physical containment modifies the hazard pathway; it is not a procedure or PPE.],
  [Q2: which box represents uncertainty in both consequence and frequency?],
  [*C*],
  [It spans both axes of the supplied diagram. Horizontal-only spread concerns consequence; vertical-only spread concerns frequency.],
  [Q5: failure to start an engine is what?],
  [*D — failure mode*],
  [It describes how the required function is lost.],
  [Q6: most concerning turbine-installation FMEA mode by given RPN?],
  [*A — failure in cables/infrastructure connections*],
  [$6 times 7 times 4=168$, versus next-highest leakage/overload $7 times 6 times 3=126$.],
  [Q7: thermography used in maintenance?],
  [*B — condition-based*],
  [Condition evidence supports maintenance decisions.],
  [Q9: port-explosion scenario's matrix rating?],
  [*E — B5*],
  [Heard of in industry; multiple fatalities.],
  [Q11: which listed term is not a lifecycle-costing value measure?],
  [*D — internal rate of deduction*],
  [This is the intended invalid term. Discount rate is an input to valuation; NPV, IRR and equivalent annual cost are distinct concepts.],
  [Q12: \$150,000 annual maintenance for four years at 8% real discount rate?],
  [*B — \$496,819*],
  [End-of-year payments are discounted as shown below.],
)
Q11–12 extend beyond the supplied Week 1–5 engineering slide set; they are retained because they appear in the provided past paper. No complete lifecycle-costing lecture set was present to imply broader assessed coverage.

$ op("NPC")=sum_(t=1)^(4)frac(150000, (1.08)^t)=496819.03 approx 496819. $

Use time zero for initial capital and years 1–4 for these annual costs. Real costs require the stated real discount rate. Net present cost sums discounted costs; NPV nets benefits and costs; IRR is a rate that makes NPV zero; equivalent annual cost converts present cost into a comparable annual amount. These definitions explain the paper's vocabulary, rather than adding an unsupplied lecture topic.

The numerical reliability questions Q3, Q4, Q8 and Q10 are also in #link("questions.md")[questions]. Their engineering lessons are survivor exposure, functional series/parallel logic, age-dependent failure, and defensible data exclusion.


=== H. Where statistics connects to each engineering topic

#table(
  columns: 3,
  align: (auto, auto, auto,),
  table.header(
    [*Engineering task*],
    [*Relevant statistics*],
    [*What the result contributes*],
  ),
  [Risk matrices and QRA],
  [Conditional probability, event unions/intersections, distributions, expectation],
  [Scenario likelihood and expected consequences, with uncertainty],
  [Event trees],
  [Multiplication of conditional branches; total probability],
  [Complete path probabilities and aggregated outcomes],
  [Fault trees and RBDs],
  [AND/OR logic, independence, dependence],
  [Probability of a top failure or system success],
  [Comparing population risks],
  [Rates, exposure denominators, cumulative frequency],
  [PLL, FAR, individual averages and F–N curves],
  [Reliability prediction],
  [Lifetime CDF/reliability/hazard, exponential and Weibull],
  [Mission survival, mean life and age dependence],
  [Field-data analysis],
  [Parameter estimation and censoring],
  [Rates and lifetime estimates that include survivor information],
  [Repair planning and availability],
  [Repair-time distributions, means, lognormal tails],
  [Downtime expectations and chance of meeting a repair window],
  [Maintenance selection],
  [Hazard trends, replacement-cycle expectation, cost comparison],
  [Whether age-based, condition-based or corrective work makes sense],
  [Condition-monitoring decisions],
  [Variability and measurement uncertainty],
  [Distinguish degradation from noise while preserving action time],
  [Week 1 safe systems],
  [No formal statistical topic specified],
  [Human, organisational and social factors determine how controls actually work],
)

=== I. HMAS Westralia: maintenance changes can introduce failure

The supplied #link("../questions/probability-questions/lecture/Lecture0.pdf")[Lecture 0 teaching case, pp. 1–3] describes the 5 May 1998 fire and four deaths. Newly installed flexible fuel hoses replaced rigid pipes; a burst hose sprayed diesel onto a hot engine component and the fuel ignited. The case states that the hoses were unsuitable for their intended service and that configuration-change and classification approval processes were bypassed. Fire also damaged electrical/communication systems, while some CO₂ bottles did not discharge remotely.

*Engineering interpretation:* distinguish the hose's burst/leakage mode from design suitability and procurement/change-control causes, and from fire and smoke consequences. A replacement part must be qualified for its actual pressure, temperature, vibration and installation context; supplier involvement does not remove engineering assurance responsibility. Review changes through configuration management, competence, approval, inspection and commissioning processes. Protective systems need proof of function, and emergency equipment must remain usable during the initiating event.

The source explicitly says its hose testing/repair dataset was fabricated for teaching. Those numbers support the statistics exercises; they are not historical failure observations from the accident.


== Source map and coverage

Page references below use PDF pages (the visible slide number normally matches). Image-only workshop diagrams were inspected directly for the Rosia event tree and levee prompt. Course slides are the primary source; weekly notes provided an initial synthesis, with ambiguities/corrections recorded above.

#table(
  columns: 2,
  align: (auto, auto,),
  table.header(
    [*Material*],
    [*Main coverage in this document*],
  ),
  [#link("../content/01-factors-affecting-safety-risk-reliability/W01%20-%20Engineering%20a%20Safer%20World.pdf")[W01 Engineering a Safer World] pp. 2–9],
  [Three capitals; Piper Alpha workshop prompts; initiation/escalation],
  [#link("../content/02-risk-management/PW02%20-%20Risk%20Management.pdf")[PW02 Risk Management] pp. 5–26, 29–35, 39–61, 63–79],
  [Terminology; principles/framework/process; matrices/ALARP; methods; barriers; FMEA],
  [#link("../content/02-risk-management/W02%20-%20Risk%20Management%20and%20Driverless%20Cars.pdf")[W02 Driverless Cars] pp. 2–7],
  [Trial scope, applying ISO 31000, scored FMEA and discussion],
  [#link("../content/03-uncertainty-and-qra/PW03%20-%20Uncertainty%20and%20QRA.pdf")[PW03 Uncertainty and QRA] pp. 4–14, 16–27, 29–35],
  [Societal/individual risk; PLL/FAR; QRA; uncertainty; safety cases; tunnel logic models],
  [#link("../content/03-uncertainty-and-qra/W03%20-%20Uncertainty%20and%20QRA%20Workshop%20-%20Student%20Version.pdf")[W03 Workshop] pp. 3–10],
  [Rosia and New Orleans applications],
  [#link("../content/03-uncertainty-and-qra/W03%20-%20Rosia%20Montana%20Case%20Study.pdf")[W03 Rosia case] pp. 1–3],
  [Failure screening, ANCOLD chart and internal-erosion event tree],
  [#link("../content/04-reliability-in-design/PW04%20-%20Reliability.pdf")[PW04 Reliability] pp. 4–44, 46–52],
  [Function/quality/reliability; failures/mechanisms/models; domains; series/parallel systems],
  [#link("../content/04-reliability-in-design/PW04%20-%20Additional%20Statistics%20Slides.pdf")[PW04 Additional Statistics]],
  [Lifetime, hazard and exponential links; full formulas delegated to statistics notes],
  [#link("../content/04-reliability-in-design/W04%20-%20Reliability%20Workshop%20-%20Student%20Version.pdf")[W04 Workshop] and #link("../content/04-reliability-in-design/W04%20-%20Negotiating%20a%20Telemetry%20Contract%20-%20Part%201.pdf")[telemetry Part 1], #link("../content/04-reliability-in-design/W04%20-%20Negotiating%20a%20Telemetry%20Contract%20-%20Part%202.pdf")[Part 2]],
  [Field-data exercise, architecture, contract assumptions and design response],
  [#link("../content/05-maintenance-strategy/PW05%20-%20Maintenance%20Strategy.pdf")[PW05 Maintenance Strategy] pp. 4–11, 13–27, 29–36],
  [Management, metrics, tactics, RCM/PMO, context, P–F and selection],
  [#link("../content/05-maintenance-strategy/PW05x%20-%20RCM%20II%20Maintenance%20Strategy%20Decision%20Tree.pdf")[RCM II decision tree]],
  [Consequence branches, task feasibility/value and default decisions],
  [#link("../content/05-maintenance-strategy/PW05%20-%20Additional%20Statistics%20Slides.pdf")[PW05 Additional Statistics]],
  [Weibull/censoring implications for maintenance; statistics details in companion notes],
  [#link("../questions/week4-quiz.md")[Week 4 quiz], #link("../questions/week5-quiz.md")[Week 5 quiz], #link("../questions/midsem/Mid%20Sem%202025%20Sem-1.pdf")[2025 paper]],
  [Existing engineering prompts, explained answers and source inconsistencies],
)
