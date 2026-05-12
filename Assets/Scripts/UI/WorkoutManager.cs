using UnityEngine;
using FitnessApp.Core;
using FitnessApp.Models;
using FitnessApp.Gacha;

namespace FitnessApp.UI
{
    public class WorkoutManager : MonoBehaviour
    {
        [SerializeField] private PushUpCounter counter;
        [SerializeField] private TrainerSO activeTrainer;

        private int sessionGoal = 10;

        private void OnEnable()
        {
            PushUpCounter.OnPushUpCounted += HandlePushUp;
        }

        private void OnDisable()
        {
            PushUpCounter.OnPushUpCounted -= HandlePushUp;
        }

        public void StartSession(int goal, TrainerSO trainer)
        {
            sessionGoal = goal;
            activeTrainer = trainer;
            counter.ResetSession();
            Debug.Log($"Session started with {trainer.trainerName}. Goal: {goal}");
        }

        private void HandlePushUp(int count)
        {
            if (count % 5 == 0)
            {
                activeTrainer.PlayEncouragement();
            }

            if (count >= sessionGoal)
            {
                EndSession();
            }
        }

        private void EndSession()
        {
            int reward = Mathf.FloorToInt(counter.CurrentCount * 10 * activeTrainer.xpMultiplier);
            CurrencyManager.Instance.AddCurrency(reward);
            Debug.Log($"Session complete! Earned {reward} currency.");
        }
    }
}
