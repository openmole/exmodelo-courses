library(tidyverse)
library(stringr)

panic0 <- read_csv("../profiles/panic0.csv") %>%
    select(value = panic0, fitness) %>%
    mutate(profile = "panic0")
staminaH <- read_csv("../profiles/staminaH.csv") %>%
    select(value = staminaH, fitness) %>%
    mutate(profile = "staminaH")
hunt0 <- read_csv("../profiles/hunt0.csv") %>%
    select(value = hunt0, fitness) %>%
    mutate(profile = "hunt0")
staminaZ <- read_csv("../profiles/staminaZ.csv") %>%
    select(value = staminaZ, fitness) %>%
    mutate(profile = "staminaZ")
inf0 <- read_csv("../profiles/inf0.csv") %>%
    select(value = inf0, fitness) %>%
    mutate(profile = "inf0")

all_profile <- panic0 %>%
    full_join(staminaH) %>%
    full_join(hunt0) %>%
    full_join(staminaZ) %>%
    full_join(inf0)

test <- all_profile %>%
    group_by(profile) %>%
    summarise_at("fitness", min) %>%
    left_join(all_profile)

plot_profile <- all_profile %>%
    filter(fitness < 1000000) %>%
    # mutate(sig = ifelse(fitness < 829550.5 + 1.92, T, F)) %>%
    ggplot(aes(x = value, y = fitness)) +
    geom_point() +
    geom_hline(yintercept = 829550.5 + 1.92, linetype = "dashed") +
    facet_wrap(~ profile, scales = "free") +
    theme_bw()
plot_profile
ggsave("../presentation/figures/profiles.png", plot_profile, width = 15, units = "cm")
