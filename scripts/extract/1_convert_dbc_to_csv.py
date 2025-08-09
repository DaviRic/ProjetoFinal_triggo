import os
import pandas as pd # type: ignore
import datasus_dbc # type: ignore
from dbfread import DBF # type: ignore

# Caminhos relativos a partir da raiz do projeto
input_folder = os.path.join("data", "raw")
output_folder = os.path.join("data", "converted")
os.makedirs(output_folder, exist_ok=True)

for file in os.listdir(input_folder):
    if file.lower().endswith(".dbc"):
        input_path = os.path.join(input_folder, file)
        temp_dbf = input_path.replace(".dbc", ".dbf")
        
        # Descompacta .dbc para .dbf temporário
        datasus_dbc.decompress(input_path, temp_dbf)

        # Lê o arquivo .dbf usando encoding latin-1
        df = pd.DataFrame(iter(DBF(temp_dbf, encoding="latin-1")))
        
        # Salva CSV em UTF-8 na pasta convertida
        output_path = os.path.join(output_folder, file.replace(".dbc", ".csv"))
        df.to_csv(output_path, index=False, encoding="utf-8")
        
        # Remove arquivo temporário .dbf
        os.remove(temp_dbf)
        
        print(f"Convertido: {file}")
