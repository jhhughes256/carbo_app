# ui.R script for Carboplatin dosing prototype App
# -----------------------------------------------------------------------------
# The user-interface and widget input for the Shiny application is defined here
# Sends user-defined input to server.R, calls created output from server.R
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Header
  header <- dashboardHeader(
    title = "Carboplatin Dosing"
  )  # dashboardHeader
  
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Sidebar - disabled
  sidebar <- dashboardSidebar(disable = T)
  
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   
# Body
  body <- dashboardBody(
    fluidRow(
      box(title = "Patient Data Input", width = 8, status = "primary", 
        solidHeader = T, 
        withMathJax(),
        numericInput("age", "Age (years)",
          value = 61
        ),  # numericInput_age
        radioButtons("sex", "Sex",
          choices = list("Male" = 1, "Female" = 0), inline = TRUE
        ),  # radioButtons_sex
        numericInput("wt", "Weight (kg)",
          value = 70
        ),  # numericInput_wt
        numericInput("secr", "Serum Creatinine (umol/L)",
          value = 71
        ),
        numericInput("pl", HTML("Platelet Count (10<sup>5</sup> cells)"),
          value = 3
        ),  # numericInput_pl
        numericInput("lym", HTML("Lymphocyte Count (10<sup>3</sup> cells)"),
          value = 3
        )  # numericInput.lym
      ),  # box_patientDataInput
      column(width = 4,
        valueBox(width = 12,
          value = uiOutput("crcl"),
          subtitle = "Creatinine Clearance",
          color = "light-blue",
          icon = icon("prescription-bottle", lib = "font-awesome")
        ),  # valueBox_creatinineClearance
        valueBox(width = 12,
          value = uiOutput("plr"),
          subtitle = "Platelet-Lymphocyte Ratio",
          color = "light-blue",
          icon = icon("flask", lib = "font-awesome")
        ),  # valueBox_PlateletLymphocyteRatio
        valueBox(width = 12,
          value = uiOutput("cli"),
          subtitle = "Total Clearance",
          color = "purple",
          icon = icon("sign-out-alt", lib = "font-awesome")
        ),  # valueBox_totalClearance
        valueBox(width = 12,
          value = uiOutput("dose"),
          subtitle = "Dose",
          color = "fuchsia",
          icon = icon("prescription", lib = "font-awesome")
        )  # valueBox_dose
      ),  # column_output
      tags$style(HTML("
        .box.box-solid.box-primary>.box-header {
          color:#fff;
          background:#605ca8
        }
        .box.box-solid.box-primary{
          border-bottom-color:#605ca8;
          border-left-color:#605ca8;
          border-right-color:#605ca8;
          border-top-color:#605ca8;
        }
      "))  # tags$style_boxColour
    )  # fluidRow
  )  # dashboardBody
 
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   
# Page
  dashboardPage(header, sidebar, body, skin = "purple")