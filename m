From: "Marco L. Crociani" <marco.crociani@gmail.com>
Subject: How to handle badblocks with btrfs?
Date: Tue, 28 Jun 2011 01:36:03 +0200
Message-ID: <BANLkTinrJV8DApCp8R=MnN-UZdPe6OrujA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I have some errors in dmesg:

[  542.255788] ata1.00: exception Emask 0x0 SAct 0xffffff SErr 0x0 action 0x0
[  542.255797] ata1.00: irq_stat 0x40000008
[  542.255805] ata1.00: failed command: READ FPDMA QUEUED
[  542.255821] ata1.00: cmd 60/00:00:1a:b7:7a/04:00:1d:00:00/40 tag 0
ncq 524288 in
[  542.255824]          res 41/40:00:a0:b7:7a/00:00:1d:00:00/40 Emask
0x409 (media error) <F>
[  542.255831] ata1.00: status: { DRDY ERR }
[  542.255837] ata1.00: error: { UNC }
[  542.264434] ata1.00: configured for UDMA/133
[  542.264505] ata1: EH complete
[  545.075811] ata1.00: exception Emask 0x0 SAct 0xd7c6ff SErr 0x0 action 0x0
[  545.075820] ata1.00: irq_stat 0x40000008
[  545.075829] ata1.00: failed command: READ FPDMA QUEUED
[  545.075845] ata1.00: cmd 60/00:b8:1a:b7:7a/04:00:1d:00:00/40 tag 23
ncq 524288 in
[  545.075848]          res 41/40:00:a0:b7:7a/00:00:1d:00:00/40 Emask
0x409 (media error) <F>
[  545.075855] ata1.00: status: { DRDY ERR }
[  545.075860] ata1.00: error: { UNC }
[  545.084251] ata1.00: configured for UDMA/133
[  545.084301] ata1: EH complete
[  547.859837] ata1.00: exception Emask 0x0 SAct 0x3ffff SErr 0x0 action 0x0
[  547.859846] ata1.00: irq_stat 0x40000008
[  547.859854] ata1.00: failed command: READ FPDMA QUEUED
[  547.859869] ata1.00: cmd 60/00:00:1a:b7:7a/04:00:1d:00:00/40 tag 0
ncq 524288 in
[  547.859872]          res 41/40:00:a0:b7:7a/00:00:1d:00:00/40 Emask
0x409 (media error) <F>
[  547.859880] ata1.00: status: { DRDY ERR }
[  547.859885] ata1.00: error: { UNC }
[  547.868063] ata1.00: configured for UDMA/133
[  547.868116] ata1: EH complete
[  550.727871] ata1.00: exception Emask 0x0 SAct 0x3fc0f SErr 0x0 action 0x0
[  550.727880] ata1.00: irq_stat 0x40000008
[  550.727890] ata1.00: failed command: READ FPDMA QUEUED
[  550.727905] ata1.00: cmd 60/00:88:1a:b7:7a/04:00:1d:00:00/40 tag 17
ncq 524288 in
[  550.727908]          res 41/40:00:a0:b7:7a/00:00:1d:00:00/40 Emask
0x409 (media error) <F>
[  550.727916] ata1.00: status: { DRDY ERR }
[  550.727921] ata1.00: error: { UNC }
[  550.735913] ata1.00: configured for UDMA/133
[  550.735964] ata1: EH complete
[  553.499907] ata1.00: exception Emask 0x0 SAct 0xfff SErr 0x0 action 0x0
[  553.499916] ata1.00: irq_stat 0x40000008
[  553.499924] ata1.00: failed command: READ FPDMA QUEUED
[  553.499939] ata1.00: cmd 60/00:00:1a:b7:7a/04:00:1d:00:00/40 tag 0
ncq 524288 in
[  553.499942]          res 41/40:00:a0:b7:7a/00:00:1d:00:00/40 Emask
0x409 (media error) <F>
[  553.499950] ata1.00: status: { DRDY ERR }
[  553.499955] ata1.00: error: { UNC }
[  553.508800] ata1.00: configured for UDMA/133
[  553.508847] ata1: EH complete
[  556.283938] ata1.00: exception Emask 0x0 SAct 0xfff SErr 0x0 action 0x0
[  556.283947] ata1.00: irq_stat 0x40000008
[  556.283956] ata1.00: failed command: READ FPDMA QUEUED
[  556.283971] ata1.00: cmd 60/00:58:1a:b7:7a/04:00:1d:00:00/40 tag 11
ncq 524288 in
[  556.283975]          res 41/40:00:a0:b7:7a/00:00:1d:00:00/40 Emask
0x409 (media error) <F>
[  556.283982] ata1.00: status: { DRDY ERR }
[  556.283987] ata1.00: error: { UNC }
[  556.292610] ata1.00: configured for UDMA/133
[  556.292671] sd 0:0:0:0: [sda] Unhandled sense code
[  556.292678] sd 0:0:0:0: [sda]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  556.292686] sd 0:0:0:0: [sda]  Sense Key : Medium Error [current]
[descriptor]
[  556.292697] Descriptor sense data with sense descriptors (in hex):
[  556.292703]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
[  556.292725]         1d 7a b7 a0
[  556.292735] sd 0:0:0:0: [sda]  Add. Sense: Unrecovered read error -
auto reallocate failed
[  556.292746] sd 0:0:0:0: [sda] CDB: Read(10): 28 00 1d 7a b7 1a 00 04 00 00
[  556.292767] end_request: I/O error, dev sda, sector 494581664
[  556.292808] ata1: EH complete
[  556.313976] btrfs_readpage_end_io_hook: 6 callbacks suppressed
[  556.313987] btrfs csum failed ino 13966 off 236142592 csum
2566472073 private 305113664
[  556.314076] btrfs csum failed ino 13966 off 236146688 csum
2566472073 private 2675414968
[  556.314135] btrfs csum failed ino 13966 off 236150784 csum
2566472073 private 3814599931
[  556.314190] btrfs csum failed ino 13966 off 236154880 csum
2566472073 private 1494803575
[  556.314247] btrfs csum failed ino 13966 off 236158976 csum
2566472073 private 3963245343
[  556.314304] btrfs csum failed ino 13966 off 236163072 csum
2566472073 private 423696632
[  556.314360] btrfs csum failed ino 13966 off 236167168 csum
2566472073 private 2701184196
[  556.314416] btrfs csum failed ino 13966 off 236171264 csum
2566472073 private 2585003232
[  556.314471] btrfs csum failed ino 13966 off 236175360 csum
2566472073 private 3223805718
[  556.314528] btrfs csum failed ino 13966 off 236179456 csum
2566472073 private 2971487607
[  559.523993] ata1.00: exception Emask 0x0 SAct 0x20 SErr 0x0 action 0x0
[  559.524002] ata1.00: irq_stat 0x40000008
[  559.524011] ata1.00: failed command: READ FPDMA QUEUED
[  559.524026] ata1.00: cmd 60/00:28:a2:b7:7a/04:00:1d:00:00/40 tag 5
ncq 524288 in
[  559.524029]          res 41/40:00:a2:b7:7a/00:00:1d:00:00/40 Emask
0x409 (media error) <F>
[  559.524037] ata1.00: status: { DRDY ERR }
[  559.524042] ata1.00: error: { UNC }
[  559.532889] ata1.00: configured for UDMA/133
[  559.532919] ata1: EH complete
[  563.676077] ata1.00: exception Emask 0x0 SAct 0x4407 SErr 0x0 action 0x0
[  563.676086] ata1.00: irq_stat 0x40000008
[  563.676095] ata1.00: failed command: READ FPDMA QUEUED
[  563.676110] ata1.00: cmd 60/00:00:a2:b7:7a/04:00:1d:00:00/40 tag 0
ncq 524288 in
[  563.676113]          res 41/40:00:a2:b7:7a/00:00:1d:00:00/40 Emask
0x409 (media error) <F>
[  563.676121] ata1.00: status: { DRDY ERR }
[  563.676126] ata1.00: error: { UNC }
[  563.685092] ata1.00: configured for UDMA/133
[  563.685131] ata1: EH complete
[  566.532063] ata1.00: exception Emask 0x0 SAct 0x10 SErr 0x0 action 0x0
[  566.532072] ata1.00: irq_stat 0x40000008
[  566.532081] ata1.00: failed command: READ FPDMA QUEUED
[  566.532096] ata1.00: cmd 60/00:20:a2:b7:7a/04:00:1d:00:00/40 tag 4
ncq 524288 in
[  566.532099]          res 41/40:00:a2:b7:7a/00:00:1d:00:00/40 Emask
0x409 (media error) <F>
[  566.532107] ata1.00: status: { DRDY ERR }
[  566.532112] ata1.00: error: { UNC }
[  566.540978] ata1.00: configured for UDMA/133
[  566.541009] ata1: EH complete
[  569.328098] ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
[  569.328108] ata1.00: irq_stat 0x40000008
[  569.328116] ata1.00: failed command: READ FPDMA QUEUED
[  569.328131] ata1.00: cmd 60/00:00:a2:b7:7a/04:00:1d:00:00/40 tag 0
ncq 524288 in
[  569.328134]          res 41/40:00:a2:b7:7a/00:00:1d:00:00/40 Emask
0x409 (media error) <F>
[  569.328142] ata1.00: status: { DRDY ERR }
[  569.328147] ata1.00: error: { UNC }
[  569.336795] ata1.00: configured for UDMA/133
[  569.336824] ata1: EH complete
[  572.124126] ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
[  572.124135] ata1.00: irq_stat 0x40000008
[  572.124144] ata1.00: failed command: READ FPDMA QUEUED
[  572.124159] ata1.00: cmd 60/00:00:a2:b7:7a/04:00:1d:00:00/40 tag 0
ncq 524288 in
[  572.124162]          res 41/40:00:a2:b7:7a/00:00:1d:00:00/40 Emask
0x409 (media error) <F>
[  572.124170] ata1.00: status: { DRDY ERR }
[  572.124175] ata1.00: error: { UNC }
[  572.132543] ata1.00: configured for UDMA/133
[  572.132575] ata1: EH complete
[  574.920162] ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
[  574.920171] ata1.00: irq_stat 0x40000008
[  574.920179] ata1.00: failed command: READ FPDMA QUEUED
[  574.920195] ata1.00: cmd 60/00:00:a2:b7:7a/04:00:1d:00:00/40 tag 0
ncq 524288 in
[  574.920198]          res 41/40:00:a2:b7:7a/00:00:1d:00:00/40 Emask
0x409 (media error) <F>
[  574.920205] ata1.00: status: { DRDY ERR }
[  574.920211] ata1.00: error: { UNC }
[  574.928356] ata1.00: configured for UDMA/133
[  574.928415] sd 0:0:0:0: [sda] Unhandled sense code
[  574.928421] sd 0:0:0:0: [sda]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[  574.928430] sd 0:0:0:0: [sda]  Sense Key : Medium Error [current]
[descriptor]
[  574.928440] Descriptor sense data with sense descriptors (in hex):
[  574.928446]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
[  574.928468]         1d 7a b7 a2
[  574.928478] sd 0:0:0:0: [sda]  Add. Sense: Unrecovered read error -
auto reallocate failed
[  574.928489] sd 0:0:0:0: [sda] CDB: Read(10): 28 00 1d 7a b7 a2 00 04 00 00
[  574.928510] end_request: I/O error, dev sda, sector 494581666
[  574.928680] ata1: EH complete
[ 1370.848498] ecryptfs_read_and_validate_header_region: Error reading
header region; rc = [-4]
[ 8039.470253] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.470269] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.561399] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.561411] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.561439] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.561445] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.561460] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.561466] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.561479] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.561486] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.561508] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.561514] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.561528] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.561534] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.561547] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.561553] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.561566] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.561573] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.562386] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.562394] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.562411] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.562417] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.562431] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.562438] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.562451] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.562458] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.562484] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.562490] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.562504] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.562510] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.562523] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.562529] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.562542] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.562549] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.562562] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.562568] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.562581] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.562588] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.562601] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.562607] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.562621] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.562627] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.562641] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.562647] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.562660] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.562666] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.562680] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.562686] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.562699] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.562705] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.562718] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.562724] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.562738] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.562745] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.562765] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.562772] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.562785] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.562792] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.562804] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.562811] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.562905] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.562912] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563122] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563129] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563145] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563151] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563165] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563171] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563185] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563191] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563204] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563211] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563230] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563237] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563251] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563257] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563270] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563277] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563298] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563305] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563318] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563325] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563338] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563345] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563358] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563364] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563378] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563384] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563397] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563404] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563417] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563424] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563438] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563444] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563458] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563464] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563478] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563485] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563498] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563504] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563523] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563529] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563542] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563549] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563561] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563568] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563581] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563587] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563600] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563607] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563619] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563626] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563639] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563645] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563658] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563664] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563677] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563684] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563697] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563703] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563716] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563723] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563736] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563742] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563755] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563762] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563775] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563781] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8039.563794] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[ 8039.563800] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 8042.336160] ata1.00: exception Emask 0x0 SAct 0x3 SErr 0x0 action 0x0
[ 8042.336169] ata1.00: irq_stat 0x40000008
[ 8042.336177] ata1.00: failed command: READ FPDMA QUEUED
[ 8042.336193] ata1.00: cmd 60/40:00:a2:b7:7a/01:00:1d:00:00/40 tag 0
ncq 163840 in
[ 8042.336196]          res 41/40:00:a2:b7:7a/00:00:1d:00:00/40 Emask
0x409 (media error) <F>
[ 8042.336203] ata1.00: status: { DRDY ERR }
[ 8042.336209] ata1.00: error: { UNC }
[ 8042.351911] ata1.00: configured for UDMA/133
[ 8042.351934] ata1: EH complete
[ 8045.132167] ata1.00: exception Emask 0x0 SAct 0x1f SErr 0x0 action 0x0
[ 8045.132176] ata1.00: irq_stat 0x40000008
[ 8045.132185] ata1.00: failed command: READ FPDMA QUEUED
[ 8045.132200] ata1.00: cmd 60/40:08:a2:b7:7a/01:00:1d:00:00/40 tag 1
ncq 163840 in
[ 8045.132204]          res 41/40:00:a2:b7:7a/00:00:1d:00:00/40 Emask
0x409 (media error) <F>
[ 8045.132211] ata1.00: status: { DRDY ERR }
[ 8045.132216] ata1.00: error: { UNC }
[ 8045.140127] ata1.00: configured for UDMA/133
[ 8045.140155] ata1: EH complete
[ 8045.184968] btrfs_readpage_end_io_hook: 189 callbacks suppressed
[ 8045.184979] btrfs csum failed ino 13966 off 236376064 csum
2566472073 private 1595666322
[ 8045.185092] btrfs csum failed ino 13966 off 236380160 csum
2566472073 private 4006228502
[ 8045.185149] btrfs csum failed ino 13966 off 236384256 csum
2566472073 private 2144702013
[ 8045.185204] btrfs csum failed ino 13966 off 236388352 csum
2566472073 private 2761331096
[ 8045.185258] btrfs csum failed ino 13966 off 236392448 csum
2566472073 private 2244201186
[ 8045.185312] btrfs csum failed ino 13966 off 236396544 csum
2566472073 private 3432746347
[ 8045.185365] btrfs csum failed ino 13966 off 236400640 csum
2566472073 private 1374667344
[ 8045.185420] btrfs csum failed ino 13966 off 236404736 csum
2566472073 private 3455582370
[ 8045.185474] btrfs csum failed ino 13966 off 236408832 csum
2566472073 private 3201313123
[ 8045.185528] btrfs csum failed ino 13966 off 236412928 csum
2566472073 private 3918471967
[ 8047.988218] ata1.00: exception Emask 0x0 SAct 0xc SErr 0x0 action 0x0
[ 8047.988227] ata1.00: irq_stat 0x40000008
[ 8047.988235] ata1.00: failed command: READ FPDMA QUEUED
[ 8047.988251] ata1.00: cmd 60/40:18:a2:b7:7a/01:00:1d:00:00/40 tag 3
ncq 163840 in
[ 8047.988254]          res 41/40:00:a2:b7:7a/00:00:1d:00:00/40 Emask
0x409 (media error) <F>
[ 8047.988261] ata1.00: status: { DRDY ERR }
[ 8047.988267] ata1.00: error: { UNC }
[ 8048.004673] ata1.00: configured for UDMA/133
[ 8048.004697] ata1: EH complete
[ 8050.784232] ata1.00: exception Emask 0x0 SAct 0x3f SErr 0x0 action 0x0
[ 8050.784242] ata1.00: irq_stat 0x40000008
[ 8050.784250] ata1.00: failed command: READ FPDMA QUEUED
[ 8050.784265] ata1.00: cmd 60/40:00:a2:b7:7a/01:00:1d:00:00/40 tag 0
ncq 163840 in
[ 8050.784269]          res 41/40:00:a2:b7:7a/00:00:1d:00:00/40 Emask
0x409 (media error) <F>
[ 8050.784276] ata1.00: status: { DRDY ERR }
[ 8050.784281] ata1.00: error: { UNC }
[ 8050.800559] ata1.00: configured for UDMA/133
[ 8050.800590] ata1: EH complete
[ 8053.604269] ata1.00: exception Emask 0x0 SAct 0x31 SErr 0x0 action 0x0
[ 8053.604278] ata1.00: irq_stat 0x40000008
[ 8053.604287] ata1.00: failed command: READ FPDMA QUEUED
[ 8053.604302] ata1.00: cmd 60/40:28:a2:b7:7a/01:00:1d:00:00/40 tag 5
ncq 163840 in
[ 8053.604305]          res 41/40:00:a2:b7:7a/00:00:1d:00:00/40 Emask
0x409 (media error) <F>
[ 8053.604313] ata1.00: status: { DRDY ERR }
[ 8053.604318] ata1.00: error: { UNC }
[ 8053.620407] ata1.00: configured for UDMA/133
[ 8053.620433] ata1: EH complete
[ 8056.400301] ata1.00: exception Emask 0x0 SAct 0x7 SErr 0x0 action 0x0
[ 8056.400310] ata1.00: irq_stat 0x40000008
[ 8056.400317] ata1.00: failed command: READ FPDMA QUEUED
[ 8056.400333] ata1.00: cmd 60/40:00:a2:b7:7a/01:00:1d:00:00/40 tag 0
ncq 163840 in
[ 8056.400336]          res 41/40:00:a2:b7:7a/00:00:1d:00:00/40 Emask
0x409 (media error) <F>
[ 8056.400343] ata1.00: status: { DRDY ERR }
[ 8056.400349] ata1.00: error: { UNC }
[ 8056.416288] ata1.00: configured for UDMA/133
[ 8056.416316] sd 0:0:0:0: [sda] Unhandled sense code
[ 8056.416323] sd 0:0:0:0: [sda]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[ 8056.416331] sd 0:0:0:0: [sda]  Sense Key : Medium Error [current]
[descriptor]
[ 8056.416342] Descriptor sense data with sense descriptors (in hex):
[ 8056.416347]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
[ 8056.416370]         1d 7a b7 a2
[ 8056.416379] sd 0:0:0:0: [sda]  Add. Sense: Unrecovered read error -
auto reallocate failed
[ 8056.416391] sd 0:0:0:0: [sda] CDB: Read(10): 28 00 1d 7a b7 a2 00 01 40 00
[ 8056.416412] end_request: I/O error, dev sda, sector 494581666
[ 8056.416457] ata1: EH complete
[ 8056.440211] btrfs_readpage_end_io_hook: 22 callbacks suppressed
[ 8056.440222] btrfs csum failed ino 13966 off 235851776 csum
2566472073 private 3377372189
[ 8056.440291] btrfs csum failed ino 13966 off 235855872 csum
2566472073 private 923280357
[ 8056.440346] btrfs csum failed ino 13966 off 235859968 csum
2566472073 private 279821627
[ 8056.440402] btrfs csum failed ino 13966 off 235864064 csum
2566472073 private 2200985106
[ 8056.440457] btrfs csum failed ino 13966 off 235868160 csum
2566472073 private 1517426087
[ 8056.440512] btrfs csum failed ino 13966 off 235872256 csum
2566472073 private 3984457445
[ 8056.440567] btrfs csum failed ino 13966 off 235876352 csum
2566472073 private 593181065
[ 8056.440621] btrfs csum failed ino 13966 off 235880448 csum
2566472073 private 4167906440
[ 8056.440674] btrfs csum failed ino 13966 off 235884544 csum
2566472073 private 1589290204
[ 8056.440727] btrfs csum failed ino 13966 off 235888640 csum
2566472073 private 1310115389
[ 8059.208326] ata1.00: exception Emask 0x0 SAct 0x1c SErr 0x0 action 0x0
[ 8059.208335] ata1.00: irq_stat 0x40000008
[ 8059.208343] ata1.00: failed command: READ FPDMA QUEUED
[ 8059.208358] ata1.00: cmd 60/10:10:a2:b7:7a/00:00:1d:00:00/40 tag 2
ncq 8192 in
[ 8059.208361]          res 41/40:00:a2:b7:7a/00:00:1d:00:00/40 Emask
0x409 (media error) <F>
[ 8059.208369] ata1.00: status: { DRDY ERR }
[ 8059.208374] ata1.00: error: { UNC }
[ 8059.216337] ata1.00: configured for UDMA/133
[ 8059.216361] ata1: EH complete
[ 8062.028369] ata1.00: exception Emask 0x0 SAct 0x1e SErr 0x0 action 0x0
[ 8062.028378] ata1.00: irq_stat 0x40000008
[ 8062.028385] ata1.00: failed command: READ FPDMA QUEUED
[ 8062.028401] ata1.00: cmd 60/10:10:a2:b7:7a/00:00:1d:00:00/40 tag 2
ncq 8192 in
[ 8062.028404]          res 41/40:00:a2:b7:7a/00:00:1d:00:00/40 Emask
0x409 (media error) <F>
[ 8062.028411] ata1.00: status: { DRDY ERR }
[ 8062.028417] ata1.00: error: { UNC }
[ 8062.045015] ata1.00: configured for UDMA/133
[ 8062.045043] ata1: EH complete
[ 8062.067134] btrfs_readpage_end_io_hook: 150 callbacks suppressed
[ 8062.067144] btrfs csum failed ino 13966 off 235716608 csum
2566472073 private 2608695049
[ 8062.067205] btrfs csum failed ino 13966 off 235720704 csum
2566472073 private 806985038
[ 8062.067242] btrfs csum failed ino 13966 off 235724800 csum
2566472073 private 141559703
[ 8062.067278] btrfs csum failed ino 13966 off 235728896 csum
2566472073 private 2702978999
[ 8062.067317] btrfs csum failed ino 13966 off 235749376 csum
2566472073 private 3401735983
[ 8062.067330] btrfs csum failed ino 13966 off 235700224 csum
2566472073 private 4013182037
[ 8062.067376] btrfs csum failed ino 13966 off 235753472 csum
2566472073 private 3818799263
[ 8062.067389] btrfs csum failed ino 13966 off 235704320 csum
2566472073 private 4070688831
[ 8062.067414] btrfs csum failed ino 13966 off 235757568 csum
2566472073 private 1952764520
[ 8062.067430] btrfs csum failed ino 13966 off 235708416 csum
2566472073 private 905957469
[ 8064.836384] ata1.00: exception Emask 0x0 SAct 0xff SErr 0x0 action 0x0
[ 8064.836394] ata1.00: irq_stat 0x40000008
[ 8064.836402] ata1.00: failed command: READ FPDMA QUEUED
[ 8064.836417] ata1.00: cmd 60/10:10:a2:b7:7a/00:00:1d:00:00/40 tag 2
ncq 8192 in
[ 8064.836421]          res 41/40:00:a2:b7:7a/00:00:1d:00:00/40 Emask
0x409 (media error) <F>
[ 8064.836428] ata1.00: status: { DRDY ERR }
[ 8064.836433] ata1.00: error: { UNC }
[ 8064.852893] ata1.00: configured for UDMA/133
[ 8064.852927] ata1: EH complete
[ 8067.644421] ata1.00: exception Emask 0x0 SAct 0x130 SErr 0x0 action 0x0
[ 8067.644430] ata1.00: irq_stat 0x40000008
[ 8067.644438] ata1.00: failed command: READ FPDMA QUEUED
[ 8067.644454] ata1.00: cmd 60/10:28:a2:b7:7a/00:00:1d:00:00/40 tag 5
ncq 8192 in
[ 8067.644457]          res 41/40:00:a2:b7:7a/00:00:1d:00:00/40 Emask
0x409 (media error) <F>
[ 8067.644464] ata1.00: status: { DRDY ERR }
[ 8067.644469] ata1.00: error: { UNC }
[ 8067.660737] ata1.00: configured for UDMA/133
[ 8067.660760] ata1: EH complete
[ 8070.440441] ata1.00: exception Emask 0x0 SAct 0x7 SErr 0x0 action 0x0
[ 8070.440450] ata1.00: irq_stat 0x40000008
[ 8070.440458] ata1.00: failed command: READ FPDMA QUEUED
[ 8070.440473] ata1.00: cmd 60/10:08:a2:b7:7a/00:00:1d:00:00/40 tag 1
ncq 8192 in
[ 8070.440477]          res 41/40:00:a2:b7:7a/00:00:1d:00:00/40 Emask
0x409 (media error) <F>
[ 8070.440484] ata1.00: status: { DRDY ERR }
[ 8070.440489] ata1.00: error: { UNC }
[ 8070.456591] ata1.00: configured for UDMA/133
[ 8070.456614] ata1: EH complete
[ 8073.236476] ata1.00: exception Emask 0x0 SAct 0x7 SErr 0x0 action 0x0
[ 8073.236485] ata1.00: irq_stat 0x40000008
[ 8073.236493] ata1.00: failed command: READ FPDMA QUEUED
[ 8073.236508] ata1.00: cmd 60/10:08:a2:b7:7a/00:00:1d:00:00/40 tag 1
ncq 8192 in
[ 8073.236512]          res 41/40:00:a2:b7:7a/00:00:1d:00:00/40 Emask
0x409 (media error) <F>
[ 8073.236519] ata1.00: status: { DRDY ERR }
[ 8073.236524] ata1.00: error: { UNC }
[ 8073.244501] ata1.00: configured for UDMA/133
[ 8073.244534] sd 0:0:0:0: [sda] Unhandled sense code
[ 8073.244540] sd 0:0:0:0: [sda]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[ 8073.244549] sd 0:0:0:0: [sda]  Sense Key : Medium Error [current]
[descriptor]
[ 8073.244560] Descriptor sense data with sense descriptors (in hex):
[ 8073.244565]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
[ 8073.244587]         1d 7a b7 a2
[ 8073.244597] sd 0:0:0:0: [sda]  Add. Sense: Unrecovered read error -
auto reallocate failed
[ 8073.244608] sd 0:0:0:0: [sda] CDB: Read(10): 28 00 1d 7a b7 a2 00 00 10 00
[ 8073.244629] end_request: I/O error, dev sda, sector 494581666
[ 8073.244667] ata1: EH complete
[ 8073.305813] btrfs_readpage_end_io_hook: 155 callbacks suppressed
[ 8073.305823] btrfs csum failed ino 13966 off 235696128 csum
2566472073 private 501345114


# smartctl -d ata -l selftest /dev/sda
smartctl 5.40 2010-07-12 r3124 [x86_64-unknown-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF READ SMART DATA SECTION ===
SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed: read failure       90%       171
      494581664


What should I do to repair the disk?
Is it possible to know which file is affected by the badblock?

I found http://smartmontools.sourceforge.net/badblockhowto.html but is
about to ext2/3/4 fs.

I am concerned about the absence of fsck tool. Should I run badblocks
on the unmounted fs?
Thanks,

-- 
Marco Lorenzo Crociani
