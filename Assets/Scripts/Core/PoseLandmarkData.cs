using UnityEngine;

namespace FitnessApp.Core
{
    [System.Serializable]
    public struct Landmark
    {
        public float x;
        public float y;
        public float z;
        public float visibility;
    }

    [System.Serializable]
    public class PoseLandmarkData
    {
        // 0-32 landmarks as per MediaPipe Pose
        public Landmark[] landmarks;

        public Landmark GetLandmark(int index)
        {
            if (landmarks != null && index < landmarks.Length)
                return landmarks[index];
            return new Landmark();
        }

        // Key indices
        public const int LeftShoulder = 11;
        public const int RightShoulder = 12;
        public const int LeftElbow = 13;
        public const int RightElbow = 14;
        public const int LeftWrist = 15;
        public const int RightWrist = 16;
    }
}
