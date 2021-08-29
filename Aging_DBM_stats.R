# Packages ----------------------------------------------------------------

library(RMINC)
library(tidyverse)


# database ----------------------------------------------------------------

data <- read_csv("/media/sf_F_DRIVE/Data/ratones/derivatives/Proccess/Mice_database_aging_cognition.csv")
data <- select(data, rid, age_group = a, sex, w)
data$age_group <- factor(data$age_group, labels = c("2","12","24"), levels = c("2","12","24"))
data$path <- paste("/media/sf_F_DRIVE/Data/ratones/derivatives/Proccess/stats_volume_all/Mouse",data$rid, "_pp_I_lsq6_lsq12_and_nlin__concat_inverted_linear_part_displ_log_det_rel_fwhm0.2.mnc", sep="")


# atlas template and mask used --------------------------------------------

anatvol <- mincArray(mincGetVolume("/media/sf_F_DRIVE/Data/DSUR_2016/DSUR_40micron.mnc"))
mask <- "/media/sf_F_DRIVE/Data/DSUR_2016/DSUR_40micron_mask_version2.mnc"



# Deformation-based mofphometry GLM -------------------------------------------

vs <- mincLm(path ~ age_group + w, data, mask = mask)

vs_corr <- mincFDR(vs, mask = mask)

peaks2vs12 <- mincFindPeaks(vs, "tvalue-age_group12", minDistance = 5, threshold = 9.072471)
peaks2vs24 <- mincFindPeaks(vs, "tvalue-age_group24", minDistance = 5, threshold = 3.756800)


