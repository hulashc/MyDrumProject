#making my drum app
#importing the pygame
import pygame
from pygame import mixer

pygame.init()

WIDTH = 1400
HEIGHT = 800 #play around with this res

black = (0, 0, 0)
white = (255, 255, 255)
grey = (128, 128, 128)
green = (0, 255, 0)
gold = (255, 215, 0)
blue = (0, 255, 255)

screen = pygame.display.set_mode([WIDTH, HEIGHT]) #should be tuple that why in [] brackets
pygame.display.set_caption('Beat maker')
lable_font = pygame.font.Font('freesansbold.ttf', 25)

fps = 60
timer = pygame.time.Clock()
beats = 8
instruments = 6
boxes = []
clicked =  [[-1 for _ in range(beats)] for _ in range(instruments)]
bpm = 240
playing = True
active_length = 0
active_beat = 1
beat_changed = True


def draw_grid(clicks, beat):
    left_box = pygame.draw.rect(screen, grey, (0, 0, 200, HEIGHT - 200), 5)
    bottom_box = pygame.draw.rect(screen, grey, (0, HEIGHT - 200, WIDTH, 200), 5)
    boxes = []
    colors = [grey, white, grey]
    hi_hat_text = lable_font.render('Hi-Hat', True, white)
    screen.blit(hi_hat_text, (30, 30))
    snare_text = lable_font.render('Snare', True, white)
    screen.blit(snare_text, (30, 130))
    kick_text = lable_font.render('Bass Drum', True, white)
    screen.blit(kick_text, (30, 230))
    crash_text = lable_font.render('Crash', True, white)
    screen.blit(crash_text, (30, 330))
    clap_text = lable_font.render('Clap', True, white)
    screen.blit(clap_text, (30, 430))
    floortom_text = lable_font.render('Crash', True, white)
    screen.blit(floortom_text, (30, 530))
    for i in range(instruments):
        pygame.draw.line(screen, grey, (0, (100 * i) + 100), (200, (100 * i) + 100), 10)
    
    for i in range(beats):
        for j in range(instruments):
            if clicks[j][i] == -1:
                color = grey
            else:
                color = green
            rect = pygame.draw.rect(screen, color, 
                                    [i * ((WIDTH - 200) // beats) + 205, (j * 100) + 5, ((WIDTH - 200) // beats) - 10, 
                                     ((HEIGHT - 200) // instruments) - 10], 0, 3)
            pygame.draw.rect(screen, gold, 
                                    [i * ((WIDTH - 200) // beats) + 200, (j * 100), ((WIDTH - 200) // beats), 
                                     ((HEIGHT - 200) // instruments)], 5, 5)
            pygame.draw.rect(screen, black, 
                                    [i * ((WIDTH - 200) // beats) + 200, (j * 100), ((WIDTH - 200) // beats), 
                                     ((HEIGHT - 200) // instruments)], 2, 5)
            
            boxes.append((rect, (i, j)))

        active = pygame.draw.rect(screen, blue, [beat * ((WIDTH - 200) // beats) + 200, 0, ((WIDTH - 200) // beats), instruments * 100], 5, 3)
    return boxes


run = True
while run:
    timer.tick(fps)
    screen.fill(black)
    boxes = draw_grid(clicked, active_beat)
    global clicks

    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            run = False
        if event.type == pygame.MOUSEBUTTONDOWN:
            for i in range(len(boxes)):
                if boxes[i][0].collidepoint(event.pos):
                    clicked[boxes[i][1][1]][boxes[i][1][0]] *= -1

    beat_length = 3600 // bpm
    if playing:
        if active_length < beat_length:
            active_length += 1
        else:
            active_length = 0
            if active_beat < beats - 1:
                active_beat += 1
                beat_changed = True
            else:
                active_beat = 0
                beat_changed = True


    pygame.display.flip()
pygame.quit()


