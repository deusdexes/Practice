using UnityEngine;
using System;

namespace FitnessApp.Core
{
    public enum InputMode
    {
        NoseTap,
        FitnessTracker,
        MediaPipeCamera
    }

    public class PushUpCounter : MonoBehaviour
    {
        public static event Action<int> OnPushUpCounted;

        private int currentCount = 0;
        private InputMode currentMode = InputMode.NoseTap;

        // MediaPipe state
        private bool isDown = false;
        private float pushUpThreshold = 0.5f; // Normalized depth

        public int CurrentCount => currentCount;

        public void SetMode(InputMode mode)
        {
            currentMode = mode;
        }

        public void ManualIncrement()
        {
            if (currentMode == InputMode.NoseTap)
            {
                CountPushUp();
            }
        }

        public void ProcessPose(PoseLandmarkData poseData)
        {
            if (currentMode != InputMode.MediaPipeCamera) return;

            // Simplified logic: compare shoulder height relative to wrists/elbows
            // In a real push-up, shoulders go down and up.
            var leftShoulder = poseData.GetLandmark(PoseLandmarkData.LeftShoulder);
            var rightShoulder = poseData.GetLandmark(PoseLandmarkData.RightShoulder);
            var avgShoulderY = (leftShoulder.y + rightShoulder.y) / 2f;

            // This is a simplified heuristic. In production, we'd use angles or relative distances.
            if (!isDown && avgShoulderY > 0.7f) // Assuming 0 is top, 1 is bottom
            {
                isDown = true;
            }
            else if (isDown && avgShoulderY < 0.4f)
            {
                isDown = false;
                CountPushUp();
            }
        }

        private void CountPushUp()
        {
            currentCount++;
            OnPushUpCounted?.Invoke(currentCount);
            Debug.Log($"Push-up counted! Total: {currentCount}");
        }

        public void ResetSession()
        {
            currentCount = 0;
        }
    }
}
