import pytest

from unique_names_generator import get_random_name


class TestGenerator:
    def test_get_random_name(self):
        FIRST_NAME = ["Satoshi"]
        LAST_NAME = ["Nakamoto"]

        assert get_random_name(combos=[[FIRST_NAME, LAST_NAME]], separator="") == "satoshinakamoto"
        assert get_random_name(combos=[[FIRST_NAME]], style="uppercase") == "SATOSHI"
        assert get_random_name(combos=[[FIRST_NAME, LAST_NAME]], separator="_", style="lowercase") == "satoshi_nakamoto"

    def test_get_random_name_empty_combo(self):
        with pytest.raises(Exception) as excinfo:
            get_random_name(combos=[])
        assert "combos cannot be empty" in str(excinfo.value)
