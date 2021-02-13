#import parallel processing libraries
library(foreach)
library(doParallel)

#import source script that defines function
source('~/water-balance/R/get_snodas.R')

# define dates of interest - this can be used to compute percentiles by ingesting the 
# same julian day for each year and post processing the cell-wise snodas data
dates = seq.Date(as.Date('2004-01-01'),as.Date('2004-12-31'), by = 1)
domain = read_sf('/home/zhoylman/water-balance-data/domain/russian_river.geojson')
domain_name = 'russian_river'

#set up internal cluster
cl = makeCluster(6)
registerDoParallel(cl)

#run function in parallel
foreach(i = 1:length(dates), .packages = c('httr', 'dplyr', 'data.table',
                                           'tools', 'raster', 'sf', 'tidyverse') ) %dopar% {
  get_snodas(date = dates[i], domain = domain, domain_name = domain_name)
}
stopCluster(cl)
