https://dabblingwithdata.wordpress.com/2016/10/10/clustering-categorical-data-with-r/
  
  
  install.packages("klaR")
library(klaR)
setwd("C:/Users/Adam/CatCluster/kmodes")
data.to.cluster <- read.csv('dataset.csveader = TRUE, sep = ',')
                            cluster.results <-kmodes(data.to.cluster[,2:5], 3, iter.max = 10, weighted = FALSE ) #don't use the record ID as a clustering variable!
                              
                              
                              install.packages("cba")
                            library(cba)
                            setwd("C:/Users/Adam/CatCluster/rock")
                            data.to.cluster <- read.csv('dataset.csveader = TRUE, sep = ',')
                                                        cluster.results <-rockCluster(as.matrix(data.to.cluster[,2:5]), 3 )
                                                        cluster.output <- cbind(data.to.cluster,cluster.results$cl)
                                                        write.csv(cluster.output, file = "Rock clusters.csv", row.names = TRUE)

