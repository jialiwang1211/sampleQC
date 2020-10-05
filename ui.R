library(shiny)

fluidPage(
  titlePanel("sampleQC"),
  tabsetPanel(
    tabPanel("Outlier plot",
             " ",
             sidebarPanel(selectizeInput("qcmetric","Select QC metric",
                                         choices = unique(sds$qcMetrics),
                                         multiple = FALSE),
               selectizeInput("outliers_mul","Select multiple outliers",
                                         choices = unique(outliers),
                                         multiple = TRUE)),
             mainPanel(textOutput("outliers_val"),
                       plotOutput("scatter_plot"),
                       plotOutput("violin_plot"))
    ),
    tabPanel("PC plot",
             " ",
             sidebarPanel(selectizeInput("PC_1","Select first PC",
                                         choices = unique(paste("PC",1:10,sep="")),
                                         multiple = FALSE),
                          selectizeInput("PC_2","Select second PC",
                                         choices = unique(paste("PC",1:10,sep="")),
                                         multiple = FALSE),
                          selectizeInput("outliers_mul1","Select multiple outliers",
                                         choices = unique(outliers),
                                         multiple = TRUE)),
             
             mainPanel(plotOutput("PC_plot"))
    ),
    tabPanel("QC metrics scatterplot",
             " ",
             sidebarPanel(selectizeInput("qcmetric","Select QC metric",
                                         choices = unique(sds$qcMetrics),
                                         multiple = FALSE),
                          selectizeInput("colorby","Color by",
                                         choices = unique(sds$annotations),
                                         multiple = FALSE)),
             mainPanel(plotOutput("qcmetric_plot",
                       hover = hoverOpts(
                         id = "plot_hover")),
                       verbatimTextOutput("hover_info"))
    ),
    tabPanel("violin plot with outlier",
             " ",
             sidebarPanel(
               selectizeInput("stratby","Stratify by",
                                         choices = c("Product","PCR","inferred_ancestry"),
                                         multiple =TRUE),
               selectizeInput("qcmetric1","Select QC metric1",
                                         choices = unique(sds$qcMetrics),
                                         multiple = FALSE),
                          sliderInput("qcmetric_z","Outliers: based on QC metric1 z score",
                                      min=0,max=10,value=5),
               selectizeInput("qcmetric2","Select QC metric2",
                              choices = unique(sds$qcMetrics),
                              multiple = FALSE)),
             mainPanel(plotlyOutput("violin_plot_outlier"),
                       plotlyOutput("violin_plot_outlier2"))
    ),
    
    
    tabPanel("network plot",
             " ",
             sidebarPanel(sliderInput("PIHAT","PIHAT",
                                      min=0.1,max=max(ibd['ibd.PI_HAT']),value=0.185,step=0.005)),
             mainPanel(plotOutput("network_plot"),
                       tableOutput("pihat_outlier"))
    )
    )
)

