import numpy as np
import pandas as pd
import joblib
import sys

import joblib
loaded_model = joblib.load('./ethML_server/models/social_model.sav')
pred = loaded_model.predict(np.array([float(sys.argv[1]), float(sys.argv[2])]).reshape(1, -1))

print(pred)
