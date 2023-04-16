// This file is part of RAETSELx86 <https://github.com/monsieuremre/raetselx86>
// RAETSELx86 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public
// License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later
// version. RAETSELx86 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the
// implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details. You should have received a copy of the GNU General Public License along with this program. If not, see
// <https://www.gnu.org/licenses/>.

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// The rotors in the enigma machine, in the same order as the configuration file.
char reflect[26];
char left[26];
char middle[26];
char right[26];
char plugboard[26];

// Starting positions of the three rotating rotors.
// They will be set by the user. We can think of this as the encryption password.
long pos_l;
long pos_m;
long pos_r;

// The function implemented in x86 assembly to emulate the enigma machine
extern char *enigma(int len, char *input);

int main(int argc, char **argv, char **envp)
{
    int len;       // User message length
    char *message; // User message will be stored here
    char *result;  // The message after the enigma process will be stored here
    FILE *fd;

    // We read the rotor configurations from a file for convenience, as inputting these every time wouldn't be practical
    fd = fopen("machine_config.txt", "r");
    if (NULL == fd)
    {
        printf("Configuration file can't be opened!\n");
    }
    fscanf(fd, "%s", reflect);
    fscanf(fd, "%s", left);
    fscanf(fd, "%s", middle);
    fscanf(fd, "%s", right);
    fscanf(fd, "%s", plugboard);
    fclose(fd);

    // We take user input
    printf("Enter Rotor Positions (0-25) for Encryption/Decryption. (This is the password for your message)\n");
    printf("Left Rotor: ");
    scanf("%ld", &pos_l);
    printf("Middle Rotor: ");
    scanf("%ld", &pos_m);
    printf("Right Rotor: ");
    scanf("%ld", &pos_r);
    printf("Enter Message Length: ");
    scanf("%d", &len);
    message = (char *)malloc((len + 1) * sizeof(char));
    printf("Enter Message (only capital ASCII letters and space allowed, like the real enigma machine): ");
    {
        char temp;
        scanf("%c", &temp); // We clear the buffer before taking an input string with possibly spaces in it
    }
    scanf("%[^\n]%*c", message);
    result = enigma(len, message); // We call the enigma function
    printf("Your message after the enigma process: %s\n", result);
    // Might as well free all the memory we allocated
    free(result);
    free(message);
    return 0;
}
