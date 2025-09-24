#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Sep 19 22:12:17 2025

@author: arjun-raf
"""
import pandas as pd
import matplotlib.pyplot as plt


def returnCase(caseStr):
    if caseStr == "CASE1":
        return "20000 x 2000"
    elif caseStr == "CASE2":
        return "2000 x 20000"
    elif caseStr == "CASE3":
        return "1000 x 400000"

# Read CSV file
df = pd.read_csv("/home/arjun-raf/Documents/SoSe2025/PTFS/PTfS-CAM-Project/codebalance.csv")

# Columns we want to plot
cb_columns = ["CB(applyStencil)", "CB(GSPreConF)", "CB(GSPreConB)"]

# Create subplots: 1 row, 3 columns
fig, axes = plt.subplots(1, 3, figsize=(15, 4), sharex=True)

# Loop over CB columns and corresponding subplot axis
for ax, col in zip(axes, cb_columns):
    for case, case_df in df.groupby("CASE"):
        ax.plot(case_df["Threads"], case_df[col], marker="o", label=returnCase(case))
    
    ax.set_title(col)
    ax.set_xlabel("Threads")
    ax.set_ylabel(col)
    ax.grid(True, alpha=0.2)

# Put legend outside the last subplot
axes[-1].legend(title="CASE", bbox_to_anchor=(1.05, 1), loc="upper left")

plt.tight_layout()
plt.show()


