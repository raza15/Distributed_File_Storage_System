from selenium import webdriver
from selenium.webdriver.common.keys import Keys

driver = webdriver.Chrome()
driver.maximize_window()
driver.get("http://localhost:3000")
elem = driver.find_element_by_id('session_email')
elem.send_keys('raza1@gmail.com')
elem = driver.find_element_by_id('session_password')
elem.send_keys('raza3')
elem.send_keys(Keys.RETURN)

all_semis = driver.find_elements_by_xpath("//*[@value='Download Using Semi-Join']")
all_blooms = driver.find_elements_by_xpath("//*[@value='Download Using Bloom-Join']")
all_parallel_semis = driver.find_elements_by_xpath("//*[@value='Parallel Semi-Join']")
all_parallel_blooms = driver.find_elements_by_xpath("//*[@value='Parallel Bloom-Join']")

size = len(all_semis)
print "size:",size
comm_time_semis = []
comm_time_blooms = []
comm_time_parallel_semis = []
comm_time_parallel_blooms = []

for i in range(0,size):
	driver.get("http://localhost:3000")
	elem = driver.find_elements_by_xpath("//*[@value='Download Using Semi-Join']")[i]
	elem.click()
	str_comm_time = driver.find_element_by_xpath('/html/body/div/div[4]').text
	comm_time = str_comm_time.split(' ')[2]
	print "comm_time:",str_comm_time,comm_time
	comm_time_semis.append(comm_time)

for i in range(0,size):
	driver.get("http://localhost:3000")
	elem = driver.find_elements_by_xpath("//*[@value='Download Using Bloom-Join']")[i]
	elem.click()
	str_comm_time = driver.find_element_by_xpath('/html/body/div/div[4]').text
	comm_time = str_comm_time.split(' ')[2]
	print "comm_time_blooms:",str_comm_time,comm_time
	comm_time_blooms.append(comm_time)

for i in range(0,size):
	driver.get("http://localhost:3000")
	elem = driver.find_elements_by_xpath("//*[@value='Parallel Semi-Join']")[i]
	elem.click()
	str_comm_time = driver.find_element_by_xpath('/html/body/div/div[4]').text
	comm_time = str_comm_time.split(' ')[2]
	print "comm_time_parallel_semis:",str_comm_time,comm_time
	comm_time_parallel_semis.append(comm_time)

for i in range(0,size):
	driver.get("http://localhost:3000")
	elem = driver.find_elements_by_xpath("//*[@value='Parallel Bloom-Join']")[i]
	elem.click()
	str_comm_time = driver.find_element_by_xpath('/html/body/div/div[4]').text
	comm_time = str_comm_time.split(' ')[2]
	print "comm_time_parallel_blooms:",str_comm_time,comm_time
	comm_time_parallel_blooms.append(comm_time)

print comm_time_semis
print comm_time_blooms
print comm_time_parallel_semis
print comm_time_parallel_blooms

#-----------------
# ONE MACHINE
# from selenium import webdriver
# from selenium.webdriver.common.keys import Keys
# driver = webdriver.Chrome()
# driver.maximize_window()
# driver.get("http://localhost:3000")
# elem = driver.find_element_by_id('session_email')
# elem.send_keys('raza1@gmail.com')
# elem = driver.find_element_by_id('session_password')
# elem.send_keys('raza3')
# elem.send_keys(Keys.RETURN)
# driver.get("http://localhost:3000/resumes")
# all_semis = driver.find_elements_by_xpath("//*[@value='Download File']")
# size = len(all_semis)
# comm_time_semis = []
# print "size:",size
# for i in range(0,size):
# 	driver.get("http://localhost:3000/resumes")
# 	elem = driver.find_elements_by_xpath("//*[@value='Download File']")[i]
# 	elem.click()
# 	str_comm_time = driver.find_element_by_xpath('/html/body/div/div').text
# 	comm_time = str_comm_time.split(' ')[5]
# 	print "comm_time:",str_comm_time,comm_time
# 	comm_time_semis.append(comm_time)
# print "one_machine:", comm_time_semis
#
#-----------------

# import csv
# semis = [u'18096.616', u'17855.498', u'17875.003', u'18154.091', u'18083.036', u'18062.539', u'17865.892', u'17814.502', u'17835.16', u'17843.374', u'17867.094999999998', u'17925.277000000002', u'17934.397', u'18078.274', u'17874.929', u'17939.207']
# blooms = [u'18053.645', u'18096.831000000002', u'18122.022', u'18176.86', u'18409.227000000003', u'18905.746', u'20304.141', u'18283.785000000003', u'17968.923', u'17160.251', u'17191.272', u'18103.746', u'18664.485', u'17502.718', u'17296.46', u'18126.493']
# parall_semis = [u'13689.74', u'13559.845', u'13778.551', u'13358.304', u'15599.161', u'14449.806', u'13411.161999999998', u'13246.087', u'13229.032', u'14097.282', u'13453.082', u'13596.551', u'13484.474', u'13542.242', u'13540.551000000001', u'13617.701000000001']
# parall_blooms = [u'13551.359', u'14481.635', u'13846.970000000001', u'13769.869999999999', u'13792.875', u'13721.778', u'13543.831', u'14099.681999999999', u'14011.384', u'13942.271', u'13924.398', u'14169.3', u'13731.337', u'13882.255000000001', u'14204.012', u'14028.506']

# semis1 = []
# for s in semis:
# 	semis1.append(float(s))
# blooms1 = []
# for s in blooms:
# 	blooms1.append(float(s))	
# parall_semis1 = []
# for s in parall_semis:
# 	parall_semis1.append(float(s))
# parall_blooms1 = []
# for s in parall_blooms:
# 	parall_blooms1.append(float(s))

# filenames = ['cv.txt','file.txt','art1.txt','fun10.txt','politics3.txt','science7.txt','art10.txt','fun4.txt','parallel.txt','security.txt','fun1.txt','fun2.txt','fun3.txt','fun5.txt','fun6.txt','readME.txt']
# print len(semis1),len(blooms1),len(parall_semis1),len(parall_blooms1)
# # print semis1
# writer=csv.writer(open('db_project_results.csv','wb'))
# data = ['filenames','semi_join', 'blooms_join', 'parallel_semi_join', 'parallel_bloom_join']
# writer.writerow(data)
# for i in range(0,len(semis1)):
# 	data = [filenames[i],semis1[i], blooms1[i], parall_semis1[i], parall_blooms1[i]]
# 	writer.writerow(data)

