import pandas as pd
import numpy as np


def lambda_handler(event, context):
    df = pd.DataFrame(
        {
            "my_dimension": ["foo", "boo"],
            "measure": [1.0, 1.1],
        }
    )
    df2 = pd.DataFrame(
        np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]]), columns=["a", "b", "c"]
    )
    return {
        "statusCode": 200,
        "df": df.to_json(),
        "df2": df2.to_json(),
    }


if __name__ == "__main__":
    df = lambda_handler({}, {})
    print(df)
