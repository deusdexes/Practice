using UnityEngine;
using System;

namespace FitnessApp.Gacha
{
    public class CurrencyManager : MonoBehaviour
    {
        public static CurrencyManager Instance { get; private set; }

        public static event Action<int> OnCurrencyChanged;

        [SerializeField] private int currentCurrency = 0;

        private void Awake()
        {
            if (Instance == null)
            {
                Instance = this;
                LoadData();
            }
            else Destroy(gameObject);
        }

        public int GetBalance() => currentCurrency;

        public void AddCurrency(int amount)
        {
            currentCurrency += amount;
            OnCurrencyChanged?.Invoke(currentCurrency);
            PlayerPrefs.SetInt("UserCurrency", currentCurrency);
            PlayerPrefs.Save();
        }

        public bool SpendCurrency(int amount)
        {
            if (currentCurrency >= amount)
            {
                currentCurrency -= amount;
                OnCurrencyChanged?.Invoke(currentCurrency);
                PlayerPrefs.SetInt("UserCurrency", currentCurrency);
                PlayerPrefs.Save();
                return true;
            }
            return false;
        }

        public void LoadData()
        {
            currentCurrency = PlayerPrefs.GetInt("UserCurrency", 0);
        }
    }
}
