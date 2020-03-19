# COVID19_undetected
Data on COVID19 cases observed outside of China. Includes Hubei and China travel history information.

# variables explained
repatriated	-- whether the case is from a repatriation flight from Wuhan. This doesn't include repatriates from the Diamond princess
date_report_dd_mm_yyyy	-- date which the case was reported in the press/ministry of health reports. there is usually a lag following admission to hospital and/or confirmation
country	-- country where the case is reported and confirmed. 
mode_of_transport_plain_train	-- if the case travelled from Wuhan, by which mode of transport did they travel.
travel_history_to_hubei_y_n	-- yes/no variable indicating whether that individual had any travel history to Hubei province
local_transmission_y_n		-- local transmission is defined as any transmission outside of China. 

# clarification point
If both travel history and local transmission variables are "n", this means that the case was imported from China but not from Hubei province. For some cases, it is known they are 
imported from China but not from where. In this case travel history would be noted as "unknown". 

