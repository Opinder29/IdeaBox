import streamlit as st
from io import BytesIO
# from helpers import record_audio






import pyaudio
import json
from vosk import Model, KaldiRecognizer
import vosk
import pyaudio
import json
import os
from gtts import gTTS
import wave
from transformers import MarianMTModel, MarianTokenizer
import streamlit as st



model_path = "./vosk-model-en-us-0.42-gigaspeech"

# # Check if the model path exists
# if not os.path.exists(model_path):
#     print("Model path does not exist.")
# else:
#     try:
#         # Initialize the model
#         model = vosk.Model(model_path)
#         print("Model loaded successfully.")
#     except Exception as e:
#         print(f"Failed to create a model: {e}")

def record_audio(device_index=0, model_path="./vosk-model-en-us-0.42-gigaspeech"):
    """Records audio from the microphone, recognizes speech until 'stop' is detected, 
       and removes the final 'stop' word from the result."""
    # Initialize the recognizer model (make sure model_path points to your Vosk model)
    st.write("Loading model... please wait")
    # model = Model(model_path)

    # # Check if the model path exists
    if not os.path.exists(model_path):
        print("Model path does not exist.")
    else:
        try:
            # Initialize the model
            model = vosk.Model(model_path)
            st.write("Model loaded successfully.")
        except Exception as e:
            st.write(f"Failed to create a model: {e}")

    rec = KaldiRecognizer(model, 16000)
    
    # Initialize the audio stream
    # Initialize PyAudio
    p = pyaudio.PyAudio()

    # Get the number of audio input devices
    device_count = p.get_device_count()

    print("Available Audio Input Devices:")
    for i in range(device_count):
        info = p.get_device_info_by_index(i)
        if info['maxInputChannels'] > 0:  # Check if it's an input device
            print(f"Device {i}: {info['name']}")

    device_index = 1

    p = pyaudio.PyAudio()
    stream = p.open(format=pyaudio.paInt16,
                    channels=1,
                    rate=16000,
                    input=True,
                    input_device_index=device_index,
                    frames_per_buffer=8192)
    
    st.write(f"Using microphone: {p.get_device_info_by_index(device_index)['name']}")
    recognized_text = ""

    # Stream audio and recognize speech
    # st.info("Recording... Please speak now.")
    st.info("Listening for speech. Say 'Stop' to stop.")
    while True:
        data = stream.read(4096, exception_on_overflow=False)
        if rec.AcceptWaveform(data):
            result = json.loads(rec.Result())
            text = result.get("text", "")
            recognized_text += text + " "
            print(text)
            
            # Stop condition
            if "stop" in text.lower():
                st.write("Stop keyword detected. Stopping...")
                break

    # Clean up audio stream
    stream.stop_stream()
    stream.close()
    p.terminate()
    
    # Remove the final 'stop' word
    words = recognized_text.strip().split()
    if words and words[-1].lower() == "stop":
        words.pop()
        words.pop()
    

    # Speech to text
    cleaned_text = " ".join(words)
    st.write(f"Recorded: {cleaned_text}")

    # if rec.AcceptWaveform(cleaned_text):
    #     result = json.loads(rec.Result())
    #     recognized_text = result.get("text", "")

    # Convert recorded audio to text (Speech-to-Text)
    # try:
    #     src_text = speech_to_text(audio_data)  # Convert to text using your function
    #     st.write("Recognized Text:", src_text)
    # except Exception as e:
    #     st.error(f"Error: {e}")
    
    print("Recognized Text:", recognized_text)

    st.write("Recognized Text:", recognized_text)

    # Language options dictionary, mapping language names to translation model names and language codes
    language_options = {
        "French": ("Helsinki-NLP/opus-mt-en-fr", "fr"),
        "Spanish": ("Helsinki-NLP/opus-mt-en-es", "es")
    }

    st.header("Step 2: Translate Text")

    target_language = st.selectbox("Select target language:", list(language_options.keys()))

    if target_language and cleaned_text:
        model_name, lang_code = language_options[target_language]

        # translate_text
        tokenizer = MarianTokenizer.from_pretrained(model_name)
        model = MarianMTModel.from_pretrained(model_name)
        
        # Tokenize the source text and generate the translation
        translated = model.generate(**tokenizer(recognized_text, return_tensors="pt", padding=True))
        
        # Decode and return the translated text
        tgt_text = tokenizer.decode(translated[0], skip_special_tokens=True)

        # translation = translate_text(cleaned_text, model_name)  # Translate using your function
        st.write("Translated Text:", tgt_text)

        # Step 3: Text-to-Speech
        st.header("Step 3: Play Translated Speech")
        audio_fp = text_to_speech(translation, lang_code)  # Convert to speech using your function

        tts = gTTS(text=text, lang=language_code)
    
        # Save audio to an in-memory file
        audio_fp = BytesIO()
        tts.write_to_fp(audio_fp)
        audio_fp.seek(0)  # Reset file pointer to the beginning
        st.audio(audio_fp, format="audio/mp3")
    
    
    return cleaned_text  # Return the cleaned recognized text












# Assuming the following functions exist and are directly callable:
# - record_audio() -> records English audio and returns audio data
# - speech_to_text(audio_data) -> converts recorded audio to text
# - translate_text(src_text, target_language_model) -> translates text to the desired language
# - text_to_speech(text, language_code) -> converts text to speech and returns audio file



# Streamlit GUI setup
st.title("Multilingual Audio Translator")

# Step 1: Record Audio
st.header("Step 1: Record English Audio")
if st.button("Start Recording"):
    audio_data = record_audio()  # Use your function to record audio
    st.success("Recording complete.")
    
    # Convert recorded audio to text (Speech-to-Text)
    # try:
    #     src_text = speech_to_text(audio_data)  # Convert to text using your function
    #     st.write("Recognized Text:", src_text)
    # except Exception as e:
    #     st.error(f"Error: {e}")

    # Step 2: Choose Translation Language
    # st.header("Step 2: Translate Text")
    # target_language = st.selectbox("Select target language:", list(language_options.keys()))
    
    # if target_language and src_text:
    #     model_name, lang_code = language_options[target_language]
    #     translation = translate_text(src_text, model_name)  # Translate using your function
    #     st.write("Translated Text:", translation)

    #     # Step 3: Text-to-Speech
    #     st.header("Step 3: Play Translated Speech")
    #     audio_fp = text_to_speech(translation, lang_code)  # Convert to speech using your function
    #     st.audio(audio_fp, format="audio/mp3")