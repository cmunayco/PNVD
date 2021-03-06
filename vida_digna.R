library(epicalc)
library(lattice)
library(grid)
library(scatterplot3d)
library(gplots)
library(latticeExtra)
library(reshape)
library(car)


#### Cargando bases de datos 
homeless<-read.csv("base_homeless_mod.csv")

str(homeless)
class(homeless$fecha_nacimiento)
homeless$fecha_nacimiento<-substring(homeless$fecha_nacimiento,1,10)

homeless1<-homeless[,c(-4,-14)]
homeless1<-subset(homeless1,homeless1$edad>=60 & homeless1$edad<=100)

###### Diccionario de variables  ###########

# Sexo (1=M; 2=F)
# Estado civil (1=Soltero; 2=Casado; 3=Viudo; 4=Divorciado; 5= separado)
# Grado de instruccion (1=Sin instruccion; 2=Primaria incompleta; 3=Primaria completa; 4=Secundaria incompleta; 5=Secundaria completa;
# 6=Superior Tecnica; 7=Superior Universitaria)
# Cuenta con seguro medico Si= 1; No=2
# Tipo de seguro medico SIS=1; ESSALUD=2; Otro=3
# Quien reporto a la persona adulta mayor en situacion de calle 
# (1=Beneficencia;2=Defensoría;3=Facilitador;4=Fiscalía;5=Hospital;6= Municipalidad; 7= PNP; 8= Sociedad Civil; 9= Solicitud Propia; 10= Vía Telefónica)
# Tiene familiares (1=Si; 2=No)
# Parentesco (1=hermano/a; 2=primos/as 3=esposo/esposa; 4= hijos; 5= sobrino; 6= tios)
# Cuenta con DNI (1=Si; 2=No)
# Tiene problemas de Salud Mental (1=Si; 2=No)
# Valoración funcional (KATZ) (1= independiente; 2= dependiente parcial; 3= dependiente total)
# Valoración Mental (Pfeiffer) (1= normal; 2=DC leve; 3= DC moderado; 4= DC severo)
# Estado afectivo (Yesavage) (1= sin manifestaciones depresivas; 2= con manifestaciones depresivas)
# Valoración socio - Familiar (1= buena/aceptable; 2 Existe riesgo social; 3= existe problema social)
# Tiene problemas medicos crónicos (1=Si; 2=No)
# VIH/SIDA (1=VIH; 2=SIDA; 3=No)
# Hepatitis viral (1=Hepatitis B; 2=Hepaticis C; 3=Ambos; 4= No) 
# Sifilis (VDRL positivo) (1=Si; 2=No)
# Alcoholismo (1=Si; 2=No)
# Drogadiccion (1=Si; 2=No)
# Tipo de droga (1=Marihuana; 2=Pasta basica; 3=  Todas)


### Exploratory analysis
use(homeless1)
#missing<-homeless1[!complete.cases(homeless1),2] ##missing data

#count(missing=="NA")

summ(homeless1$edad)
tab1(homeless1$edad,graph=FALSE)
summ(homeless1$edad,graph=FALSE)#aqui podemos ver el grafico con la distribucion segun edad

mean(homeless1$edad,na.rm=TRUE)#n.a es para no considere los valores perdidos 
sd(homeless1$edad,na.rm=TRUE)
is.numeric(homeless1$edad)

tab1(homeless1$ubicacion, graph=FALSE)


#table(homeless1$edad<40)#funcion logica
#table(homeless1$edad>50)

quartz(width=10, height=6, pointsize=10)
hist(na.omit(homeless1$edad), breaks=20, col="blue", xlab="Edad (años)", ylab="Frecuencia", main="", axes=FALSE)
axis(side=1, at=seq(60,100,5))
axis(side=2)
par(mar=c(5, 4, 4, 2) + 0.1)

age.M=subset(homeless1,homeless1$sexo=="1")
age.F=subset(homeless1,homeless1$sexo=="2")
tab1(age.M$edad)
tab1(age.F$edad)
summ(age.M$edad)
summ(age.F$edad)
summ(homeless1$edad,by=homeless1$sexo)

quartz(width=10, height=6, pointsize=10)
op <- par(mfrow=c(1, 2))
hist(age.M$edad, breaks=20,main="Hombres",xlab="Edad (años)", ylab="Frecuencia", col="blue", axes=FALSE)
axis(side=1, at=seq(60,100,5))
axis(side=2)
hist(age.F$edad, breaks=20, main="Mujeres",xlab="Edad (años)", ylab="Frecuencia", col="red", axes=FALSE)
axis(side=1, at=seq(60,100,5))
axis(side=2)
par(mfrow=c(1, 1))


quartz(width=10, height=6, pointsize=10)
par(mar=c(5,4,4,8) + 0.1)
hist(na.omit(homeless1$edad), col="blue", xlab="", ylab="",axes=FALSE, main="")
axis(4)
par(new=T)
plot(density(homeless1$edad, col="blue",na.rm=TRUE), main="",ylab="Densidad de Kernel", xlab="Edad (años)")
mtext("Frecuencia",side=4, las=3, line=2)

use(homeless1)
tab1(homeless1$edad,graph=FALSE))
tab1(homeless1$sexo,graph=FALSE))
tab1(homeless1$grado_Instruccion,graph=FALSE))
tab1(homeless1$estado_civil,graph=FALSE))
tab1(homeless1$ubicacion,graph=FALSE)

### 1 CARPAM; 2 Hospederia; 3 EGRESADO
homeless1$location <- NA
homeless1$location[homeless1$ubicacion=="CARPAM BUEN JESUS (AREQUIPA)"] <-1
homeless1$location[homeless1$ubicacion=="CARPAM EL EDEN"] <-1
homeless1$location[homeless1$ubicacion=="CARPAM HOGAR GERIATRICO SENOR DE LA ASCENSION-HOGESA"] <-1
homeless1$location[homeless1$ubicacion=="CARPAM HOUSE FLORA'S (HUANCAYO)"] <-1
homeless1$location[homeless1$ubicacion=="CARPAM IGNACIA RODULFO VIUDA DE CANEVARO"] <-1
homeless1$location[homeless1$ubicacion=="CARPAM ILLARI"] <-1
homeless1$location[homeless1$ubicacion=="CARPAM JESUS ES AMOR"] <-1
homeless1$location[homeless1$ubicacion=="CARPAM LUZ EN TU VIDA"] <-1
homeless1$location[homeless1$ubicacion=="CARPAM REGALITO DE DIOS"] <-1
homeless1$location[homeless1$ubicacion=="CARPAM SAN JOSE (HUANUCO)"] <-1
homeless1$location[homeless1$ubicacion=="CARPAM SAN VICENTE DE PAUL"] <-1
homeless1$location[homeless1$ubicacion=="CARPAM SEMBRANDO ESPERANZA"] <-1
homeless1$location[homeless1$ubicacion=="CARPAM SENOR DE NAZARENO"] <-1
homeless1$location[homeless1$ubicacion=="HOSPEDERIA MANOS BENDITAS"] <-2
homeless1$location[homeless1$ubicacion=="HOSPEDERIA VIRGEN DE LA MEDALLA MILAGROSA"] <-2
homeless1$location[homeless1$ubicacion=="EGRESADO"] <-3
homeless1$location[homeless1$ubicacion=="FALLECIDO"] <-4
homeless1$location[homeless1$ubicacion=="REINSERCION"] <-3
tab1(homeless1$location)

#tab1(homeless1$cuenta_seguro,graph=FALSE)
#tab1(homeless1$tipo_seguro,graph=FALSE)
tab1(homeless1$tipo_reporte,graph=FALSE)

tab1(homeless1$tipo_patologia_medica_cronica,graph=FALSE)

is.numeric(homeless1$problemas_medicos_cronicos)
homeless1$problemas_medicos_cronicos<-recode(homeless1$problemas_medicos_cronicos,"NA=2")
tab1(homeless1$problemas_medicos_cronicos,graph=FALSE)


tab1(homeless1$hta,graph=FALSE)
tab1(homeless1$diabetes.mellitus,graph=FALSE)
tab1(homeless1$secuelas_acv,graph=FALSE)
tab1(homeless1$insuficiencia.renal,graph=FALSE)
tab1(homeless1$cancer,graph=FALSE)
tab1(homeless1$osteoporosis,graph=FALSE)
tab1(homeless1$dncro,graph=FALSE)
tab1(homeless1$artritis_artrosis,graph=FALSE)
tab1(homeless1$enferm.card,graph=FALSE)

tab1(homeless1$tbc,graph=FALSE)
tab1(homeless1$VIH_SIDA,graph=FALSE)
tab1(homeless1$hepatitis_viral,graph=FALSE)
tab1(homeless1$sifilis_VDRL,graph=FALSE)




tab1(homeless1$alcoholismo,graph=FALSE)
tab1(homeless1$drogadiccion,graph=FALSE)
tab1(homeless1$tipo_droga,graph=FALSE)

tab1(homeless1$victimizacion,graph=FALSE)
tab1(homeless1$problemas_salud_mental,graph=FALSE)

tab1(homeless1$valoracion_funcional_KATZ,graph=FALSE)

homeless1$problemas_salud_mental<-recode(homeless1$problemas_salud_mental,"NA=2")
tab1(homeless1$problemas_salud_mental,graph=FALSE)

tab1(homeless1$tipo_patologia_mental,graph=FALSE)
tab1(homeless1$demencia.senil,graph=FALSE)
tab1(homeless1$esquizofrenia,graph=FALSE)
tab1(homeless1$enf.parkinson,graph=FALSE)
tab1(homeless1$ts.psicoticos,graph=FALSE)
tab1(homeless1$retado.mental,graph=FALSE)

tab1(homeless1$sind.depresivo,graph=FALSE)
tab1(homeless1$ts.bipolar,graph=FALSE)

tab1(homeless1$valoracion_mental_Pfeiffer,graph=FALSE)

homeless1$valoracion_mental_Pfeiffer_fff<-NA
homeless1$valoracion_mental_Pfeiffer_fff[homeless1$valoracion_mental_Pfeiffer=="1"]<-1
homeless1$valoracion_mental_Pfeiffer_fff[homeless1$valoracion_mental_Pfeiffer=="2"]<-2
homeless1$valoracion_mental_Pfeiffer_fff[homeless1$valoracion_mental_Pfeiffer=="3"]<-3
homeless1$valoracion_mental_Pfeiffer_fff[homeless1$valoracion_mental_Pfeiffer=="4"]<-4
homeless1$valoracion_mental_Pfeiffer_fff[homeless1$valoracion_mental_Pfeiffer=="2,3"]<-3
homeless1$valoracion_mental_Pfeiffer_fff[homeless1$valoracion_mental_Pfeiffer=="3,4"]<-4
tab1(homeless1$valoracion_mental_Pfeiffer_fff,graph=FALSE)


tab1(homeless1$red_familiar,graph=FALSE)
tab1(homeless1$parentesco,graph=FALSE)
tab1(homeless1$dni)
tab1(homeless1$estado_afectivo_Yesavage,graph=FALSE)
tab1(homeless1$Valoracion.socio...Familiar,graph=FALSE)


### recodificacion de variables ######

homeless1$valoracion_funcional_KATZ[homeless1$valoracion_funcional_KATZ==1]<-0
homeless1$valoracion_funcional_KATZ[homeless1$valoracion_funcional_KATZ==2]<-1

homeless1$sexo[homeless1$sexo==1]<-0
homeless1$sexo[homeless1$sexo==2]<-1



homeless1$valoracion_mental_Pfeiffer_fff[homeless1$valoracion_mental_Pfeiffer==1]<-0
homeless1$valoracion_mental_Pfeiffer_fff[homeless1$valoracion_mental_Pfeiffer==2]<-1
homeless1$valoracion_mental_Pfeiffer_fff[homeless1$valoracion_mental_Pfeiffer==3]<-2
homeless1$valoracion_mental_Pfeiffer_fff[homeless1$valoracion_mental_Pfeiffer==4]<-3

homeless1$problemas_salud_mental[homeless1$problemas_salud_mental==2]<-0

homeless1$problemas_medicos_cronicos[homeless1$problemas_medicos_cronicos==2]<-0

homeless1$alcoholismo[homeless1$alcoholismo==2]<-0
homeless1$drogadiccion[homeless1$drogadiccion==2]<-0

tab1(homeless1$valoracion_funcional_KATZ,graph=FALSE)
tab1(homeless1$valoracion_mental_Pfeiffer_fff,graph=FALSE)
tab1(homeless1$sexo,graph=FALSE)
tab1(homeless1$alcoholismo,graph=FALSE)
tab1(homeless1$drogadiccion,graph=FALSE)
tab1(homeless1$problemas_salud_mental,graph=FALSE)
tab1(homeless1$problemas_medicos_cronicos,graph=FALSE)


##### Regresion logistica #####
### premier pas ###

library(arm)
use(homeless1)

rl1<-glm(valoracion_funcional_KATZ~edad,family=binomial(link="logit"),data=.data)
rl1
summary(rl1)
confint(rl1)
exp(coef(rl1))
exp(cbind(OR=coef(rl1),confint(rl1)))
wald.test(b=coef(rl1),Sigma=vcov(rl1),Terms=2)
logistic.display(rl1)

quartz(width=10, height=6, pointsize=10)
rl1<-glm(valoracion_funcional_KATZ~edad,family=binomial(link="logit"),data=.data)
summary(rl1)
display(rl1)
jitter.binary<-function(a, jitt=.05){
ifelse (a==0, runif (length(a), 0 ,jitt), runif(length(a), 1-jitt,1))
}
dependencia.jitter<-jitter.binary(valoracion_funcional_KATZ)
plot(edad,dependencia.jitter,ylab="Probabilidad(Dependencia parcial)", xlab="Edad, years")
curve(invlogit(coef(rl1)[1] + coef(rl1)[2]*x), col="black", lwd=4, add=TRUE)



rl2<-glm(valoracion_funcional_KATZ~sexo,family=binomial(link="logit"),data=.data)
rl2
summary(rl2)
confint(rl2)
exp(coef(rl2))
exp(cbind(OR=coef(rl2),confint(rl2)))
wald.test(b=coef(rl2),Sigma=vcov(rl2),Terms=2)
logistic.display(rl2)


quartz(width=10, height=6, pointsize=10)
model.1<-glm(valoracion_funcional_KATZ~edad + as.numeric(sexo), family=binomial(link="logit"), data=.data)
plot(edad, dependencia.jitter, ylab="Probabilidad(Dependencia parcial)", xlab="Edad, años", xlim=c(60,100))
curve(invlogit(cbind (1, x, 1) %*% coef(model.1)), add=TRUE, col = "black",lwd = 3)
curve(invlogit(cbind (1, x, 2) %*% coef(model.1)), add=TRUE, col = "gray",lwd = 3)
legend(locator(1),c("Masculino","Femenino"),fill=c("black","gray"),cex = .8)



quartz(width=10, height=6, pointsize=10)
model.1<-glm(valoracion_funcional_KATZ~edad + valoracion_mental_Pfeiffer_fff, family=binomial(link="logit"), data=.data)
plot(edad, dependencia.jitter, ylab="Probabilidad(Dependencia parcial)", xlab="Edad, años", xlim=c(60,100))
curve(invlogit(cbind (1, x, 1) %*% coef(model.1)), add=TRUE, col = "black",lwd = 3)
curve(invlogit(cbind (1, x, 2) %*% coef(model.1)), add=TRUE, col = "dimgray",lwd = 3)
curve(invlogit(cbind (1, x, 3) %*% coef(model.1)), add=TRUE, col = "darkgray",lwd = 3)
curve(invlogit(cbind (1, x, 4) %*% coef(model.1)), add=TRUE, col = "gainsboro",lwd = 3)
legend(locator(1),c("Normal","Deterioro cognitivo leve","Deterioro cognitivo moderado","Deterioro cognitivo severo"),
       fill=c("black","dimgray", "darkgray","gainsboro"),cex = .8)

model.1<-glm(valoracion_funcional_KATZ~edad + as.factor(valoracion_mental_Pfeiffer_fff), family=binomial(link="logit"), data=.data)
summary(model.1)


rl3<-glm(valoracion_funcional_KATZ~edad,family=binomial(link="logit"),data=.data)
summary(rl3)
confint(rl3)
exp(coef(rl3))
exp(cbind(OR=coef(rl3),confint(rl3)))
logistic.display(rl3)


rl4<-glm(valoracion_funcional_KATZ~drogadiccion,family=binomial(link="logit"),data=.data)
logistic.display(rl4)

rl5<-glm(valoracion_funcional_KATZ~as.factor(valoracion_mental_Pfeiffer),family=binomial(link="logit"),data=.data)
summary(rl5)
confint(rl5)
exp(coef(rl5))
exp(cbind(OR=coef(rl5),confint(rl5)))
wald.test(b=coef(rl5),Sigma=vcov(rl5),Terms=4)
logistic.display(rl5)


rl6<-glm(valoracion_funcional_KATZ~problemas_medicos_cronicos,family=binomial(link="logit"),data=.data)
logistic.display(rl6)


rl7<-glm(valoracion_funcional_KATZ~problemas_salud_mental,family=binomial(link="logit"),data=.data)
logistic.display(rl7)

rl8<-glm(valoracion_funcional_KATZ~demencia.senil,family=binomial(link="logit"),data=.data)
logistic.display(rl8)

rl9<-glm(valoracion_funcional_KATZ~enf.parkinson,family=binomial(link="logit"),data=.data)
logistic.display(rl9)

rl10<-glm(valoracion_funcional_KATZ~hta,family=binomial(link="logit"),data=.data)
logistic.display(rl10)


rl11<-glm(valoracion_funcional_KATZ~diabetes.mellitus,family=binomial(link="logit"),data=.data)
logistic.display(rl11)

rl12<-glm(valoracion_funcional_KATZ~dncro,family=binomial(link="logit"),data=.data)
logistic.display(rl12)

rl13<-glm(valoracion_funcional_KATZ~artritis_artrosis,family=binomial(link="logit"),data=.data)
logistic.display(rl13)



tab1(homeless1$Valoracion.socio...Familiar)
tab1(homeless1$problemas_medicos_cronicos)
homeless1$problemas_medicos_cronicos[homeless1$problemas_medicos_cronicos==2]<-0
rl11<-glm(valoracion_funcional_KATZ~problemas_medicos_cronicos,family=binomial(link="logit"),data=.data)
logistic.display(rl11)

#### Analisis multivariado  1 ###


rlmv1<-glm(valoracion_funcional_KATZ~problemas_salud_mental,family=binomial(link="logit"),data=.data)
logistic.display(rlmv1)

rlmv2<-glm(valoracion_funcional_KATZ~problemas_salud_mental + problemas_medicos_cronicos ,family=binomial(link="logit"),data=.data)
logistic.display(rlmv2)

rlmv3<-glm(valoracion_funcional_KATZ~problemas_salud_mental + problemas_medicos_cronicos + as.factor(valoracion_mental_Pfeiffer),family=binomial(link="logit"),data=.data)
logistic.display(rlmv3)

rlmv4<-glm(valoracion_funcional_KATZ~problemas_salud_mental + problemas_medicos_cronicos + as.factor(valoracion_mental_Pfeiffer) + edad ,family=binomial(link="logit"),data=.data)
logistic.display(rlmv4)

rlmv5<-glm(valoracion_funcional_KATZ~problemas_salud_mental + problemas_medicos_cronicos + as.factor(valoracion_mental_Pfeiffer) + sexo + edad ,family=binomial(link="logit"),data=.data)
logistic.display(rlmv5)

#### Analisis multivariado  2 ###

rlmv1a<-glm(valoracion_funcional_KATZ~demencia.senil,family=binomial(link="logit"),data=.data)
logistic.display(rlmv1a)

rlmv1b<-glm(valoracion_funcional_KATZ~demencia.senil + enf.parkinson,family=binomial(link="logit"),data=.data)
logistic.display(rlmv1b)

rlmv1c<-glm(valoracion_funcional_KATZ~demencia.senil + enf.parkinson + sexo + edad,family=binomial(link="logit"),data=.data)
logistic.display(rlmv1c)


rlmv1d<-glm(valoracion_funcional_KATZ~demencia.senil + enf.parkinson + as.factor(valoracion_mental_Pfeiffer) + sexo + edad,family=binomial(link="logit"),data=.data)
logistic.display(rlmv1d)

rlmv1e<-glm(valoracion_funcional_KATZ~diabetes.mellitus + demencia.senil + enf.parkinson + as.factor(valoracion_mental_Pfeiffer) + sexo + edad,family=binomial(link="logit"),data=.data)
logistic.display(rlmv1e)



