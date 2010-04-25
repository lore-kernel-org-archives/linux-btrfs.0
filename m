From: Tomas Thiemel <thiemel@centrum.cz>
Subject: Report bug (remove device)
Date: Sun, 25 Apr 2010 07:37:42 +0200
Message-ID: <201004250737.42506.thiemel@centrum.cz>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

###
OS: 
 Gentoo x86_64

###
Kernel: 
 2.6.34-rc5 (from Gentoo's vanilla-sources)

###
Btrfs-progs: 
 v0.19-16-g075587c-dirty

###
BTRFS partitions: 
 /dev/sdb1 (1400GB - disk "B")
 /dev/sdc1 (1400GB - disk "C")
 /dev/sdd1 (1400GB - disk "A")
 - mounted as /FTP

###
Action that lead to bug/fault:
 - initial state: disks A+B in Btrfs (A 97% full, B 10% full)
 - add disk C 
   # btrfs device add /dev/sdc1 /FTP
 - remove disk B (move btrfs data from B to C)
   # btrfs device delete /dev/sdb1 /FTP
 - add disk B again
   # btrfs device add /dev/sdb1 /FTP
 - remove disk A (move btrfs data from A to B+C)
   # btrfs device delete /dev/sdd1 /FTP
 - BUG

###
KERNEL LOG:
Apr 25 07:35:18 ftp1 kernel: [  595.826933] btrfs: relocating block group 
1350796574720 flags 1
Apr 25 07:35:39 ftp1 kernel: [  616.570378] btrfs: found 20 extents
Apr 25 07:35:43 ftp1 kernel: [  619.768303] btrfs allocation failed flags 9, 
wanted 4096
Apr 25 07:35:43 ftp1 kernel: [  619.768308] space_info has 0 free, is full
Apr 25 07:35:43 ftp1 kernel: [  619.768312] space_info total=146028888064, 
pinned=0, delalloc=72802304, may_use=0, used=145355206656, root=0, 
super=65536, reserved=673615872
Apr 25 07:35:43 ftp1 kernel: [  619.768317] block group 3831518593024 has 
2147483648 bytes, 2147160064 used 0 pinned 258048 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768320] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768322] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768326] block group 3833666076672 has 
2147483648 bytes, 2147323904 used 0 pinned 159744 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768329] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768331] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768334] block group 3835813560320 has 
2147483648 bytes, 2147483648 used 0 pinned 0 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768337] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768339] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768342] block group 3837961043968 has 
2147483648 bytes, 2147397632 used 0 pinned 86016 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768345] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768347] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768350] block group 3840108527616 has 
2147483648 bytes, 2147270656 used 0 pinned 212992 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768353] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768355] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768358] block group 3842256011264 has 
2147483648 bytes, 2147360768 used 0 pinned 122880 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768361] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768363] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768366] block group 3844403494912 has 
2147483648 bytes, 2147393536 used 0 pinned 90112 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768369] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768371] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768374] block group 3846550978560 has 
2147483648 bytes, 2147246080 used 0 pinned 237568 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768377] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768379] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768382] block group 3848698462208 has 
2147483648 bytes, 2147299328 used 0 pinned 184320 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768385] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768386] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768390] block group 3850845945856 has 
2147483648 bytes, 2147225600 used 0 pinned 258048 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768393] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768394] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768397] block group 3852993429504 has 
2147483648 bytes, 2147434496 used 0 pinned 49152 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768401] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768402] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768405] block group 3855140913152 has 
2147483648 bytes, 2147418112 used 0 pinned 65536 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768408] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768410] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768413] block group 3857288396800 has 
2147483648 bytes, 2147479552 used 0 pinned 4096 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768416] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768418] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768421] block group 3859435880448 has 
2147483648 bytes, 2147250176 used 0 pinned 233472 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768424] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768426] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768429] block group 3861583364096 has 
2147483648 bytes, 2147405824 used 0 pinned 77824 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768432] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768434] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768437] block group 3863730847744 has 
2147483648 bytes, 2147393536 used 0 pinned 90112 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768440] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768442] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768445] block group 3865878331392 has 
2147483648 bytes, 2147356672 used 0 pinned 126976 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768448] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768450] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768453] block group 3868025815040 has 
2147483648 bytes, 2147459072 used 0 pinned 24576 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768456] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768458] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768461] block group 3870173298688 has 
2147483648 bytes, 2147401728 used 0 pinned 81920 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768464] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768466] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768469] block group 3872320782336 has 
2147483648 bytes, 2147225600 used 0 pinned 258048 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768472] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768474] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768477] block group 3874468265984 has 
2147483648 bytes, 2147397632 used 0 pinned 86016 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768480] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768481] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768484] block group 3876615749632 has 
2147483648 bytes, 2147282944 used 0 pinned 200704 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768488] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768489] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768492] block group 3878763233280 has 
2147483648 bytes, 2147377152 used 0 pinned 106496 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768496] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768497] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768500] block group 3880910716928 has 
2147483648 bytes, 2147442688 used 0 pinned 40960 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768503] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768505] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768508] block group 3883058200576 has 
2147483648 bytes, 2147385344 used 0 pinned 98304 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768511] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768513] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768516] block group 3885205684224 has 
2147483648 bytes, 2147237888 used 0 pinned 245760 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768519] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768521] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768524] block group 3887353167872 has 
2147483648 bytes, 2147483648 used 0 pinned 0 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768527] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768529] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768532] block group 3889500651520 has 
2147483648 bytes, 2147409920 used 0 pinned 73728 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768535] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768537] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768540] block group 3891648135168 has 
2147483648 bytes, 2147483648 used 0 pinned 0 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768543] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768545] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768548] block group 3893795618816 has 
2147483648 bytes, 2147344384 used 0 pinned 139264 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768551] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768553] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768556] block group 3895943102464 has 
2147483648 bytes, 2147241984 used 0 pinned 241664 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768559] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768561] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768564] block group 3898090586112 has 
2147483648 bytes, 2147319808 used 0 pinned 163840 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768567] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768569] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768572] block group 3900238069760 has 
2147483648 bytes, 2147254272 used 0 pinned 229376 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768575] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768577] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768580] block group 3902385553408 has 
2147483648 bytes, 2147291136 used 0 pinned 192512 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768583] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768584] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768588] block group 3904533037056 has 
2147483648 bytes, 2147479552 used 0 pinned 4096 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768591] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768592] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768595] block group 3906680520704 has 
2147483648 bytes, 2147348480 used 0 pinned 135168 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768598] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768600] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768603] block group 3908828004352 has 
2147483648 bytes, 2147450880 used 0 pinned 32768 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768606] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768608] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768611] block group 3910975488000 has 
2147483648 bytes, 2147303424 used 0 pinned 180224 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768614] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768616] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768619] block group 3913122971648 has 
2147483648 bytes, 2147332096 used 0 pinned 151552 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768622] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768624] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768627] block group 3915270455296 has 
2147483648 bytes, 2147479552 used 0 pinned 4096 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768630] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768632] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768635] block group 3917417938944 has 
2147483648 bytes, 2147446784 used 0 pinned 36864 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768638] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768640] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768643] block group 3919565422592 has 
2147483648 bytes, 2147344384 used 0 pinned 139264 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768646] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768648] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768651] block group 3921712906240 has 
2147483648 bytes, 2147483648 used 0 pinned 0 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768654] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768656] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768659] block group 3923860389888 has 
2147483648 bytes, 2147483648 used 0 pinned 0 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768662] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768664] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768667] block group 3926007873536 has 
2147483648 bytes, 2147295232 used 0 pinned 188416 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768670] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768672] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768675] block group 3928155357184 has 
2147483648 bytes, 2147459072 used 0 pinned 24576 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768678] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768679] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768683] block group 3930302840832 has 
2147483648 bytes, 2147483648 used 0 pinned 0 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768685] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768687] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768690] block group 3932450324480 has 
2147483648 bytes, 2147291136 used 0 pinned 192512 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768693] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768695] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768698] block group 3934597808128 has 
2147483648 bytes, 2147483648 used 0 pinned 0 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768701] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768703] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768706] block group 3936745291776 has 
2147483648 bytes, 2147315712 used 0 pinned 167936 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768709] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768711] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768714] block group 3938892775424 has 
2147483648 bytes, 2147426304 used 0 pinned 57344 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768717] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768719] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768722] block group 3941040259072 has 
2147483648 bytes, 2147438592 used 0 pinned 45056 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768725] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768727] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768730] block group 3943187742720 has 
2147483648 bytes, 2147311616 used 0 pinned 172032 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768733] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768735] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768738] block group 3945335226368 has 
2147483648 bytes, 2147287040 used 0 pinned 196608 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768741] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768743] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768746] block group 3947482710016 has 
2147483648 bytes, 2147479552 used 0 pinned 4096 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768749] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768751] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768754] block group 3949630193664 has 
2147483648 bytes, 2147377152 used 0 pinned 106496 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768757] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768759] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768762] block group 3951777677312 has 
2147483648 bytes, 2147454976 used 0 pinned 28672 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768765] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768767] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768770] block group 3953925160960 has 
2147483648 bytes, 2147262464 used 0 pinned 221184 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768773] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768775] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768778] block group 3956072644608 has 
2147483648 bytes, 2147475456 used 0 pinned 8192 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768781] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768782] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768785] block group 3958220128256 has 
2147483648 bytes, 2147368960 used 0 pinned 114688 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768788] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768790] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768793] block group 3960367611904 has 
2147483648 bytes, 2147409920 used 0 pinned 73728 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768796] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768798] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768801] block group 3962515095552 has 
2147483648 bytes, 2147483648 used 0 pinned 0 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768804] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768806] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768809] block group 3964662579200 has 
2147483648 bytes, 2147287040 used 0 pinned 196608 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768812] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768814] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768817] block group 3966810062848 has 
2147483648 bytes, 2147246080 used 0 pinned 237568 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768820] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768822] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768825] block group 3968957546496 has 
2147483648 bytes, 2147135488 used 0 pinned 348160 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768828] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768830] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768833] block group 3971105030144 has 
2147483648 bytes, 2147373056 used 0 pinned 110592 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768836] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768838] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768841] block group 3973252513792 has 
2147483648 bytes, 2144337920 used 0 pinned 3145728 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768844] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768846] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768849] block group 3975399997440 has 
2147483648 bytes, 1484632064 used 0 pinned 662851584 reserved
Apr 25 07:35:43 ftp1 kernel: [  619.768852] block group has cluster?: no
Apr 25 07:35:43 ftp1 kernel: [  619.768854] 0 blocks of free space at or 
bigger than bytes is
Apr 25 07:35:43 ftp1 kernel: [  619.768880] ------------[ cut here 
]------------
Apr 25 07:35:43 ftp1 kernel: [  619.770005] kernel BUG at 
fs/btrfs/inode.c:804!
Apr 25 07:35:43 ftp1 kernel: [  619.770005] invalid opcode: 0000 [#1] SMP 
Apr 25 07:35:43 ftp1 kernel: [  619.770005] last sysfs file: 
/sys/devices/pci0000:00/0000:00:12.0/host3/target3:0:0/3:0:0:0/uevent
Apr 25 07:35:43 ftp1 kernel: [  619.770005] CPU 0 
Apr 25 07:35:43 ftp1 kernel: [  619.770005] Modules linked in: btrfs 
zlib_deflate crc32c libcrc32c nfsd lockd auth_rpcgss exportfs sunrpc f71882fg 
dm_mod fuse dummy ohci_hcd ehci_hcd usbcore r8169 pcspkr mii sg i2c_piix4 
processor k8temp i2c_core pata_atiixp button thermal
Apr 25 07:35:43 ftp1 kernel: [  619.770005] 
Apr 25 07:35:43 ftp1 kernel: [  619.770005] Pid: 4938, comm: btrfs Not tainted 
2.6.34-rc5-mykernel #1 MS-7367/MS-7367
Apr 25 07:35:43 ftp1 kernel: [  619.770005] RIP: 0010:[<ffffffffa0195511>]  
[<ffffffffa0195511>] cow_file_range+0x1eb/0x33b [btrfs]
Apr 25 07:35:43 ftp1 kernel: [  619.770005] RSP: 0018:ffff8801035d1778  EFLAGS: 
00010286
Apr 25 07:35:43 ftp1 kernel: [  619.770005] RAX: 00000000ffffffe4 RBX: 
00000381984e0000 RCX: 000000000000de19
Apr 25 07:35:43 ftp1 kernel: [  619.770005] RDX: 0000000000000001 RSI: 
0000000000000046 RDI: ffff8801023e4b80
Apr 25 07:35:43 ftp1 kernel: [  619.770005] RBP: 000000003b9e9000 R08: 
0000000000000032 R09: 0000000000000002
Apr 25 07:35:43 ftp1 kernel: [  619.770005] R10: 000000000000000a R11: 
ffff8801035d1558 R12: 0000000000001000
Apr 25 07:35:43 ftp1 kernel: [  619.770005] R13: 0000000000001000 R14: 
ffff88010161cd90 R15: ffff880103b9d800
Apr 25 07:35:43 ftp1 kernel: [  619.770005] FS:  00007f52c43a1730(0000) 
GS:ffff880001600000(0000) knlGS:0000000000000000
Apr 25 07:35:43 ftp1 kernel: [  619.770005] CS:  0010 DS: 0000 ES: 0000 CR0: 
000000008005003b
Apr 25 07:35:43 ftp1 kernel: [  619.770005] CR2: 0000000000427140 CR3: 
00000001035ca000 CR4: 00000000000006f0
Apr 25 07:35:43 ftp1 kernel: [  619.770005] DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Apr 25 07:35:43 ftp1 kernel: [  619.770005] DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
Apr 25 07:35:43 ftp1 kernel: [  619.770005] Process btrfs (pid: 4938, 
threadinfo ffff8801035d0000, task ffff88011fee7310)
Apr 25 07:35:43 ftp1 kernel: [  619.770005] Stack:
Apr 25 07:35:43 ftp1 kernel: [  619.770005]  ffffffffffffffff ffff8801035d17e8 
0000000000000001 ffff88010178b128
Apr 25 07:35:43 ftp1 kernel: [  619.770005] <0> ffff8801035d19b0 ffff8801035d19cc 
ffffea00002361c8 00001000035d1fd8
Apr 25 07:35:43 ftp1 kernel: [  619.770005] <0> ffff88010161cc20 ffff88010161cc28 
ffff880101675160 000000000006d000
Apr 25 07:35:43 ftp1 kernel: [  619.770005] Call Trace:
Apr 25 07:35:43 ftp1 kernel: [  619.770005]  [<ffffffffa0195cf1>] ? 
run_delalloc_range+0xa5/0x310 [btrfs]
Apr 25 07:35:43 ftp1 kernel: [  619.770005]  [<ffffffffa01ac2e8>] ? 
__extent_writepage+0x22a/0x68f [btrfs]
Apr 25 07:35:43 ftp1 kernel: [  619.770005]  [<ffffffffa01aa636>] ? 
end_bio_extent_writepage+0x0/0x158 [btrfs]
Apr 25 07:35:43 ftp1 kernel: [  619.770005]  [<ffffffffa01a9bd7>] ? 
extent_write_cache_pages+0x140/0x214 [btrfs]
Apr 25 07:35:43 ftp1 kernel: [  619.770005]  [<ffffffffa01a84e9>] ? 
flush_write_bio+0x0/0x2 [btrfs]
Apr 25 07:35:43 ftp1 kernel: [  619.770005]  [<ffffffffa01ac0be>] ? 
__extent_writepage+0x0/0x68f [btrfs]
Apr 25 07:35:43 ftp1 kernel: [  619.770005]  [<ffffffffa01a9cf6>] ? 
extent_writepages+0x4b/0x5f [btrfs]
Apr 25 07:35:43 ftp1 kernel: [  619.770005]  [<ffffffffa01941da>] ? 
btrfs_get_extent+0x0/0x7c6 [btrfs]
Apr 25 07:35:43 ftp1 kernel: [  619.770005]  [<ffffffff810748f6>] ? 
__filemap_fdatawrite_range+0x4c/0x57
Apr 25 07:35:43 ftp1 kernel: [  619.770005]  [<ffffffffa01a6b4b>] ? 
btrfs_wait_ordered_range+0x4e/0x10f [btrfs]
Apr 25 07:35:43 ftp1 kernel: [  619.770005]  [<ffffffffa01c4b38>] ? 
btrfs_relocate_block_group+0x19c/0x2c0 [btrfs]
Apr 25 07:35:43 ftp1 kernel: [  619.770005]  [<ffffffffa01af545>] ? 
btrfs_relocate_chunk+0x65/0x4c7 [btrfs]
Apr 25 07:35:43 ftp1 kernel: [  619.770005]  [<ffffffffa01a7cb2>] ? 
map_extent_buffer+0x61/0x9a [btrfs]
Apr 25 07:35:43 ftp1 kernel: [  619.770005]  [<ffffffffa019f578>] ? 
btrfs_dev_extent_chunk_offset+0xb6/0xc2 [btrfs]
Apr 25 07:35:43 ftp1 kernel: [  619.770005]  [<ffffffffa01afba6>] ? 
btrfs_shrink_device+0x1ff/0x33d [btrfs]
Apr 25 07:35:43 ftp1 kernel: [  619.770005]  [<ffffffffa01acbc5>] ? 
__find_device+0x38/0x59 [btrfs]
Apr 25 07:35:43 ftp1 kernel: [  619.770005]  [<ffffffffa01b055f>] ? 
btrfs_rm_device+0x234/0x4de [btrfs]
Apr 25 07:35:43 ftp1 kernel: [  619.770005]  [<ffffffffa01b59bf>] ? 
btrfs_ioctl+0x693/0x840 [btrfs]
Apr 25 07:35:43 ftp1 kernel: [  619.770005]  [<ffffffff8101e66d>] ? 
do_page_fault+0x2ab/0x2e6
Apr 25 07:35:43 ftp1 kernel: [  619.770005]  [<ffffffff810a6fc2>] ? 
vfs_ioctl+0x21/0x92
Apr 25 07:35:43 ftp1 kernel: [  619.770005]  [<ffffffff810a74bd>] ? 
do_vfs_ioctl+0x414/0x44c
Apr 25 07:35:43 ftp1 kernel: [  619.770005]  [<ffffffff810a7532>] ? 
sys_ioctl+0x3d/0x5c
Apr 25 07:35:43 ftp1 kernel: [  619.770005]  [<ffffffff8100286b>] ? 
system_call_fastpath+0x16/0x1b
Apr 25 07:35:43 ftp1 kernel: [  619.770005] Code: 7c 24 50 45 31 c0 49 89 d9 
4c 89 fe 48 c7 44 24 10 01 00 00 00 48 89 44 24 08 48 c7 04 24 ff ff ff ff e8 37 
e2 fe ff 85 c0 74 04 <0f> 0b eb fe bf 50 00 00 00 e8 7b 7b 00 00 48 89 68 18 48 
89 68 
Apr 25 07:35:43 ftp1 kernel: [  619.770005] RIP  [<ffffffffa0195511>] 
cow_file_range+0x1eb/0x33b [btrfs]
Apr 25 07:35:43 ftp1 kernel: [  619.770005]  RSP <ffff8801035d1778>
Apr 25 07:35:43 ftp1 kernel: [  620.763048] ---[ end trace 811cc5b821c8c34e 
]---



###
Note:
 Filesystem could be in "not-good" state before, because I tried to add/remove 
disks under kernel versions 2.6.32 & 2.6.33 which always caused immediately 
"kernel oops". But after "btrfsck" command everything seems to be OK.


Best regards,

Tomas Thiemel 
<thiemel@centrum.cz>
http://www.wifizabreh.net

