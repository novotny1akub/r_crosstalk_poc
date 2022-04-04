if(rstudioapi::isAvailable()){
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

cars_shared <- crosstalk::SharedData$new(mtcars)

css <- list(
  htmltools::htmlDependency(
    name = "font-awesome"
    ,version = "4.3.0"
    ,src = c(href="http://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css")
    ,stylesheet = "font-awesome.min.css"
  )
)

# filters
f <- list(
  crosstalk::filter_checkbox("cyl", "Cylinders", cars_shared, ~cyl, inline = TRUE),
  crosstalk::filter_slider("hp", "Horsepower", cars_shared, ~hp, width = "100%"),
  crosstalk::filter_select("auto", "Automatic", cars_shared, ~ifelse(am == 0, "Yes", "No"))
)

# plot
p <- d3scatter::d3scatter(cars_shared, ~mpg, ~disp, ~am)

# table
dt <- DT::datatable(
  cars_shared, extensions = "Scroller", style = "bootstrap", class = "compact", width = "100%",
  options = list(deferRender = T, scrollY = 300, scroller = T)
)

# putting together the widget
widget <- shiny::tagList(
  css,
  shiny::tags$h1("This is a title"),
  crosstalk::bscols(widths = c(2, 8), f, p),
  shiny::tags$div("This is a random html text."),
  crosstalk::bscols(dt)
)
# htmltools::browsable(widget)


themed_widget <- bslib::page(widget, theme = bslib::bs_theme(primary = "red", secondary = "darkred"))

# exporting
htmltools::save_html(widget, file = "regular_widget.html")
browseURL(
  file.path(getwd(), "regular_widget.html")
)

# exporting
htmltools::save_html(themed_widget, file = "themed_widget.html")
browseURL(
  file.path(getwd(), "themed_widget.html")
)


