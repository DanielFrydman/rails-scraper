import { useState } from "react";
import "./styles/App.css";

function App() {
  const [inputs, setInputs] = useState([""]);

  const handleInputChange = (index, event) => {
    const newInputs = [...inputs];
    newInputs[index] = event.target.value;
    setInputs(newInputs);
  };

  const handleAddInput = () => {
    if (areInputsFilled) {
      setInputs([...inputs, ""]);
    }
  };

  const handleRemoveInput = (index) => {
    const newInputs = [...inputs];
    newInputs.splice(index, 1);
    setInputs(newInputs);
  };

  const areInputsFilled = inputs.every((input) => input.trim() !== "");

  const handleScrapeData = () => {
    // Lógica para web scraping
    // Exemplo: axios.post('/api/scrape', { inputs }).then(...);
    if (areInputsFilled) {
      console.log(inputs);
    }
  };

  return (
    <>
      <form className="grid justify-items-center mt-10">
        <div className="max-w-sm p-6 bg-white border border-gray-200 rounded-lg shadow hover:bg-gray-200 dark:bg-gray-200 dark:border-gray-200 dark:hover:bg-gray-200">
          <div className="group mt-3">
            <input id="url_address" name="url_address" type="text" required />
            <span className="highlight"></span>
            <span className="bar"></span>
            <label>URL address</label>
          </div>

          {inputs.map((input, index) => (
            <div key={index} className="group" id="fields">
              <input
                id="field"
                name="field"
                type="text"
                value={input}
                onChange={(event) => handleInputChange(index, event)}
                required
              />
              <span className="highlight"></span>
              <span className="bar"></span>
              <label>Field to extract</label>
              <button
                className="delete-icon"
                onClick={() => handleRemoveInput(index)}
              >
                X
              </button>
            </div>
          ))}

          <div className="flex justify-between button-div">
            <button
              className="bg-blue-500 w-32 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
              onClick={handleAddInput}
            >
              Add Field
            </button>
            <button
              className="bg-blue-500 w-32 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
              onClick={handleScrapeData}
            >
              Start Scrap
            </button>
          </div>

          {/* Renderize os resultados do scraping aqui */}
        </div>
      </form>
    </>
  );
}

export default App;


// componentes com pastas por componentes
// pasta de api
// criar index de componentes pra exportar tudo junto