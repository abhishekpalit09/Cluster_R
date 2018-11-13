https://towardsdatascience.com/clustering-on-mixed-type-data-8bbd0a2569c3

https://stackoverflow.com/questions/47590287/compute-dissimilarity-matrix-for-large-data



setwd("C:/Users/palitabhishek/Documents/Analysis")

data<-read.csv("train.csv")

data$cat1<-as.factor(data$cat1)
data$cat2<-as.factor(data$cat2)
data$cat3<-as.factor(data$cat3)

data<-data[1:4]

require(plyr)
Mydata_grid <-  count(data[,-1])
Mydata_grid


require(vegan)
dist_grid <- vegdist(Mydata_grid, method="jaccard")
d_matrix <- as.matrix(dist_grid)
d_matrix

gower_dist <- daisy(Mydata_grid,
                    metric = "gower")

gower_mat <- as.matrix(gower_dist)

#' Print most similar clients
data[which(gower_mat == min(gower_mat[gower_mat != min(gower_mat)]), arr.ind = TRUE)[1, ], ]

#' Print most dissimilar clients
data[which(gower_mat == max(gower_mat[gower_mat != max(gower_mat)]), arr.ind = TRUE)[1, ], ]


sil_width <- c(NA)
for(i in 2:8){  
  pam_fit <- pam(gower_dist, diss = TRUE, k = i)  
  sil_width[i] <- pam_fit$silinfo$avg.width  
}
plot(1:8, sil_width,
     xlab = "Number of clusters",
     ylab = "Silhouette Width")
lines(1:8, sil_width)

k <- 5
pam_fit <- pam(gower_dist, diss = TRUE, k)
pam_results <- data %>%
  mutate(cluster = pam_fit$clustering) %>%
  group_by(cluster) %>%
  do(the_summary = summary(.))
pam_results$the_summary

tsne_obj <- Rtsne(gower_dist, is_distance = TRUE)
tsne_data <- tsne_obj$Y %>%
  data.frame() %>%
  setNames(c("X", "Y")) %>%
  mutate(cluster = factor(pam_fit$clustering))
ggplot(aes(x = X, y = Y), data = tsne_data) +
  geom_point(aes(color = cluster))



Mydata_cluster <- cbind(Mydata_grid, cluster, Mydata_grid$freq)

Mydata_cluster_full <- Mydata_cluster[rep(row.names(Mydata_cluster), Mydata_cluster$freq), 1:(dim(Mydata_cluster)[2]-1)]


##H2o installation

library(h2o)
memory.size()

h2o.init(nthreads = 16, min_mem_size = '10G')
h2o.df <- as.h2o(df)
h2o_kmeans <- h2o.kmeans(training_frame = h2o.df, x = vars, k = 5, estimate_k = FALSE, seed = 1234)
summary(h2o_kmeans)