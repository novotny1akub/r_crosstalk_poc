library(crosstalk)
library(plotly)
library(dplyr)

shared_data <- highlight_key(txhousing %>% mutate(select_all_helper = T))

widgets <- bscols(
  widths = c(12, 12, 12, 12),
  filter_select("city", "Cities", shared_data, ~city, allLevels = T),
  filter_slider("sales", "Sales", shared_data, ~sales),
  filter_slider("year", "Years", shared_data, ~year, step = 1, ticks = F),
  filter_checkbox("select_all_helper", "Return selected and then deselected", shared_data, ~ifelse(select_all_helper == T, "Yes", "No"))
)

p <- plot_ly(shared_data, x = ~date, y = ~median, showlegend = FALSE) %>% 
  add_lines(color = ~city, colors = "black") %>%
  highlight(on = "plotly_select", off = "plotly_doubleclick")

dt <- DT::datatable(
  shared_data, 
  extensions = 'Buttons', options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
  )
)

widget <- bscols(
  widths = c(4, 8, 12),
  widgets, p # , dt
)

# theming
bslib::bs_global_theme(primary = "darkred")
theme <- bslib::bs_add_rules(
  bslib::bs_global_theme(primary = "darkred"),
  sass::as_sass(" table.dataTable tbody tr.active td { background: darkred !important; }")
)

bs_widget <- bslib::page_fixed(
  widget,
  theme = theme
)
# htmltools::browsable(bs_widget)

# exporting
readr::write_lines(repr::repr_html(bs_widget), "crosstalk_plotly_widget.html")
browseURL(
  file.path(getwd(), "crosstalk_plotly_widget.html")
)
