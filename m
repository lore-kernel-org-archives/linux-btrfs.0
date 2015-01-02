Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.plaintext.sk ([85.248.156.6]:41926 "EHLO
	shiva.plaintext.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbbABOrw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Jan 2015 09:47:52 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by shiva.plaintext.sk (Postfix) with ESMTP id 957D426F7D
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Jan 2015 15:42:30 +0100 (CET)
Received: from shiva.plaintext.sk ([127.0.0.1])
	by localhost (shiva.plaintext.sk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 36WwEVzNFFSV for <linux-btrfs@vger.kernel.org>;
	Fri,  2 Jan 2015 15:42:29 +0100 (CET)
Received: from shiva.plaintext.sk (shiva.plaintext.sk [85.248.156.6])
	by shiva.plaintext.sk (Postfix) with ESMTP id 7EA0426F6F
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Jan 2015 15:42:29 +0100 (CET)
Date: Fri, 2 Jan 2015 15:42:29 +0100 (GMT+01:00)
From: luvar@plaintext.sk
To: linux-btrfs@vger.kernel.org
Message-ID: <1256750348.24201420209749292.JavaMail.root@shiva>
In-Reply-To: <1377898232.24181420209516734.JavaMail.root@shiva>
Subject: possible bug in balance
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I have today added one device and I have converted metadata to raid1. Than I wanted to convert to raid1 also some data (with balance filter) and try if there is some speedup when reading files (starting programs)... I have issued this command:

luvar@blackdawn:~$ sudo time btrfs balance start -dconvert=raid1 -dusage=20 /home/luvar/programs/
[sudo] password for luvar: 
ERROR: error during balancing '/home/luvar/programs/' - Input/output error
There may be more info in syslog - try dmesg | tail
Command exited with non-zero status 19
0.00user 0.08system 0:08.29elapsed 1%CPU (0avgtext+0avgdata 768maxresident)k
14696inputs+6584outputs (2major+253minor)pagefaults 0swaps


Part of df command:
luvar@blackdawn:~$ df -h
Filesystem                   Size  Used Avail Use% Mounted on
/dev/sdb2                    458G  177G   59G  75% /
/dev/sdb2                    458G  177G   59G  75% /home
/dev/sdb1                    226M   96M  114M  46% /boot
/dev/sdb2                    458G  177G   59G  75% /home/luvar/eclipseWorkspaceAndroid
/dev/sdb2                    458G  177G   59G  75% /home/luvar/eclipseWorkspaceErlang
/dev/sdb2                    458G  177G   59G  75% /home/luvar/programs

root@blackdawn:/home/luvar# dmesg|tail -n 50
[ 8107.693414] attempt to access beyond end of device
[ 8107.693425] sdb2: rw=32, want=480102272, limit=473956352
[ 8107.711854] attempt to access beyond end of device
[ 8107.711863] sdb2: rw=1041, want=480102272, limit=473956352
[ 8107.771103] attempt to access beyond end of device
[ 8107.771114] sdb2: rw=32, want=482410504, limit=473956352
[ 8107.784037] attempt to access beyond end of device
[ 8107.784045] sdb2: rw=1041, want=482410504, limit=473956352
[ 8107.804923] attempt to access beyond end of device
[ 8107.804933] sdb2: rw=32, want=478657496, limit=473956352
[ 8107.817134] attempt to access beyond end of device
[ 8107.817142] sdb2: rw=1041, want=478657496, limit=473956352
[ 8107.835377] attempt to access beyond end of device
[ 8107.835384] sdb2: rw=32, want=480795752, limit=473956352
[ 8107.842977] attempt to access beyond end of device
[ 8107.842985] sdb2: rw=1041, want=480795752, limit=473956352
[ 8107.887768] attempt to access beyond end of device
[ 8107.887778] sdb2: rw=32, want=478931480, limit=473956352
[ 8107.898939] attempt to access beyond end of device
[ 8107.898946] sdb2: rw=1041, want=478931480, limit=473956352
[ 8107.958691] attempt to access beyond end of device
[ 8107.958699] sdb2: rw=32, want=479426840, limit=473956352
[ 8107.966368] attempt to access beyond end of device
[ 8107.966375] sdb2: rw=1041, want=479426840, limit=473956352
[ 8116.097908] attempt to access beyond end of device
[ 8116.097919] sdb2: rw=32, want=478334096, limit=473956352
[ 8116.097923] btrfs_dev_stat_print_on_error: 12 callbacks suppressed
[ 8116.097926] btrfs: bdev /dev/sdb2 errs: wr 638625, rd 65863, flush 0, corrupt 0, gen 0
[ 8116.133108] attempt to access beyond end of device
[ 8116.133118] sdb2: rw=1041, want=478334096, limit=473956352
[ 8116.133124] btrfs: bdev /dev/sdb2 errs: wr 638626, rd 65863, flush 0, corrupt 0, gen 0
[ 8125.065061] attempt to access beyond end of device
[ 8125.065073] sdb2: rw=32, want=481418928, limit=473956352
[ 8125.065077] btrfs: bdev /dev/sdb2 errs: wr 638626, rd 65864, flush 0, corrupt 0, gen 0
[ 8125.084522] attempt to access beyond end of device
[ 8125.084533] sdb2: rw=1041, want=481418928, limit=473956352
[ 8125.084539] btrfs: bdev /dev/sdb2 errs: wr 638627, rd 65864, flush 0, corrupt 0, gen 0
[ 8131.848768] btrfs: relocating block group 472710643712 flags 1
[ 8133.866427] attempt to access beyond end of device
[ 8133.866436] sdb2: rw=0, want=476739152, limit=473956352
[ 8133.866441] btrfs: bdev /dev/sdb2 errs: wr 638627, rd 65865, flush 0, corrupt 0, gen 0
[ 8133.866516] attempt to access beyond end of device
[ 8133.866520] sdb2: rw=0, want=476739152, limit=473956352
[ 8133.866523] btrfs: bdev /dev/sdb2 errs: wr 638627, rd 65866, flush 0, corrupt 0, gen 0
[ 8159.272179] attempt to access beyond end of device
[ 8159.272191] sdb2: rw=32, want=480110048, limit=473956352
[ 8159.272196] btrfs: bdev /dev/sdb2 errs: wr 638627, rd 65867, flush 0, corrupt 0, gen 0
[ 8159.300427] attempt to access beyond end of device
[ 8159.300434] sdb2: rw=1041, want=480110048, limit=473956352
[ 8159.300440] btrfs: bdev /dev/sdb2 errs: wr 638628, rd 65867, flush 0, corrupt 0, gen 0

root@blackdawn:/home/luvar# uname -a
Linux blackdawn 3.13.0-30-generic #55-Ubuntu SMP Fri Jul 4 21:40:53 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux

root@blackdawn:/home/luvar# btrfs v
Btrfs v0.20-rc1-189-g704a08c


Am I doing something forbidden (I have not see any structure where raid type is stored per file/subvolume item), or I just hit some problem? What should I try?

PS: After all I will convert all data to raid1, but I want to play first :-)
