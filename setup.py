import os

themes = ["orzklv", "shahruz"]

tpm_path = "~/.config/tmux/plugins/tpm"

p = os.path


def configure(index):
    os.system(f"cp {themes[index]}/* ~/.config -r")
    os.system("mkdir -p ~/.fonts")
    os.system("cp fonts/* ~/.fonts -r")
    os.system("cp dunst tmux wallpaper.jpg ~/.config -r")
    if (p.exists(p.expanduser(tpm_path))):
        os.system(f"rm -rf {tpm_path}")
    os.system(f"git clone https://github.com/tmux-plugins/tpm {tpm_path}")


theme_question = ""
for index, element in enumerate(themes):
    theme_question += f"[{index}] {element}        "

try:
    print("Which theme do you want to install?\n")
    print(theme_question)

    theme_index = int(input("Enter theme index: "))
    if theme_index >= len(themes):
        print(f"\nEnter only 1..{len(themes)}!")
        exit()

    packages = ""
    with open(f"{themes[theme_index]}/requirements.txt", "r") as file:
        lines = file.readlines()
        for line in lines:
            packages += line.strip() + " "

    if len(packages) > 0:
        os.system(f"sudo pacman -S {packages}")
        configure(theme_index)

except ValueError:
    print(f"Enter only 0..{len(themes)-1}")

except FileNotFoundError as e:
    print(f"\n{e.filename} not found!")
