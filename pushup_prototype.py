import math

class PushUpDetector:
    def __init__(self, threshold_angle=90, up_threshold=160):
        self.threshold_angle = threshold_angle # Angle at which we consider "down"
        self.up_threshold = up_threshold       # Angle at which we consider "up"
        self.count = 0
        self.direction = 0 # 0 for down, 1 for up

    def calculate_angle(self, a, b, c):
        """Calculates the angle between three points (landmarks)."""
        # a, b, c are (x, y) tuples
        angle = math.degrees(
            math.atan2(c[1] - b[1], c[0] - b[0]) -
            math.atan2(a[1] - b[1], a[0] - b[0])
        )
        angle = abs(angle)
        if angle > 180:
            angle = 360 - angle
        return angle

    def process(self, shoulder, elbow, wrist):
        angle = self.calculate_angle(shoulder, elbow, wrist)

        # Percentage of completion (0 to 100)
        per = 0 # Placeholder for more complex mapping

        # Check for the push-up
        if angle <= self.threshold_angle:
            if self.direction == 0:
                self.direction = 1 # Now moving up

        if angle >= self.up_threshold:
            if self.direction == 1:
                self.count += 1
                self.direction = 0 # Now moving down
                return True # Counted!

        return False

# Example usage/test
if __name__ == "__main__":
    detector = PushUpDetector()

    # Simulate a push-up
    # 1. Start standing (Straight arm)
    print(f"Start: {detector.process((0,0), (0,5), (0,10))}, Count: {detector.count}")

    # 2. Go down (Bent arm)
    print(f"Down: {detector.process((0,0), (2,2), (0,4))}, Count: {detector.count}")

    # 3. Go up (Straight arm)
    print(f"Up: {detector.process((0,0), (0,5), (0,10))}, Count: {detector.count}")
