#include <stdio.h>

#include "utility.cuh"

int getSPcores(cudaDeviceProp devProp) {
  int cores = 0;
  int mp = devProp.multiProcessorCount;
  switch (devProp.major) {
    case 2:  // Fermi
      if (devProp.minor == 1)
        cores = mp * 48;
      else
        cores = mp * 32;
      break;
    case 3:  // Kepler
      cores = mp * 192;
      break;
    case 5:  // Maxwell
      cores = mp * 128;
      break;
    case 6:  // Pascal
      if ((devProp.minor == 1) || (devProp.minor == 2))
        cores = mp * 128;
      else if (devProp.minor == 0)
        cores = mp * 64;
      else
        printf("Unknown device type\n");
      break;
    case 7:  // Volta and Turing
      if ((devProp.minor == 0) || (devProp.minor == 5))
        cores = mp * 64;
      else
        printf("Unknown device type\n");
      break;
    case 8:  // Ampere
      if (devProp.minor == 0)
        cores = mp * 64;
      else if (devProp.minor == 6)
        cores = mp * 128;
      else if (devProp.minor == 9)
        cores = mp * 128;  // ada lovelace
      else
        printf("Unknown device type\n");
      break;
    case 9:  // Hopper
      if (devProp.minor == 0)
        cores = mp * 128;
      else
        printf("Unknown device type\n");
      break;
    default:
      printf("Unknown device type\n");
      break;
  }
  return cores;
}

double current_seconds(void) {
  struct timespec ts;
  if (clock_gettime(CLOCK_MONOTONIC_RAW, &ts) != 0) {
    printf("Error getting time.\n");
    exit(1);
  }
  return ((double)ts.tv_sec) + (((double)ts.tv_nsec) / 1e9);
}