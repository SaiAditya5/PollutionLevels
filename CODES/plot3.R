# 1. Create a data directory
if(!base::file.exists("data")) {
    base::dir.create("data")
}

########################### 2. Downloading data ################################

# 2. Download files and store it in data directory.
if(!base::file.exists("./data/FNEI_data.zip")){
    utils::download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                         destfile = "./data/FNEI_data.zip")
}

# 2.1. Unzipping the FNEI_data.zip file.
if(!base::file.exists("./data/unzipped/Source_Classification_Code.rds") | !base::file.exists("./data/unzipped/summarySCC_PM25.rds")){
    utils::unzip(zipfile = "./data/FNEI_data.zip",
                 exdir = "./data/unzipped/",
                 list = FALSE,
                 overwrite = TRUE)
}

########################### 3. Loading RDS files ###############################

# 3. Loading the RDS files.
NEI <- base::readRDS("./data/unzipped/summarySCC_PM25.rds")
SCC <- base::readRDS("./data/unzipped/Source_Classification_Code.rds")

########################### 4. Dataset Manipulation ############################

# 4.1. Creating a subsetting for Baltimore City.
NEI_q3 <- base::subset(x = NEI, NEI$fips == "24510")

# 4.2. Summarizing the data set to calculate the total summation by year and type.
plot_3_data <- NEI_q3 %>%
    dplyr::group_by(type, year) %>%
    dplyr::summarise(Total = base::sum(Emissions))

#################################### 5. Plot 3  #######################################
# 5.1. Creating a PNG file.
grDevices::png(filename = "plot3.png", height = 480, width = 800)  

    # Plotting a GGPLOT2 graphic.
    ggplot2::ggplot(data = plot_3_data,
                    ggplot2::aes(x = year,
                                 y = Total,
                                 label = base::format(x = Total,
                                                      nsmall = 1,
                                                      digits = 1))) + 
        
    # Defining a line graphic.
    ggplot2::geom_line(ggplot2::aes(color = type), lwd = 1) + 
        
    # Adding labels to each point.
    ggplot2::geom_text(hjust = 0.5, vjust = 0.5) + 
        
    # Setting the years.
    ggplot2::scale_x_discrete(limits = c(1999, 2002, 2005, 2008)) +
        
    # Editing the Graphic Tile.
    ggplot2::labs(title = base::expression('Emissions of PM'[2.5] ~ ' in Baltimore')) +
        
    # Adding x-axis label.
    ggplot2::xlab("Year") + 
        
    # Adding y-axis label.
    ggplot2::ylab(base::expression("Total PM"[2.5] ~ "emission (tons)")) +
        
    # Editing the legend position and tile position.
    ggplot2::theme(legend.position = "right",
                   legend.title.align = 0.5,
                   plot.title = ggplot2::element_text(hjust = 0.5))

# Closing the device.
grDevices::dev.off()
