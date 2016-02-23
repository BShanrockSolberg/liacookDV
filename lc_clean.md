---
title: "Lia Cook Weave vs Photo: Data Cleansing"
output: lc_clean.md
  html_document: lc_clean.HTML
    keep_md: true
---

Lia Cook Weave vs Photo: Data Cleansing
===========================================
### By Bradley Shanrock-Solberg 20-December 2015
Synopsis
--------

Surveys from the Houston and Pittsburgh Weave vs Photo experiments were entered into three spreadsheets and, in the case of Houston emotion words, a large series of text files.

Formats were inconsistent and in some cases the data was not transcribed correctly.  The two Houston spreadsheets were identical, so only one was used.  When data was not entered in the survey, it is captured as NA.

The following R code was used to clean up the data and reduce it to two data frames (pdata for Pittsburgh, hdata for Houston)

Data Processing
----------------------------------

Load data, ensure that only one houston data matters,
compare format to Pittsburgh


```r
houston1 <- read.csv(skip=1, "rawdata/Houston Data-1csv.csv")
houston2 <- read.csv(skip=1, "rawdata/Houston Data-resizecsv.csv")
identical(houston1,houston2)
```

```
## [1] TRUE
```

```r
str(houston1)
```

```
## 'data.frame':	428 obs. of  18 variables:
##  $ ID.Number                              : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ First.piece                            : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ First_Image_Rate_Intensity_Emotion     : num  7 7 6 7 6 8 5 7 8 5 ...
##  $ First_Image_Rate_Intensity_NegPosReact : int  9 7 8 5 7 8 5 9 8 3 ...
##  $ Second_Image_Rate_Intensity_Emotion    : num  8 5 8 8 5 6 3 9 9 7 ...
##  $ Second_Image_Rate_Intensity_NegPosReact: num  3 7 4 4 5 7 4 2 4 5 ...
##  $ Art_Experience                         : int  1 2 2 1 2 1 1 2 2 1 ...
##  $ Number.of.Years                        : int  70 NA NA 10 NA 2 8 NA NA 15 ...
##  $ Scientific_Experiments                 : int  2 1 2 2 2 1 1 1 2 1 ...
##  $ Number.of.Years.1                      : int  NA 7 NA NA NA 3 4 30 NA 3 ...
##  $ Photography_Experience                 : int  1 2 1 2 2 2 1 2 1 1 ...
##  $ Number.of.Years.2                      : num  45 NA 10 NA NA NA 10 NA 20 28 ...
##  $ Weaving_Experience                     : int  2 2 2 NA 2 2 2 2 2 1 ...
##  $ Number.of.Years.3                      : int  NA NA NA NA NA NA NA NA NA 6 ...
##  $ Age                                    : int  77 26 38 29 42 21 23 56 46 51 ...
##  $ Gender                                 : int  2 2 2 2 1 2 2 2 1 2 ...
##  $ education                              : int  16 16 16 18 16 16 16 16 13 18 ...
##  $ X                                      : logi  NA NA NA NA NA NA ...
```

```r
pitt1 <- read.csv(skip=1, "rawdata/LiaCookPittsburghDataPhotovWovenFace-1csv.csv",
                  stringsAsFactors = FALSE)
str(pitt1)
```

```
## 'data.frame':	396 obs. of  19 variables:
##  $ ID                 : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ X1st.piece.1.A..2.B: int  1 1 1 1 1 1 1 1 1 1 ...
##  $ A_EmotionWord      : chr  "beauty" "caring" "crackle" "concern" ...
##  $ A_EmotionIntensity : num  6 8 6 7 7 8 7 6 8 5 ...
##  $ A_Neg_Pos          : num  3 6 5 3 7 0 7 3 3 7 ...
##  $ B_EmotionWord      : chr  "disappointed" "confused" "clean" "fear" ...
##  $ B_EmotionIntensity : num  7 7 1 7 6 8 7 8 9 7 ...
##  $ B_Neg_Pos          : num  1 9 5 1 4 0 7 3 2 4 ...
##  $ ArtExperience      : int  1 2 1 2 1 1 2 2 1 2 ...
##  $ X.years            : num  8 NA 20 NA 33 6 NA NA 1 NA ...
##  $ ScientificExpts    : int  1 1 2 1 1 2 1 2 1 2 ...
##  $ X.years.1          : num  3 6 NA 6 2 NA 2 NA 1 NA ...
##  $ Photography        : int  1 1 1 2 1 2 2 2 1 1 ...
##  $ X.years.2          : num  2 8 5 NA 15 NA NA NA 2 20 ...
##  $ Weaving            : int  2 1 2 2 1 1 2 2 2 2 ...
##  $ X.years.3          : num  NA 8 NA NA 1 10 NA NA NA NA ...
##  $ Age                : int  NA 23 38 25 33 60 36 21 23 61 ...
##  $ Gender             : int  2 2 1 2 2 2 1 2 2 2 ...
##  $ education          : int  16 16 18 16 16 18 18 16 18 16 ...
```

Merge formats into consistent, eliminate columns with lots of NA data, change numbers to factors where appropriate,


```r
pdata <- pitt1[, c(1:9, 11, 13, 15, 17:19)]
names(pdata) <- c("ID", "FirstViewed", "Photo_Word", "Photo_Intensity",
                  "Photo_Neg_Pos", "Weave_Word", "Weave_Intensity",
                  "Weave_Neg_Pos", "Art", "Science", 
                  names(pdata[11:14]),"Education")
# subject ID was repeated for FirstViewed = 2, instead of getting a unique
# value (unlike Houston data).  Fix
length(unique(pdata$ID))
```

```
## [1] 199
```

```r
table(pdata$FirstViewed,pdata$ID)
```

```
##    
##     1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26
##   1 1 1 1 1 1 1 1 1 1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1
##   2 1 1 1 1 1 1 1 1 1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1
##    
##     27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49
##   1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1
##   2  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1
##    
##     50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72
##   1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1
##   2  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1
##    
##     73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95
##   1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1
##   2  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1
##    
##     96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113
##   1  1  1  1  1   1   1   1   1   1   1   1   1   1   1   1   1   1   1
##   2  1  1  1  1   1   1   1   1   1   1   1   1   1   1   1   1   1   1
##    
##     114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130
##   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1
##   2   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1
##    
##     131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147
##   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1
##   2   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1
##    
##     148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164
##   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1
##   2   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1
##    
##     165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181
##   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1
##   2   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1
##    
##     182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198
##   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1
##   2   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   0
##    
##     199
##   1   1
##   2   0
```

```r
pdata[pdata$FirstViewed == 2, "ID"] <- 200:396
dim(pdata)[1] ==  length(unique(pdata$ID))
```

```
## [1] TRUE
```

```r
pdata$FirstViewed <- ifelse(pdata$FirstViewed == 1, "Photo", "Weave")
pdata$FirstViewed <- factor(pdata$FirstViewed, order <- c("Photo", "Weave"))
# Now just check the data ranges to be sure nothing is out of bounds,
# and round partial values down to integers
table(pdata$Photo_Intensity)
```

```
## 
##   0   1   2   3   4   5   6   7   8 8.5   9  10 
##   7   3  11  39  27  34  68 101  74   1  21   4
```

```r
pdata$Photo_Intensity <- floor(pdata$Photo_Intensity)
table(pdata$Weave_Intensity)
```

```
## 
##   0   1   2   3   4   5   6   7   8   9 9.5  10 
##   4   6  17  28  30  52  66  72  55  28   1  16
```

```r
pdata$Weave_Intensity <- floor(pdata$Weave_Intensity)
table(pdata$Photo_Neg_Pos)
```

```
## 
##   0   1   2   3   4   5   6 6.5   7   8   9  10 
##   7  23  45  58  36  65  47   1  45  36  18   9
```

```r
pdata$Photo_Neg_Pos <- floor(pdata$Photo_Neg_Pos)
table(pdata$Weave_Neg_Pos)
```

```
## 
##   0   1   2   3   4 4.5   5   6   7   8   9  10 
##  14  23  32  51  53   1  74  45  35  20  18   8
```

```r
pdata$Weave_Neg_Pos <- floor(pdata$Weave_Neg_Pos)
# for the experience questions, treat no response as a "No"
table(pdata$Art)
```

```
## 
##   1   2 
## 189 178
```

```r
pdata$Art <- ifelse(pdata$Art == 1, "Yes", "No")
pdata$Art <- factor(pdata$Art, ordered <- c("Yes", "No"))
pdata[is.na(pdata$Art), "Art"] <- "No"
table(pdata$Science)
```

```
## 
##   1   2 
## 126 236
```

```r
pdata$Science <- ifelse(pdata$Science == 1, "Yes", "No")
pdata$Science <- factor(pdata$Science, ordered <- c("Yes", "No"))
pdata[is.na(pdata$Science), "Science"] <- "No"
table(pdata$Photography)
```

```
## 
##   1   2 
## 165 200
```

```r
pdata$Photography <- ifelse(pdata$Photography == 1, "Yes", "No")
pdata$Photography <- factor(pdata$Photography, ordered <- c("Yes", "No"))
pdata[is.na(pdata$Photography), "Photography"] <- "No"
table(pdata$Weaving)
```

```
## 
##   1   2 
##  52 311
```

```r
pdata$Weaving <- ifelse(pdata$Weaving == 1, "Yes", "No")
pdata$Weaving <- factor(pdata$Weaving, ordered <- c("Yes", "No"))
pdata[is.na(pdata$Weaving), "Weaving"] <- "No"
# The age is a very wide spread, and there are 31 unknown entries.  Rather
# than make assumptions such as mean or median, which will might fuzz the
# results in the age 41 range I'd rather leave out the observations which
# are NA in any analysis involving age
table(pdata$Age)
```

```
## 
##  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 
##  3  4  3  4  7  4  2  3  3  9  6  7  3  7  8  9  9  8 10  8 11  6  6  6  6 
## 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 
##  8  4  2  2  1  4  3  4  5  4  4  3  4  3  6  7  4 11  4 10  6  8 11  6  7 
## 58 59 60 61 62 63 64 65 66 67 68 69 70 71 73 75 80 
## 12  5 12  5  8  3  8  5  2  3  4  1  9  1  1  2  1
```

```r
sum(is.na(pdata$Age))
```

```
## [1] 31
```

```r
mean(pdata$Age[!is.na(pdata$Age)])
```

```
## [1] 40.28493
```

```r
median(pdata$Age[!is.na(pdata$Age)])
```

```
## [1] 41
```

```r
# Gender might be left blank by intent (eg, a transgendered person), but again
# I'd rather leave it out of gender-based analysis because the unknown value
# is nearly 10% of the total and could skew results if assigned incorrectly
 sum(is.na(pdata$Gender))
```

```
## [1] 34
```

```r
 sum(is.na(pdata$Gender))/dim(pdata)[1]
```

```
## [1] 0.08585859
```

```r
# The gender entry of "7", by contrast is almost certainly a data entry error
# checking the paper, it looks like this should be "F"
# (7 can look like a 1 or a 7, but I'll flag it as NA until we get paper confirmation
 table(pdata$Gender)
```

```
## 
##   1   2   7 
## 102 259   1
```

```r
 pdata$Gender <- ifelse(pdata$Gender == 1, "Male", ifelse(pdata$Gender %in% c(2,7), "Female", NA))
 pdata$Gender <- factor(pdata$Gender, ordered <- c("Male", "Female"))
# Education is a coded value that corresponds roughly to years, with 12 = High School
 table(pdata$Education)
```

```
## 
##   1   2   4   5   6   7   8   9  10  11  12  13  14  16  18  21  31 
##   2   2   4   4   5   6   2   2   1   4  27  27   5 107 118  36   1
```

```r
 table(pdata$Age[is.na(pdata$Education)])
```

```
## 
##  9 28 38 41 46 48 56 57 58 62 70 
##  2  1  1  1  1  1  1  2  1  1  1
```

```r
 table(pdata$Education[pdata$Age == 9])
```

```
## 
## 4 
## 2
```

```r
# Set education for the two 9 year olds to 4
 pdata$Education[pdata$Age == 9] <- 4
 table(pdata$Education)
```

```
## 
##   1   2   4   5   6   7   8   9  10  11  12  13  14  16  18  21  31 
##   2   2   6   4   5   6   2   2   1   4  27  27   5 107 118  36   1
```

```r
 table(pdata$Age[is.na(pdata$Education)])
```

```
## 
## 28 38 41 46 48 56 57 58 62 70 
##  1  1  1  1  1  1  2  1  1  1
```

```r
# Reduce factors to the following:
# "Gr1-5", "Gr6-8", "Gr9-11", "High_School", "Some_College", 
# "AA_Degree", "BA_BS", "MA_MS", "PHD_MD"
pdata$Education <- ifelse(pdata$Education < 6, "Gr1-5",
                   ifelse(pdata$Education < 9, "Gr6-8",
                   ifelse(pdata$Education < 12, "Gr9-11",
                   ifelse(pdata$Education < 13, "High_School",
                   ifelse(pdata$Education < 14, "Some_College",
                   ifelse(pdata$Education < 16, "AA_Degree",
                   ifelse(pdata$Education < 18, "BA_BS",
                   ifelse(pdata$Education < 21, "MA_MS",  "PHD_MD"))))))))
pdata$Education <- factor(pdata$Education, ordered <- c("Gr1-5", "Gr6-8", "Gr9-11", 
            "High_School", "Some_College", "AA_Degree", "BA_BS", "MA_MS", "PHD_MD"))
table(pdata$Education)
```

```
## 
##        Gr1-5        Gr6-8       Gr9-11  High_School Some_College 
##           14           13            7           27           27 
##    AA_Degree        BA_BS        MA_MS       PHD_MD 
##            5          107          118           37
```

```r
## now group ages into factors of 10 years each
pdata$AgeRange <- ifelse(pdata$Age <13 , "Child",
                  ifelse(pdata$Age <20 , "Teenage",
                  ifelse(pdata$Age <30 , "Twenties",
                  ifelse(pdata$Age <40 , "Thirties",
                  ifelse(pdata$Age <50 , "Fourties",
                  ifelse(pdata$Age <60 , "Fifties",
                  ifelse(pdata$Age <70 , "Sixties",
                  ifelse(pdata$Age <80 , "Seventies",
                  ifelse(pdata$Age <90 , "Eighties", "Over 90")))))))))
pdata$AgeRange <- factor(pdata$AgeRange, ordered <- c("Child", "Teenage",
                  "Twenties", "Thirties", "Fourties", "Fifties", "Sixties",
                  "Seventies", "Eighties", "Over 90"))
```

Now create Houston data in same format.  As the word columns are missing we'll start by just cloning the structure of the pdata table, then add the emotion word columns later.


```r
hdata <- pdata[1 == 2, ]
dim(houston1)[1] == length(unique(houston1$ID.Number))
```

```
## [1] TRUE
```

```r
for (i in 1:dim(houston1)[1]){
 hdata[i,"ID"] <- houston1$ID.Number[i]
} # end loop to create subject records
## set First Piece
table(houston1$First.piece)
```

```
## 
##   1   2 
## 220 208
```

```r
sum(is.na(houston1$First.piece))
```

```
## [1] 0
```

```r
hdata$FirstViewed <- as.factor(ifelse(houston1$First.piece == 1, "Photo", "Weave"))
table(hdata$FirstViewed)
```

```
## 
## Photo Weave 
##   220   208
```

```r
## set Emotion Intensity
# Check the data ranges to be sure nothing is out of bounds
table(houston1$First_Image_Rate_Intensity_Emotion)
```

```
## 
##   0   1   2   3   4   5   6   7   8 8.5   9  10 
##   4   6  12  30  27  46  86 107  54   1  38  13
```

```r
table(houston1$Second_Image_Rate_Intensity_Emotion)
```

```
## 
##   0   1   2   3   4 4.5   5   6   7 7.5   8   9  10  12 
##   5   4  20  21  36   1  56  70  70   3  63  33  12   1
```

```r
# Reorganize the data by A and B, rather than First and Second

hdata[hdata$FirstViewed == "Photo", 
      "Photo_Intensity"] <- houston1[houston1$First.piece == 1, 
                                        "First_Image_Rate_Intensity_Emotion"]
hdata[hdata$FirstViewed == "Weave", 
      "Photo_Intensity"] <- houston1[houston1$First.piece == 2, 
                                        "Second_Image_Rate_Intensity_Emotion"]
hdata[hdata$FirstViewed == "Weave", 
      "Weave_Intensity"] <- houston1[houston1$First.piece == 2, 
                                        "First_Image_Rate_Intensity_Emotion"]
hdata[hdata$FirstViewed == "Photo", 
      "Weave_Intensity"] <- houston1[houston1$First.piece == 1, 
                                        "Second_Image_Rate_Intensity_Emotion"]
sum(is.na(hdata$Photo_Intensity)) + sum(is.na(hdata$Weave_Intensity)) ==
  sum(is.na(houston1$First_Image_Rate_Intensity_Emotion)) + 
    sum(is.na(houston1$Second_Image_Rate_Intensity_Emotion))
```

```
## [1] TRUE
```

```r
## set Neg/Pos ratio
# Check the data ranges to be sure nothing is out of bounds
table(houston1$First_Image_Rate_Intensity_NegPosReact)
```

```
## 
##  0  1  2  3  4  5  6  7  8  9 10 
## 26 11 16 44 37 53 43 62 63 45 19
```

```r
table(houston1$Second_Image_Rate_Intensity_NegPosReact)
```

```
## 
##   0   1   2   3   4   5   6   7 7.5   8   9  10 
##  12  20  24  47  72  66  33  48   1  33  24  11
```

```r
hdata[hdata$FirstViewed == "Photo", 
      "Photo_Neg_Pos"] <- houston1[houston1$First.piece == 1, 
                                        "First_Image_Rate_Intensity_NegPosReact"]
hdata[hdata$FirstViewed == "Weave", 
      "Photo_Neg_Pos"] <- houston1[houston1$First.piece == 2, 
                                        "Second_Image_Rate_Intensity_NegPosReact"]
hdata[hdata$FirstViewed == "Weave", 
      "Weave_Neg_Pos"] <- houston1[houston1$First.piece == 2, 
                                        "First_Image_Rate_Intensity_NegPosReact"]
hdata[hdata$FirstViewed == "Photo", 
      "Weave_Neg_Pos"] <- houston1[houston1$First.piece == 1, 
                                        "Second_Image_Rate_Intensity_NegPosReact"]
sum(is.na(hdata$Photo_Neg_Pos)) + sum(is.na(hdata$Weave_Neg_Pos)) ==
  sum(is.na(houston1$First_Image_Rate_Intensity_NegPosReact)) + 
    sum(is.na(houston1$Second_Image_Rate_Intensity_NegPosReact))
```

```
## [1] TRUE
```

```r
# There is one value in data set to intensity = 12.  Reduce to 10
hdata[hdata$Weave_Intensity == 12 & 
      !(is.na(hdata$Weave_Intensity )), ]$Weave_Intensity <- 10
# reduce partial values to integers
hdata$Photo_Intensity <- floor(hdata$Photo_Intensity)
hdata$Weave_Intensity <- floor(hdata$Weave_Intensity)
hdata$Photo_Neg_Pos <- floor(hdata$Photo_Neg_Pos)
hdata$Weave_Neg_Pos <- floor(hdata$Weave_Neg_Pos)
# for the experience questions, treat no response as a "No"
table(houston1$Art_Experience)
```

```
## 
##   1   2   8 
## 217 152   1
```

```r
# the "8" is an outlier.  Look at the whole record
 houston1[houston1$Art_Experience == 8 & !is.na(houston1$Art_Experience), ]
```

```
##     ID.Number First.piece First_Image_Rate_Intensity_Emotion
## 137       137           1                                  6
##     First_Image_Rate_Intensity_NegPosReact
## 137                                      6
##     Second_Image_Rate_Intensity_Emotion
## 137                                   7
##     Second_Image_Rate_Intensity_NegPosReact Art_Experience Number.of.Years
## 137                                      NA              8               1
##     Scientific_Experiments Number.of.Years.1 Photography_Experience
## 137                      3                 2                     NA
##     Number.of.Years.2 Weaving_Experience Number.of.Years.3 Age Gender
## 137                 1                  2                NA  24      2
##     education  X
## 137        16 NA
```

```r
# it is clear that this record was shifted one column, starting with 
# Second_Image_Rate_Intensity_NegPosReact and ending with Photography Years.  
# correct values should be:
hdata[hdata$ID == 137, "Weave_Neg_Pos"] <- 8
# then Art should be "Yes" (= 1 in "years", set to 8 in database)
hdata$Art <- ifelse(houston1$Art_Experience %in% c(1,8), "Yes", "No")
hdata$Art <- factor(hdata$Art, ordered <- c("Yes", "No"))
hdata[is.na(hdata$Art), "Art"] <- "No"
# then Science should be "NO" if value = 3 (was 2 in "years" offset value)
table(houston1$Scientific_Experiments)
```

```
## 
##   1   2   3 
## 115 258   1
```

```r
# the basic formula already sets values other than 1 to "No"
hdata$Science <- ifelse(houston1$Scientific_Experiments == 1, "Yes", "No")
hdata$Science <- factor(hdata$Science, ordered <- c("Yes", "No"))
hdata[is.na(hdata$Art), "Science"] <- "No"
# in Photography, the shifted value is NA, so we have to add it later
table(houston1$Photography_Experience)
```

```
## 
##   1   2 
## 176 200
```

```r
hdata$Photography <- ifelse(houston1$Photography_Experience == 1, "Yes", "No")
hdata[hdata$ID == 137, "Photography"] <- "Yes"
hdata$Photography <- factor(hdata$Photography, ordered <- c("Yes", "No"))
hdata[is.na(hdata$Photography), "Photography"] <- "No"
# the weaving entry was no longer shifted, so the rest will proceed normally
table(houston1$Weaving_Experience)
```

```
## 
##   1   2 
##  69 305
```

```r
hdata$Weaving <- ifelse(houston1$Weaving_Experience == 1, "Yes", "No")
hdata$Weaving <- factor(hdata$Weaving, ordered <- c("Yes", "No"))
hdata[is.na(hdata$Weaving), "Weaving"] <- "No"
# The age is a very wide spread, and there are 53 unknown entries.  Rather
# than make assumptions such as mean or median, which will might fuzz the
# results in the age 47-52 range I'd rather leave out the observations which
# are NA in any analysis involving age
hdata$Age <- houston1$Age
table(hdata$Age)
```

```
## 
##   5   7   8   9  11  12  13  14  15  16  17  18  19  20  21  22  23  24 
##   1   2   2   4   3   1   2   4   3   2   4   2   3   9   5   3  10   7 
##  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  40  41  42 
##   3   3   2   4   6   6   5   5   8   5   5   1   5   9   1   3   1   4 
##  43  44  45  46  47  48  49  50  51  52  53  54  55  56  57  58  59  60 
##   5   3   5   4   3   7   3   8   5   5   7   9   6   9   7  10  14  16 
##  61  62  63  64  65  66  67  68  69  70  71  72  73  74  75  76  77  78 
##   9   7  10   9  12   9   6   8   3   6   3   4   4   2   1   3   3   1 
##  79  80  86  87  88 101 
##   1   1   1   1   1   1
```

```r
sum(is.na(hdata$Age))
```

```
## [1] 53
```

```r
mean(hdata$Age[!is.na(hdata$Age)])
```

```
## [1] 47.13067
```

```r
median(hdata$Age[!is.na(hdata$Age)])
```

```
## [1] 52
```

```r
# This time over 10% declined to state gender.  
# I'll exclude those from gender-based statistics
 hdata$Gender <- houston1$Gender
 sum(is.na(hdata$Gender))
```

```
## [1] 49
```

```r
 sum(is.na(hdata$Gender))/dim(hdata)[1]
```

```
## [1] 0.114486
```

```r
# The gender entry of "7", by contrast is almost certainly a data entry error
# Paper check showed "7" was actually "F"
 table(hdata$Gender)
```

```
## 
##   1   2   7 
## 107 271   1
```

```r
 hdata$Gender <- ifelse(hdata$Gender == 1, "Male", 
                       ifelse(hdata$Gender %in% c(2,7), "Female", NA))
 hdata$Gender <- factor(hdata$Gender, ordered <- c("Male", "Female"))

# Education has nobody in the age range where I can predict education by age,
# so will leave the NA records alone and ignore when doing statistics by education
 hdata$Education <- houston1$education
 table(hdata$Education)
```

```
## 
##   1   2   3   5   6   7   8   9  10  11  12  13  14  16  18  21  28 
##   3   1   5   2   2   3   2   4   3   2   8  68  10 107  75  74   2
```

```r
 table(hdata$Age[is.na(hdata$Education)])
```

```
## 
## 20 34 54 58 61 62 65 71 
##  1  1  1  1  1  1  1  1
```

```r
# Categories are otherwise the same as with the Pittsburgh data
# Reduce factors to the following:
# "Gr1-5", "Gr6-8", "Gr9-11", "High_School", "Some_College", "AA_Degree", 
# "BA_BS", "MA_MS", "PHD_MD"
hdata$Education <- ifelse(hdata$Education < 6, "Gr1-5",
                   ifelse(hdata$Education < 9, "Gr6-8",
                   ifelse(hdata$Education < 12, "Gr9-11",
                   ifelse(hdata$Education < 13, "High_School",
                   ifelse(hdata$Education < 14, "Some_College",
                   ifelse(hdata$Education < 16, "AA_Degree",
                   ifelse(hdata$Education < 18, "BA_BS",
                   ifelse(hdata$Education < 21, "MA_MS",  "PHD_MD"))))))))
hdata$Education <- factor(hdata$Education, ordered <- c("Gr1-5", "Gr6-8", "Gr9-11",  
           "High_School", "Some_College", "AA_Degree", "BA_BS", "MA_MS", "PHD_MD"))
table(hdata$Education)
```

```
## 
##        Gr1-5        Gr6-8       Gr9-11  High_School Some_College 
##           11            7            9            8           68 
##    AA_Degree        BA_BS        MA_MS       PHD_MD 
##           10          107           75           76
```

```r
# add in date range information
hdata$AgeRange <- ifelse(hdata$Age <13 , "Child",
                  ifelse(hdata$Age <20 , "Teenage",
                  ifelse(hdata$Age <30 , "Twenties",
                  ifelse(hdata$Age <40 , "Thirties",
                  ifelse(hdata$Age <50 , "Fourties",
                  ifelse(hdata$Age <60 , "Fifties",
                  ifelse(hdata$Age <70 , "Sixties",
                  ifelse(hdata$Age <80 , "Seventies",
                  ifelse(hdata$Age <90 , "Eighties", "Over 90")))))))))
hdata$AgeRange <- factor(hdata$AgeRange, ordered <- c("Child", "Teenage",
                  "Twenties", "Thirties", "Fourties", "Fifties", "Sixties",
                  "Seventies", "Eighties", "Over 90"))
## basic processing of the Word variables to eliminate NA and case
pdata$Photo_Word <- ifelse(is.na(pdata$Photo_Word),  "", 
                           tolower(pdata$Photo_Word))
pdata$Weave_Word <- ifelse(is.na(pdata$Weave_Word),  "", 
                           tolower(pdata$Weave_Word))
```

Finally add in the emotion words, from the large number of text files in the raw data.


```r
for (i in hdata$ID) {
 if (hdata$FirstViewed[i] == "Photo") {
  pfname <- paste("rawdata/", i, "_Photo_First_Question_3b.txt", sep="")
  wfname <- paste("rawdata/", i, "_Photo_First_Question_6b.txt", sep="")
 } else {
  wfname <- paste("rawdata/", i, "_Weave_First_Question_3b.txt", sep="")
  pfname <- paste("rawdata/", i, "_Weave_First_Question_6b.txt", sep="")
 } # end set filename
 if (file.exists(pfname)) {
   hdata[hdata$ID ==i, "Photo_Word"] <- scan(pfname, character(0))[1]
 } # 
 if (file.exists(wfname)) {
     hdata[hdata$ID ==i, "Weave_Word"] <- scan(wfname, character(0))[1]
 } # 
} # end loop through subjects
## basic processing of the Word variables to eliminate NA and case
hdata$Photo_Word <- ifelse(is.na(hdata$Photo_Word),  "", 
                           tolower(hdata$Photo_Word))
hdata$Weave_Word <- ifelse(is.na(hdata$Weave_Word),  "", 
                           tolower(hdata$Weave_Word))
```

### Check for significance of printing errors
(see file "rawdata/printing_errors.txt")
in Pittsburgh, the referenced ID's go from 1-199 for A and
001-197 for B.  The "B" are in range 200-396 in pdata, so
we adjust by adding 199 to the number provided in the error file


```r
pperr <- c(1:2,5:6,8:26,28:47,77,82,85:86,89,91:99,100:101,
           103:108,114:118,122:129,132,141,146:148,158:159,
           165:171,173:187,189,190,199:200,202:205,209:218,
           220:221,233:238,240:267,281,298,302:325,331,339,
           353,357,359:360,362:369,371:375,377:392,394:396)
hperr <- c(42:53,58:63,69,72:90,117,119:121,159:160,
           307:313,315:328,330:335,342:359,381,393:399,391)

t.test(pdata[pperr, ]$Photo_Intensity, pdata[-pperr, ]$Photo_Intensity)$p.value
```

```
## [1] 0.2503832
```

```r
t.test(pdata[pperr, ]$Weave_Intensity, pdata[-pperr, ]$Weave_Intensity)$p.value
```

```
## [1] 0.6195411
```

```r
t.test(pdata[pperr, ]$Photo_Neg_Pos, pdata[-pperr, ]$Photo_Neg_Pos)$p.value
```

```
## [1] 0.3589116
```

```r
t.test(pdata[pperr, ]$Weave_Neg_Pos, pdata[-pperr, ]$Weave_Neg_Pos)$p.value
```

```
## [1] 0.1681242
```

```r
t.test(hdata[hperr, ]$Photo_Intensity, hdata[-hperr, ]$Photo_Intensity)$p.value
```

```
## [1] 0.4823887
```

```r
t.test(hdata[hperr, ]$Photo_Intensity, hdata[-hperr, ]$Weave_Intensity)$p.value
```

```
## [1] 0.1790151
```

```r
t.test(hdata[hperr, ]$Photo_Neg_Pos, hdata[-hperr, ]$Photo_Neg_Pos)$p.value
```

```
## [1] 0.8118441
```

```r
t.test(hdata[hperr, ]$Weave_Neg_Pos, hdata[-hperr, ]$Weave_Neg_Pos)$p.value
```

```
## [1] 0.8920258
```
Conclusion is we can include the recods from the printing error, as none of the
emotional intensity or neg_pos values were significantly different in the population
with the printing error and the population without the printing error.              

### Add insights gained from Statistical Analysis
Correct for FirstViewed bias - statistical analysis shows that 
Weave_Pos_Neg should be adjusted if FirstViewed = Weave in both
Pittsburgh and Houston

```r
pAdj_Neg_Pos <- pdata[pdata$FirstViewed == "Weave", ]$Weave_Neg_Pos - 1
pAdj_Neg_Pos[pAdj_Neg_Pos < 0 & !is.na(pAdj_Neg_Pos)] <- 0
pdata$Weave_Adj_Neg_Pos <- pdata$Weave_Neg_Pos
pdata[pdata$FirstViewed == "Weave", ]$Weave_Adj_Neg_Pos <- pAdj_Neg_Pos
hAdj_Neg_Pos <- hdata[hdata$FirstViewed == "Weave", ]$Weave_Neg_Pos - 1
hAdj_Neg_Pos[hAdj_Neg_Pos < 0 & !is.na(hAdj_Neg_Pos)] <- 0
hdata$Weave_Adj_Neg_Pos <- hdata$Weave_Neg_Pos
hdata[hdata$FirstViewed == "Weave", ]$Weave_Adj_Neg_Pos <- hAdj_Neg_Pos
```

Merge Photo and Weave words that are similar.  In some cases I had to go to
the detailed reactions on the survey to interpret the word.  wordmap.csv
contains the relevant mappings

```r
wordmap <- read.csv("rawdata/wordmap.csv", stringsAsFactors = FALSE)
pdata$Adj_Photo_Word <- pdata$Photo_Word
ppidx <- pdata[pdata$Photo_Word %in% wordmap$baseword, ]$ID
for (i in ppidx) {
  pdata[i, "Adj_Photo_Word"] <- wordmap[wordmap$baseword == 
                                        pdata[i, "Photo_Word"], "adjword"]
}
pdata$Adj_Weave_Word <- pdata$Weave_Word
pwidx <- pdata[pdata$Weave_Word %in% wordmap$baseword, ]$ID
for (i in pwidx) {
  pdata[i, "Adj_Weave_Word"] <- wordmap[wordmap$baseword == 
                                        pdata[i, "Weave_Word"], "adjword"]
}
hdata$Adj_Photo_Word <- hdata$Photo_Word
hpidx <- hdata[hdata$Photo_Word %in% wordmap$baseword, ]$ID
for (i in hpidx) {
  hdata[i, "Adj_Photo_Word"] <- wordmap[wordmap$baseword == 
                                        hdata[i, "Photo_Word"], "adjword"]
}
hdata$Adj_Weave_Word <- hdata$Weave_Word
hwidx <- hdata[hdata$Weave_Word %in% wordmap$baseword, ]$ID
for (i in hwidx) {
  hdata[i, "Adj_Weave_Word"] <- wordmap[wordmap$baseword == 
                                        hdata[i, "Weave_Word"], "adjword"]
}
```

Reduce the data set the positive and negative reactions, plus age factors
for use in graphic visualisations (again based on statistical factor analysis)

```r
pgrdata <- pdata[, c("Weave_Adj_Neg_Pos", "Photo_Neg_Pos", "Age", 
                     "Adj_Photo_Word", "Adj_Weave_Word")]
pgrdata <- pgrdata[!is.na(pgrdata$Weave_Adj_Neg_Pos), ]
pgrdata <- pgrdata[!is.na(pgrdata$Photo_Neg_Pos), ]
pgrdata <- pgrdata[!is.na(pgrdata$Age), ]
pgrdata$Weave_Minus_Photo <- pgrdata$Weave_Adj_Neg_Pos - pgrdata$Photo_Neg_Pos
pgrdata$Age_Breakpoint <- as.factor(ifelse(pgrdata$Age < 50, "Under50", "50+")) 

hgrdata <- hdata[, c("Weave_Adj_Neg_Pos", "Photo_Neg_Pos", "Age", 
                     "Adj_Photo_Word", "Adj_Weave_Word")]
hgrdata <- hgrdata[!is.na(hgrdata$Weave_Adj_Neg_Pos), ]
hgrdata <- hgrdata[!is.na(hgrdata$Photo_Neg_Pos), ]
hgrdata <- hgrdata[!is.na(hgrdata$Age), ]
hgrdata$Weave_Minus_Photo <- hgrdata$Weave_Adj_Neg_Pos - hgrdata$Photo_Neg_Pos
hgrdata$Age_Breakpoint <- as.factor(ifelse(hgrdata$Age < 30, "Under30", "30+"))
```


### Data processing is complete
pdata and hdata are used by the statistical analysis
pgrdata and hgrdata are used for the visualizations

```r
str(pdata)
```

```
## 'data.frame':	396 obs. of  19 variables:
##  $ ID               : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ FirstViewed      : Factor w/ 2 levels "Photo","Weave": 1 1 1 1 1 1 1 1 1 1 ...
##  $ Photo_Word       : chr  "beauty" "caring" "crackle" "concern" ...
##  $ Photo_Intensity  : num  6 8 6 7 7 8 7 6 8 5 ...
##  $ Photo_Neg_Pos    : num  3 6 5 3 7 0 7 3 3 7 ...
##  $ Weave_Word       : chr  "disappointed" "confused" "clean" "fear" ...
##  $ Weave_Intensity  : num  7 7 1 7 6 8 7 8 9 7 ...
##  $ Weave_Neg_Pos    : num  1 9 5 1 4 0 7 3 2 4 ...
##  $ Art              : Factor w/ 2 levels "Yes","No": 1 2 1 2 1 1 2 2 1 2 ...
##  $ Science          : Factor w/ 2 levels "Yes","No": 1 1 2 1 1 2 1 2 1 2 ...
##  $ Photography      : Factor w/ 2 levels "Yes","No": 1 1 1 2 1 2 2 2 1 1 ...
##  $ Weaving          : Factor w/ 2 levels "Yes","No": 2 1 2 2 1 1 2 2 2 2 ...
##  $ Age              : int  NA 23 38 25 33 60 36 21 23 61 ...
##  $ Gender           : Factor w/ 2 levels "Male","Female": 2 2 1 2 2 2 1 2 2 2 ...
##  $ Education        : Factor w/ 9 levels "Gr1-5","Gr6-8",..: 7 7 8 7 7 8 8 7 8 7 ...
##  $ AgeRange         : Factor w/ 10 levels "Child","Teenage",..: NA 3 4 3 4 7 4 3 3 7 ...
##  $ Weave_Adj_Neg_Pos: num  1 9 5 1 4 0 7 3 2 4 ...
##  $ Adj_Photo_Word   : chr  "beauty" "caring" "crackle" "concerned" ...
##  $ Adj_Weave_Word   : chr  "disappointed" "confused" "clean" "fear" ...
```

```r
str(pgrdata)
```

```
## 'data.frame':	350 obs. of  7 variables:
##  $ Weave_Adj_Neg_Pos: num  9 5 1 4 0 7 3 2 4 5 ...
##  $ Photo_Neg_Pos    : num  6 5 3 7 0 7 3 3 7 3 ...
##  $ Age              : int  23 38 25 33 60 36 21 23 61 39 ...
##  $ Adj_Photo_Word   : chr  "caring" "crackle" "concerned" "sad" ...
##  $ Adj_Weave_Word   : chr  "confused" "clean" "fear" "curious" ...
##  $ Weave_Minus_Photo: num  3 0 -2 -3 0 0 0 -1 -3 2 ...
##  $ Age_Breakpoint   : Factor w/ 2 levels "50+","Under50": 2 2 2 2 1 2 2 2 1 2 ...
```

```r
str(hdata)
```

```
## 'data.frame':	428 obs. of  19 variables:
##  $ ID               : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ FirstViewed      : Factor w/ 2 levels "Photo","Weave": 1 1 1 1 1 1 1 1 1 1 ...
##  $ Photo_Word       : chr  "warmth" "sad" "intrigued" "content" ...
##  $ Photo_Intensity  : num  7 7 6 7 6 8 5 7 8 5 ...
##  $ Photo_Neg_Pos    : num  9 7 8 5 7 8 5 9 8 3 ...
##  $ Weave_Word       : chr  "awed" "curious" "stark" "intrigue" ...
##  $ Weave_Intensity  : num  8 5 8 8 5 6 3 9 9 7 ...
##  $ Weave_Neg_Pos    : num  3 7 4 4 5 7 4 2 4 5 ...
##  $ Art              : Factor w/ 2 levels "Yes","No": 1 2 2 1 2 1 1 2 2 1 ...
##  $ Science          : Factor w/ 2 levels "Yes","No": 2 1 2 2 2 1 1 1 2 1 ...
##  $ Photography      : Factor w/ 2 levels "Yes","No": 1 2 1 2 2 2 1 2 1 1 ...
##  $ Weaving          : Factor w/ 2 levels "Yes","No": 2 2 2 2 2 2 2 2 2 1 ...
##  $ Age              : int  77 26 38 29 42 21 23 56 46 51 ...
##  $ Gender           : Factor w/ 2 levels "Male","Female": 2 2 2 2 1 2 2 2 1 2 ...
##  $ Education        : Factor w/ 9 levels "Gr1-5","Gr6-8",..: 7 7 7 8 7 7 7 7 5 8 ...
##  $ AgeRange         : Factor w/ 10 levels "Child","Teenage",..: 8 3 4 3 5 3 3 6 5 6 ...
##  $ Weave_Adj_Neg_Pos: num  3 7 4 4 5 7 4 2 4 5 ...
##  $ Adj_Photo_Word   : chr  "warmth" "sad" "intrigued" "content" ...
##  $ Adj_Weave_Word   : chr  "awe" "curious" "stark" "intrigued" ...
```

```r
str(hgrdata)
```

```
## 'data.frame':	357 obs. of  7 variables:
##  $ Weave_Adj_Neg_Pos: num  3 7 4 4 5 7 4 2 4 5 ...
##  $ Photo_Neg_Pos    : num  9 7 8 5 7 8 5 9 8 3 ...
##  $ Age              : int  77 26 38 29 42 21 23 56 46 51 ...
##  $ Adj_Photo_Word   : chr  "warmth" "sad" "intrigued" "content" ...
##  $ Adj_Weave_Word   : chr  "awe" "curious" "stark" "intrigued" ...
##  $ Weave_Minus_Photo: num  -6 0 -4 -1 -2 -1 -1 -7 -4 2 ...
##  $ Age_Breakpoint   : Factor w/ 2 levels "30+","Under30": 1 2 1 2 1 2 2 1 1 1 ...
```
