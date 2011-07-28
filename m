From: Simon Arlott <simon@fire.lp0.eu>
Subject: 3.0 BUG at fs/btrfs/disk-io.c:2362 caused by I/O errors
Date: Thu, 28 Jul 2011 19:34:44 +0100
Message-ID: <4E31ABC4.8030409@simon.arlott.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I was running rsync when this happened. The filesystem appeared to be ok
afterwards, with the current temporary file .MVI_0478.MOV.6YQlBJ still
present.

[93805.371253] ehci_hcd 0000:00:02.1: detected XactErr len 1024/8192 retry 1
[93805.371746] ehci_hcd 0000:00:02.1: detected XactErr len 1024/8192 retry 2
[93805.372744] ehci_hcd 0000:00:02.1: detected XactErr len 1024/8192 retry 3
[93805.373746] ehci_hcd 0000:00:02.1: detected XactErr len 1024/8192 retry 4
[93805.374744] ehci_hcd 0000:00:02.1: detected XactErr len 1024/8192 retry 5
[93805.375746] ehci_hcd 0000:00:02.1: detected XactErr len 1024/8192 retry 6
[93805.376748] ehci_hcd 0000:00:02.1: detected XactErr len 1024/8192 retry 7
[93805.376869] ehci_hcd 0000:00:02.1: detected XactErr len 1024/8192 retry 8
[93805.377744] ehci_hcd 0000:00:02.1: detected XactErr len 1024/8192 retry 9
[93805.378746] ehci_hcd 0000:00:02.1: detected XactErr len 1024/8192 retry 10
[93805.379745] ehci_hcd 0000:00:02.1: detected XactErr len 1024/8192 retry 11
[93805.380744] ehci_hcd 0000:00:02.1: detected XactErr len 1024/8192 retry 12
[93805.381745] ehci_hcd 0000:00:02.1: detected XactErr len 1024/8192 retry 13
[93805.382746] ehci_hcd 0000:00:02.1: detected XactErr len 1024/8192 retry 14
[93805.383743] ehci_hcd 0000:00:02.1: detected XactErr len 1024/8192 retry 15
[93805.384745] ehci_hcd 0000:00:02.1: detected XactErr len 1024/8192 retry 16
[93805.385745] ehci_hcd 0000:00:02.1: detected XactErr len 1024/8192 retry 17
[93805.386744] ehci_hcd 0000:00:02.1: detected XactErr len 1024/8192 retry 18
[93805.387745] ehci_hcd 0000:00:02.1: detected XactErr len 1024/8192 retry 19
[93805.388745] ehci_hcd 0000:00:02.1: detected XactErr len 1024/8192 retry 20
[93805.389744] ehci_hcd 0000:00:02.1: detected XactErr len 1024/8192 retry 21
[93805.390744] ehci_hcd 0000:00:02.1: detected XactErr len 1024/8192 retry 22
[93805.391750] ehci_hcd 0000:00:02.1: detected XactErr len 1024/8192 retry 23
[93805.392748] ehci_hcd 0000:00:02.1: detected XactErr len 1024/8192 retry 24
[93805.393749] ehci_hcd 0000:00:02.1: detected XactErr len 1024/8192 retry 25
[93805.394750] ehci_hcd 0000:00:02.1: detected XactErr len 1024/8192 retry 26
[93805.395742] ehci_hcd 0000:00:02.1: detected XactErr len 1024/8192 retry 27
[93805.396750] ehci_hcd 0000:00:02.1: detected XactErr len 1024/8192 retry 28
[93805.397749] ehci_hcd 0000:00:02.1: detected XactErr len 1024/8192 retry 29
[93805.398748] ehci_hcd 0000:00:02.1: detected XactErr len 1024/8192 retry 30
[93805.399744] ehci_hcd 0000:00:02.1: detected XactErr len 1024/8192 retry 31
[93805.400750] ehci_hcd 0000:00:02.1: devpath 1.1.3 ep2out 3strikes
[93805.413000] hub 1-1.1:1.0: logical disconnect on port 3
[93805.413148] hub 1-1.1:1.0: state 7 ports 4 chg 0008 evt 0000
[93805.413235] sd 13:0:0:1: [sdj] Unhandled error code
[93805.413251] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
[93805.413262] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 3c a8 00 00 80 00
[93805.413302] end_request: I/O error, dev sdj, sector 28458152
[93805.413329] sd 13:0:0:0: [sdi] Unhandled error code
[93805.413333] sd 13:0:0:0: [sdi]  Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
[93805.413339] sd 13:0:0:0: [sdi] CDB: Write(10): 2a 00 01 b2 d4 a8 00 00 80 00
[93805.413351] end_request: I/O error, dev sdi, sector 28497064
[93805.413394] hub 1-1.1:1.0: port 3, status 0101, change 0001, 12 Mb/s
[93805.413403] usb 1-1.1.3: USB disconnect, device number 21
[93805.413411] usb 1-1.1.3: unregistering device
[93805.413419] usb 1-1.1.3: unregistering interface 1-1.1.3:1.0
[93805.413482] sd 13:0:0:1: [sdj] Unhandled error code
[93805.413486] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
[93805.413492] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 3d 28 00 00 80 00
[93805.413503] end_request: I/O error, dev sdj, sector 28458280
[93805.413516] sd 13:0:0:0: [sdi] Unhandled error code
[93805.413520] sd 13:0:0:0: [sdi]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.413525] sd 13:0:0:0: [sdi] CDB: Write(10): 2a 00 01 b2 d5 28 00 00 80 00
[93805.413537] end_request: I/O error, dev sdi, sector 28497192
[93805.413554] sd 13:0:0:1: [sdj] Unhandled error code
[93805.413557] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.413565] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 3d a8 00 00 80 00
[93805.413586] end_request: I/O error, dev sdj, sector 28458408
[93805.413813] sd 13:0:0:0: [sdi] Unhandled error code
[93805.413816] sd 13:0:0:0: [sdi]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.413821] sd 13:0:0:0: [sdi] CDB: Write(10): 2a 00 01 b2 d5 a8 00 00 80 00
[93805.413841] end_request: I/O error, dev sdi, sector 28497320
[93805.413861] sd 13:0:0:1: [sdj] Unhandled error code
[93805.413865] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.413870] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 3e 28 00 00 80 00
[93805.413888] end_request: I/O error, dev sdj, sector 28458536
[93805.413903] sd 13:0:0:1: [sdj] Unhandled error code
[93805.413907] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.413913] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 3e a8 00 00 80 00
[93805.413930] end_request: I/O error, dev sdj, sector 28458664
[93805.413947] sd 13:0:0:1: [sdj] Unhandled error code
[93805.413952] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.413962] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 3f 28 00 00 80 00
[93805.413999] end_request: I/O error, dev sdj, sector 28458792
[93805.414025] sd 13:0:0:1: [sdj] Unhandled error code
[93805.414031] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.414041] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 3f a8 00 00 80 00
[93805.414079] end_request: I/O error, dev sdj, sector 28458920
[93805.414100] sd 13:0:0:1: [sdj] Unhandled error code
[93805.414106] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.414116] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 40 28 00 00 80 00
[93805.414154] end_request: I/O error, dev sdj, sector 28459048
[93805.414173] sd 13:0:0:1: [sdj] Unhandled error code
[93805.414179] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.414188] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 40 a8 00 00 80 00
[93805.414226] end_request: I/O error, dev sdj, sector 28459176
[93805.414287] sd 13:0:0:1: [sdj] Unhandled error code
[93805.414293] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.414303] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 41 28 00 00 80 00
[93805.414340] end_request: I/O error, dev sdj, sector 28459304
[93805.414359] sd 13:0:0:1: [sdj] Unhandled error code
[93805.414365] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.414375] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 41 a8 00 00 80 00
[93805.414413] end_request: I/O error, dev sdj, sector 28459432
[93805.414432] sd 13:0:0:1: [sdj] Unhandled error code
[93805.414438] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.414448] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 42 28 00 00 80 00
[93805.414487] end_request: I/O error, dev sdj, sector 28459560
[93805.414503] sd 13:0:0:1: [sdj] Unhandled error code
[93805.414510] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.414519] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 42 a8 00 00 80 00
[93805.414558] end_request: I/O error, dev sdj, sector 28459688
[93805.414577] sd 13:0:0:1: [sdj] Unhandled error code
[93805.414583] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.414593] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 43 28 00 00 80 00
[93805.414631] end_request: I/O error, dev sdj, sector 28459816
[93805.414649] sd 13:0:0:1: [sdj] Unhandled error code
[93805.414655] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.414664] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 43 a8 00 00 80 00
[93805.414701] end_request: I/O error, dev sdj, sector 28459944
[93805.414716] sd 13:0:0:1: [sdj] Unhandled error code
[93805.414722] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.414732] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 44 28 00 00 80 00
[93805.414770] end_request: I/O error, dev sdj, sector 28460072
[93805.414785] sd 13:0:0:1: [sdj] Unhandled error code
[93805.414791] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.414801] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 44 a8 00 00 80 00
[93805.414838] end_request: I/O error, dev sdj, sector 28460200
[93805.414853] sd 13:0:0:1: [sdj] Unhandled error code
[93805.414859] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.414868] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 45 28 00 00 80 00
[93805.414906] end_request: I/O error, dev sdj, sector 28460328
[93805.414925] sd 13:0:0:1: [sdj] Unhandled error code
[93805.414931] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.414941] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 45 a8 00 00 80 00
[93805.414979] end_request: I/O error, dev sdj, sector 28460456
[93805.414998] sd 13:0:0:1: [sdj] Unhandled error code
[93805.415012] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.415022] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 46 28 00 00 80 00
[93805.415061] end_request: I/O error, dev sdj, sector 28460584
[93805.415083] sd 13:0:0:1: [sdj] Unhandled error code
[93805.415089] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.415099] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 46 a8 00 00 80 00
[93805.415136] end_request: I/O error, dev sdj, sector 28460712
[93805.415156] sd 13:0:0:1: [sdj] Unhandled error code
[93805.415162] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.415172] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 47 28 00 00 80 00
[93805.415209] end_request: I/O error, dev sdj, sector 28460840
[93805.415227] sd 13:0:0:1: [sdj] Unhandled error code
[93805.415233] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.415242] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 47 a8 00 00 80 00
[93805.415278] end_request: I/O error, dev sdj, sector 28460968
[93805.415295] sd 13:0:0:1: [sdj] Unhandled error code
[93805.415301] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.415310] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 48 28 00 00 80 00
[93805.415347] end_request: I/O error, dev sdj, sector 28461096
[93805.415365] sd 13:0:0:1: [sdj] Unhandled error code
[93805.415371] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.415380] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 48 a8 00 00 80 00
[93805.415418] end_request: I/O error, dev sdj, sector 28461224
[93805.415435] sd 13:0:0:1: [sdj] Unhandled error code
[93805.415441] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.415451] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 49 28 00 00 80 00
[93805.415487] end_request: I/O error, dev sdj, sector 28461352
[93805.415505] sd 13:0:0:1: [sdj] Unhandled error code
[93805.415511] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.415521] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 49 a8 00 00 80 00
[93805.415558] end_request: I/O error, dev sdj, sector 28461480
[93805.415575] sd 13:0:0:1: [sdj] Unhandled error code
[93805.415581] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.415591] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 4a 28 00 00 80 00
[93805.415628] end_request: I/O error, dev sdj, sector 28461608
[93805.415646] sd 13:0:0:1: [sdj] Unhandled error code
[93805.415653] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.415663] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 4a a8 00 00 80 00
[93805.415700] end_request: I/O error, dev sdj, sector 28461736
[93805.415718] sd 13:0:0:1: [sdj] Unhandled error code
[93805.415723] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.415733] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 4b 28 00 00 80 00
[93805.415768] end_request: I/O error, dev sdj, sector 28461864
[93805.415786] sd 13:0:0:1: [sdj] Unhandled error code
[93805.415792] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.415801] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 4b a8 00 00 80 00
[93805.415817] end_request: I/O error, dev sdj, sector 28461992
[93805.415831] sd 13:0:0:1: [sdj] Unhandled error code
[93805.415834] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.415840] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 4c 28 00 00 80 00
[93805.415850] end_request: I/O error, dev sdj, sector 28462120
[93805.415864] sd 13:0:0:1: [sdj] Unhandled error code
[93805.415868] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.415873] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 4c a8 00 00 80 00
[93805.415883] end_request: I/O error, dev sdj, sector 28462248
[93805.415899] sd 13:0:0:1: [sdj] Unhandled error code
[93805.415902] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.415907] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 4d 28 00 00 80 00
[93805.415918] end_request: I/O error, dev sdj, sector 28462376
[93805.415932] sd 13:0:0:1: [sdj] Unhandled error code
[93805.415935] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.415941] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 4d a8 00 00 80 00
[93805.415951] end_request: I/O error, dev sdj, sector 28462504
[93805.415965] sd 13:0:0:1: [sdj] Unhandled error code
[93805.415969] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.415973] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 4e 28 00 00 80 00
[93805.415985] end_request: I/O error, dev sdj, sector 28462632
[93805.416001] sd 13:0:0:1: [sdj] Unhandled error code
[93805.416011] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.416043] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 4e a8 00 00 80 00
[93805.416108] end_request: I/O error, dev sdj, sector 28462760
[93805.416125] sd 13:0:0:1: [sdj] Unhandled error code
[93805.416128] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.416133] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 4f 28 00 00 80 00
[93805.416153] end_request: I/O error, dev sdj, sector 28462888
[93805.416171] sd 13:0:0:1: [sdj] Unhandled error code
[93805.416174] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.416178] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 4f a8 00 00 80 00
[93805.416199] end_request: I/O error, dev sdj, sector 28463016
[93805.416214] sd 13:0:0:1: [sdj] Unhandled error code
[93805.416218] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.416222] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 50 28 00 00 80 00
[93805.416230] end_request: I/O error, dev sdj, sector 28463144
[93805.416244] sd 13:0:0:1: [sdj] Unhandled error code
[93805.416247] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.416261] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 50 a8 00 00 80 00
[93805.416270] end_request: I/O error, dev sdj, sector 28463272
[93805.416284] sd 13:0:0:1: [sdj] Unhandled error code
[93805.416287] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.416292] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 51 28 00 00 80 00
[93805.416299] end_request: I/O error, dev sdj, sector 28463400
[93805.416314] sd 13:0:0:1: [sdj] Unhandled error code
[93805.416318] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.416323] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 51 a8 00 00 80 00
[93805.416335] end_request: I/O error, dev sdj, sector 28463528
[93805.416349] sd 13:0:0:1: [sdj] Unhandled error code
[93805.416352] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.416357] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 52 28 00 00 80 00
[93805.416376] end_request: I/O error, dev sdj, sector 28463656
[93805.416391] sd 13:0:0:1: [sdj] Unhandled error code
[93805.416395] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.416402] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 52 a8 00 00 80 00
[93805.416420] end_request: I/O error, dev sdj, sector 28463784
[93805.416435] sd 13:0:0:1: [sdj] Unhandled error code
[93805.416438] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.416444] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 53 28 00 00 80 00
[93805.416462] end_request: I/O error, dev sdj, sector 28463912
[93805.416477] sd 13:0:0:1: [sdj] Unhandled error code
[93805.416480] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.416487] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 53 a8 00 00 80 00
[93805.416506] end_request: I/O error, dev sdj, sector 28464040
[93805.416521] sd 13:0:0:1: [sdj] Unhandled error code
[93805.416525] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.416530] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 54 28 00 00 80 00
[93805.416542] end_request: I/O error, dev sdj, sector 28464168
[93805.416556] sd 13:0:0:1: [sdj] Unhandled error code
[93805.416559] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.416565] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 54 a8 00 00 80 00
[93805.416576] end_request: I/O error, dev sdj, sector 28464296
[93805.416590] sd 13:0:0:1: [sdj] Unhandled error code
[93805.416593] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.416598] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 55 28 00 00 80 00
[93805.416609] end_request: I/O error, dev sdj, sector 28464424
[93805.416623] sd 13:0:0:1: [sdj] Unhandled error code
[93805.416627] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.416632] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 55 a8 00 00 80 00
[93805.416643] end_request: I/O error, dev sdj, sector 28464552
[93805.416657] sd 13:0:0:1: [sdj] Unhandled error code
[93805.416660] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.416665] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 56 28 00 00 80 00
[93805.416676] end_request: I/O error, dev sdj, sector 28464680
[93805.416691] sd 13:0:0:1: [sdj] Unhandled error code
[93805.416696] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.416703] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 56 a8 00 00 80 00
[93805.416721] end_request: I/O error, dev sdj, sector 28464808
[93805.416737] sd 13:0:0:1: [sdj] Unhandled error code
[93805.416742] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.416749] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 57 28 00 00 80 00
[93805.416768] end_request: I/O error, dev sdj, sector 28464936
[93805.416783] sd 13:0:0:1: [sdj] Unhandled error code
[93805.416786] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.416793] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 57 a8 00 00 80 00
[93805.416808] end_request: I/O error, dev sdj, sector 28465064
[93805.416822] sd 13:0:0:1: [sdj] Unhandled error code
[93805.416827] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.416834] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 58 28 00 00 80 00
[93805.416853] end_request: I/O error, dev sdj, sector 28465192
[93805.416867] sd 13:0:0:1: [sdj] Unhandled error code
[93805.416872] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.416879] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 58 a8 00 00 80 00
[93805.416897] end_request: I/O error, dev sdj, sector 28465320
[93805.416912] sd 13:0:0:1: [sdj] Unhandled error code
[93805.416915] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.416922] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 59 28 00 00 80 00
[93805.416940] end_request: I/O error, dev sdj, sector 28465448
[93805.416955] sd 13:0:0:1: [sdj] Unhandled error code
[93805.416958] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.416965] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 59 a8 00 00 80 00
[93805.416984] end_request: I/O error, dev sdj, sector 28465576
[93805.416999] sd 13:0:0:1: [sdj] Unhandled error code
[93805.417010] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.417016] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 5a 28 00 00 80 00
[93805.417035] end_request: I/O error, dev sdj, sector 28465704
[93805.417051] sd 13:0:0:1: [sdj] Unhandled error code
[93805.417056] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.417063] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 5a a8 00 00 80 00
[93805.417081] end_request: I/O error, dev sdj, sector 28465832
[93805.417096] sd 13:0:0:1: [sdj] Unhandled error code
[93805.417101] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.417108] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 5b 28 00 00 80 00
[93805.417126] end_request: I/O error, dev sdj, sector 28465960
[93805.417141] sd 13:0:0:1: [sdj] Unhandled error code
[93805.417144] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.417150] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 5b a8 00 00 80 00
[93805.417161] end_request: I/O error, dev sdj, sector 28466088
[93805.417175] sd 13:0:0:1: [sdj] Unhandled error code
[93805.417178] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.417183] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 5c 28 00 00 80 00
[93805.417194] end_request: I/O error, dev sdj, sector 28466216
[93805.417208] sd 13:0:0:1: [sdj] Unhandled error code
[93805.417212] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.417217] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 5c a8 00 00 80 00
[93805.417228] end_request: I/O error, dev sdj, sector 28466344
[93805.417243] sd 13:0:0:1: [sdj] Unhandled error code
[93805.417247] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.417252] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 5d 28 00 00 80 00
[93805.417262] end_request: I/O error, dev sdj, sector 28466472
[93805.417276] sd 13:0:0:1: [sdj] Unhandled error code
[93805.417279] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.417284] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 5d a8 00 00 80 00
[93805.417303] end_request: I/O error, dev sdj, sector 28466600
[93805.417317] sd 13:0:0:1: [sdj] Unhandled error code
[93805.417321] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.417328] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 5e 28 00 00 80 00
[93805.417347] end_request: I/O error, dev sdj, sector 28466728
[93805.417361] sd 13:0:0:1: [sdj] Unhandled error code
[93805.417365] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.417371] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 5e a8 00 00 80 00
[93805.417389] end_request: I/O error, dev sdj, sector 28466856
[93805.417403] sd 13:0:0:1: [sdj] Unhandled error code
[93805.417407] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.417413] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 5f 28 00 00 80 00
[93805.417432] end_request: I/O error, dev sdj, sector 28466984
[93805.417446] sd 13:0:0:1: [sdj] Unhandled error code
[93805.417449] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.417456] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 5f a8 00 00 80 00
[93805.417475] end_request: I/O error, dev sdj, sector 28467112
[93805.417490] sd 13:0:0:1: [sdj] Unhandled error code
[93805.417495] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.417502] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 60 28 00 00 80 00
[93805.417520] end_request: I/O error, dev sdj, sector 28467240
[93805.417535] sd 13:0:0:1: [sdj] Unhandled error code
[93805.417538] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.417545] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 60 a8 00 00 80 00
[93805.417564] end_request: I/O error, dev sdj, sector 28467368
[93805.417578] sd 13:0:0:1: [sdj] Unhandled error code
[93805.417581] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.417588] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 61 28 00 00 80 00
[93805.417607] end_request: I/O error, dev sdj, sector 28467496
[93805.417622] sd 13:0:0:1: [sdj] Unhandled error code
[93805.417627] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.417634] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 61 a8 00 00 80 00
[93805.417651] end_request: I/O error, dev sdj, sector 28467624
[93805.417666] sd 13:0:0:1: [sdj] Unhandled error code
[93805.417670] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.417675] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 62 28 00 00 80 00
[93805.417686] end_request: I/O error, dev sdj, sector 28467752
[93805.417700] sd 13:0:0:1: [sdj] Unhandled error code
[93805.417703] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.417708] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 62 a8 00 00 80 00
[93805.417719] end_request: I/O error, dev sdj, sector 28467880
[93805.417734] sd 13:0:0:1: [sdj] Unhandled error code
[93805.417737] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.417742] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 63 28 00 00 80 00
[93805.417751] end_request: I/O error, dev sdj, sector 28468008
[93805.417766] sd 13:0:0:1: [sdj] Unhandled error code
[93805.417770] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.417775] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 63 a8 00 00 80 00
[93805.417794] end_request: I/O error, dev sdj, sector 28468136
[93805.417809] sd 13:0:0:1: [sdj] Unhandled error code
[93805.417812] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.417819] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 64 28 00 00 80 00
[93805.417838] end_request: I/O error, dev sdj, sector 28468264
[93805.417853] sd 13:0:0:1: [sdj] Unhandled error code
[93805.417857] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.417864] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 64 a8 00 00 80 00
[93805.417882] end_request: I/O error, dev sdj, sector 28468392
[93805.417897] sd 13:0:0:1: [sdj] Unhandled error code
[93805.417902] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.417908] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 65 28 00 00 80 00
[93805.417926] end_request: I/O error, dev sdj, sector 28468520
[93805.417939] sd 13:0:0:1: [sdj] Unhandled error code
[93805.417942] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.417947] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 65 a8 00 00 80 00
[93805.417963] end_request: I/O error, dev sdj, sector 28468648
[93805.433591] sd 13:0:0:1: [sdj] Unhandled error code
[93805.433594] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.433599] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 66 28 00 00 80 00
[93805.433607] end_request: I/O error, dev sdj, sector 28468776
[93805.434014] sd 13:0:0:1: [sdj] Unhandled error code
[93805.434019] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.434024] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 66 a8 00 00 80 00
[93805.434036] end_request: I/O error, dev sdj, sector 28468904
[93805.434646] sd 13:0:0:1: [sdj] Unhandled error code
[93805.434650] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.434656] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 67 28 00 00 80 00
[93805.434668] end_request: I/O error, dev sdj, sector 28469032
[93805.434739] sd 13:0:0:1: [sdj] Unhandled error code
[93805.434741] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.434744] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 67 a8 00 00 80 00
[93805.434750] end_request: I/O error, dev sdj, sector 28469160
[93805.435119] sd 13:0:0:1: [sdj] Unhandled error code
[93805.435123] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.435129] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 68 28 00 00 80 00
[93805.435141] end_request: I/O error, dev sdj, sector 28469288
[93805.435484] sd 13:0:0:1: [sdj] Unhandled error code
[93805.435488] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.435494] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 68 a8 00 00 80 00
[93805.435506] end_request: I/O error, dev sdj, sector 28469416
[93805.435858] sd 13:0:0:1: [sdj] Unhandled error code
[93805.435862] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.435868] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 69 28 00 00 80 00
[93805.435880] end_request: I/O error, dev sdj, sector 28469544
[93805.436524] sd 13:0:0:1: [sdj] Unhandled error code
[93805.436529] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.436534] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 69 a8 00 00 80 00
[93805.436546] end_request: I/O error, dev sdj, sector 28469672
[93805.436637] sd 13:0:0:1: [sdj] Unhandled error code
[93805.436641] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.436646] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 6a 28 00 00 80 00
[93805.436658] end_request: I/O error, dev sdj, sector 28469800
[93805.437014] sd 13:0:0:1: [sdj] Unhandled error code
[93805.437017] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.437020] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 6a a8 00 00 80 00
[93805.437027] end_request: I/O error, dev sdj, sector 28469928
[93805.437371] sd 13:0:0:1: [sdj] Unhandled error code
[93805.437373] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.437378] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 6b 28 00 00 80 00
[93805.437393] end_request: I/O error, dev sdj, sector 28470056
[93805.437760] sd 13:0:0:1: [sdj] Unhandled error code
[93805.437762] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.437764] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 6b a8 00 00 80 00
[93805.437768] end_request: I/O error, dev sdj, sector 28470184
[93805.438147] sd 13:0:0:1: [sdj] Unhandled error code
[93805.438150] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.438155] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 6c 28 00 00 80 00
[93805.438169] end_request: I/O error, dev sdj, sector 28470312
[93805.438525] sd 13:0:0:1: [sdj] Unhandled error code
[93805.438527] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.438529] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 6c a8 00 00 80 00
[93805.438535] end_request: I/O error, dev sdj, sector 28470440
[93805.438901] sd 13:0:0:1: [sdj] Unhandled error code
[93805.438903] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.438906] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 6d 28 00 00 80 00
[93805.438911] end_request: I/O error, dev sdj, sector 28470568
[93805.439562] sd 13:0:0:1: [sdj] Unhandled error code
[93805.439567] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.439573] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 6d a8 00 00 80 00
[93805.439585] end_request: I/O error, dev sdj, sector 28470696
[93805.439606] sd 13:0:0:1: [sdj] Unhandled error code
[93805.439610] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.439615] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 6e 28 00 00 80 00
[93805.439626] end_request: I/O error, dev sdj, sector 28470824
[93805.439641] sd 13:0:0:1: [sdj] Unhandled error code
[93805.439644] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.439649] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 6e a8 00 00 80 00
[93805.439660] end_request: I/O error, dev sdj, sector 28470952
[93805.439687] sd 13:0:0:1: [sdj] Unhandled error code
[93805.439690] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.439695] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 6f 28 00 00 80 00
[93805.439706] end_request: I/O error, dev sdj, sector 28471080
[93805.439725] sd 13:0:0:1: [sdj] Unhandled error code
[93805.439728] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.439733] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 6f a8 00 00 80 00
[93805.439750] end_request: I/O error, dev sdj, sector 28471208
[93805.439764] sd 13:0:0:1: [sdj] Unhandled error code
[93805.439767] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.439772] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 70 28 00 00 80 00
[93805.439783] end_request: I/O error, dev sdj, sector 28471336
[93805.439796] sd 13:0:0:1: [sdj] Unhandled error code
[93805.439800] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.439805] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 70 a8 00 00 80 00
[93805.439816] end_request: I/O error, dev sdj, sector 28471464
[93805.439829] sd 13:0:0:1: [sdj] Unhandled error code
[93805.439833] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.439838] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 71 28 00 00 80 00
[93805.439855] end_request: I/O error, dev sdj, sector 28471592
[93805.439868] sd 13:0:0:1: [sdj] Unhandled error code
[93805.439872] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.439877] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 71 a8 00 00 80 00
[93805.439888] end_request: I/O error, dev sdj, sector 28471720
[93805.439909] sd 13:0:0:1: [sdj] Unhandled error code
[93805.439913] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.439918] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 72 28 00 00 80 00
[93805.439932] end_request: I/O error, dev sdj, sector 28471848
[93805.439951] sd 13:0:0:1: [sdj] Unhandled error code
[93805.439954] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.439959] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 72 a8 00 00 80 00
[93805.439977] end_request: I/O error, dev sdj, sector 28471976
[93805.439990] sd 13:0:0:1: [sdj] Unhandled error code
[93805.439994] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.439999] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 73 28 00 00 80 00
[93805.440026] end_request: I/O error, dev sdj, sector 28472104
[93805.440044] sd 13:0:0:1: [sdj] Unhandled error code
[93805.440049] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.440059] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 73 a8 00 00 80 00
[93805.440092] end_request: I/O error, dev sdj, sector 28472232
[93805.440110] sd 13:0:0:1: [sdj] Unhandled error code
[93805.440116] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.440126] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 74 28 00 00 80 00
[93805.440159] end_request: I/O error, dev sdj, sector 28472360
[93805.440175] sd 13:0:0:1: [sdj] Unhandled error code
[93805.440180] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.440189] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 74 a8 00 00 80 00
[93805.440223] end_request: I/O error, dev sdj, sector 28472488
[93805.440239] sd 13:0:0:1: [sdj] Unhandled error code
[93805.440245] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.440254] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 75 28 00 00 80 00
[93805.440288] end_request: I/O error, dev sdj, sector 28472616
[93805.440306] sd 13:0:0:1: [sdj] Unhandled error code
[93805.440312] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.440321] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 75 a8 00 00 80 00
[93805.440355] end_request: I/O error, dev sdj, sector 28472744
[93805.440371] sd 13:0:0:1: [sdj] Unhandled error code
[93805.440377] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.440386] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 76 28 00 00 80 00
[93805.440419] end_request: I/O error, dev sdj, sector 28472872
[93805.440435] sd 13:0:0:1: [sdj] Unhandled error code
[93805.440441] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.440450] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 76 a8 00 00 80 00
[93805.440483] end_request: I/O error, dev sdj, sector 28473000
[93805.440499] sd 13:0:0:1: [sdj] Unhandled error code
[93805.440505] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.440513] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 77 28 00 00 80 00
[93805.440547] end_request: I/O error, dev sdj, sector 28473128
[93805.440563] sd 13:0:0:1: [sdj] Unhandled error code
[93805.440568] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.440577] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 77 a8 00 00 80 00
[93805.440610] end_request: I/O error, dev sdj, sector 28473256
[93805.440626] sd 13:0:0:1: [sdj] Unhandled error code
[93805.440632] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.440641] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 78 28 00 00 80 00
[93805.440674] end_request: I/O error, dev sdj, sector 28473384
[93805.440690] sd 13:0:0:1: [sdj] Unhandled error code
[93805.440695] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.440704] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 78 a8 00 00 80 00
[93805.440737] end_request: I/O error, dev sdj, sector 28473512
[93805.440753] sd 13:0:0:1: [sdj] Unhandled error code
[93805.440759] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.440768] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 79 28 00 00 80 00
[93805.440801] end_request: I/O error, dev sdj, sector 28473640
[93805.440817] sd 13:0:0:1: [sdj] Unhandled error code
[93805.440823] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.440832] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 79 a8 00 00 80 00
[93805.440866] end_request: I/O error, dev sdj, sector 28473768
[93805.440882] sd 13:0:0:1: [sdj] Unhandled error code
[93805.440887] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.440896] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 7a 28 00 00 80 00
[93805.440929] end_request: I/O error, dev sdj, sector 28473896
[93805.440945] sd 13:0:0:1: [sdj] Unhandled error code
[93805.440951] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.440960] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 7a a8 00 00 80 00
[93805.440993] end_request: I/O error, dev sdj, sector 28474024
[93805.441017] sd 13:0:0:1: [sdj] Unhandled error code
[93805.441023] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.441032] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 7b 28 00 00 80 00
[93805.441065] end_request: I/O error, dev sdj, sector 28474152
[93805.441087] sd 13:0:0:1: [sdj] Unhandled error code
[93805.441091] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.441096] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 7b a8 00 00 80 00
[93805.441110] end_request: I/O error, dev sdj, sector 28474280
[93805.441124] sd 13:0:0:1: [sdj] Unhandled error code
[93805.441127] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.441132] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 7c 28 00 00 80 00
[93805.441143] end_request: I/O error, dev sdj, sector 28474408
[93805.441157] sd 13:0:0:1: [sdj] Unhandled error code
[93805.441161] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.441166] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 7c a8 00 00 80 00
[93805.441185] end_request: I/O error, dev sdj, sector 28474536
[93805.441201] sd 13:0:0:1: [sdj] Unhandled error code
[93805.441204] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.441210] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 7d 28 00 00 80 00
[93805.441228] end_request: I/O error, dev sdj, sector 28474664
[93805.441244] sd 13:0:0:1: [sdj] Unhandled error code
[93805.441247] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.441254] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 7d a8 00 00 80 00
[93805.441273] end_request: I/O error, dev sdj, sector 28474792
[93805.441290] sd 13:0:0:1: [sdj] Unhandled error code
[93805.441295] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.441302] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 7e 28 00 00 80 00
[93805.441320] end_request: I/O error, dev sdj, sector 28474920
[93805.441336] sd 13:0:0:1: [sdj] Unhandled error code
[93805.441340] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.441347] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 7e a8 00 00 80 00
[93805.441365] end_request: I/O error, dev sdj, sector 28475048
[93805.441381] sd 13:0:0:1: [sdj] Unhandled error code
[93805.441384] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.441390] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 7f 28 00 00 80 00
[93805.441409] end_request: I/O error, dev sdj, sector 28475176
[93805.441422] sd 13:0:0:1: [sdj] Unhandled error code
[93805.441425] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.441430] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 b2 7f a8 00 00 80 00
[93805.441449] end_request: I/O error, dev sdj, sector 28475304
[93805.446693] sd 13:0:0:1: [sdj] Unhandled error code
[93805.446700] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.446707] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 20 79 b0 00 00 30 00
[93805.446722] end_request: I/O error, dev sdj, sector 18905520
[93805.446777] sd 13:0:0:1: [sdj] Unhandled error code
[93805.446781] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.446786] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 20 7a 00 00 00 40 00
[93805.446798] end_request: I/O error, dev sdj, sector 18905600
[93805.446832] sd 13:0:0:1: [sdj] Unhandled error code
[93805.446835] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.446840] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 20 7a 68 00 00 28 00
[93805.446852] end_request: I/O error, dev sdj, sector 18905704
[93805.446881] sd 13:0:0:1: [sdj] Unhandled error code
[93805.446884] sd 13:0:0:1: [sdj]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[93805.446889] sd 13:0:0:1: [sdj] CDB: Write(10): 2a 20 01 20 7a b0 00 00 10 00
[93805.446900] end_request: I/O error, dev sdj, sector 18905776
[93805.447060] lost page write due to I/O error on sdi1
[93805.447088] lost page write due to I/O error on sdi1
[93805.447115] lost page write due to I/O error on sdi1
[93805.454060] lost page write due to I/O error on sdj1
[93805.454078] lost page write due to I/O error on sdj1
[93805.454093] lost page write due to I/O error on sdj1
[93805.454171] btrfs: 2 errors while writing supers
[93805.454206] ------------[ cut here ]------------
[93805.454279] kernel BUG at fs/btrfs/disk-io.c:2362!
[93805.454340] invalid opcode: 0000 [#1] PREEMPT SMP 
[93805.454408] CPU 4 
[93805.454435] Modules linked in: bridge stp ext4 jbd2 crc16 ipt_REJECT iptable_filter iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ipv6 nf_defrag_ipv6 xt_state ip6t_REJECT xt_tcpudp ip6table_filter xt_dscp xt_string xt_owner xt_NFQUEUE xt_multiport xt_mark xt_iprange xt_hashlimit xt_conntrack xt_connmark nf_conntrack ip6_tables ip_tables x_tables fuse sr_mod uvcvideo cdrom zaurus cdc_ether usbnet btusb bluetooth
[93805.455006] 
[93805.455006] Pid: 30262, comm: sync Tainted: G       A    3.0.0+ #00002-g2f054bd64 empty empty/S2932/S2932-E
[93805.455006] RIP: 0010:[<ffffffff811d3cf8>]  [<ffffffff811d3cf8>] write_all_supers+0x298/0x2c0
[93805.455006] RSP: 0018:ffff88045c78bd58  EFLAGS: 00010296
[93805.455006] RAX: 000000000000003a RBX: ffff880460a861f0 RCX: 00000000000fffff
[93805.455006] RDX: ffffffff81c329e8 RSI: 0000000000000046 RDI: ffffffff81d8b9d0
[93805.455006] RBP: ffff88045c78bdd8 R08: 0000000000000000 R09: 0000000000000000
[93805.455006] R10: 0000000000000006 R11: 0000000000000000 R12: 0000000000000002
[93805.455006] R13: ffff88045c78bda0 R14: ffff880460a861f0 R15: 0000000000000001
[93805.455006] FS:  00007f61b43e4700(0000) GS:ffff88047fc00000(0000) knlGS:00000000f6a03800
[93805.455006] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[93805.455006] CR2: 0000000000ea7338 CR3: 000000029380b000 CR4: 00000000000006e0
[93805.455006] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[93805.455006] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[93805.455006] Process sync (pid: 30262, threadinfo ffff88045c78a000, task ffff8803b64b9600)
[93805.455006] Stack:
[93805.455006]  ffffea0008d98338 ffff880111b14f6e ffff880460a86180 0000000100000001
[93805.455006]  ffff880111b14f7e 000000007521e800 ffff880111b14e63 ffff88027521e800
[93805.455006]  0000000000000000 ffff880460a861f0 ffff88045c78bdd8 ffff88027521e800
[93805.455006] Call Trace:
[93805.455006]  [<ffffffff811d3d2e>] write_ctree_super+0xe/0x10
[93805.455006]  [<ffffffff811d89c5>] btrfs_commit_transaction+0x685/0x820
[93805.455006]  [<ffffffff81103440>] ? iput+0x40/0x1c0
[93805.455006]  [<ffffffff811d8c81>] ? join_transaction+0x61/0x260
[93805.455006]  [<ffffffff81061880>] ? wake_up_bit+0x40/0x40
[93805.455006]  [<ffffffff81112c00>] ? __sync_filesystem+0x80/0x80
[93805.455006]  [<ffffffff811b1647>] btrfs_sync_fs+0x47/0x80
[93805.455006]  [<ffffffff81112c00>] ? __sync_filesystem+0x80/0x80
[93805.455006]  [<ffffffff81112bd9>] __sync_filesystem+0x59/0x80
[93805.455006]  [<ffffffff81112c17>] sync_one_sb+0x17/0x20
[93805.455006]  [<ffffffff810ecdbe>] iterate_supers+0x7e/0xe0
[93805.455006]  [<ffffffff81112b3b>] sync_filesystems+0x1b/0x20
[93805.455006]  [<ffffffff81112c3c>] sys_sync+0x1c/0x40
[93805.455006]  [<ffffffff816cd03b>] system_call_fastpath+0x16/0x1b
[93805.455006] Code: b8 48 8b 81 20 01 00 00 48 8b b8 48 23 00 00 48 83 c7 50 e8 1b 6e 4f 00 eb d2 44 89 e6 48 c7 c7 b0 58 a1 81 31 c0 e8 b1 55 4f 00 <0f> 0b eb fe 44 89 ce 48 c7 c7 b0 58 a1 81 31 c0 e8 9c 55 4f 00 
[93805.455006] RIP  [<ffffffff811d3cf8>] write_all_supers+0x298/0x2c0
[93805.455006]  RSP <ffff88045c78bd58>
[93805.489542] ---[ end trace c0fbb585ab150cee ]---
[93805.512215] usb 1-1.1.3: usb_disable_device nuking all URBs
[93805.616758] hub 1-1.1:1.0: debounce: port 3: total 100ms stable 100ms status 0x500
[93806.001687] ------------[ cut here ]------------
[93806.001789] kernel BUG at fs/btrfs/inode.c:1662!
[93806.001876] invalid opcode: 0000 [#2] PREEMPT SMP 
[93806.002007] CPU 2 
[93806.002033] Modules linked in: bridge stp ext4 jbd2 crc16 ipt_REJECT iptable_filter iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ipv6 nf_defrag_ipv6 xt_state ip6t_REJECT xt_tcpudp ip6table_filter xt_dscp xt_string xt_owner xt_NFQUEUE xt_multiport xt_mark xt_iprange xt_hashlimit xt_conntrack xt_connmark nf_conntrack ip6_tables ip_tables x_tables fuse sr_mod uvcvideo cdrom zaurus cdc_ether usbnet btusb bluetooth
[93806.002649] 
[93806.002649] Pid: 29599, comm: btrfs-endio-wri Tainted: G      DA    3.0.0+ #00002-g2f054bd64 empty empty/S2932/S2932-E
[93806.002649] RIP: 0010:[<ffffffff811e5592>]  [<ffffffff811e5592>] T.1215+0x242/0x260
[93806.002649] RSP: 0018:ffff880110badc40  EFLAGS: 00010282
[93806.002649] RAX: 00000000fffffffb RBX: ffff880262fe16c0 RCX: 000000000129742a
[93806.002649] RDX: 0000000001297422 RSI: 000060fb800000d0 RDI: ffffea00085a7938
[93806.002649] RBP: ffff880110badcd0 R08: ffffffff811bbdf5 R09: 0000000000000000
[93806.002649] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880109f18578
[93806.002649] R13: 0000000052d80000 R14: ffff8802758b3800 R15: ffff880265937af8
[93806.002649] FS:  00007ff3ed4d8710(0000) GS:ffff88027fd00000(0000) knlGS:00000000f6a2a800
[93806.002649] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[93806.002649] CR2: 00007f906571b000 CR3: 0000000001c23000 CR4: 00000000000006e0
[93806.002649] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[93806.002649] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[93806.002649] Process btrfs-endio-wri (pid: 29599, threadinfo ffff880110bac000, task ffff880268089600)
[93806.002649] Stack:
[93806.002649]  0000000052d80000 0000000000400000 0000000366300000 0000000000400000
[93806.002649]  ffff880265937af8 ffff8802758b3800 ffff880110badcc0 ffffffff811d8f11
[93806.002649]  ffff880110badcd0 0000000000000010 ffff880110badce0 ffff880109f18578
[93806.002649] Call Trace:
[93806.002649]  [<ffffffff811d8f11>] ? start_transaction+0x91/0x2d0
[93806.002649]  [<ffffffff811e5b6b>] btrfs_finish_ordered_io+0x2db/0x330
[93806.002649]  [<ffffffff810a8907>] ? test_clear_page_writeback+0xf7/0x130
[93806.002649]  [<ffffffff811e5bd5>] btrfs_writepage_end_io_hook+0x15/0x20
[93806.002649]  [<ffffffff811fb13b>] end_bio_extent_writepage+0x13b/0x180
[93806.002649]  [<ffffffff81118718>] bio_endio+0x18/0x40
[93806.002649]  [<ffffffff811d3704>] end_workqueue_fn+0xf4/0x130
[93806.002649]  [<ffffffff8120501f>] worker_loop+0x14f/0x530
[93806.002649]  [<ffffffff81204ed0>] ? btrfs_queue_worker+0x300/0x300
[93806.056013]  [<ffffffff81204ed0>] ? btrfs_queue_worker+0x300/0x300
[93806.056013]  [<ffffffff810613e6>] kthread+0x96/0xa0
[93806.056013]  [<ffffffff816cdd94>] kernel_thread_helper+0x4/0x10
[93806.056013]  [<ffffffff81061350>] ? kthread_worker_fn+0x180/0x180
[93806.056013]  [<ffffffff816cdd90>] ? gs_change+0xb/0xb
[93806.056013] Code: 83 c4 68 31 c0 5b 41 5c 41 5d 41 5e 41 5f c9 c3 90 49 8b 84 24 b0 00 00 00 e9 55 fe ff ff 0f 1f 00 49 8b 8c 24 b0 00 00 00 eb af <0f> 0b eb fe 66 90 0f 0b eb fe 0f 1f 40 00 0f 0b eb fe 0f 1f 40 
[93806.056013] RIP  [<ffffffff811e5592>] T.1215+0x242/0x260
[93806.056013]  RSP <ffff880110badc40>
[93806.057081] ---[ end trace c0fbb585ab150cef ]---
[93806.122305] ------------[ cut here ]------------
[93806.123263] kernel BUG at fs/btrfs/inode.c:1662!
[93806.123263] invalid opcode: 0000 [#3] PREEMPT SMP 
[93806.123263] CPU 1 
[93806.123263] Modules linked in: bridge stp ext4 jbd2 crc16 ipt_REJECT iptable_filter iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ipv6 nf_defrag_ipv6 xt_state ip6t_REJECT xt_tcpudp ip6table_filter xt_dscp xt_string xt_owner xt_NFQUEUE xt_multiport xt_mark xt_iprange xt_hashlimit xt_conntrack xt_connmark nf_conntrack ip6_tables ip_tables x_tables fuse sr_mod uvcvideo cdrom zaurus cdc_ether usbnet btusb bluetooth
[93806.123263] 
[93806.123263] Pid: 29658, comm: btrfs-endio-wri Tainted: G      DA    3.0.0+ #00002-g2f054bd64 empty empty/S2932/S2932-E
[93806.123263] RIP: 0010:[<ffffffff811e5592>]  [<ffffffff811e5592>] T.1215+0x242/0x260
[93806.123263] RSP: 0018:ffff880101627c40  EFLAGS: 00010282
[93806.123263] RAX: 00000000fffffffb RBX: ffff880262c18cf0 RCX: 0000000000b0ea21
[93806.123263] RDX: 0000000000b0ea19 RSI: 000060fb800000d0 RDI: ffffea000859a540
[93806.123263] RBP: ffff880101627cd0 R08: ffffffff811bbdf5 R09: 0000000000000000
[93806.123263] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880109f18578
[93806.123263] R13: 0000000053180000 R14: ffff8802758b3800 R15: ffff88026152bb88
[93806.123263] FS:  00007f39165f3700(0000) GS:ffff88027fc80000(0000) knlGS:00000000f36ffb70
[93806.123263] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[93806.123263] CR2: 00007f391616eca0 CR3: 00000002980b8000 CR4: 00000000000006f0
[93806.123263] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[93806.123263] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[93806.123263] Process btrfs-endio-wri (pid: 29658, threadinfo ffff880101626000, task ffff88000b092c00)
[93806.123263] Stack:
[93806.123263]  0000000053180000 0000000000100000 0000000366700000 0000000000100000
[93806.123263]  ffff88026152bb88 ffff8802758b3800 ffff880101627cc0 ffffffff811d8f11
[93806.123263]  ffff880101627cd0 0000000000000010 ffff880101627ce0 ffff880109f18578
[93806.123263] Call Trace:
[93806.123263]  [<ffffffff811d8f11>] ? start_transaction+0x91/0x2d0
[93806.123263]  [<ffffffff811e5b6b>] btrfs_finish_ordered_io+0x2db/0x330
[93806.123263]  [<ffffffff810a8907>] ? test_clear_page_writeback+0xf7/0x130
[93806.123263]  [<ffffffff811e5bd5>] btrfs_writepage_end_io_hook+0x15/0x20
[93806.255016]  [<ffffffff811fb13b>] end_bio_extent_writepage+0x13b/0x180
[93806.255016]  [<ffffffff81118718>] bio_endio+0x18/0x40
[93806.255016]  [<ffffffff811d3704>] end_workqueue_fn+0xf4/0x130
[93806.255016]  [<ffffffff8120501f>] worker_loop+0x14f/0x530
[93806.255016]  [<ffffffff81204ed0>] ? btrfs_queue_worker+0x300/0x300
[93806.255016]  [<ffffffff81204ed0>] ? btrfs_queue_worker+0x300/0x300
[93806.255016]  [<ffffffff810613e6>] kthread+0x96/0xa0
[93806.255016]  [<ffffffff816cdd94>] kernel_thread_helper+0x4/0x10
[93806.255016]  [<ffffffff81061350>] ? kthread_worker_fn+0x180/0x180
[93806.255016]  [<ffffffff816cdd90>] ? gs_change+0xb/0xb
[93806.255016] Code: 83 c4 68 31 c0 5b 41 5c 41 5d 41 5e 41 5f c9 c3 90 49 8b 84 24 b0 00 00 00 e9 55 fe ff ff 0f 1f 00 49 8b 8c 24 b0 00 00 00 eb af <0f> 0b eb fe 66 90 0f 0b eb fe 0f 1f 40 00 0f 0b eb fe 0f 1f 40 
[93806.255016] RIP  [<ffffffff811e5592>] T.1215+0x242/0x260
[93806.255016]  RSP <ffff880101627c40>
[93806.258794] ---[ end trace c0fbb585ab150cf0 ]---
[93806.593753] hub 1-1.1:1.0: state 7 ports 4 chg 0000 evt 0008
[93806.594790] hub 1-1.1:1.0: port 3, status 0101, change 0001, 12 Mb/s
[93806.698670] hub 1-1.1:1.0: debounce: port 3: total 100ms stable 100ms status 0x101
[93806.709661] hub 1-1.1:1.0: port 3 not reset yet, waiting 10ms
[93806.771681] usb 1-1.1.3: new high speed USB device number 22 using ehci_hcd
[93806.784156] hub 1-1.1:1.0: port 3 not reset yet, waiting 10ms
[93806.860893] usb 1-1.1.3: default language 0x0409
[93806.862268] usb 1-1.1.3: udev 22, busnum 1, minor = 21
[93806.862274] usb 1-1.1.3: New USB device found, idVendor=152d, idProduct=2336
[93806.862279] usb 1-1.1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=5
[93806.862284] usb 1-1.1.3: Product: JM20336 SATA, USB Combo
[93806.862289] usb 1-1.1.3: Manufacturer: JMicron
[93806.862292] usb 1-1.1.3: SerialNumber: DCA084731388
[93806.862564] usb 1-1.1.3: usb_probe_device
[93806.862572] usb 1-1.1.3: configuration #1 chosen from 1 choice
[93806.863410] usb 1-1.1.3: adding 1-1.1.3:1.0 (config #1, interface 0)
[93806.864194] usb-storage 1-1.1.3:1.0: usb_probe_interface
[93806.864206] usb-storage 1-1.1.3:1.0: usb_probe_interface - got id
[93806.864334] scsi14 : usb-storage 1-1.1.3:1.0
[93806.864543] drivers/usb/core/inode.c: creating file '022'
[93806.866925] scsi 14:0:0:0: Direct-Access     WDC WD20 EARS-00J99B0          PQ: 0 ANSI: 2 CCS
[93806.870306] scsi 14:0:0:1: Direct-Access     WDC WD20 EARS-00J99B0          PQ: 0 ANSI: 2 CCS
[93807.002480] sd 14:0:0:0: Attached scsi generic sg9 type 0
[93807.002780] sd 14:0:0:1: Attached scsi generic sg10 type 0
[93807.004411] sd 14:0:0:0: [sdk] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[93807.005556] sd 14:0:0:1: [sdl] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[93807.007681] sd 14:0:0:0: [sdk] Write Protect is off
[93807.007692] sd 14:0:0:0: [sdk] Mode Sense: 00 38 00 00
[93807.009672] sd 14:0:0:1: [sdl] Write Protect is off
[93807.009682] sd 14:0:0:1: [sdl] Mode Sense: 00 38 00 00
[93807.011651] sd 14:0:0:0: [sdk] Asking for cache data failed
[93807.011658] sd 14:0:0:0: [sdk] Assuming drive cache: write through
[93807.013647] sd 14:0:0:1: [sdl] Asking for cache data failed
[93807.013653] sd 14:0:0:1: [sdl] Assuming drive cache: write through
[93807.021643] sd 14:0:0:0: [sdk] Asking for cache data failed
[93807.021646] sd 14:0:0:0: [sdk] Assuming drive cache: write through
[93807.023650] sd 14:0:0:1: [sdl] Asking for cache data failed
[93807.023658] sd 14:0:0:1: [sdl] Assuming drive cache: write through
[93807.112119]  sdk: sdk1
[93807.112598]  sdl: sdl1
[93807.121649] sd 14:0:0:0: [sdk] Asking for cache data failed
[93807.121656] sd 14:0:0:0: [sdk] Assuming drive cache: write through
[93807.121662] sd 14:0:0:0: [sdk] Attached SCSI disk
[93807.126640] sd 14:0:0:1: [sdl] Asking for cache data failed
[93807.126649] sd 14:0:0:1: [sdl] Assuming drive cache: write through
[93807.126656] sd 14:0:0:1: [sdl] Attached SCSI disk
[93840.010284] BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
[93840.011249] IP: [<ffffffff811cb17f>] btrfs_print_leaf+0x2f/0x8d0
[93840.011249] PGD 101172067 PUD 2630cb067 PMD 0 
[93840.011249] Oops: 0000 [#4] PREEMPT SMP 
[93840.011249] CPU 4 
[93840.011249] Modules linked in: bridge stp ext4 jbd2 crc16 ipt_REJECT iptable_filter iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ipv6 nf_defrag_ipv6 xt_state ip6t_REJECT xt_tcpudp ip6table_filter xt_dscp xt_string xt_owner xt_NFQUEUE xt_multiport xt_mark xt_iprange xt_hashlimit xt_conntrack xt_connmark nf_conntrack ip6_tables ip_tables x_tables fuse sr_mod uvcvideo cdrom zaurus cdc_ether usbnet btusb bluetooth
[93840.011249] 
[93840.011249] Pid: 29603, comm: btrfs-transacti Tainted: G      DA    3.0.0+ #00002-g2f054bd64 empty empty/S2932/S2932-E
[93840.011249] RIP: 0010:[<ffffffff811cb17f>]  [<ffffffff811cb17f>] btrfs_print_leaf+0x2f/0x8d0
[93840.011249] RSP: 0018:ffff880262a35a90  EFLAGS: 00010287
[93840.011249] RAX: 00000000fffffffb RBX: 0000000000000000 RCX: ffff880262a35fd8
[93840.011249] RDX: ffff880262a34000 RSI: 0000000000000000 RDI: ffff88027521a800
[93840.011249] RBP: ffff880262a35b10 R08: 0000000000000001 R09: 0000000000000000
[93840.011249] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[93840.011249] R13: 0000000242231000 R14: 00000000fffffffb R15: 0000000000000000
[93840.011249] FS:  00007ff3ef27e710(0000) GS:ffff88047fc00000(0000) knlGS:00000000f6a2a800
[93840.011249] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[93840.011249] CR2: 0000000000000030 CR3: 0000000265e77000 CR4: 00000000000006e0
[93840.011249] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[93840.011249] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[93840.011249] Process btrfs-transacti (pid: 29603, threadinfo ffff880262a34000, task ffff88010e5c2c00)
[93840.011249] Stack:
[93840.011249]  0000000000000000 0000000242231000 ffff88027521a800 0000000000000000
[93840.011249]  0000000000000000 0000000000000000 0000000242231000 00000000001000a8
[93840.011249]  0000000000000000 ffffffff810dfc69 ffff880268103840 ffff88045bb6c120
[93840.011249] Call Trace:
[93840.011249]  [<ffffffff810dfc69>] ? kmem_cache_alloc+0x79/0xb0
[93840.011249]  [<ffffffff811ca0cb>] __btrfs_free_extent+0x62b/0x730
[93840.011249]  [<ffffffff81041f75>] ? load_balance+0xa5/0x7e0
[93840.011249]  [<ffffffff811ca6b2>] run_clustered_refs+0x4e2/0x7f0
[93840.011249]  [<ffffffff816c9c4b>] ? schedule+0x45b/0xac0
[93840.011249]  [<ffffffff81218600>] ? btrfs_find_ref_cluster+0x70/0x170
[93840.011249]  [<ffffffff811caa80>] btrfs_run_delayed_refs+0xc0/0x210
[93840.011249]  [<ffffffff811d83be>] btrfs_commit_transaction+0x7e/0x820
[93840.011249]  [<ffffffff810521a2>] ? del_timer_sync+0x32/0x50
[93840.011249]  [<ffffffff816ca761>] ? schedule_timeout+0x161/0x230
[93840.011249]  [<ffffffff811d8c81>] ? join_transaction+0x61/0x260
[93840.011249]  [<ffffffff81061880>] ? wake_up_bit+0x40/0x40
[93840.011249]  [<ffffffff811d2633>] transaction_kthread+0x273/0x280
[93840.011249]  [<ffffffff811d23c0>] ? find_and_setup_root+0x110/0x110
[93840.011249]  [<ffffffff811d23c0>] ? find_and_setup_root+0x110/0x110
[93840.011249]  [<ffffffff810613e6>] kthread+0x96/0xa0
[93840.011249]  [<ffffffff816cdd94>] kernel_thread_helper+0x4/0x10
[93840.011249]  [<ffffffff81061350>] ? kthread_worker_fn+0x180/0x180
[93840.011249]  [<ffffffff816cdd90>] ? gs_change+0xb/0xb
[93840.011249] Code: 0c 25 c8 b5 00 00 48 8d 91 28 e0 ff ff 48 89 e5 48 83 c4 80 48 89 5d d8 4c 89 65 e0 48 89 f3 4c 89 6d e8 4c 89 75 f0 4c 89 7d f8 
[93840.011249]  8b 76 30 ff 42 1c 48 b8 00 00 00 00 00 16 00 00 48 8d 04 06 
[93840.011249] RIP  [<ffffffff811cb17f>] btrfs_print_leaf+0x2f/0x8d0
[93840.011249]  RSP <ffff880262a35a90>
[93840.011249] CR2: 0000000000000030
[93840.235221] ---[ end trace c0fbb585ab150cf1 ]---
[93933.084007] btrfs failed to delete reference to .MVI_0478.MOV.6YQlBJ, inode 3518 parent 2578
[93933.084065] ------------[ cut here ]------------
[93933.087912] kernel BUG at fs/btrfs/inode.c:3024!
[93933.087912] invalid opcode: 0000 [#5] PREEMPT SMP 
[93933.087912] CPU 6 
[93933.087912] Modules linked in: bridge stp ext4 jbd2 crc16 ipt_REJECT iptable_filter iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ipv6 nf_defrag_ipv6 xt_state ip6t_REJECT xt_tcpudp ip6table_filter xt_dscp xt_string xt_owner xt_NFQUEUE xt_multiport xt_mark xt_iprange xt_hashlimit xt_conntrack xt_connmark nf_conntrack ip6_tables ip_tables x_tables fuse sr_mod uvcvideo cdrom zaurus cdc_ether usbnet btusb bluetooth
[93933.087912] 
[93933.087912] Pid: 29640, comm: rsync Tainted: G      DA    3.0.0+ #00002-g2f054bd64 empty empty/S2932/S2932-E
[93933.087912] RIP: 0010:[<ffffffff811e38b9>]  [<ffffffff811e38b9>] btrfs_unlink+0xc9/0xe0
[93933.087912] RSP: 0018:ffff88028adebe28  EFLAGS: 00010282
[93933.087912] RAX: 00000000fffffffb RBX: ffff88045bb759d8 RCX: 000000000080227e
[93933.087912] RDX: 0000000000802276 RSI: 000060fb800000d0 RDI: ffffea000f40b1c0
[93933.087912] RBP: ffff88028adebe58 R08: ffffffff811bbdf5 R09: 0000000000000001
[93933.087912] R10: 0000000000000005 R11: 0000000000000000 R12: 00000000fffffffb
[93933.087912] R13: ffff88010f7194f8 R14: ffff8802758b3800 R15: ffff880109f18578
[93933.087912] FS:  00007f16835e6700(0000) GS:ffff88047fd00000(0000) knlGS:00000000f6a2a800
[93933.087912] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[93933.087912] CR2: 00007f1682d5dee0 CR3: 000000028f31f000 CR4: 00000000000006e0
[93933.087912] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[93933.087912] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[93933.087912] Process rsync (pid: 29640, threadinfo ffff88028adea000, task ffff880280ebd800)
[93933.087912] Stack:
[93933.087912]  ffff88028adebe58 0000000000000000 ffff880274dd49c0 ffff88010f7194f8
[93933.087912]  0000000000000000 00007f16821926c8 ffff88028adebe88 ffffffff810f7151
[93933.087912]  ffffffffffffffeb ffff88028adebe98 ffff880274dd49c0 ffff880109f18578
[93933.087912] Call Trace:
[93933.087912]  [<ffffffff810f7151>] vfs_unlink+0x91/0x100
[93933.087912]  [<ffffffff810f8fd3>] do_unlinkat+0x193/0x1c0
[93933.087912]  [<ffffffff810eb21d>] ? vfs_write+0x12d/0x180
[93933.087912]  [<ffffffff810f9011>] sys_unlink+0x11/0x20
[93933.087912]  [<ffffffff816cd03b>] system_call_fastpath+0x16/0x1b
[93933.087912] Code: ff ff 4c 89 f7 4c 89 ee e8 35 d7 fe ff 44 89 e0 48 8b 5d d8 4c 8b 65 e0 4c 8b 6d e8 4c 8b 75 f0 4c 8b 7d f8 c9 c3 41 89 c4 eb e2 <0f> 0b eb fe 0f 0b eb fe 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 
[93933.087912] RIP  [<ffffffff811e38b9>] btrfs_unlink+0xc9/0xe0
[93933.087912]  RSP <ffff88028adebe28>
[93933.088192] ---[ end trace c0fbb585ab150cf2 ]---

-- 
Simon Arlott
