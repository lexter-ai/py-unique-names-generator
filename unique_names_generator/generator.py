import random
from typing import List

from unique_names_generator.data import LEX_ADJETIVOS, LEX_SUBSTANTIVOS, LEX_VERBOS, STAR_WARS

combo1 = [STAR_WARS, LEX_ADJETIVOS]
combo2 = [STAR_WARS, LEX_VERBOS, LEX_SUBSTANTIVOS]


def get_random_name(
    combos: List[List[str]] = [combo1, combo2],
    separator: str = "_",
    style: str = "lowercase",
):
    if not combos:
        raise Exception("combos cannot be empty")

    combo = random.choice(combos)

    random_name = []
    for word_list in combo:
        part_name = random.choice(word_list)
        if style == "capital":
            part_name = part_name.capitalize()
        if style == "lowercase":
            part_name = part_name.lower()
        if style == "uppercase":
            part_name = part_name.upper()
        random_name.append(part_name)
    return separator.join(random_name)
