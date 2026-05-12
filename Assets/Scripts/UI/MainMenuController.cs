using UnityEngine;
using UnityEngine.UI;
using FitnessApp.Models;
using FitnessApp.Gacha;

namespace FitnessApp.UI
{
    public class MainMenuController : MonoBehaviour
    {
        [Header("UI Elements")]
        [SerializeField] private Text currencyText;
        [SerializeField] private Image trainerPortrait;
        [SerializeField] private Text trainerNameText;

        [Header("Data")]
        [SerializeField] private TrainerSO currentTrainer;

        private void Start()
        {
            CurrencyManager.OnCurrencyChanged += UpdateCurrencyUI;
            if (CurrencyManager.Instance != null)
            {
                UpdateCurrencyUI(CurrencyManager.Instance.GetBalance());
            }
            UpdateUI();
        }

        public void OnGachaButton()
        {
            // Assuming we have a GachaManager in the scene
            GachaManager gacha = FindFirstObjectByType<GachaManager>();
            TrainerSO newTrainer = gacha.PullTrainer();

            if (newTrainer != null)
            {
                SetTrainer(newTrainer);
            }
        }

        public void SetTrainer(TrainerSO trainer)
        {
            currentTrainer = trainer;
            UpdateUI();
        }

        private void UpdateCurrencyUI(int amount)
        {
            if (currencyText != null)
                currencyText.text = $"Coins: {amount}";
        }

        private void UpdateUI()
        {
            if (currentTrainer != null)
            {
                if (trainerPortrait != null) trainerPortrait.sprite = currentTrainer.portrait;
                if (trainerNameText != null) trainerNameText.text = currentTrainer.trainerName;

                // Set theme colors based on trainer
                Camera.main.backgroundColor = currentTrainer.primaryColor;
            }
        }
    }
}
