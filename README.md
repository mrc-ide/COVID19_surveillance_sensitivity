# COVID19_undetected
Data on COVID19 cases observed outside of China. Includes Hubei and China travel history information.

# variables explained
repatriated	-- whether the case is from a repatriation flight from Wuhan. This doesn't include repatriates from the Diamond princess
date_report_dd_mm_yyyy	-- date which the case was reported in the press/ministry of health reports. there is usually a lag following admission to hospital and/or confirmation
country	-- country where the case is reported and confirmed. 
mode_of_transport_plain_train	-- if the case travelled from Wuhan, by which mode of transport did they travel.
travel_history_to_hubei_y_n	-- yes/no variable indicating whether that individual had any travel history to Hubei province
local_transmission_y_n		-- local transmission is defined as any transmission outside of China. 

# Clarification
If both travel history and local transmission variables are "n", this means that the case was imported from China but not from Hubei province. For some cases, it is known they are 
imported from China but not from where. In this case travel history would be noted as "unknown". 

# Running the analysis

To reproduce the analysis, first clone or download this
repository. Navigate to the downloaded repository on your computer. 
To process the list of exported cases, in a new R session, source the
R script `data_processing.R`.

```
source('data_processing.R')
```

This will read the file `exported_cases.csv`, and aggregate the
rows into a list of cases detected overseas (see Methods in the main
text). Then, use rmarkdown to render the file `analysis.Rmd`.

```
rmarkdown::render('analysis.Rmd')
```

This analysis uses a list of "reference" countries (see
Methods). Reference countries can be
changed by editing the object called `possible_ref_countries` (Line
49). We then read in data on the volume of air travel between
countries. Our analysis relied on data from IATA, which cannot be
shared publicly. We have instead provided a file with the same
structure as used for our work, but with dummy numbers.

Finally, the data on exported cases is matched with travel volume data
and used to estimate the surveillance sensitivity as described in the paper.
The likelihood function (called `likelihood`) is implemented in the
file `likelihood.R`. 
