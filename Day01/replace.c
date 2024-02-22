#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char* replace(const char* original, const char* substring, const char* replace);

int main(void)
{
  char* filename = "input.txt";
  FILE* fp = fopen(filename, "r");

  if (fp == NULL)
  {
    printf("Error opening file %s", filename);
    return EXIT_FAILURE;
  }

  const unsigned MAX_LENGTH = 256;
  char buffer[MAX_LENGTH];

  // Weird order to replace the substrings in the file correctly
  const char* number_mappings[] = {
    "seven", "7",
    "one", "1",
    "eight", "8",
    "six", "6",
    "five", "5",
    "four", "4",
    "three", "3",
    "two", "2",
    "nine", "9",
  };

  FILE* fp_out = fopen("output.txt", "w");
  while (fgets(buffer, MAX_LENGTH, fp))
  {
    for (int i = 0; i < sizeof(number_mappings) / sizeof(number_mappings[0]); i += 2)
    {
      char* replaced = replace(buffer, number_mappings[i], number_mappings[i+1]);
      strcpy(buffer, replaced);
    }
    fprintf(fp_out, "%s", buffer);
  }

  fclose(fp);
  fclose(fp_out);
  
  return 0;
}

char* replace(const char* original, const char* substring, const char* replace)
{
  int original_len = strlen(original);
  int sub_len = strlen(substring);
  int replace_len = strlen(replace);
  
  char* result;
  
  if (sub_len == replace_len)
  {
    result = malloc((original_len + 1) * sizeof(char));
  }
  else
  {
    int occurrences = 0;
    
    for (int i = 0; i < original_len;)
    {
      if (strstr(&original[i], substring) == &original[i])
      {
        ++occurrences;
        i += sub_len;
      }
      else ++i;
    }
    
    int sub_diff = replace_len - sub_len;
    int result_len = original_len;

    result_len += occurrences * sub_diff;
    result = malloc((result_len + 1) * sizeof(char));
  }
  
  int i = 0; int j = 0;
  while (i < strlen(original))
  {
    if (strstr(&original[i], substring) == &original[i])
    {
      strcpy(&result[j], replace);

      i += sub_len;
      j += replace_len;
    }
    else
    {
      result[j] = original[i];
      ++i; ++j;
    }
  }
  
  result[j] = '\0';
  return result;
}
