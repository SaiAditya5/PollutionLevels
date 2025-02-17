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
# 4.1. Creating a subsetting to plot 1.
plot_1_data <- NEI %>%
     dplyr::group_by(year) %>%
     dplyr::summarise(total = base::sum(Emissions))

########################### 5. Plot 1 ##########################################

# 5.1. Defining the plot_1_data as data of the graph.
base::with(data = plot_1_data, {
    
    # 5.1.1. Creating a PNG file.
    grDevices::png(filename = "plot1.png", height = 480, width = 800)  
    
        # 5.1.1.1. Add a outer margin to the plot.
        par(oma = c(1,1,1,1))
        
        # 5.1.1.2. Creating the barchart plotting using base graphic system.
        p <- graphics::barplot(total/1000000, # Re-scaling to million.
                               name = year,
                                
                               # Adding title.
                               main = base::expression('Total PM'[2.5] ~ ' in the United States'),
                     
                               # Adding y-axis label.
                               ylab = base::expression('PM'[2.5] ~ 'Emissions (10' ^6 ~ 'tons)'),
                                 
                               # Adding x-axis label.
                               xlab = "Year")
        
        # 5.1.1.3. Adding text over the bars.
        graphics::text(x = p,
                       y = total/1000000 - 0.5,            # Re-scaling to million.
                       label = base::format(total/1000000, # Re-scaling to million.
                                            nsmall = 1,          # Rounding the number.
                                            digits = 1))
    
    # 5.1.2. Closing the device.
    grDevices::dev.off()      
})
