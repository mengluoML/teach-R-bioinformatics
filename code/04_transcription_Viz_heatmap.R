##########################################
#  http://www.majorbio.com/
#  Copyright (C) 2019 in  Majorbio workshop
#  contact: meng.luo@majorbio.com
##########################################

library(ComplexHeatmap)
library(circlize)
## complex heatmap
mrna <- read.csv("mRNAresult.all.csv", header = T)
mmat <- mrna[, c(9:16)]
express_mean <- rowMeans(mmat)
mmmat <- t(apply(mmat, 1, scale))
colnames(mmmat) <- colnames(mmat)
m <- as.matrix(mmmat)
column_ha <- HeatmapAnnotation(box = anno_boxplot(m, size = unit(10, "cm"), gp = gpar(fill = 1:8)))
row_ha <- rowAnnotation(keggpvalue = mrna$keggPValue)

## sampleheatmap
Heatmap(mmmat,
  name = "expression", col = colorRamp2(
    c(-2, 0, 2),
    c("green", "white", "red")
  ),
  show_row_names = FALSE, show_column_names = TRUE
) +
  Heatmap(express_mean, name = "express_mean", show_row_names = FALSE, width = unit(5, "mm"))

## boxplot

Heatmap(mmmat,
  name = "expression", col = colorRamp2(c(-2, 0, 2), c("green", "white", "red")),
  show_row_names = FALSE, show_column_names = TRUE,
  top_annotation = column_ha, left_annotation = row_ha
) +
  Heatmap(express_mean, name = "express_mean", show_row_names = FALSE, width = unit(5, "mm")) +
  Heatmap(mrna$keggPValue, show_row_names = FALSE, width = unit(5, "mm"))

## add annotation
ha <- HeatmapAnnotation(df = data.frame(type = mrna$typeI))
Heatmap(mmmat,
  name = "expression",
  col = colorRamp2(c(-2, 0, 2), c("green", "white", "red")),
  show_row_names = FALSE,
  show_column_names = TRUE
) +
  Heatmap(express_mean,
    name = "express_mean",
    show_row_names = FALSE,
    width = unit(5, "mm")
  ) +
  Heatmap(mrna$typeII,
    name = "typeII",
    width = unit(5, "mm")
  ) +
  Heatmap(mrna$typeI,
    name = "typeI",
    width = unit(5, "mm")
  )

## all legend list
kegg <- HeatmapAnnotation(
  keggFDR = mrna$keggFDR, diffFDR = mrna$diffqvalue, which = "row",
  annotation_legend_param = list(
    keggFDR = list(title = "FDR"),
    diffFDR = list(title = "expressFDR")
  )
)
png(paste("complexheatmap", ".png", sep = ""), width = 1000, height = 800)
Heatmap(mmmat,
  name = "expression", col = colorRamp2(c(-2, 0, 2), c("yellow", "red", "blue")),
  show_row_names = FALSE, show_column_names = TRUE,
  left_annotation = kegg
) +
  rowAnnotation(typeI = mrna$typeI) +
  Heatmap(mrna$typeII, name = "typeII", width = unit(5, "mm")) +
  rowAnnotation(GOterm_type = mrna$goTerm_type) +
  rowAnnotation(GOterm = mrna$goTerm) +
  rowAnnotation(regulate = mrna$regulate) +
  HeatmapAnnotation(fc = mrna$log2FC.HH.MOD., annotation_legend_param = list(title = "log2FC"), which = "row")
dev.off()
