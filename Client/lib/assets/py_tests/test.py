from selenium import webdriver
# from selenium.webdriver import ActionChains
# from selenium.webdriver.common.keys import Keys

driver = webdriver.Firefox()
driver.get("https://www.google.com")














f = open("poo.txt","w") #opens file with name of "test.txt"

f.write("I am a test file.")

f.close()