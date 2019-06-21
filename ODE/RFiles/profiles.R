library(tidyverse)
library(stringr)

data <- read_csv("../profiles/staminaZ.csv")
plot_profile <- data %>%
    ggplot(aes(x = staminaZ, y = fitness)) +
    geom_point() +
    geom_hline(yintercept = 780394.4 + 1.92) +
    theme_bw()
plot_profile
ggsave("../presentation/figures/profile_staminaZ.png", plot_profile, width = 15, units = "cm")
