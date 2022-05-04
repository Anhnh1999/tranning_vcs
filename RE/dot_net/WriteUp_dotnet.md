## Basic.exe
- nạp file vào dnSpy thu được source code 
- input được mã hóa với thuật toán RC4 
- key mã hóa là `c-sharp`, với hint thu được chuỗi mã hóa theo hệ 16 là `a0-d3-57-17-e2-17-98-82-ae-42-0b-df-2a-80-ec-d0-1b-f2-2e-62-67-96-f3-ba`

##### có key và chuỗi mã nên có thể giải mã RC4 bằng cách sử dụng cyberchef 
[https://gchq.github.io/CyberChef/#recipe=From_Hex('Auto')RC4(%7B'option':'UTF8','string':'c-sharp'%7D,'Latin1','Latin1')&input=YTAtZDMtNTctMTctZTItMTctOTgtODItYWUtNDItMGItZGYtMmEtODAtZWMtZDAtMWItZjItMmUtNjItNjctOTYtZjMtYmE](https://gchq.github.io/CyberChef/#recipe=From_Hex('Auto')RC4(%7B'option':'UTF8','string':'c-sharp'%7D,'Latin1','Latin1')&input=YTAtZDMtNTctMTctZTItMTctOTgtODItYWUtNDItMGItZGYtMmEtODAtZWMtZDAtMWItZjItMmUtNjItNjctOTYtZjMtYmE)

flag: `trainingctf{b4s1c_C++++}`


## Find_Imposter.exe
- nạp file vào dnsSpy thu được source code 
- input ban đầu được hash bằng MD5 
- sau đó cũng được mã hóa bằng thuật toán RC4 với key `among-us` nhưng trước khi mã hóa thì input sẽ được biến đổi thông qua rất nhiều hàm đã bị obfuscate
- sau khi biến đổi thì input mã hóa với RC4 được so sánh với `40-72-b1-25-9e-ff-83-f3-07-c4-e8-d6-8a-a6-0c-e0-ef-9f-a6-3f-e2-fc-0b-81-2a-47-dd-8b-1a-a3-4c-32`, nếu bằng nhau thì input nhập vào sẽ là đúng

##### vì trước khi mã hóa bằng RC4 thì input md5 đã bị biến đổi qua các hàm obfuscate, nên suy ra không thể decrypt RC4 như bài trước được 
##### để làm được cần xem input biến đổi như nào bằng cách mã hóa bằng cyberchef và bằng chương trình với cùng 1 input. kết quá thu được là 
##### thử với chuỗi `test` thì chuỗi được đưa vào trước khi thực hiện RC4 là
###### dnSpy:      `[0x30,0x39,0x38,0x46,0x36,0x42,0x43,0x44,0x34,0x36,0x32,0x31,0x44,0x33,0x37,0x33,0x43,0x41,0x44,0x45,0x34,0x45,0x38,0x33,0x32,0x36,0x32,0x37,0x42,0x34,0x46,0x36]`
###### cyberchef:  `[0x30,0x39,0x38,0x66,0x36,0x62,0x63,0x64,0x34,0x36,0x32,0x31,0x64,0x33,0x37,0x33,0x63,0x61,0x64,0x65,0x34,0x65,0x38,0x33,0x32,0x36,0x32,0x37,0x62,0x34,0x66,0x36]` 


##### so sánh thấy obfuscate sẽ trừ 32 byte những byte nào có độ lớn hơn 0x60, thử những chuỗi khác cũng tương tự, từ đây có thể giải mã được flag bằng cách decrypt rc4 chuỗi `40-72-b1-25-9e-ff-83-f3-07-c4-e8-d6-8a-a6-0c-e0-ef-9f-a6-3f-e2-fc-0b-81-2a-47-dd-8b-1a-a3-4c-32` rồi unhash md5 khi cộng những byte có độ lớn từ 0x40 lên 32 byte.

###### decrypt rc4 thu được `[0x33,0x30,0x33,0x43,0x42,0x30,0x45,0x46,0x39,0x45,0x44,0x42,0x39,0x30,0x38,0x32,0x44,0x36,0x31,0x42,0x42,0x42,0x45,0x35,0x38,0x32,0x35,0x44,0x39,0x37,0x32,0x41]`
###### cộng 32 byte thu được `[0x33,0x30,0x33,0x63,0x62,0x30,0x65,0x66,0x39,0x65,0x64,0x62,0x39,0x30,0x38,0x32,0x64,0x36,0x31,0x62,0x62,0x62,0x65,0x35,0x38,0x32,0x35,0x64,0x39,0x37,0x32,0x61]`

##### từ đây thu được hash và decrypt md5 thu được key 
##### hash: [https://gchq.github.io/CyberChef/#recipe=From_Hex('Auto')&input=MHgzMywweDMwLDB4MzMsMHg2MywweDYyLDB4MzAsMHg2NSwweDY2LDB4MzksMHg2NSwweDY0LDB4NjIsMHgzOSwweDMwLDB4MzgsMHgzMiwweDY0LDB4MzYsMHgzMSwweDYyLDB4NjIsMHg2MiwweDY1LDB4MzUsMHgzOCwweDMyLDB4MzUsMHg2NCwweDM5LDB4MzcsMHgzMiwweDYx](https://gchq.github.io/CyberChef/#recipe=From_Hex('Auto')&input=MHgzMywweDMwLDB4MzMsMHg2MywweDYyLDB4MzAsMHg2NSwweDY2LDB4MzksMHg2NSwweDY0LDB4NjIsMHgzOSwweDMwLDB4MzgsMHgzMiwweDY0LDB4MzYsMHgzMSwweDYyLDB4NjIsMHg2MiwweDY1LDB4MzUsMHgzOCwweDMyLDB4MzUsMHg2NCwweDM5LDB4MzcsMHgzMiwweDYx)


###### decrypt md5[https://www.md5online.org/md5-decrypt.html](https://www.md5online.org/md5-decrypt.html) - 303cb0ef9edb9082d61bbbe5825d972a

key: `.NET`
flag: `trainingctf{.NET_is_imposter!}`








