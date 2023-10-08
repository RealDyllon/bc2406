import os
import csv

def get_simulated_rows():
    rows = []
    print("get_simulated_rows - Current Working Directory:", os.getcwd())
    with open('../data/7/DRAWN_00001.csv', 'r') as csv_file:
        csv_reader = csv.DictReader(csv_file)
        for row in csv_reader:
            rows.append(row)
    while True:
        for row in rows:
            yield row


            