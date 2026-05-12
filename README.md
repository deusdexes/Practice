# Инструкция по запуску мобильного фитнес-приложения в Unity

Этот проект содержит архитектуру и логику для приложения по отслеживанию отжиманий с гача-механиками.

## Шаги по настройке в Unity

### 1. Создание проекта
* Создайте новый проект Unity (рекомендуется версия 2021.3 LTS или новее).
* Скопируйте папку `Assets` из этого репозитория в корень вашего проекта Unity.

### 2. Настройка сцены
1. **Managers**:
   * Создайте пустой GameObject с названием `_Managers`.
   * Добавьте на него компоненты:
     * `CurrencyManager`
     * `GachaManager`
     * `PushUpCounter`
     * `WorkoutManager`
2. **UI**:
   * Создайте `Canvas` (UI -> Canvas).
   * Добавьте пустой GameObject `UIController` и прикрепите к нему скрипт `MainMenuController`.
   * Привяжите элементы UI (Text для валюты, Image для портрета тренера) к соответствующим полям в `MainMenuController` через Инспектор.
3. **Камера**:
   * Убедитесь, что `Main Camera` имеет тег "MainCamera", так как `MainMenuController` меняет её цвет фона.

### 3. Создание Тренеров (ScriptableObjects)
1. В окне Project перейдите в `Assets/Resources/Trainers`.
2. Нажмите правой кнопкой мыши -> **Create -> FitnessApp -> Trainer**.
3. Создайте несколько тренеров (например, "Лояльный тренер", "Суровый тренер").
4. Настройте их параметры:
   * **Rarity**: Common, Rare и т.д.
   * **Loyalty Factor**: от 0 (суровый) до 1 (добрый).
   * **Primary Color**: цвет фона приложения при выборе этого тренера.
5. Перетащите созданных тренеров в список `All Trainers` компонента `GachaManager` на сцене.

### 4. Интеграция MediaPipe
Для работы реального трекинга через камеру:
1. Рекомендуется использовать [MediaPipe Unity Plugin](https://github.com/homuler/MediaPipeUnityPlugin).
2. Настройте получение Landmark-ов из плагина и передавайте их в метод `PushUpCounter.ProcessPose(PoseLandmarkData data)`.
3. В текущей версии `PushUpCounter.cs` реализована упрощенная эвристика. Для высокой точности используйте логику из `pushup_prototype.py`.

### 5. Тестирование
* Вы можете имитировать нажатие "носом" по кнопке, вызывая метод `PushUpCounter.ManualIncrement()`.
* За выполнение нормы (session goal) в `WorkoutManager` начисляется валюта, которую можно тратить в `GachaManager`.

## Структура папок
* `Assets/Scripts/Models`: Базовые классы и ScriptableObjects.
* `Assets/Scripts/Core`: Логика подсчета и обработки данных.
* `Assets/Scripts/Gacha`: Экономика и лутбоксы.
* `Assets/Scripts/UI`: Управление экранами и отображением.
