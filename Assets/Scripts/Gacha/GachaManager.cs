using UnityEngine;
using System.Collections.Generic;
using FitnessApp.Models;

namespace FitnessApp.Gacha
{
    public class GachaManager : MonoBehaviour
    {
        [SerializeField] private List<TrainerSO> allTrainers;
        [SerializeField] private int pullCost = 100;

        private HashSet<string> ownedTrainerNames = new HashSet<string>();

        private void Awake()
        {
            LoadOwnedTrainers();
        }

        public TrainerSO PullTrainer()
        {
            if (CurrencyManager.Instance.SpendCurrency(pullCost))
            {
                TrainerSO trainer = GetRandomTrainer();
                if (trainer != null)
                {
                    AddOwnedTrainer(trainer.trainerName);
                }
                return trainer;
            }
            Debug.Log("Not enough currency!");
            return null;
        }

        private TrainerSO GetRandomTrainer()
        {
            float roll = Random.value;
            Rarity targetRarity;

            if (roll < 0.01f) targetRarity = Rarity.Legendary;
            else if (roll < 0.05f) targetRarity = Rarity.Epic;
            else if (roll < 0.15f) targetRarity = Rarity.Rare;
            else if (roll < 0.40f) targetRarity = Rarity.Uncommon;
            else targetRarity = Rarity.Common;

            List<TrainerSO> pool = allTrainers.FindAll(t => t.rarity == targetRarity);

            // Fallback if pool is empty
            if (pool.Count == 0)
            {
                return allTrainers[Random.Range(0, allTrainers.Count)];
            }

            return pool[Random.Range(0, pool.Count)];
        }

        private void AddOwnedTrainer(string name)
        {
            if (!ownedTrainerNames.Contains(name))
            {
                ownedTrainerNames.Add(name);
                SaveOwnedTrainers();
            }
        }

        private void SaveOwnedTrainers()
        {
            string data = string.Join(",", ownedTrainerNames);
            PlayerPrefs.SetString("OwnedTrainers", data);
            PlayerPrefs.Save();
        }

        private void LoadOwnedTrainers()
        {
            string data = PlayerPrefs.GetString("OwnedTrainers", "");
            if (!string.IsNullOrEmpty(data))
            {
                ownedTrainerNames = new HashSet<string>(data.Split(','));
            }
        }
    }
}
