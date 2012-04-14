From: "Marco L. Crociani" <marco.crociani@gmail.com>
Subject: Errors in rebalancing RAID1 array after disk failure.
Date: Sat, 14 Apr 2012 18:39:12 +0200
Message-ID: <CADy=jfV9pKJurcormuMK7KW54-DKSvYns-Ow-T_FEELGmFQ18Q@mail.gmail.com>
References: <CADy=jfVRz5UuKcFkDXC9hwZnP8Z=E9NuF9p3hE6b0ZC06k7DWg@mail.gmail.com>
 <CADy=jfWC1vJs_TWt-EmvAN2Ybqw8kjN2tFV_vgAb-OKeGMpotg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CADy=jfWC1vJs_TWt-EmvAN2Ybqw8kjN2tFV_vgAb-OKeGMpotg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
do you remember my btrfs array?
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg14482.html
http://btrfs.ipv5.de/index.php?title=3DUseCases#Resize_on_multi_devices=
_filesystem

One disk of my two disks btrfs RAID1 array broke down.
Initially there was bad sectors that seem to be OK after rewriting
those. So I started a scrub.
During scrub the faulty disk went worse and I found the first disk
completely full.
I sent the hard disk to the vendors (it was in warranty) and now I
have a new drive.
I add it to the btrfs file system.
mount -o degraded /dev/sda3 /mnt/sda3

With kernel 3.2.7 I got errors after mounting it.

With 3.3.2 I was able to add the new disk.
btrfs dev add /dev/sdb3 /mnt/sda3

=2E/btrfs fi sh
Label: 'RootFS'=C2=A0 uuid: c87975a0-a575-405e-9890-d3f7f25bbd96
=C2=A0=C2=A0=C2=A0 Total devices 3 FS bytes used 1015.83GB
=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 3 size 1.75TB used 357.00GB =
path /dev/sdb3
=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 1 size 1.75TB used 1.34TB pa=
th /dev/sda3
=C2=A0=C2=A0=C2=A0 *** Some devices missing

Btrfs Btrfs v0.19

start balance

# ./btrfs filesystem balance start /mnt/sda3
ERROR: error during balancing '/mnt/sda3' - Input/output error
There may be more info in syslog - try dmesg | tail


Apr 14 18:02:36 evo kernel: [=C2=A0 115.294006] device label RootFS dev=
id 1
transid 45583 /dev/sda3
Apr 14 18:03:20 evo kernel: [=C2=A0 159.027945] device label RootFS dev=
id 1
transid 45583 /dev/sda3
Apr 14 18:03:20 evo kernel: [=C2=A0 159.028397] btrfs: allowing degrade=
d mounts
Apr 14 18:03:20 evo kernel: [=C2=A0 159.028404] btrfs: disk space cachi=
ng is enabled
Apr 14 18:06:16 evo kernel: [=C2=A0 335.740763] btrfs: relocating block
group 1513745285120 flags 20
Apr 14 18:06:17 evo kernel: [=C2=A0 336.613986] btrfs: relocating block
group 1512671543296 flags 20
Apr 14 18:06:19 evo kernel: [=C2=A0 338.727980] btrfs: relocating block
group 1511597801472 flags 20
Apr 14 18:06:20 evo kernel: [=C2=A0 339.230115] btrfs: relocating block
group 1510524059648 flags 20
Apr 14 18:06:20 evo kernel: [=C2=A0 339.711998] btrfs: relocating block
group 1509450317824 flags 20
Apr 14 18:06:21 evo kernel: [=C2=A0 340.192085] btrfs: relocating block
group 1508376576000 flags 20
Apr 14 18:06:21 evo kernel: [=C2=A0 340.648110] btrfs: relocating block
group 1507302834176 flags 20
Apr 14 18:06:22 evo kernel: [=C2=A0 341.342495] btrfs: relocating block
group 1506229092352 flags 20
Apr 14 18:06:23 evo kernel: [=C2=A0 341.812211] btrfs: relocating block
group 1505155350528 flags 20
Apr 14 18:06:23 evo kernel: [=C2=A0 342.315954] btrfs: relocating block
group 1504081608704 flags 20
Apr 14 18:06:24 evo kernel: [=C2=A0 342.880293] btrfs: relocating block
group 1503007866880 flags 20
Apr 14 18:06:24 evo kernel: [=C2=A0 343.502431] btrfs: relocating block
group 1501934125056 flags 20
Apr 14 18:06:25 evo kernel: [=C2=A0 344.020142] btrfs: relocating block
group 1500860383232 flags 20
Apr 14 18:06:25 evo kernel: [=C2=A0 344.500399] btrfs: relocating block
group 1499786641408 flags 20
Apr 14 18:06:26 evo kernel: [=C2=A0 345.004203] btrfs: relocating block
group 1498712899584 flags 20
Apr 14 18:06:26 evo kernel: [=C2=A0 345.676401] btrfs: relocating block
group 1497639157760 flags 20
Apr 14 18:06:27 evo kernel: [=C2=A0 346.432498] btrfs: relocating block
group 1496565415936 flags 20
Apr 14 18:06:28 evo kernel: [=C2=A0 346.898677] btrfs: relocating block
group 1495491674112 flags 20
Apr 14 18:06:28 evo kernel: [=C2=A0 347.358779] btrfs: relocating block
group 1494417932288 flags 20
Apr 14 18:06:29 evo kernel: [=C2=A0 347.812423] btrfs: relocating block
group 1493344190464 flags 20
Apr 14 18:06:29 evo kernel: [=C2=A0 348.254785] btrfs: relocating block
group 1492270448640 flags 20
Apr 14 18:06:29 evo kernel: [=C2=A0 348.712486] btrfs: relocating block
group 1491196706816 flags 20
Apr 14 18:06:30 evo kernel: [=C2=A0 349.180724] btrfs: relocating block
group 1490122964992 flags 20
Apr 14 18:06:30 evo kernel: [=C2=A0 349.660531] btrfs: relocating block
group 1489049223168 flags 20
Apr 14 18:06:31 evo kernel: [=C2=A0 350.247621] btrfs: relocating block
group 1487975481344 flags 20
Apr 14 18:06:32 evo kernel: [=C2=A0 351.640810] btrfs: relocating block
group 1486901739520 flags 20
Apr 14 18:06:34 evo kernel: [=C2=A0 353.045191] btrfs: relocating block
group 1485827997696 flags 20
Apr 14 18:06:35 evo kernel: [=C2=A0 354.353076] btrfs: relocating block
group 1484754255872 flags 20
Apr 14 18:06:36 evo kernel: [=C2=A0 355.649374] btrfs: relocating block
group 1483680514048 flags 20
Apr 14 18:06:38 evo kernel: [=C2=A0 356.789416] btrfs: relocating block
group 1482606772224 flags 20
Apr 14 18:06:39 evo kernel: [=C2=A0 358.049273] btrfs: relocating block
group 1481533030400 flags 20
Apr 14 18:06:40 evo kernel: [=C2=A0 358.997303] btrfs: relocating block
group 1480459288576 flags 20
Apr 14 18:06:41 evo kernel: [=C2=A0 359.907791] btrfs: relocating block
group 1479385546752 flags 20
Apr 14 18:06:42 evo kernel: [=C2=A0 360.808096] btrfs: relocating block
group 1478311804928 flags 20
Apr 14 18:06:42 evo kernel: [=C2=A0 361.673508] btrfs: relocating block
group 1477238063104 flags 20
Apr 14 18:06:43 evo kernel: [=C2=A0 362.561198] btrfs: relocating block
group 1476164321280 flags 20
Apr 14 18:06:44 evo kernel: [=C2=A0 363.737713] btrfs: relocating block
group 1475090579456 flags 20
Apr 14 18:06:45 evo kernel: [=C2=A0 364.638036] btrfs: relocating block
group 1474016837632 flags 20
Apr 14 18:06:46 evo kernel: [=C2=A0 365.430090] btrfs: relocating block
group 1472943095808 flags 20
Apr 14 18:06:47 evo kernel: [=C2=A0 366.304545] btrfs: relocating block
group 1471869353984 flags 20
Apr 14 18:06:48 evo kernel: [=C2=A0 367.134223] btrfs: relocating block
group 1470795612160 flags 20
Apr 14 18:06:49 evo kernel: [=C2=A0 368.015084] btrfs: relocating block
group 1469721870336 flags 20
Apr 14 18:06:50 evo kernel: [=C2=A0 368.981808] btrfs: relocating block
group 1468648128512 flags 20
Apr 14 18:06:51 evo kernel: [=C2=A0 369.954430] btrfs: relocating block
group 1467574386688 flags 20
Apr 14 18:06:52 evo kernel: [=C2=A0 370.811505] btrfs: relocating block
group 1466500644864 flags 20
Apr 14 18:06:53 evo kernel: [=C2=A0 371.802372] btrfs: relocating block
group 1465426903040 flags 20
Apr 14 18:06:53 evo kernel: [=C2=A0 372.690405] btrfs: relocating block
group 1464353161216 flags 20
Apr 14 18:06:54 evo kernel: [=C2=A0 373.542724] btrfs: relocating block
group 1463279419392 flags 20
Apr 14 18:06:55 evo kernel: [=C2=A0 374.705285] btrfs: relocating block
group 1462205677568 flags 20
Apr 14 18:06:56 evo kernel: [=C2=A0 375.738935] btrfs: relocating block
group 1461131935744 flags 20
Apr 14 18:06:58 evo kernel: [=C2=A0 376.818765] btrfs: relocating block
group 1460058193920 flags 20
Apr 14 18:06:59 evo kernel: [=C2=A0 377.911016] btrfs: relocating block
group 1458984452096 flags 20
Apr 14 18:07:00 evo kernel: [=C2=A0 378.785504] btrfs: relocating block
group 1457910710272 flags 20
Apr 14 18:07:01 evo kernel: [=C2=A0 380.155285] btrfs: relocating block
group 1456836968448 flags 20
Apr 14 18:07:02 evo kernel: [=C2=A0 380.995338] btrfs: relocating block
group 1455763226624 flags 20
Apr 14 18:07:03 evo kernel: [=C2=A0 381.979403] btrfs: relocating block
group 1454689484800 flags 20
Apr 14 18:07:04 evo kernel: [=C2=A0 382.891477] btrfs: relocating block
group 1453615742976 flags 20
Apr 14 18:07:04 evo kernel: [=C2=A0 383.743286] btrfs: relocating block
group 1452542001152 flags 20
Apr 14 18:07:06 evo kernel: [=C2=A0 385.395922] btrfs: relocating block
group 1451468259328 flags 20
Apr 14 18:07:07 evo kernel: [=C2=A0 386.237748] btrfs: relocating block
group 1450394517504 flags 20
Apr 14 18:07:08 evo kernel: [=C2=A0 386.947701] btrfs: relocating block
group 1449320775680 flags 20
Apr 14 18:07:08 evo kernel: [=C2=A0 387.715735] btrfs: relocating block
group 1448247033856 flags 20
Apr 14 18:07:09 evo kernel: [=C2=A0 388.495807] btrfs: relocating block
group 1447173292032 flags 20
Apr 14 18:07:10 evo kernel: [=C2=A0 389.310221] btrfs: relocating block
group 1446099550208 flags 20
Apr 14 18:07:11 evo kernel: [=C2=A0 389.995904] btrfs: relocating block
group 1445025808384 flags 20
Apr 14 18:07:11 evo kernel: [=C2=A0 390.643700] btrfs: relocating block
group 1443952066560 flags 20
Apr 14 18:07:12 evo kernel: [=C2=A0 391.639758] btrfs: relocating block
group 1442878324736 flags 20
Apr 14 18:07:13 evo kernel: [=C2=A0 392.202374] btrfs: relocating block
group 1441804582912 flags 20
Apr 14 18:07:14 evo kernel: [=C2=A0 392.802422] btrfs: relocating block
group 1440730841088 flags 20
Apr 14 18:07:14 evo kernel: [=C2=A0 393.428116] btrfs: relocating block
group 1439657099264 flags 20
Apr 14 18:07:15 evo kernel: [=C2=A0 394.184194] btrfs: relocating block
group 1438583357440 flags 20
Apr 14 18:07:15 evo kernel: [=C2=A0 394.722289] btrfs: relocating block
group 1437509615616 flags 20
Apr 14 18:07:16 evo kernel: [=C2=A0 395.275988] btrfs: relocating block
group 1436435873792 flags 20
Apr 14 18:07:17 evo kernel: [=C2=A0 395.905274] btrfs: relocating block
group 1435362131968 flags 20
Apr 14 18:07:17 evo kernel: [=C2=A0 396.584115] btrfs: relocating block
group 1434288390144 flags 20
Apr 14 18:07:18 evo kernel: [=C2=A0 397.194476] btrfs: relocating block
group 1433214648320 flags 20
Apr 14 18:07:19 evo kernel: [=C2=A0 397.758507] btrfs: relocating block
group 1432140906496 flags 20
Apr 14 18:07:19 evo kernel: [=C2=A0 398.382795] btrfs: relocating block
group 1431067164672 flags 20
Apr 14 18:07:20 evo kernel: [=C2=A0 399.152527] btrfs: relocating block
group 1429993422848 flags 20
Apr 14 18:07:20 evo kernel: [=C2=A0 399.726684] btrfs: relocating block
group 1428919681024 flags 20
Apr 14 18:07:21 evo kernel: [=C2=A0 400.352578] btrfs: relocating block
group 1427845939200 flags 20
Apr 14 18:07:22 evo kernel: [=C2=A0 401.010780] btrfs: relocating block
group 1426772197376 flags 20
Apr 14 18:07:23 evo kernel: [=C2=A0 401.972700] btrfs: relocating block
group 1425698455552 flags 20
Apr 14 18:07:23 evo kernel: [=C2=A0 402.691132] btrfs: relocating block
group 1424624713728 flags 20
Apr 14 18:07:24 evo kernel: [=C2=A0 403.291128] btrfs: relocating block
group 1423550971904 flags 20
Apr 14 18:07:25 evo kernel: [=C2=A0 403.868841] btrfs: relocating block
group 1422477230080 flags 20
Apr 14 18:07:25 evo kernel: [=C2=A0 404.611037] btrfs: relocating block
group 1421403488256 flags 20
Apr 14 18:07:26 evo kernel: [=C2=A0 405.163300] btrfs: relocating block
group 1420329746432 flags 20
Apr 14 18:07:27 evo kernel: [=C2=A0 405.896774] btrfs: relocating block
group 1419256004608 flags 20
Apr 14 18:07:27 evo kernel: [=C2=A0 406.435405] btrfs: relocating block
group 1418182262784 flags 20
Apr 14 18:07:28 evo kernel: [=C2=A0 407.385118] btrfs: relocating block
group 1417108520960 flags 20
Apr 14 18:07:29 evo kernel: [=C2=A0 407.935516] btrfs: relocating block
group 1416034779136 flags 20
Apr 14 18:07:29 evo kernel: [=C2=A0 408.512968] btrfs: relocating block
group 1414961037312 flags 20
Apr 14 18:07:30 evo kernel: [=C2=A0 409.053245] btrfs: relocating block
group 1413887295488 flags 20
Apr 14 18:07:30 evo kernel: [=C2=A0 409.531385] btrfs: relocating block
group 1412813553664 flags 20
Apr 14 18:07:31 evo kernel: [=C2=A0 410.025036] btrfs: relocating block
group 1411739811840 flags 20
Apr 14 18:07:31 evo kernel: [=C2=A0 410.503666] btrfs: relocating block
group 1410666070016 flags 20
Apr 14 18:07:32 evo kernel: [=C2=A0 411.033124] btrfs: relocating block
group 1409592328192 flags 20
Apr 14 18:07:33 evo kernel: [=C2=A0 411.753059] btrfs: relocating block
group 1408518586368 flags 20
Apr 14 18:07:33 evo kernel: [=C2=A0 412.401433] btrfs: relocating block
group 1407444844544 flags 20
Apr 14 18:07:34 evo kernel: [=C2=A0 412.951844] btrfs: relocating block
group 1406371102720 flags 20
Apr 14 18:07:34 evo kernel: [=C2=A0 413.385523] btrfs: relocating block
group 1405297360896 flags 20
Apr 14 18:07:35 evo kernel: [=C2=A0 413.817546] btrfs: relocating block
group 1404223619072 flags 20
Apr 14 18:07:35 evo kernel: [=C2=A0 414.235729] btrfs: relocating block
group 1403149877248 flags 20
Apr 14 18:07:35 evo kernel: [=C2=A0 414.703857] btrfs: relocating block
group 1402076135424 flags 17
Apr 14 18:07:47 evo kernel: [=C2=A0 425.878246] btrfs: found 119 extent=
s
Apr 14 18:07:51 evo kernel: [=C2=A0 430.715144] btrfs: found 119 extent=
s
Apr 14 18:07:52 evo kernel: [=C2=A0 431.054709] btrfs: relocating block
group 1401002393600 flags 17
Apr 14 18:08:14 evo kernel: [=C2=A0 453.506541] btrfs csum failed ino 3=
62
off 910946304 csum 432355644 private 175165154
Apr 14 18:08:14 evo kernel: [=C2=A0 453.536473] btrfs csum failed ino 3=
62
off 910946304 csum 432355644 private 175165154
Apr 14 18:08:14 evo kernel: [=C2=A0 453.536804] btrfs csum failed ino 3=
62
off 910946304 csum 432355644 private 175165154
Apr 14 18:08:14 evo kernel: [=C2=A0 453.607397] btrfs csum failed ino 3=
62
off 910946304 csum 432355644 private 175165154
Apr 14 18:08:14 evo kernel: [=C2=A0 453.607649] btrfs csum failed ino 3=
62
off 910946304 csum 432355644 private 175165154


=C2=A0./btrfs device delete missing /mnt/sda3/
ERROR: error removing the device 'missing' - Input/output error


Apr 14 18:13:49 evo kernel: [=C2=A0 788.432854] btrfs: relocating block
group 1401002393600 flags 17
Apr 14 18:14:07 evo kernel: [=C2=A0 806.727391] btrfs csum failed ino 3=
63
off 910946304 csum 432355644 private 175165154
Apr 14 18:14:08 evo kernel: [=C2=A0 806.765441] btrfs csum failed ino 3=
63
off 910946304 csum 432355644 private 175165154
Apr 14 18:14:08 evo kernel: [=C2=A0 806.765799] btrfs csum failed ino 3=
63
off 910946304 csum 432355644 private 175165154
Apr 14 18:14:08 evo kernel: [=C2=A0 806.766290] btrfs csum failed ino 3=
63
off 910946304 csum 432355644 private 175165154
Apr 14 18:14:08 evo kernel: [=C2=A0 806.766650] btrfs csum failed ino 3=
63
off 910946304 csum 432355644 private 175165154

What can I do?

Best regards,

--
Marco Lorenzo Crociani,
marco.crociani@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
