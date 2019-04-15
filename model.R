# Carboplatin Population Pharmacokinetic Model
# ------------------------------------------------------------------------------
# Model code written for mrgsolve for manuscript:

#   BDW Harris, V Phan, V Perera, A Szyc, P Galettis, P Beale, SA Pearson, 
#   JH Martin, E Walpole, AJ McLachlan, SJ Clarke, SE Reuter, KA Charles. An 
#   improved carboplatin dosing formula incorporating systemic inflammation and 
#   renal function in people with advanced lung cancer.

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Load libraries
  # library(dplyr)
  # library(mrgsolve)

# Define model code

  code <- '
$INIT  // Initial Conditions for Compartments
  CENT = 0,  // Central Compartment
  PERI = 0,  // Peripheral Compartment
  AUC = 0,  // AUC Collection Compartment

$SET  // Set Differential Equation Solver Options			
  atol = 1e-8, rtol = 1e-8
  maxsteps = 100000

$PARAM  // Population parameters
  POPCL = 8.78,  // clearance (L/H)
  POPV1 = 29.2,  // central volume (L)
  POPV2 = 64.5,  // peripheral volume (L)
  POPQ1 = 11.2,  // distributional clearance (L/h)

  // Covariate effects
  CL_CRCL = 0.676,  // effect of creatinine clearance on clearance
  CL_PLR = -0.155,  // effect of platelet-lymphocyte ratio on clearance
  V1_WT = 0.628,  // effect of weight on central volume
  V1_ALB = -1.3,  // effect of albumin on central volume
  V1_NLR = -0.22,  // effect of neutrophil-lymphocyte ratio on central volume

  // Average covariate values
  CRCL = 90,  // creatinine clearance (mL/min)
  PLR = 160,  // platelet-lymphocyte ratio
  WT = 70,  // weight (kg)
  ALB = 40,  // albumin
  NLR = 2.5,  // neutrophil-lymphocyte ratio

$OMEGA  // Population parameter Variability
  name = "omega1"
  block = FALSE
  0.0615  // PPVCL
  0.1332  // PPVQ1

$SIGMA  // Residual Unexplained Variability	
  block = FALSE
  0.0445  // ERRPROP

$MAIN  // Define population parameter variability
  double PPVCL = ETA(1);
  double PPVQ1 = ETA(2);

  // Individual Parameter Values
  double CL = POPCL*pow(CRCL/90, CL_CRCL)*pow(PLR/160, CL_PLR)*exp(PPVCL); 
  double V1 = POPV1*pow(WT/70, V1_WT)*pow(ALB/40, V1_ALB)*pow(NLR/2.5, V1_NLR);
  double V2 = POPV2;
  double Q1 = POPQ1*exp(PPVQ1);

$ODE  // Differential Equations
  double C1 = CENT/V1;
  double C2 = PERI/V2;

  dxdt_CENT = -C1*Q1 + C2*Q1 - C1*CL ;
  dxdt_PERI =  C1*Q1 - C2*Q1;
  dxdt_AUC = C1;

$TABLE  // Determines Values and Includes in Output	
  double IPRED = C1;               // real concentration
  double DV = IPRED*(1 + ERR(1));  // observed concentration

$CAPTURE 
  ALB CRCL WT PLR NLR IPRED DV AUC  // Patient Covariates and outputs
  CL V1 V2 Q1 PPVCL PPVQ1  // Individual Parameters and Variability
  // CENT PERI  // debug
'

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Compile the model code
  mod <- mrgsolve::mcode("CarboPK", code)