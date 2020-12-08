import numpy as np
import pandas as pd
import joblib
import sys

import joblib
loaded_model = joblib.load('./ethML_server/models/cancer.sav')

arr = np.array([])

for i in range(1, len(sys.argv)):
  arr = np.append(arr, float(sys.argv[i]))

pred = loaded_model.predict(arr.reshape(1, -1))

print(int(pred[0]))
