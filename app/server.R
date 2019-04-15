# server.R script for Carboplatin dosing prototype App
# -----------------------------------------------------------------------------
# Reactive objects (i.e., those dependent on widget input) are written here
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Server
  server <- function(input, output, session) {
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -     
  # Define reactive objects
  # Calculate serum creatinine
    crcl <- reactive({
    # Define inputs
      age <- input$age
      weight <- input$wt
      serum_creatinine <- input$secr
      sex <- as.numeric(input$sex)
    # Return output using creatinine clearance function
      return(crcl_fn(age, weight, serum_creatinine, sex))
    })  # reactive_crcl
    
  # Calculate platelet-lymphocyte ratio
    plr <- reactive({
    # Define inputs
      platelets <- input$pl
    # Return output using platelet-lymphocyte ratio function
      lymphocytes <- input$lym
      return(plr_fn(platelets, lymphocytes))
    })  # reactive_plr
    
  # Calculate individual clearance
    cli <- reactive({
    # Define inputs
      crcl <- crcl()
      plr <- plr()
    # Return output using individual clearance function
      return(cli_fn(crcl, plr))
    })  # reactive_cli
    
  # Calculate dose
    dose <- reactive({
    # Define inputs
      cl_lh <- cli()
    # Convert clearance to mL/min
      cl_mlmin <- 1000*cl_lh/60
    # Return output using rearranged auc equation
      return(auc*cl_mlmin)
    })  # reactive_dose
    
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -     
  # Define output for ui.R
    
    output$crcl <- renderText({
      crcl <- round(crcl())
      return(paste(crcl, "mL/min"))
    })
    
    output$plr <- renderText({
      plr <- round(plr())
      return(paste(plr))
    })
    
    output$cli <- renderText({
      cl <- round(cli(), 1)
      return(paste(cl, "L/hr"))
    })
    
    output$dose <- renderText({
      dose <- round(dose())
      return(paste(dose, "mg"))
    })
    
  }  # server