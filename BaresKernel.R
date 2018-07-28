# Instalando pacoates ----
# install.packages("rgdal". depencies = TRUE)
# install.packages("spatstat", dependencies = TRUE)

# Carregando os pacotes ----
library(rgdal)
library(spatstat)

# Carregando os dados
BaresBH <- readOGR("./Dados/BaresBH.geojson", "BaresBH")
plot(BaresBH)
plot(BaresBH, axes = TRUE)
BaresBH@proj4string

# Convertendo os dados para PPP ----
bares_ppp <- ppp(BaresBH@coords[,1], BaresBH@coords[,2], window = as.owin(c(bbox(BaresBH)[1,], bbox(BaresBH)[2,])))
plot(bares_ppp)
?ppp

# Densidade Kernel ----
?density.ppp
BAresKernel <- density.ppp(bares_ppp, sigma = 0.01)
plot(BAresKernel)
plot(BaresBH, add = TRUE)

# Usando bw.diggle
bw.diggle(bares_ppp)
BAresKernel <- density.ppp(bares_ppp, sigma = bw.diggle(bares_ppp))
plot(BAresKernel)

# Usando bw.scott
mean(bw.scott(bares_ppp))
BAresKernel <- density.ppp(bares_ppp, sigma = mean(bw.scott(bares_ppp)))
plot(BAresKernel)

# Efeito de borda
?density.ppp
BAresKernel <- density.ppp(bares_ppp, sigma = mean(bw.scott(bares_ppp)), edge = TRUE, diggle = TRUE)
plot(BAresKernel)

# Mapa dinâmico
# install.packages(mapview)
# install.packages(raster)
library(mapview)
library(raster)
BAresKernel <- raster(BAresKernel)
crs(BAresKernel) <- crs(BaresBH)

mapview(BAresKernel)

# Salvando esultado em raster
wirteRaster(BAresKernel, "BaresKernel.tif")