div(
  wellPanel(
    plotOutput(outputId = "word_freq", height = "1200px"),
    h6("The wordcloud provides the most frequently used words in Twitter. Based on the words, the hot topic of that day can be inferred.", style="color: #BDCED6;")
  ),
  wellPanel(
    h6(strDisclaimer, style="color: #BDCED6;")
  )
)


