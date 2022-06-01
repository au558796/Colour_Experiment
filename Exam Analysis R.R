#___________SETTING UP___________
#working directory
setwd("C:/Users/Dana/Desktop/SEMESTER 1/COGNITION AND COMMUNICATION/Exam Paper/col_data")
#load libraries
library(dplyr)
library(tidyr)
library(lmerTest)
library(ggplot2)
library(outliers)
library(MASS)
library(pastecs)
#import data
col_exp_0<- read.csv("1_col_exp_0.csv", header = TRUE, stringsAsFactors = FALSE)
col_exp_1e<- read.csv("1_col_exp_1e.csv", header = TRUE, stringsAsFactors = FALSE)
col_exp_1d= read.csv("2_col_exp_1d.csv", header = TRUE, stringsAsFactors = FALSE)
col_exp_1c= read.csv("1_col_exp_1c.csv", header = TRUE, stringsAsFactors = FALSE)
col_exp_1b= read.csv("2_col_exp_1b.csv", header = TRUE, stringsAsFactors = FALSE)
col_exp_1a= read.csv("1_col_exp_1a.csv", header = TRUE, stringsAsFactors = FALSE)
col_exp_r= read.csv("2_col_exp_r.csv", header = TRUE, stringsAsFactors = FALSE)
col_exp_p= read.csv("2_col_exp_p.csv", header = TRUE, stringsAsFactors = FALSE)
col_exp_l= read.csv("2_col_exp_l.csv", header = TRUE, stringsAsFactors = FALSE)
col_exp_j= read.csv("2_col_exp_j.csv", header = TRUE, stringsAsFactors = FALSE)
col_exp_h= read.csv("2_col_exp_h.csv", header = TRUE, stringsAsFactors = FALSE)
col_exp_f= read.csv("2_col_exp_f.csv", header = TRUE, stringsAsFactors = FALSE)
col_exp_1= read.csv("1_col_exp_1.csv", header = TRUE, stringsAsFactors = FALSE)
col_exp_g= read.csv("1_col_exp_g.csv", header = TRUE, stringsAsFactors = FALSE)
col_exp_i= read.csv("1_col_exp_i.csv", header = TRUE, stringsAsFactors = FALSE)
col_exp_k= read.csv("1_col_exp_k.csv", header = TRUE, stringsAsFactors = FALSE)
col_exp_Q= read.csv("1_col_exp_Q.csv", header = TRUE, stringsAsFactors = FALSE)
col_exp_S= read.csv("1_col_exp_S.csv", header = TRUE, stringsAsFactors = FALSE)
col_exp_C= read.csv("2_col_exp_C.csv", header = TRUE, stringsAsFactors = FALSE)
col_exp_21= read.csv("1_col_exp_21.csv", header = TRUE, stringsAsFactors = FALSE)
col_exp_20= read.csv("1_col_exp_20.csv", header = TRUE, stringsAsFactors = FALSE)
#combine into one data frame
data=dplyr::bind_rows(col_exp_20,col_exp_21,col_exp_0,col_exp_1e,col_exp_1,col_exp_f,col_exp_h,col_exp_j,col_exp_l,col_exp_p,col_exp_r,col_exp_1a,col_exp_1b,col_exp_1d, col_exp_C,col_exp_S,col_exp_Q,col_exp_k,col_exp_i,col_exp_g,col_exp_1c)
#set as factors
data$phase = as.factor(data$phase)
#establish base for intercept
data$phase <- relevel(data$phase, ref="pre-training")
"-----------------------------------------------------------------------------------------"
length(rt_means$Gender[rt_means$Gender=="Female"])/4
length(rt_means$Gender[rt_means$Gender=="Male"])/4
length(rt_means$Gender[rt_means$Gender=="Other"])/4

#linear mixed effects model
data$rt = scale(data$rt, center = FALSE, round(digits = 2))


#______RT_______
modelRT1.1= glmer(rt ~ condition + phase + category + (1|ID), data, family = Gamma)
summary(modelRT1.1)
#null hypothesis model
modelRT1.2= lmer(rt ~ phase + (1|ID), data, REML = F)
summary(modelRT1.2)
#anova for p-value of rt
anova(modelRT1.1,modelRT1.2)

#_____ACCURACY______
#mixed effects model
modelAc1.1 = glmer(accuracy ~ condition + phase + category + (1|ID), data, family = binomial)
summary(modelAc1.1) 
#null hypothesis model
modelAc1.2 = glmer(accuracy ~ phase + (1|ID), data, family = binomial)
summary(modelAc1.2)
#anova for p value of Accuracy
anova(modelAc1.1,modelAc1.2)

by(data$ac, data$condition, stat.desc, basic = F,round (digits = 2))
?by

#_________averages__________
#summary rt
rtm = aggregate(data["rt"], by= list(phase=data["phase"] != "post-training", con=data["condition"] < 2), FUN = mean)
View(rtm)
#summary acc
acm = aggregate(data["accuracy"], by= list(phase=data["phase"] != "post-training", con=data["condition"] < 2), FUN = mean)
View(acm)
#make condition a factor
#reaction time (condition)
rt_means = aggregate(data["rt"], by=c(data["ID"], data["Gender"], data["condition"], data["phase"], data["category"]), FUN=mean, na.rm=T)
View(rt_means)
#accuracy (condition)
acc_means = aggregate(data["accuracy"], by=c(data["ID"], data["condition"], data["phase"], data["category"]), FUN=mean, na.rm=T)
View(acc_means)
#reaction time (category)
catmrt= aggregate(data["rt"], by= list(cat=data["category"] != "across", con=data["condition"]<2), FUN = mean)
View(catmrt)
#accuracy (category)
catmac= aggregate(data["accuracy"], by= list(cat=data["category"] != "across", con=data["condition"]<2), FUN = mean)
View(catmac)
#reaction time (phase)
catmrtpre= aggregate(data["rt"], by= list(cat=data["category"] != "across", p=data["phase"] != "post-training"), FUN = mean)
View(catmrtpre)
#accuracy (phase)
catmacpost= aggregate(data["accuracy"], by= list(cat=data["category"] != "across", p=data["phase"] != "post-training"), FUN = mean)
View(catmacpost)

catmrtcond= aggregate(data["rt"], by= list(cat=data["category"] != "across", p=data["condition"]<2), FUN = mean)
View(catmrcond)
#__________GRAPHS_____

#___REACTION TIME___

#bar graph (phase)
ggplot(rt_means, aes(x=phase, y=rt)) + 
  geom_bar(stat="summary", fun.y=mean, fill=c("lightblue","darkblue","lightblue","darkblue")) +
  labs(x="Phase",y="Reaction Time (ms)", title="Phase vs Reaction Time By Condition")+
  geom_errorbar(stat="summary", fun.data = mean_se)+
  facet_grid(.~condition)+
  theme_minimal()
#bar graph (condition)
ggplot(rt_means, aes(x=condition, y=rt))+
  geom_bar(stat="summary", fun.y=mean, fill=c("lightblue","darkblue","lightblue","darkblue"))+
  labs(x="Condition",y="Reaction Time (ms)", title="Condition vs Reaction Time By Phase")+
  geom_errorbar(stat="summary", fun.data= mean_se)+
  facet_grid(.~phase)+
  theme_minimal()
#box plot (phase)
ggplot(rt_means, aes(x=phase, y=rt))+
  geom_boxplot(fill=c("lightblue","darkblue","lightblue","darkblue"))+
  labs(x="Phase",y="Reaction Time (ms)", title="Phase vs Reaction Time By Condition")+
  facet_grid(.~condition)+
  theme_minimal()
#MAKE CONTINUOUS
data$condition=as.factor(data$condition)
class(data$condition)
#box plot (condition)
#still need this one
ggplot(rt_means, aes(x=condition, y=rt))+
  geom_boxplot()+
  labs(x="Condition",y="Reaction Time (ms)", title="Condition vs Reaction Time By Phase")+
  facet_grid(.~phase)+
  theme_minimal()
#scatter plot
ggplot(rt_means, aes(x=ID, y=rt, fill=phase))+
  geom_point(colour="white", shape=21, size = 2, aes(fill = phase, position="jitter"))+
  labs(x="Participant ID",y="Reaction Time (ms)", title="Participant vs Reaction Time By Condition")+
  scale_fill_manual(values=c("cyan4", "darkblue"))+
  scale_shape_identity() +
  facet_grid(.~condition)+
 # geom_smooth()+
  theme_minimal()

#___ACCURACY___
#bar graph (phase)
ggplot(data, aes(x=phase, y=accuracy)) + 
  geom_bar(stat="summary", fun.y=mean, fill=c("lightblue","cyan4","lightblue","cyan4")) +
  labs(x="Phase",y="Accuracy (%)", title="Phase vs Accuracy By Condition")+
  geom_errorbar(stat="summary", fun.data = mean_se)+
  facet_grid(.~condition)+
  theme_minimal()
#bar graph (condition)
ggplot(acc_means, aes(x=condition, y=accuracy)) + 
    geom_bar(stat="summary", fun.y=mean,fill=c("lightblue","cyan4","lightblue","cyan4")) +
    labs(x="Condition",y="Accuracy (%)", title="Condition vs Accuracy By Phase")+
    geom_errorbar(stat="summary", fun.data = mean_se)+
    facet_grid(.~phase)+
    theme_minimal()
#box plot(phase)
ggplot(acc_means, aes(x=phase, y=accuracy))+
  geom_boxplot(fill=c("lightblue","cyan4","lightblue","cyan4"))+
  labs(x="Phase",y="Accuracy (%)", title="Phase vs Accuracy By Condition")+
  facet_grid(.~condition)+
  theme_minimal()
#box plot (condition)
#still need this one too
ggplot(acc_means, aes(x=condition, y=accuracy))+
  geom_boxplot(fill=c("lightblue","cyan4","lightblue","cyan4"))+
  labs(x="Condition",y="Accuracy (%)", title="Condition vs Accuracy By Phase")+
  facet_grid(.~phase)+
  theme_minimal()
#scatter plot
ggplot(acc_means, aes(x=ID, y=accuracy, fill=phase))+
  geom_point(colour="white", shape=21, size = 2, aes(fill = phase, position="jitter"))+
  labs(x="Participant ID",y="Accuracy(%)", title="Participant vs Accuracy By Condition")+
  scale_fill_manual(values=c("cyan4", "darkblue"))+
  scale_shape_identity() +
  facet_grid(.~condition)+
  theme_minimal()
data$condition=as.factor(data$condition)
#still need this one
ggplot(acc_means, aes(x=ID, y=accuracy, fill=condition))+
  geom_point(colour="white", shape=21, size = 2, aes(fill = condition, position="jitter"))+
  geom_smooth(method = lm)+
  labs(x="Participant ID",y="Accuracy(%)", title="Participant vs Accuracy By Condition")+
  scale_fill_manual(values=c("cyan4", "darkblue"))+
  scale_shape_identity() +
  facet_grid(.~phase)+
  theme_minimal()

#____________CATEGORY________
#bar rt (con)
ggplot(data, aes(x=data$category, y=data$rt)) + 
  geom_bar(stat="summary", fun.y=mean, fill=c("lightblue","darkblue","lightblue","darkblue")) +
  labs(x="Category",y="Reaction Time (ms)", title="Category vs Reaction Time By Condition")+
  geom_errorbar(stat="summary", fun.data = mean_se)+
  facet_grid(.~condition)+
  theme_minimal()
#bar ac (con)
ggplot(data, aes(x=data$category, y=data$accuracy)) + 
  geom_bar(stat="summary", fun.y=mean, fill=c("lightblue","cyan4","lightblue","cyan4")) +
  labs(x="Category",y="Accuracy(%)", title="Category vs Accuracy By Condition")+
  geom_errorbar(stat="summary", fun.data = mean_se)+
  facet_grid(.~condition)+
  theme_minimal()
#bar ac (phase)
ggplot(acc_means, aes(x=category, y=accuracy)) + 
  geom_bar(stat="summary", fun.y=mean, fill=c("lightblue","cyan4","lightblue","cyan4")) +
  labs(x="Category",y="Accuracy(%)", title="Category vs Accuracy By Phase")+
  geom_errorbar(stat="summary", fun.data = mean_se)+
  facet_grid(.~phase)+
  theme_minimal()

