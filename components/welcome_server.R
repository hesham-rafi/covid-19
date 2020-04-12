####---- Open Global Tab ----####
observeEvent(input$cmd_global, {
  
  hideTab(inputId = "tags", target = tabWelcome)
  showTab(inputId = "tags", target = tab01)
  showTab(inputId = "tags", target = tab02)
  
  updateTabsetPanel(session, "tags", selected = tab01)
})


####---- Open Singapore Tab ----####
observeEvent(input$cmd_sing, {
  
  hideTab(inputId = "tags", target = tabWelcome)
  showTab(inputId = "tags", target = tab01)
  showTab(inputId = "tags", target = tab02)
  
  updateTabsetPanel(session, "tags", selected = tab02)
})