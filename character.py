import random

class Character:
    def __init__(self, name="Hero"):
        self.name = name
        self.stats = {
            "strength": 10,
            "dexterity": 10,
            "intelligence": 10,
            "health": 100,
            "max_health": 100,
            "mana": 50,
            "max_mana": 50,
            "level": 1,
            "experience": 0,
            "gold": 0,
        }
        self.equipment = {
            "ring_1": None,
            "ring_2": None,
            "belt": None,
            "amulet": None,
            "chest": None,
            "leggings": None,
            "boots": None,
            "headgear": None,
            "main_hand": None, # Added for completeness, though not in initial request
            "off_hand": None,  # Added for completeness
        }
        self.current_action = "idle" # Default action
        self.current_scene = "town" # Default scene
        self.enemy_sprite = None

    def get_state(self):
        """Returns the current state of the character for the API."""
        state = {
            "name": self.name,
            "stats": self.stats,
            "equipment": self.equipment,
            "current_action": self.current_action,
            "current_scene": self.current_scene,
        }
        if self.current_action == "fighting":
            state["enemy_sprite"] = self.enemy_sprite
        return state

    def _set_random_state(self):
        """Helper method to set a random action and scene for demonstration."""
        actions = ["walking", "running", "idle"]
        scenes = ["forest", "cave", "town", "mountain_pass", "ruins"]

        # 10% chance to be fighting
        if random.random() < 0.1:
            self.current_action = "fighting"
            possible_enemies = ["goblin_grunt", "orc_raider", "dire_wolf", "giant_spider", "skeleton_warrior"]
            self.enemy_sprite = random.choice(possible_enemies)
        else:
            self.current_action = random.choice(actions)
            self.enemy_sprite = None # Ensure no enemy if not fighting

        self.current_scene = random.choice(scenes)

    def update_state(self):
        """Updates the character's state, e.g., for the next frame of animation."""
        # For now, just set a random state.
        # Later, this could involve more complex logic (AI, player input, etc.)
        self._set_random_state()

# Example usage:
if __name__ == "__main__":
    player = Character(name="JulesTheBrave")
    print("Initial State:")
    print(player.get_state())

    print("\nUpdating state...")
    player.update_state()
    print("New State:")
    print(player.get_state())

    print("\nUpdating state again (chance of fighting)...")
    player.update_state()
    print("New State:")
    print(player.get_state())
