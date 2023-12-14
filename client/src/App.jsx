import { useState } from "react";
import "./styles/App.css";
import ApiClient from "./api/axios";

function App() {
  const [inputs, setInputs] = useState([""]);
  const [url_address, setUrlAddress] = useState("");

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

  const defineKeyForCssSelector = (string) => {
    const onlyWords = string.match(/[^\W_]+/)[0];

    if (string.includes("-")) {
      return onlyWords;
    }

    return onlyWords.replace(/([a-z])([A-Z])/g, "$1_$2").toLowerCase();
  };

  const mountFieldParams = () => {
    const hash = inputs.reduce((initialValue, string) => {
      const key = defineKeyForCssSelector(string);
      if (!(string[0] == '.')) {
        initialValue["meta"].push(string);
        return initialValue;
      }
      initialValue[key] = string;
      return initialValue;
    }, { meta: [] });

    return { "url": url_address, "fields": { ...hash } }
  };

  const handleScrapData = async (event) => {
    event.preventDefault();

    if (areInputsFilled) {
      try {
        const params = mountFieldParams();
        const response = await ApiClient().post("/scraper", params);
        const data = response.data;
        return data;
      } catch ({ response: { data } }) {
        const { message } = data.error;
        return message;
      }
    }
  };

  return (
    <>
      <form className="grid justify-items-center mt-10 mb-10">
        <div className="p-6 bg-white border border-gray-200 rounded-lg shadow hover:bg-gray-200 dark:bg-gray-200 dark:border-gray-200 dark:hover:bg-gray-200">
          <div className="group mt-3">
            <input
              id="url_address"
              name="url_address"
              type="text"
              value={url_address}
              className="field-inputs w-full"
              onChange={(event) => setUrlAddress(event.target.value)}
              required
            />
            <span className="highlight"></span>
            <span className="bar"></span>
            <label>URL address</label>
          </div>
          {inputs.map((input, index) => (
            <div key={index} className="flex group" id="fields">
              <input
                id="field"
                name="field"
                type="text"
                className="field-inputs"
                value={input}
                onChange={(event) => handleInputChange(index, event)}
                required
              />
              <span className="highlight"></span>
              <span className="bar"></span>
              <label>CSS Selector Field / Meta</label>
              <button
                type="button"
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
              onClick={(event) => handleScrapData(event)}
            >
              Start Scrap
            </button>
          </div>
          {}
        </div>
      </form>
    </>
  );
}

export default App;
