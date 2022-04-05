# 

if(rstudioapi::isAvailable()){
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

cars_shared <- crosstalk::SharedData$new(mtcars)

# filters
f <- list(
  crosstalk::filter_checkbox("cyl", "Cylinders", cars_shared, ~cyl, inline = TRUE),
  crosstalk::filter_slider("hp", "Horsepower", cars_shared, ~hp, width = "100%"),
  crosstalk::filter_select("auto", "Automatic", cars_shared, ~ifelse(am == 0, "Yes", "No"))
)

# plot
p <- d3scatter::d3scatter(cars_shared, ~mpg, ~disp, ~am, color = ~gear)

# table
dt <- DT::datatable(
  cars_shared, extensions = "Scroller", style = "bootstrap", class = "compact", width = "100%",
  options = list(deferRender = T, scrollY = 300, scroller = T)
)

# putting together the widget
widget <- shiny::tagList(
  shiny::tags$h1("This is a title"),
  crosstalk::bscols(widths = c(2, 8), f, p),
  shiny::tags$div("This is a random html text."),
  crosstalk::bscols(dt)
)
# htmltools::browsable(widget)

# bslib::bs_theme_preview(bslib::bs_theme(primary = "darkred"), with_themer = FALSE)
bslib::bs_global_theme(primary = "darkred")
theme <- bslib::bs_add_rules(
  bslib::bs_global_theme(primary = "darkred"),
  sass::as_sass(" table.dataTable tbody tr.active td { background: darkred !important; }")
)

bs_widget <- bslib::page_fixed(
  widget,
  theme = theme
)


# exporting
readr::write_lines(repr::repr_html(bs_widget), "bs_widget.html")
browseURL(
  file.path(getwd(), "bs_widget.html")
)


