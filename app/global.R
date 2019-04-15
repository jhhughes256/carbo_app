# global.R script for Carboplatin dosing prototype App
# -----------------------------------------------------------------------------
# Objects that are not reactive are written here
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Load package libraries
  require(shinydashboard)

# Define target AUC
  auc <- 6

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Define functions
# Creatinine clearance (mL/min)
  crcl_fn <- function(age, wt, secr, sex) {
	  return((140 - age)*wt*0.85^(1-sex)/(0.815*secr))
  }
  
# Platelet-lymphocyte ratio
  plr_fn <- function(platelets, lymphocytes) {
    return(platelets/lymphocytes)
  }

# Clearance equation
  cli_fn <- function(crcl, plr) {
  # Define fixed values for function use
    auc <- 6
    pop_cl <- 8.78  # clearance (L/h)
    cov_crcl <- 0.676  # effect of creatinine clearance on clearance
    cov_plr <- -0.155  # effect of platelet-lymphocyte ratio on clearance
  # Calculate individual clearance (L/h)
    return(pop_cl*(crcl/90)^cov_crcl*(plr/160)^cov_plr)
  }