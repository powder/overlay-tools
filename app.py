from flask import Flask, jsonify, render_template_string
from character import Character

app = Flask(__name__)

# Initialize our character instance
# For a real application, you might load this from a database or session
player_character = Character(name="StreamPet")

@app.route('/character/state')
def character_state():
    """
    Backend route to provide the character's current state.
    """
    player_character.update_state() # Update state before sending
    return jsonify(player_character.get_state())

@app.route('/character/view')
def character_view():
    """
    Frontend route to display the character.
    This will fetch data from /character/state using JavaScript.
    """
    # Basic HTML structure for now.
    # JavaScript will be added later to fetch and display data.
    return render_template_string("""
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Character Viewer</title>
        <style>
            body { font-family: sans-serif; margin: 20px; background-color: #f0f0f0; color: #333; }
            #character-info { padding: 15px; background-color: #fff; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
            h1 { color: #5a5a5a; }
            pre { background-color: #e9e9e9; padding: 10px; border-radius: 4px; white-space: pre-wrap; word-wrap: break-word; }
        </style>
    </head>
    <body>
        <h1>Character State</h1>
        <div id="character-info">
            <p>Loading character state...</p>
        </div>

        <script>
            async function fetchCharacterState() {
                try {
                    const response = await fetch('/character/state');
                    if (!response.ok) {
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }
                    const state = await response.json();
                    displayCharacterState(state);
                } catch (error) {
                    console.error("Could not fetch character state:", error);
                    document.getElementById('character-info').innerHTML = "<p>Error loading character state.</p>";
                }
            }

            function displayCharacterState(state) {
                const infoDiv = document.getElementById('character-info');
                let htmlContent = `<h2>${state.name} (Level ${state.stats.level})</h2>`;
                htmlContent += `<p><strong>Action:</strong> ${state.current_action}</p>`;
                htmlContent += `<p><strong>Scene:</strong> ${state.current_scene}</p>`;
                if (state.current_action === 'fighting' && state.enemy_sprite) {
                    htmlContent += `<p><strong>Fighting:</strong> ${state.enemy_sprite}</p>`;
                }
                htmlContent += '<h3>Stats:</h3><pre>' + JSON.stringify(state.stats, null, 2) + '</pre>';
                htmlContent += '<h3>Equipment:</h3><pre>' + JSON.stringify(state.equipment, null, 2) + '</pre>';
                infoDiv.innerHTML = htmlContent;
            }

            // Fetch state when page loads
            fetchCharacterState();

            // Set an interval to refresh the state every 3 seconds (3000 milliseconds)
            setInterval(fetchCharacterState, 3000);
        </script>
    </body>
    </html>
    """)

if __name__ == '__main__':
    app.run(debug=True)
