###
# used by lc_stats.Rmd to generate comparison histograms
###
lc.dhist <- function(x, y, xleg = "x" , yleg = "y",
                    hmain = "",  hpair = FALSE) {
 p <-  t.test(x, y, paired = hpair)
 if (hpair) {
   hmtx <- matrix(replicate(22,0), nrow = 2, ncol = 11, 
                  dimnames = list(c(yleg, xleg), as.character(0:10)))
   hmtx[xleg, names(table(x))] <- table(x)
   hmtx[yleg, names(table(y))] <- table(y)
   hmatcol <- c("Red","Yellow")
   barplot(hmtx, beside = TRUE, col = hmatcol, 
           main = paste(hmain, "P = ", round(p$p.value, 3)))
 } else {
 
   hmtx <- matrix(replicate(42,0), nrow = 2, ncol = 21, 
                  dimnames = list(c(yleg, xleg), as.character(10:-10)))
   hmtx[xleg, names(table(x))] <- table(x)
   hmtx[yleg, names(table(y))] <- table(y)
   hmatcol <- c("Red","Yellow")

   barplot(hmtx, beside = TRUE, col = hmatcol, 
           main = paste(hmain, "P = ", round(p$p.value, 3)))
 } # end paired true
 legend(x="topleft", legend = rownames(hmtx), fill = hmatcol)
}


###
# used by lc_viz.Rmd to generate matplot graphs
# transparent = TRUE is used by Lia as an overlay on her own graphic tools
###
lc.matplot <- function(x, y, face=1, thick = 1,
                       transparent = FALSE) {
 hmtx <- as.data.frame(table(x, y))
 hmtx <- subset(hmtx, Freq > 0)
 hmtx[, 1] <- as.numeric(as.character(hmtx[, 1]))
 hmtx[, 2] <- as.numeric(as.character(hmtx[, 2]))
 names(hmtx) <- c("x", "y", "Freq")
#  red      lt purple    cyan
# "#FF0000","DD00FF","#55CCFF"))
 hmatcol <- ifelse(hmtx[, 1] == hmtx[, 2], "#DD00FF", 
           ifelse(hmtx[, 1] > hmtx[, 2], "#FF0000", "#55CCFF"))

 hmat <- t(data.frame(hmtx[, 1], hmtx[, 2], hmtx$Freq))

 matplot(hmat[1:2,], type="n", col=hmatcol, lty = 1,
         xlab = " ", ylab = " ", xaxt = "n",  yaxt = "n",
         lwd = face * thick * hmat[3, ]/2, pch = 19, asp = 1/10 )

 if (!transparent) {
   points(1.5, 5, col = "snow2", cex = 48 * face, pch=19 )
   points(1.35, 6, col = "dimgrey", cex = 8 * face, pch=19 )
   points(1.7, 6, col = "dimgrey", cex = 28 * face, pch=19)
   points(1.7, 6, col = "snow2", cex = 8 * face, pch=19 )
   points(1.5, 3, col = "dimgrey", cex = 8 * face, pch=17 )
 }

 matlines(hmat[1:2,], type="b", col=hmatcol, lty = 1,
         lwd = face * thick * hmat[3, ]/2, pch = 19 , asp = 1/10 )

} # end function lc.matplot

###
# used by lc_viz.Rmd to generate spots graphs
# transparent = TRUE is used by Lia as an overlay on her own graphic tools
###


lc.spots <- function(x, y, face=1, size = 1, ptype = 19, grid=FALSE,
            transparent = FALSE) {
 hmtx <- as.data.frame(table(x, y))
 hmtx <- subset(hmtx, Freq > 0)
 hmtx[, 1] <- as.numeric(as.character(hmtx[, 1]))
 hmtx[, 2] <- as.numeric(as.character(hmtx[, 2]))
 names(hmtx) <- c("x", "y", "Frequency")
#  red      lt purple    cyan
# "#FF0000","DD00FF","#55CCFF"
 hcol <- ifelse(hmtx[, 1] == hmtx[, 2], "#DD00FF", 
           ifelse(hmtx[, 1] > hmtx[, 2], "#FF0000", "#55CCFF"))
 plot(hmtx$x, hmtx$y, type = "n", col=hcol, pch = ptype,
      xlim = c(-0.5,10.5), ylim = c(-0.5,10.5), asp = 1, 
      lab=c(11,11,7), xlab = " ", ylab = " ", 
      xaxs = "i",  yaxs = "r", 
      cex = face * size * hmtx$Frequency/3)
 if (!transparent) {
   points(5, 4.5, col = "snow2", cex = 48 * face, pch=19)
   points(3, 5.5, col = "dimgrey", cex = 7 * face, pch=19)
   points(7, 5.5, col = "dimgrey", cex = 25 * face, pch=19)
   points(7, 5.5, col = "snow2", cex = 7 * face, pch=19)
   points(5, 2, col = "dimgrey", cex = 7 * face, pch=17 )
 }
 if (grid) {
   grid(col="Snow2", lty = 1)
 } else {
   axis(side = 1, col = "#FF0000", col.ticks = "#FF0000", tcl = .25)
   axis(side = 2, col = "#00FFFF", col.ticks = "#00FFFF", tcl = .25)
 }
 

 points(hmtx$x, hmtx$y, type = "p", col=hcol, pch = ptype,
     cex = face * size * hmtx$Frequency/5)
 

} # end function lc.spots







