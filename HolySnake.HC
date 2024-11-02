// Snake Game in TempleOS (HolyC)

#include "std/Kernel.h"

const int WIDTH = 20, HEIGHT = 20;
int score = 0;

int snakeX[400], snakeY[400];
int snakeLength = 5;
int dirX = 1, dirY = 0;

int foodX, foodY;

void InitGame() {
    for (int i = 0; i < snakeLength; ++i) {
        snakeX[i] = WIDTH / 2 - i;
        snakeY[i] = HEIGHT / 2;
    }
    PlaceFood();
}

void PlaceFood() {
    foodX = Rand() % WIDTH;
    foodY = Rand() % HEIGHT;
}

void DrawGame() {
    ClrScr();

    for (int x = 0; x <= WIDTH; ++x) {
        PlotChar(x + 10, 1, '#', WHITE);
        PlotChar(x + 10, HEIGHT + 2, '#', WHITE);
    }
    for (int y = 0; y <= HEIGHT; ++y) {
        PlotChar(10, y + 2, '#', WHITE);
        PlotChar(WIDTH + 11, y + 2, '#', WHITE);
    }

    for (int i = 0; i < snakeLength; ++i) {
        PlotChar(snakeX[i] + 10, snakeY[i] + 2, 'O', GREEN);
    }

    PlotChar(foodX + 10, foodY + 2, '*', RED);

    PrintAt(0, 0, "Score: %d", score);
}

void MoveSnake() {
    for (int i = snakeLength - 1; i > 0; --i) {
        snakeX[i] = snakeX[i - 1];
        snakeY[i] = snakeY[i - 1];
    }
    snakeX[0] += dirX;
    snakeY[0] += dirY;
}

bool CheckCollision() {
    if (snakeX[0] < 0 || snakeX[0] >= WIDTH || snakeY[0] < 0 || snakeY[0] >= HEIGHT) {
        return TRUE;
    }
    for (int i = 1; i < snakeLength; ++i) {
        if (snakeX[0] == snakeX[i] && snakeY[0] == snakeY[i]) {
            return TRUE;
        }
    }
    return FALSE;
}

void CheckFood() {
    if (snakeX[0] == foodX && snakeY[0] == foodY) {
        snakeLength++;
        score += 10;
        PlaceFood();
    }
}

// main
void SnakeGame() {
    InitGame();
    bool gameRunning = TRUE;

    while (gameRunning) {
        switch (KeyPeek()) {
            case KEY_LEFT:
                if (dirX == 0) { dirX = -1; dirY = 0; }
                break;
            case KEY_RIGHT:
                if (dirX == 0) { dirX = 1; dirY = 0; }
                break;
            case KEY_UP:
                if (dirY == 0) { dirX = 0; dirY = -1; }
                break;
            case KEY_DOWN:
                if (dirY == 0) { dirX = 0; dirY = 1; }
                break;
        }

        MoveSnake();
        if (CheckCollision()) {
            PrintAt(0, 2, "Game Over! Final Score: %d", score);
            gameRunning = FALSE;
        } else {
            CheckFood();
            DrawGame();
        }

        // game speed, lower int = faster
        Wait(5);
    }
}