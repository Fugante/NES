from collections import defaultdict

with open("assets.asm", encoding="utf-8") as file:
    file.readline()
    rows = [r[7:-1].split(",") for r in file]
    rows = [rows[i] + rows[i+1] for i in range(0, len(rows), 2)]

attr_rows = rows[-2:]
rows = rows[:-2]
names = defaultdict(list[tuple[int, int]])
for r, row in enumerate(rows):
    for c, col in enumerate(row):
        if col != "$00":
            h = hex((32 * r) + c)[2:].rjust(4, "0")
            offset, lb = f"${h[:2]}", f"${h[2:]}"
            names[col].append((offset, lb))

with open("nametable.asm", "w", encoding="utf-8") as file:
    print("nametable:", file=file)
    for k, v in names.items():
        print(f"    .byte {k}", file=file)
        print(f"    .byte {hex(len(v)).replace("0x", "$")}", file=file)
        for offset, lb in v:
            print(f"    .byte {offset}, {lb}", file=file)
        print(file=file)
    print("    .byte $00", file=file)

attrs = [a for attrs in attr_rows for a in attrs]
attr_rows = []
row = []
for i, a in enumerate(attrs):
    if i % 8 == 0:
        if row:
            attr_rows.append(row)
        row = []
    row.append(a)
if row:
    attr_rows.append(row)

with open("attr_table.asm", "w", encoding="utf-8") as file:
    print("attr_table:", file=file)
    for attrs in attr_rows:
        print("    .byte  " + ", ".join(attrs), file=file)
