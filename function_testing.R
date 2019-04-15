# Testing function structure for dose calculation
# -----------------------------------------------------------------------------
# Calculating dose using AUC and CL
# Requires knowledge of patients:
# - creatinine clearance (age, weight, serum creatinine)
# - platelet-lymphocyte ratio (platelets, lymphocytes)
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Testing the equations
# Remove all objects from workspace
	rm(list=ls(all=TRUE))
	graphics.off()
	
# Target AUC is 6 mg/mL.min
  auc <- 6

# Define population values and covariate effects
  pop_cl <- 8.78  # clearance (L/h)
  cov_crcl <- 0.676  # effect of creatinine clearance on clearance
  cov_plr <- -0.155  # effect of platelet-lymphocyte ratio on clearance

# Define covariate values
  crcl <- 90  # creatinine clearance (mL/min)
  plr <- 160  # platelet-lymphocyte ratio

# Calculate individual clearance (L/h)
  cl_lh <- pop_cl*(crcl/90)^cov_crcl*(plr/160)^cov_plr

# Calculate dose using clearance in mL/min
  cl_mlmin <- cl_lh*1000/60
  dose <- auc*cl_mlmin
  
# As compared to the Calvert equation
  dose_cal <- auc*(crcl+25)
  
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Defining the dosing function
# Remove all objects from workspace
	rm(list=ls(all=TRUE))
	graphics.off()
	
# Inputs for function are those that are likely to change
# These inputs are creatinine clearance and platelet-lymphocyte ratio
  dose_fn <- function(crcl, plr) {
  # Define fixed values for function use
    auc <- 6
    pop_cl <- 8.78  # clearance (L/h)
    cov_crcl <- 0.676  # effect of creatinine clearance on clearance
    cov_plr <- -0.155  # effect of platelet-lymphocyte ratio on clearance
  # Calculate individual clearance (L/h)
    cl_lh <- pop_cl*(crcl/90)^cov_crcl*(plr/160)^cov_plr
  # Calculate dose using clearance in mL/min  
    cl_mlmin <- cl_lh*1000/60
    return(auc*cl_mlmin)
  }
  
# Calculate dose
  dose_fn(90, 160)
  
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Defining creatinine clearance and plr functions
# Remove all objects from workspace
	rm(list=ls(all=TRUE))
	graphics.off()
	
# Inputs for creatinine clearance are age, weight and serum creatinine
# Average values from the model dataset
	# age <- 61
	# wt <- 70
	# secr <- 71.5
	
# Also need sex
	# sex <- 1  # categorical
	
# Define function
	crcl_fn <- function(age, wt, secr, sex) {
	  return((140 - age)*wt*0.85^(1-sex)/(0.815*secr))
	}
  
# Test function
  crcl_fn(61, 70, 71.5, 1)
  
# Inputs for platelet-lymphocyte ratio are platelet and lymphocyte count
# No average value available for model dataset, but general values are
  # platelets <- 300000
  # lymphocytes <- 3000
  
# Define function
  plr_fn <- function(platelets, lymphocytes) {
    return(platelets/lymphocytes)
  }
  
# Test function
  plr_fn(3E5, 3E3)
  