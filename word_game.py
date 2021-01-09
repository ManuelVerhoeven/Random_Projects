# Name:  Manuel Verhoeven
# Student Number: 10480891
# CSP5110







# Imported Modules
import random
import os
import sys





# Variables
candidateWords = ['AETHER', 'BADGED', 'BALDER', 'BANDED', 'BANTER', 'BARBER', 'BASHER', 'BATHED', 'BATHER', 'BEAMED', 'BEANED', 'BEAVER', 'BECKET', 'BEDDER', 'BEDELL', 'BEDRID', 'BEEPER', 'BEGGAR', 'BEGGED', 'BELIES', 'BELLES', 'BENDED', 'BENDEE', 'BETTER', 'BLAMER', 'BLOWER', 'BOBBER', 'BOLDER', 'BOLTER', 'BOMBER', 'BOOKER', 'BOPPER', 'BORDER', 'BOSKER', 'BOTHER', 'BOWYER', 'BRACER', 'BUDGER', 'BUMPER', 'BUSHER', 'BUSIER', 'CEILER', 'DEADEN', 'DEAFER', 'DEARER', 'DELVER', 'DENSER', 'DEXTER', 'EVADER', 'GELDED', 'GELDER', 'HEARER', 'HEIFER', 'HERDER', 'HIDDEN', 'JESTER', 'JUDDER', 'KIDDED', 'KIDDER', 'LEANER', 'LEAPER', 'LEASER', 'LEVIED', 'LEVIER', 'LEVIES', 'LIDDED', 'MADDER', 'MEANER', 'MENDER', 'MINDER', 'NEATER', 'NEEDED', 'NESTER', 'PENNER', 'PERTER', 'PEWTER', 'PODDED', 'PONDER', 'RADDED', 'REALER', 'REAVER', 'REEDED', 'REIVER', 'RELIER', 'RENDER', 'SEARER', 'SEDGES', 'SEEDED', 'SEISER', 'SETTER', 'SIDDUR', 'TEENER', 'TEMPER', 'TENDER', 'TERMER', 'VENDER', 'WEDDED', 'WEEDED', 'WELDED', 'YONDER']
difficultyList = ['casual', 'avarage', 'hard', 'very hard']
wordList = random.sample(candidateWords, 8)
password = random.choice(wordList)
NumWord = len(wordList)
Turn = 0
guessHistory = ['', '3/6', '', '', '', '', '', '']







# Fuctions
def compareWords(word1, word2):
    wordLetterCorrect = 0
    for index in range(0, 6):
        if (word1[index] == word2[index]):
            wordLetterCorrect  = wordLetterCorrect + 1     
    Matches = print(wordLetterCorrect,'/ 6 Letters correct and in the right location')
print('\n')
print('\n')

    
#Instructions
print('AWESOME WORD GAME')
print('\n')
print('\n')
print('Instructions')
print('The aim of the game is to guess the right word in a word list.')
print('After each guess you will be told how many letters in your guessed word wer cirrect and in the ight location.')
print('There are 4 difficulty settings (casual, avarage, hard, very hard)')
print('\n')





# Difficulty Choice
for index, wordsRemaining in enumerate(difficultyList):
        print(index, '-', wordsRemaining)
print('\n')       
difficulty = difficultyList[int(input('Enter your choice with the corrosponding number:'))]
print('You have choosen to play on', difficulty)
if difficulty == 'very hard':
    Turn = 2
if difficulty == 'hard':
    Turn = 3
if difficulty == 'avarage':
    Turn = 4
if difficulty == 'casual':
    Turn = 5

print('\n')
print('\n')

# Word list

print('This is your word list:')
for index, words in enumerate(wordList):
    print(index, '-', words,) 
    

#While guessing loop
while (Turn > 0):
    print('Guess the password')
    print('Guesses left:', Turn)
          
    print('\n')
    choice = wordList[int(input('Enter your choice with the corrosponding number: '))]
    print('\n')



    print('comparing...')
    print('\n')
    compareWords(choice, password) 
    print('for your choosen word', choice)
    print('\n')


    print('This is your word list:') 
    for index, words in enumerate(wordList):
        outputMessage = print(index, '-', words, guessHistory[index])
    print('\n')


    if choice == password:
        print('Password Correct! You Win, congratulations')
        break

    Turn = Turn -1
    if (Turn == 0):
        print('You have lost, you have run out of guesses, Game over!')
        break
    
print('\n')
print('\n')
    

# End of Game/Restart
restart = input('Would you like to play again ? type [Y/N]: ')
print(restart)
if restart == 'Y':
    python = sys.executable
    os.execl(python, python, *sys.argv)
if restart == 'N':
      print('exitting')
     
        
                      
