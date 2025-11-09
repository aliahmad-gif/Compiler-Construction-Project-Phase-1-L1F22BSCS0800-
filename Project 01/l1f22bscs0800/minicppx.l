%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

int line_num = 1;
int token_count = 0;
int error_count = 0;
FILE *token_file, *error_file;

void print_token(const char* type, const char* lexeme);
void print_error_with_detail(const char* lexeme, const char* detail);
void print_summary();
%}

%%

\"[^\n"]*\"     { print_token("STRING", yytext); }
\"[^\n"]*       { print_error_with_detail(yytext, "unterminated string"); }

"//".*          ;
"/*"([^*]|(\*+[^*/]))*\*+"/"   ;

[ \t]+          ;
\n              { line_num++; }

agar            { print_token("KEYWORD", yytext); }
warna           { print_token("KEYWORD", yytext); }
jabtak          { print_token("KEYWORD", yytext); }
likho           { print_token("KEYWORD", yytext); }
lo              { print_token("KEYWORD", yytext); }
kaam            { print_token("KEYWORD", yytext); }
wapas           { print_token("KEYWORD", yytext); }
shuru           { print_token("KEYWORD", yytext); }
khatam          { print_token("KEYWORD", yytext); }
pura            { print_token("KEYWORD", yytext); }
dosra           { print_token("KEYWORD", yytext); }
lafz            { print_token("KEYWORD", yytext); }
jab             { print_token("KEYWORD", yytext); }
ruk             { print_token("KEYWORD", yytext); }
jarri           { print_token("KEYWORD", yytext); }

"="             { print_token("ASSIGNMENT_OPERATOR", yytext); }
"=="            { print_token("EQUAL_OPERATOR", yytext); }
"+"             { print_token("ADDITION_OPERATOR", yytext); }
"-"             { print_token("SUBTRACTION_OPERATOR", yytext); }
"*"             { print_token("MULTIPLICATION_OPERATOR", yytext); }
"/"             { print_token("DIVISION_OPERATOR", yytext); }
">"             { print_token("GREATER_THAN_OPERATOR", yytext); }
"<"             { print_token("LESS_THAN_OPERATOR", yytext); }
"<="            { print_token("LESS_EQUAL_OPERATOR", yytext); }
">="            { print_token("GREATER_EQUAL_OPERATOR", yytext); }
"!="            { print_token("NOT_EQUAL_OPERATOR", yytext); }
"&"             { print_token("BITWISE_AND_OPERATOR", yytext); }
"|"             { print_token("BITWISE_OR_OPERATOR", yytext); }
"!"             { print_token("LOGICAL_NOT_OPERATOR", yytext); }
"&&"            { print_token("LOGICAL_AND_OPERATOR", yytext); }
"||"            { print_token("LOGICAL_OR_OPERATOR", yytext); }
"++"            { print_token("INCREMENT_OPERATOR", yytext); }
"--"            { print_token("DECREMENT_OPERATOR", yytext); }
"^"             { print_token("BITWISE_XOR_OPERATOR", yytext); }
"~"             { print_token("BITWISE_NOT_OPERATOR", yytext); }
"<<"            { print_token("LEFT_SHIFT_OPERATOR", yytext); }
">>"            { print_token("RIGHT_SHIFT_OPERATOR", yytext); }
"%"             { print_token("MODULUS_OPERATOR", yytext); }
"+="            { print_token("ADD_ASSIGN_OPERATOR", yytext); }
"-="            { print_token("SUB_ASSIGN_OPERATOR", yytext); }
"*="            { print_token("MUL_ASSIGN_OPERATOR", yytext); }
"/="            { print_token("DIV_ASSIGN_OPERATOR", yytext); }
"%="            { print_token("MOD_ASSIGN_OPERATOR", yytext); }
"&="            { print_token("AND_ASSIGN_OPERATOR", yytext); }
"|="            { print_token("OR_ASSIGN_OPERATOR", yytext); }
"^="            { print_token("XOR_ASSIGN_OPERATOR", yytext); }
"<<="           { print_token("LEFT_SHIFT_ASSIGN_OPERATOR", yytext); }
">>="           { print_token("RIGHT_SHIFT_ASSIGN_OPERATOR", yytext); }

";"             { print_token("SEMICOLON_PUNCTUATIONS", yytext); }
","             { print_token("COMMA_PUNCTUATIONS", yytext); }
"("             { print_token("LEFT_PAREN_PUNCTUATIONS", yytext); }
")"             { print_token("RIGHT_PAREN_PUNCTUATIONS", yytext); }
"{"             { print_token("LEFT_BRACE_PUNCTUATIONS", yytext); }
"}"             { print_token("RIGHT_BRACE_PUNCTUATIONS", yytext); }
"["             { print_token("LEFT_BRACKET_PUNCTUATIONS", yytext); }
"]"             { print_token("RIGHT_BRACKET_PUNCTUATIONS", yytext); }
":"             { print_token("COLON_PUNCTUATIONS", yytext); }
"."             { print_token("DOT_PUNCTUATIONS", yytext); }
"->"            { print_token("ARROW_PUNCTUATIONS", yytext); }

[0-9]+"."[0-9]+"e"[0-9]+   { print_token("EXPONENTIAL", yytext); }
[0-9]+"e"[0-9]+            { print_token("EXPONENTIAL", yytext); }
[0-9]+"."[0-9]+            { print_token("FLOAT", yytext); }
[0-9]+                     { print_token("INTEGER", yytext); }

\'[^\\'\n]\'     { print_token("CHAR", yytext); }
\'[^\\'\n]\\[^\\'\n]\'     { print_token("CHAR", yytext); }
\'[^\\'\n]*\'     { print_error_with_detail(yytext, "invalid char - multiple characters"); }
\'[^\\'\n]*       { print_error_with_detail(yytext, "invalid char - unterminated"); }

_[a-zA-Z0-9_]+      { print_token("IDENTIFIER", yytext); }
[a-zA-Z][a-zA-Z0-9_]*   { print_token("IDENTIFIER", yytext); }

[0-9]+[a-zA-Z_]+[a-zA-Z0-9_]*    { print_error_with_detail(yytext, "invalid identifier - cannot start with digit"); }

[0-9]+[@#$~?]+[0-9@#$~?]*  { print_error_with_detail(yytext, "invalid token - numbers cannot contain special characters"); }

[a-zA-Z]+[@#$~?]+[a-zA-Z0-9@#$~?]*  { print_error_with_detail(yytext, "invalid identifier - cannot contain special characters"); }

[@#$~?a-zA-Z0-9]+ { 
    int has_special = 0;
    int has_alpha_num = 0;
    int i;
    for (i = 0; yytext[i]; i++) {
        if (strchr("@#$~?", yytext[i]) != NULL) {
            has_special = 1;
        }
        if (isalnum(yytext[i])) {
            has_alpha_num = 1;
        }
    }
    
    if (has_special && has_alpha_num) {
        if (strchr("@#$~?", yytext[0]) != NULL) {
            print_error_with_detail(yytext, "invalid identifier - cannot start with special characters");
        } else {
            print_error_with_detail(yytext, "invalid identifier - cannot contain special characters");
        }
    } else if (has_special) {
        print_error_with_detail(yytext, "invalid token - only special characters");
    } else {
        print_error_with_detail(yytext, "invalid token");
    }
}

"/*"([^*]|\*+[^*/])*       { print_error_with_detail(yytext, "unterminated comment"); }

.               { 
    char c = yytext[0];
    if (c == '`') print_error_with_detail(yytext, "invalid character - `");
    else print_error_with_detail(yytext, "invalid token");
}

%%

void print_token(const char* type, const char* lexeme) {
    token_count++;
    if (token_file != NULL) {
        fprintf(token_file, "Line %d: %s -> %s\n", line_num, type, lexeme);
    }
    printf("Line %d: %s -> %s\n", line_num, type, lexeme);
}

void print_error_with_detail(const char* lexeme, const char* detail) {
    error_count++;
    
    char display_lexeme[100];
    if (lexeme[0] == '\0' || !isprint(lexeme[0])) {
        if (lexeme[0] == '\0') {
            strcpy(display_lexeme, " ");
        } else {
            sprintf(display_lexeme, "\\x%02X", (unsigned char)lexeme[0]);
        }
    } else {
        strncpy(display_lexeme, lexeme, 99);
        display_lexeme[99] = '\0';
    }
    
    if (error_file != NULL) {
        fprintf(error_file, "Line %d: ERROR -> '%s' (%s)\n", line_num, display_lexeme, detail);
    }
    printf("Line %d: ERROR -> '%s' (%s)\n", line_num, display_lexeme, detail);
}

void print_summary() {
    printf("\n=== SCANNING SUMMARY ===\n");
    printf("Total Lines Processed: %d\n", line_num);
    printf("Total Tokens Found: %d\n", token_count);
    printf("Total Errors Found: %d\n", error_count);
    
    if (token_count + error_count > 0) {
        printf("Success Rate: %.2f%%\n", (token_count * 100.0) / (token_count + error_count));
    } else {
        printf("Success Rate: 0.00%%\n");
    }
    
    if (token_file != NULL) {
        fprintf(token_file, "\n=== SCANNING SUMMARY ===\n");
        fprintf(token_file, "Total Lines Processed: %d\n", line_num);
        fprintf(token_file, "Total Tokens Found: %d\n", token_count);
        fprintf(token_file, "Total Errors Found: %d\n", error_count);
        if (token_count + error_count > 0) {
            fprintf(token_file, "Success Rate: %.2f%%\n", (token_count * 100.0) / (token_count + error_count));
        } else {
            fprintf(token_file, "Success Rate: 0.00%%\n");
        }
        fclose(token_file);
    }
    
    if (error_file != NULL) {
        fprintf(error_file, "\n=== SCANNING SUMMARY ===\n");
        fprintf(error_file, "Total Lines Processed: %d\n", line_num);
        fprintf(error_file, "Total Tokens Found: %d\n", token_count);
        fprintf(error_file, "Total Errors Found: %d\n", error_count);
        if (token_count + error_count > 0) {
            fprintf(error_file, "Success Rate: %.2f%%\n", (token_count * 100.0) / (token_count + error_count));
        } else {
            fprintf(error_file, "Success Rate: 0.00%%\n");
        }
        fclose(error_file);
    }
}

int main(int argc, char *argv[]) {
    token_file = fopen("token.txt", "w");
    if (token_file == NULL) {
        printf("Warning: Cannot create token.txt, using stdout only\n");
    }
    
    error_file = fopen("error.txt", "w");
    if (error_file == NULL) {
        printf("Warning: Cannot create error.txt, using stdout only\n");
    }
    
    if (token_file != NULL) {
        fprintf(token_file, "=== TOKEN OUTPUT ===\n");
    }
    if (error_file != NULL) {
        fprintf(error_file, "=== ERROR OUTPUT ===\n");
    }
    
    printf("=== URDU-INSPIRED MINI C++ LEXICAL ANALYZER ===\n");
    printf("================================================\n");
    
    if (argc > 1) {
        printf("Reading from file: %s\n\n", argv[1]);
        FILE *input_file = fopen(argv[1], "r");
        if (input_file == NULL) {
            printf("Error: Cannot open file %s\n", argv[1]);
            if (token_file != NULL) fclose(token_file);
            if (error_file != NULL) fclose(error_file);
            return 1;
        }
        yyin = input_file;
        yylex();
        fclose(input_file);
    } else {
        printf("Enter your input (Ctrl+D to end):\n");
        printf("=====================================\n");
        yyin = stdin;
        yylex();
    }
    
    print_summary();
    
    printf("\nResults:\n");
    if (token_file != NULL) {
        printf("   - token.txt (all valid tokens)\n");
    }
    if (error_file != NULL) {
        printf("   - error.txt (all errors with details)\n");
    }
    
    return 0;
}

int yywrap() {
    return 1;
}

