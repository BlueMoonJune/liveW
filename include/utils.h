#ifndef _UTIL_H
#define _UTIL_H

#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdbool.h>
#include <sys/time.h>

typedef struct SongInfo {
	pthread_t thread;
	char artist[64];
	char title[64];
	char *albumArt;
} SongInfo;

float getUnixTime();
char *getSystemTime();
int exec(char *cmd, char *buf, int size);
int getSongInfo(char *artist, char *title);
void *updateSongInfo(void *arg);

#endif
