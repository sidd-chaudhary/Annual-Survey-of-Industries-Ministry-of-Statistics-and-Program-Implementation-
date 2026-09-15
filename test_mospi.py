import esankhyiki
import pandas as pd
import time


# 1. mapping years to classification years


year_classification = {}

for year in range(1992, 1998):
    year_classification[f"{year}-{str(year + 1)[-2:]}"] = "1987"

for year in range(1998, 2004):
    year_classification[f"{year}-{str(year + 1)[-2:]}"] = "1998"

for year in range(2004, 2008):
    year_classification[f"{year}-{str(year + 1)[-2:]}"] = "2004"

for year in range(2008, 2024):
    year_classification[f"{year}-{str(year + 1)[-2:]}"] = "2008"



# 2. wanted states/UTs


wanted_states = [
    "Andaman & Nicobar Islands",
    "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chandigarh",
    "Chattisgarh",
    "Dadra & Nagar Haveli",
    "Dadra & Nagar Haveli and Daman & Diu",
    "Daman & Diu",
    "Delhi",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jammu & Kashmir",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Ladakh",
    "Lakshadweep",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Puducherry",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttarakhand",
    "Uttar Pradesh",
    "West Bengal"
]



# 3. downloading data from MOSPI website


all_data = []

for year, classification in year_classification.items():

    print(f"\nDownloading {year} | Classification {classification}")

    page = 1

    while True:

        filters = {
            "classification_year": classification,
            "sector_code": "Combined",
            "year": year,
            "indicator_code": "1",
            "nic_type": "All",
            "limit": 10000,
            "page": page
        }

        try:

            data = esankhyiki.get_data(
                "ASI",
                filters,
                format="dict"
            )

            if not data:
                break

            # Keep only states/UTs from our list
            filtered_data = [
                row for row in data
                if row.get("state") in wanted_states
            ]

            all_data.extend(filtered_data)

            print(
                f"  Page {page}: "
                f"{len(data)} downloaded → "
                f"{len(filtered_data)} matching rows"
            )

            # Last page
            if len(data) < 10000:
                break

            page += 1

        except Exception as e:

            print(f"  ERROR: {e}")
            break

        time.sleep(0.5)



# 4. converting to pandas dataframe


df = pd.DataFrame(all_data)



# 5. rearranging columns


columns = [
    "nic_classification",
    "year",
    "state",
    "sector",
    "indicator",
    "nic_code",
    "nic_description",
    "nic_type",
    "value",
    "unit"
]

df = df[columns]


# 6. sorting by year, state, nic_type


df["_year_sort"] = pd.Categorical(
    df["year"],
    categories=list(year_classification.keys()),
    ordered=True
)

df = df.sort_values(
    ["_year_sort", "state", "nic_type"]
).drop(columns="_year_sort")



# 7. saving in excel format


output_file = "ASI_Number_of_Factories_All_States_1992-93_to_2023-24.xlsx"

df.to_excel(
    output_file,
    index=False
)


# 8. final checks


print("\n" + "=" * 70)
print("DONE!")
print("=" * 70)

print(f"Total rows: {len(df)}")
print(f"Total columns: {len(df.columns)}")
print(f"CSV file: {output_file}")

print("\nStates found:")
print(df["state"].value_counts().sort_index())

print("\nStates NOT found:")
found_states = set(df["state"].unique())

for state in wanted_states:
    if state not in found_states:
        print("-", state)