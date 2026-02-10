import streamlit as st
import random
import time

st.set_page_config(page_title="Blind Date Shuffle", layout="centered")

# --- INITIALIZE SESSION STATE ---
if 'users' not in st.session_state:
    st.session_state.users = []
if 'matches' not in st.session_state:
    st.session_state.matches = {}

st.title("🎭 Anonymous Blind Dating")
st.subheader("No names. No faces. Just conversation.")

# --- STEP 1: JOINING ---
with st.sidebar:
    st.header("Join the Pool")
    name = st.text_input("Pick a Nickname (e.g., StarGazer)", max_chars=15)
    gender = st.selectbox("Your Gender", ["Male", "Female"])
    
    if st.button("Enter Lobby"):
        if name:
            user_data = {"name": name, "gender": gender}
            if user_data not in st.session_state.users:
                st.session_state.users.append(user_data)
                st.success(f"{name} joined!")

# --- STEP 2: THE MATCHMAKING ENGINE ---
def create_matches():
    males = [u for u in st.session_state.users if u['gender'] == "Male"]
    females = [u for u in st.session_state.users if u['gender'] == "Female"]
    
    random.shuffle(males)
    random.shuffle(females)
    
    # Create pairs based on the smaller list size
    new_matches = {}
    for m, f in zip(males, females):
        new_matches[m['name']] = f['name']
        new_matches[f['name']] = m['name']
    
    st.session_state.matches = new_matches

# --- STEP 3: THE INTERFACE ---
if st.session_state.users:
    st.write(f"Total Participants: {len(st.session_state.users)}")
    
    if st.button("🔀 SHUFFLE PAIRS"):
        create_matches()

    # Find the current user's match
    if name in st.session_state.matches:
        partner = st.session_state.matches[name]
        st.info(f"❤️ **{name}**, you have been matched with: **{partner}**")
        
        # Simple Chat Box
        chat_input = st.text_input("Send a message...")
        if chat_input:
            st.write(f"**You:** {chat_input}")
            st.caption("Timer starting... you have 3 minutes!")
    else:
        st.warning("Waiting for a match... We need more people of the opposite gender!")

else:
    st.write("The lobby is currently empty. Use the sidebar to join.")
