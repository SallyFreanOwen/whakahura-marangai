#########################

### Testing webscrape 

#########################

# Prep: packages

if (!("rvest" %in% installed.packages())) {
  install.packages("rvest")
  }
if (!("dplyr" %in% installed.packages())) {
  install.packages("dplyr")
  }
library(rvest) # (also installs xml2)
library(dplyr)

# Tell it what page to scrape

item1page <- "https://paperspast.natlib.govt.nz/newspapers/PBH19380602.2.27?query=flooding+marae&snippet=true#text-tab"

### recall to follow along live:
  # cmd option C shows the code of the site 

#<div class="content tabs-panel" id="text-tab" role="tabpanel" aria-labelledby="text-tab-label" aria-hidden="true">
#  <div itemprop="articleBody"><p>NGATIPOROU HUI</p><p>TRIBAL MONUMENTS NEXT WEEK’S CEREMONY MINISTER PARTICIPATING DELEGATIONS FROM NORTH</p><p>Ceremonies in connection with the opening of the Porourangi meetinghouse at Wai-o-matatini and the Mangahanea Hall, in Ruatoria, which were postponed owing to the Anzac Day floods, will take place on June 11 and 12, the dedication of these tribal monuments of the Ngatiporou furnishing the occasion for a notable gathering of Maoris and interested European representatives.</p><p>The Hon. F. Langstone, acting-Min-ister of Native Affairs, has arranged to return from a South Island tour in time to officiate at the opening of the Porourangi meeting-house, and also has consented to lay the foundation stone of the Lady Arihia Ngata Memorial Hall, which it is proposed to reconstruct on a new site.</p><p>It will be remembered that this beautiful dining-hall, which contained many fine examples of native art as features of its interior decoration, was erected as a memorial to the late Lady Arihia Ngata and her eldest son, Makarini Ngata, whose deaths in 1929 cast a deep gloom over the whole of the tribal connections. The hall was completed and opened in March, 1930, and had been the scene of many colourful functions from time to time in its short history.</p><p>Big Outlay Wasted</p><p>When owing to the erosion of steep country on the banks of the Wai-o-matatini Stream and to silting of the land round the <b class="highlightcolor">marae,</b> it was found necessary last year to remove Porourangi to another site nearby, the dining-hall also was given attention, its floor-level being raised to reduce the danger of <b class="highlightcolor">flooding.</b> This work, together with an extensive overhaul of the premises, had not long been completed when the disastrous flood on the eve of Anzac Day destroyed the building.</p><p>The Wai-o-matatini <b class="highlightcolor">marae</b> has been the scene of much activity since the end of April. Steps have been taken to protect Porourangi against <b class="highlightcolor">flooding</b> and consequent damage, and a new site has been chosen for the social hall, the foundations for the reconstructed building having been nearly completed.</p><p>Advce has . been received by Sir Apirana Ngata that representatives of the Manawatu, Wanganui, Taranaki, King Country, Waikato, Taupo, and Tauranga tribes are to converge on Rotorua on June 7 and 8, and probably will be joined by Arawa and Matatua tribal representatives en route to the East Coast. The Waikatos have suffered a great loss recently through the death of Tumate Mahuta, a younger brother of the late King Te Rata Mahuta, and an uncle of the present Maori king, Ko-, roki.</p><p>Visit of Maori King</p><p>King Koroki, accompanied by Princess te Puea and other members of his 1 family connection, will attend the ceremonies at Ruatoria and Wai-o-matatini, and subsequently will proceed to Wairoa to take part in the Carroll Memorial celebrations. It is understood that the Waikato and other tribal representatives are anxious to travel to the Waiapu via Te Kaha, in order to see the traditional landfall, at Whangaparoa, of the canoes in their long voyage from Hawaiki. The present precarious state of the roads, particularly between Hicks Bay and Tikitiki, however, may induce them to travel via the Waioeka and Gisborne. In that case, they will reach Gisborne on June 9. Ngatiporou Hospitality The Ngatiporou tribe, as hosts at both Mangahanea and Wai-o-matatini, through Sir Apirana Ngata, have asked the Herald to intimate to their European friends in the district from Gisborne northwards that they will be pleased to welcome them at both ceremonies. The Mangahanea Hall will be opened at 11 a.m. on Saturday, June 11, after which ceremony there will be a luncheon provided for all visitors, European and Maori. The opening ceremony will be preceded by welcomes to the visiting tribal representatives and to the Ministerial party, and hakas are in preparation to grace the occasion. In the afternoon, the Tainui Cup football match will take place in Ruatoria between Horouta (East Coast) and the Maniopoto team, from the King Country, the latter being the challengers.</p><p>The visitors will then concentrate at Wai-o-matatini, and the Ngatiporou will welcome the Ministerial party and Maori tribes there. On Sunday, June 12, after divine service which it is hoped will be conducted by the Bishop of Aotearoa, the Rt. Rev. F. A .Bennett, the opening of the Porourangi house will be undertaken by the Hon. F. Langstone, acting-Minister of Native Affairs, who also will lay the foundation stone of the reconstructed memorial hall which carries the name of the late Lady Arihia Ngata. Again the Ngatiporou will be pleased to welcome and entertain their pakeha friends on this day.</p></div>
#  <div class="article-message">This article text was automatically generated and may include errors. <a href="/newspapers/poverty-bay-herald/1938/06/02/4">View the full page</a> to see article in its original form.</div>
#</div>

item1 <- read_html(item1page)
item1
str(item1)

body_nodes <- item1 %>% 
  html_node("body")  %>% 
  html_children()
body_nodes


text1 <- item1 %>% 
  xml2::xml_find_all("//div[contains(@itemprop, 'articleBody')]") %>% 
  rvest::html_text()
text1

###### References

# Webscraping tutorial:
# https://towardsdatascience.com/tidy-web-scraping-in-r-tutorial-and-resources-ac9f72b4fe47