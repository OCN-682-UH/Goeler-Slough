# Goeler-Slough

### MBIO612 / OCN682: Data Science Fundamentals in R (**Fall 2026**)
___
#### About this Repository:  
This repository contains my work for **MBIO612/OCN682**, taken during Fall 2026 at the University of Hawai‘i at Mānoa.
Repository will be updated weekly with new homework & coursework.


#### Table of Contents:  
* [**Week 2**](https://github.com/OCN-682-UH/Goeler-Slough/tree/main/Week_02) 
  * First script, reading in 'weightdata.csv' with _here_ package
* [**Week 3**](https://github.com/OCN-682-UH/Goeler-Slough/tree/main/Week_03) 
  * Intro to plotting & ggplot, using data on penguins in Palmer Archipelago
* [**Week 4**](https://github.com/OCN-682-UH/Goeler-Slough/tree/main/Week_04) 
  * Data wrangling in dplyr and tidyr
* [**Week 5**](https://github.com/OCN-682-UH/Goeler-Slough/tree/main/Week_05) 
  * Data wrangling: joins and dates in lubridate
  * Fun advanced plotting (patchwork, ggrepel, gganimate, plotly, magick)
* [**Week 6**](https://github.com/OCN-682-UH/Goeler-Slough/tree/main/Week_06) 
  * Learning Quarto! [(Class Quarto practice)](https://01a0efa4-c52b-5da3-fffc-3a7358b1251a.share.connect.posit.cloud/)
  * Quarto [homework assignment](https://01a10f42-30ad-1820-a279-116196e5f62b.share.connect.posit.cloud/)
* [**Week 7**](https://github.com/OCN-682-UH/Goeler-Slough/tree/main/Week_07) 
  * Mapping: part 1, [in class](https://01a11e02-1709-3b25-0318-da5a5307a518.share.connect.posit.cloud/)
  * Mapping: part 2, [lecture](https://01a11e04-7eb2-d8c4-91cb-f9303b221942.share.connect.posit.cloud/)
  * Week 7 mapping [homework](https://01a11e57-60a2-1d23-90e7-bcd5fa105af7.share.connect.posit.cloud/)
* [**Week 8**](https://github.com/OCN-682-UH/Goeler-Slough/tree/main/Week_08) 
  * Functional programming [in class](https://01a14c46-0ec6-1ebe-bc8b-57dfb15a126f.share.connect.posit.cloud/)
  * Functions [homework](https://01a14c44-f3fa-8265-7bb8-aa4357853d08.share.connect.posit.cloud/)
* [**Good Plot Bad Plot**](https://github.com/OCN-682-UH/Goeler-Slough/tree/main/Goodplot_Badplot) 
  * Making worst and best plots using the same data: [quarto output](https://01a14d63-5487-da00-d55f-184f8405dc26.share.connect.posit.cloud/) 
  * I used the London Fire Brigade animal rescues dataset, taken from tidytuesday
* [**Week 9**](https://github.com/OCN-682-UH/Goeler-Slough/tree/main/Week_09)
  * Factors [lecture](https://01a16b18-39fe-3874-55d1-07481b55276e.share.connect.posit.cloud/)
  * Practicing factors [homework](https://01a16b16-c5e7-c4a3-f127-35cfaae824d0.share.connect.posit.cloud/)
* [**Week 10**](https://github.com/OCN-682-UH/Goeler-Slough/tree/main/Week_10)
  * Strings! (*stringr, regex, tidytext*) [class quarto](https://01a1e69b-8317-914e-6970-ffc0e8484c43.share.connect.posit.cloud/)
* [**Week 12**](https://github.com/OCN-682-UH/Goeler-Slough/tree/main/Week_12)
  * Shiny apps! Class manual app practice (histogram): [link](https://01a1e68a-874c-ed00-c49d-bb5cad9b85d1.share.connect.posit.cloud/)
  * Class app example using sea stars dataset: [link](https://01a1e68b-6e45-2154-020d-7b6eaa1e1833.share.connect.posit.cloud/)
  * Homework -- making a shiny app to investigate benthic composition: [link](https://01a1e75e-2470-f399-7ca5-38bc60fd7721.share.connect.posit.cloud/)

##### About me:
My name is Natalie Goeler-Slough, and I'm a second year Marine Biology PhD student in the 
[McDevitt-Irwin Lab](https://www.jamiemcdevittirwin.com/) at UH Mānoa! I study coral reef ecology and I love watching cleaner wrasse stations :)  


![Cleaner wrasse](https://marinelifephotography.com/fishes/puffers/arothron-meleagris-cleaner-2.jpg)  
_Image from Keoki Stender_

___
 
#### Repository Structure & Contents:

\*_some sections abbreviated for readability_
```text
├── Goodplot_Badplot
│   ├── Output
│   │   ├── badplot_animation.gif
│   │   ├── badplot_rescues_static.png
│   │   ├── dogcatlegend.png
│   │   ├── figure-html
│   │   │   ├── animated plot-1.gif
│   │   │   ├── badplot legend-1.png
│   │   │   ├── baseplot-1.png
│   │   │   ├── combined animated plot-1.gif
│   │   │   ├── combined animated plot-2.png
│   │   │   ├── combined static plots-1.png
│   │   │   ├── combining static plots-1.png
│   │   └── goodplot_badplot.html
│   └── Scripts
│       ├── goodplot_badplot_files
│       │   └── libs
│       ├── goodplot_badplot.qmd
│       └── rsconnect
├── README.html
├── README.md
├── Week_02
│   ├── Data
│   │   └── weightdata.csv
│   ├── Output
│   └── Scripts
│       └── Week_2_Script.R
└── Week_03
    ├── Output
    │   ├── penguin_plot_hw.png
    │   └── beyonce_penguin.png
    └── Scripts
        └── Week_3_Script.R
└── Week_04
    ├── Data
    │   ├── chem_data_dictionary.csv
    │   └── chemicaldata_maunalua.csv
    ├── Output
    │   ├── hw4a_penguin_plot.png
    │   ├── hw4b_biogeochemistry_plot.png
    │   ├── hw4b_summary.csv
    │   └── summary.csv
    └── Scripts
        ├── Week_4_Class.R
        ├── Week_4_Lecture.R
        ├── Week_4a_Homework.R
        └── Week_4b_Homework.R
└── Week_05
    ├── Data
    │   ├── CondData.csv
    │   ├── DepthData.csv
    │   ├── Topt_data.csv
    │   ├── data_dictionary.csv
    │   └── site.characteristics.data.csv
    ├── Output
    │   ├── penguin_animation.gif
    │   ├── penguinplot.png
    │   └── salinity_depth_plot_HW.png
    └── Scripts
        ├── Week_5_Class.R
        ├── Week_5_HW.R
        └── Week_5_Lecture.R
└── Week_06
    ├── Output
        ├── Week_6_Class.html
        ├── Week_6_HW.html
        ├── Week_6_Lecture.html
    └── Scripts
        ├── Week_6_Class.qmd
        ├── Week_6_HW.qmd
        ├── Week_6_Lecture.qmd
        └── rsconnect
└── Week_07
    ├── Data
        ├── CAPopdata.csv
        ├── chemicaldata_maunalua.csv
        ├── stars.csv
        └── tiles_cache
    └── Ouput
        ├── CApopstars.pdf
        ├── maunalua_map.pdf
        ├── Week_7_Class.html
        ├── Week_7_HW.html
        └── Week_7_Lecture.html     
    └── Scripts
        ├── rsconnect
        ├── Week_7_Class.qmd
        ├── Week_7_HW.qmd
        └── Week_7_Lecture.qmd
└── Week_08
    ├── Data
    │   ├── annotations.csv
    │   └── CoralNet_Labelset.csv
    ├── Output
    │   ├── class-figures-html
    │   ├── hw-figures-html
    │   ├── Week_8_Class.html
    │   └── Week_8_HW.html
    └── Scripts
        ├── rsconnect
        ├── Week_8_Class_files
        ├── Week_8_Class.qmd
        ├── Week_8_HW_files
        └── Week_8_HW.qmd
└── Week_09
    ├── Data
    │   ├── intertidal_data_dictionary.csv
    │   ├── intertidaldata_latitude.csv
    │   └── intertidaldata.csv
    ├── Output
    │   ├── hw-figure-html
    │   ├── lecture-figure-html
    │   ├── Week_9_HW.html
    │   └── Week_9_Lecture.html
    └── Scripts
        ├── rsconnect
        ├── Week_9_HW_files
        │   └── libs
        ├── Week_9_HW.qmd
        ├── Week_9_Lecture_files
        │   └── libs
        └── Week_9_Lecture.qmd
└── Week_10
    ├── Output
    │   └── Week_10_Class.html
    └── Scripts
        ├── rsconnect
        ├── Week_10_Class_files
        ├── Week_10_Class.qmd
        └── Week_10_HW.qmd
└── Week_12
    ├── Class_App_Manual
    │   ├── app.R
    │   └── rsconnect
    ├── Class_Stars_App
    │   ├── app.R
    │   ├── data
    │   │   └── stars.csv
    │   └── rsconnect
    └── Homework_App
        ├── app.R
        ├── data
        │   ├── annotations.csv
        │   └── CoralNet_Labelset.csv
        └── rsconnect
```

