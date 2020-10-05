library(shiny)

function(input, output, session) {
 #scatter plot 
  output$scatter_plot <- renderPlot({
    ggplot(data = data, aes_string(x="index", y=input$qcmetric, color = annotation))+
    labs(color = annotation)+
    geom_point()+
    geom_point(data=data[data[[primaryID]] %in% input$outliers_mul,],color='black', size=3)
  })
  
  #violin plot
  output$violin_plot <- renderPlot({
    ggplot(data = data, aes_string(x=annotation, y=input$qcmetric,color =annotation))+
      geom_violin()+
      geom_jitter(height = 0, width = 0.3, alpha = 0.3)+
      theme(axis.text.x = element_blank(),legend.position = "none")+
      geom_point(data=data[data[[primaryID]] %in% input$outliers_mul,],color='black', size=3)
  })
  
  #outliers values
  output$outliers_val<-renderText({
    Zscores<-data[data[[primaryID]] %in% input$outliers_mul,paste(input$qcmetric,"Zscore",sep="")]
    print(paste("Sample:",input$outliers_mul,"  ,",input$qcmetric," Zscore=",Zscores,";",sep=""))
    })

  #PC plot
  output$PC_plot <- renderPlot({
    ggplot(data = data, aes_string(x=input$PC_1, y=input$PC_2, color = "inferred_ancestry"))+
      labs(color = "inferred_ancestry")+
      geom_point()+
      geom_point(data=data[data[[primaryID]] %in% input$outliers_mul1,],color='black', size=3)
  })
  
  #qcmetric scatter plot
  output$qcmetric_plot <- renderPlot({
    data.sort <- data[order(data[input$colorby]),] 
    data.sort$x=1:nrow(data.sort)
    ggplot(data = data.sort, aes_string(x="x", y=input$qcmetric, color = input$colorby))+
      labs(color = input$colorby)+
      geom_point(aes(text=sample_id))
  })
  
  output$hover_info <- renderPrint({
    cat("input$plot_hover:\n")
    str(input$plot_hover)
  })
  
  #violin plot with outlier 
  output$violin_plot_outlier <- renderPlotly({
    stratifyby=as.vector(input$stratby)
    strat=paste(stratifyby, collapse = '.')
    data[strat]<-apply(data[stratifyby], 1, paste, collapse='')
    text=data$sample_id
    outliers=data$sample_id[abs(data[paste(input$qcmetric1,"Zscore",sep="")])>input$qcmetric_z]
    
      ggplot(data = data, aes_string(x=strat, y=input$qcmetric1,color =strat))+
        geom_violin()+
       theme(axis.text.x=element_blank())+
       geom_point(data=data[data[[primaryID]] %in% outliers,],aes(text=sample_id),color='black', size=3)
      ggplotly(tooltip = "text")
  })
  
  #violin plot with outlier 2
  output$violin_plot_outlier2 <- renderPlotly({
    stratifyby=as.vector(input$stratby)
    strat=paste(stratifyby, collapse = '.')
    data[strat]<-apply(data[stratifyby], 1, paste, collapse='')
    text=data$sample_id
    outliers=data$sample_id[abs(data[paste(input$qcmetric1,"Zscore",sep="")])>input$qcmetric_z]
    
    ggplot(data = data, aes_string(x=strat, y=input$qcmetric2,color =strat))+
      geom_violin()+
      theme(axis.text.x=element_blank())+
      geom_point(data=data[data[[primaryID]] %in% outliers,],aes(text=sample_id),color='black', size=3)
    ggplotly(tooltip = "text")
  })
  
  #network
  output$network_plot <- renderPlot({
    t <- which(ibd[,"ibd.PI_HAT"] >= input$PIHAT)
    ibd_outlier <- ibd[t,]
    g<-graph_from_data_frame(ibd_outlier,directed = F)
    plot(g)
  })
  
  #pihat outlier
  output$pihat_outlier<-renderTable({
    t <- which(ibd[,"ibd.PI_HAT"] >= input$PIHAT)
    ibd_outlier<-ibd[t,c(1,2,6)]
    names(ibd_outlier)<-c("sample_i","sample_j","PIHAT")
    ibd_outlier
  })
}

        