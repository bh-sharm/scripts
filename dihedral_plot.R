library(ggplot2)
library(reshape2)
library(gridExtra)
library(ggExtra)

#dists <- c("0.2", "0.4", "0.6", "0.8", "1.0", "1.2", "1.4", "1.6", "1.8", "2.0", "2.2", "2.4", "2.6", "2.8", "3.0")
#dists <- c("0.2", "0.4", "0.6", "0.8")
#dists <- c("1.0", "1.2", "1.4", "1.6")
#dists <- c("1.8", "2.0", "2.2", "2.4")
#dists <- c("2.6", "2.8", "3.0")
dists <- c("1.8", "1.9")

# for loop 
for (VALUE in dists) {

filename <- paste("dihedral_", VALUE,".dat", sep = "")
title <- paste("EigenThreshold_", VALUE, sep = "")

df <- read.table(filename, header = T)

df <- as.data.frame(melt(df, id.var = c('Frame'), variable.name = 'dihedral'))
# Frame dihedral value format 


# With Color
#p1 <- ggplot(df, aes(df$Frame, df$value, colour = df$dihedral)) + theme_classic()+
#  geom_point(aes(y=df$value))

# no color
p1 <- ggplot(df, aes(df$Frame, df$value)) + theme_classic()+
  geom_point(aes(y=df$value))

p2 <- p1 + geom_hline(yintercept = 0) +
  geom_hline(yintercept = 60) +
  geom_hline(yintercept = 120)+
  geom_hline(yintercept = 180)+
  geom_hline(yintercept = -60) +
  geom_hline(yintercept = -120)+
  geom_hline(yintercept = -180)

p3 <- p2 + scale_y_continuous(breaks = seq(-180,180,30)) +
  theme(panel.border = element_blank())+
  labs(x="Frames", y = "Dihedral") +
  ggtitle(title) +theme(plot.title=element_text(hjust=0.5))

p4 <- ggExtra::ggMarginal(p3, type = "histogram", binwidth = 5, margins = "y")

if(VALUE == dists[1]) {
first <- p4
} else if (VALUE == dists[2]) {
second <- p4
}
# else if (VALUE == dists[3]) {
#third <- p4
#} else if (VALUE == dists[4]) {
#forth <- p4
#}

# energy calculation starts
filename <- paste("energy_", VALUE,".dat", sep = "")
df <- read.table(filename, header = TRUE)
h <- 2.7
h1 <- "2.7 kcal/mol"

title <- paste("EigenThreshold_", VALUE, sep = "")

E1 <- ggplot(df, aes(df$Frame, df$Energy))+
  geom_point(aes(y=df$Energy))+
  geom_hline(yintercept = 2.7 )+
#  geom_hline(yintercept = 10)+
  scale_y_continuous(breaks = seq(0,10,1))+
  labs(x="Frames", y = "Energy (kcal/mol")+
  ggtitle(title) +theme(plot.title=element_text(hjust=0.5)) +
  geom_text(aes(4,h,label = h1, vjust = 1)) # 4 is position from left

E1 <- E1 + theme_bw()+ theme(panel.border = element_rect(colour = "black"))

if(VALUE == dists[1]) {
energy1 <- E1
} else if (VALUE == dists[2]) {
energy2 <- E1
}

# energy calculation ends

}

# To plot in grid format
#gridplot <- grid.arrange(p1, p2, p3, p4, ncol = 2, top = "Main title")

gridplot <- grid.arrange(first, energy1, second, energy2, ncol = 2, top = "Main title")
#gridplot <- grid.arrange(first, second, third, ncol = 2, top = "Main title")

#ggsave("plot111_2.jpg", plot = gridplot, dpi=300)
outputfile <- paste("plot_",dists[1],"_to_",dist[2],".jpg", sep= "")
#ggsave(paste("plot_",dists[1],"_to_",dists[4],".jpg" sep= ""), plot = gridplot, dpi=300)
ggsave(outputfile, plot = gridplot, dpi=300)
