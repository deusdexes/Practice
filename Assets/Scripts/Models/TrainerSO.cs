using UnityEngine;

namespace FitnessApp.Models
{
    [CreateAssetMenu(fileName = "NewTrainer", menuName = "FitnessApp/Trainer")]
    public class TrainerSO : ScriptableObject
    {
        public string trainerName;
        public Rarity rarity;

        [TextArea(3, 10)]
        public string description;

        public Color primaryColor = Color.white;
        public Sprite portrait;

        // Character traits
        public float loyaltyFactor; // 0 = Harsh, 1 = Loyal
        public string catchphrase;

        // Gameplay impact
        public float restTimeModifier = 1.0f;
        public float xpMultiplier = 1.0f;

        public void PlayEncouragement()
        {
            if (loyaltyFactor > 0.7f)
            {
                Debug.Log($"{trainerName}: You're doing great! Keep it up!");
            }
            else if (loyaltyFactor < 0.3f)
            {
                Debug.Log($"{trainerName}: Is that all you've got? Move it!");
            }
            else
            {
                Debug.Log($"{trainerName}: Good progress. Focus on your form.");
            }
        }
    }
}
