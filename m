Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:54092 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754581AbeGJB0x (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Jul 2018 21:26:53 -0400
Subject: Fwd: Re: So, does btrfs check lowmem take days? weeks?
References: <20180709174818.wq2d4awmgasxgwad@merlins.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Qu Wenruo <quwenruo.btrfs@gmx.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <ca6355da-86fc-6007-44ff-171ddb692c6f@cn.fujitsu.com>
Date: Tue, 10 Jul 2018 09:33:17 +0800
MIME-Version: 1.0
In-Reply-To: <20180709174818.wq2d4awmgasxgwad@merlins.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[FWD to linux-btrfs]
Thanks to Marc's patient of running and tests btrfsck lowmem mode
in recent days.
The FS has a large extent tree but luckily few are corrupted, they are
all fixed by special version. Reloc trees were cleaned too.
So the FS can be mounted with RW.

However, the remaining errors of extent data in file trees are 
unresloved, they are all about holes.
Since I'm not familiar with kernel code, not sure how serious those 
errors are and what result could be during write/read those wrong
items.

Marc also has some questions in the part forwarded, replies are
always welcome.

Error messages are showed in the last.


-------- Forwarded Message --------
Subject: Re: So, does btrfs check lowmem take days? weeks?
Date: Mon, 9 Jul 2018 10:48:18 -0700
From: Marc MERLIN <marc@merlins.org>
To: Su Yue <Damenly_Su@gmx.com>
CC: quwenruo.btrfs@gmx.com, Su Yue <suy.fnst@cn.fujitsu.com>

Success!
Well done Su, this is a huge improvement to the lowmem code. It went 
from days to less than 3 hours.

I'll paste the logs below.

Questions:
1) I assume I first need to delete a lot of snapshots. What is the limit 
in your opinion?
100? 150? other?

2) my filesystem is somewhat misbalanced. Which balance options do you 
think are safe to use?

3) Should I start a scrub now (takes about 1 day) or anything else to
check that the filesystem is hopefully not damaged anymore?

4) should btrfs check reset the corrupt counter?
bdev /dev/mapper/dshelf2 errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
for now, should I reset it manually?

Thanks,
Marc


gargamel:/var/local/src/btrfs-progs.sy# ./btrfsck --mode=lowmem -q 
--repair /dev/mapper/dshelf2
enabling repair mode
WARNING: low-memory mode repair support is only partial
Checking filesystem on /dev/mapper/dshelf2
UUID: 0f1a0c9f-4e54-4fa7-8736-fd50818ff73d
Created new chunk [18460145811456 1073741824]
Add one extent data backref [84302495744 69632]
Add one extent data backref [84302495744 69632]
Add one extent data backref [125712527360 12214272]
Add one extent data backref [125730848768 5111808]
Add one extent data backref [125730848768 5111808]
Add one extent data backref [125736914944 6037504]
Add one extent data backref [125736914944 6037504]
Add one extent data backref [129952120832 20242432]
Add one extent data backref [129952120832 20242432]
Add one extent data backref [134925357056 11829248]
Add one extent data backref [134925357056 11829248]
Add one extent data backref [147895111680 12345344]
Add one extent data backref [147895111680 12345344]
Add one extent data backref [150850146304 17522688]
Add one extent data backref [156909494272 55320576]
Add one extent data backref [156909494272 55320576]
good luck!
found 0 bytes used, no error found
total csum bytes: 0
total tree bytes: 0
total fs tree bytes: 0
total extent tree bytes: 0
btree space waste bytes: 0
file data blocks allocated: 0
  referenced 0
gargamel:/var/local/src/btrfs-progs.sy# ./btrfsck --mode=lowmem -q 
/dev/mapper/dshelf2
Checking filesystem on /dev/mapper/dshelf2
UUID: 0f1a0c9f-4e54-4fa7-8736-fd50818ff73d
good luck!
found 251650048 bytes used, no error found
total csum bytes: 0
total tree bytes: 0
total fs tree bytes: 0
total extent tree bytes: 0
btree space waste bytes: 0
file data blocks allocated: 0
  referenced 0
gargamel:/var/local/src/btrfs-progs.sy# ./btrfsck -c /dev/mapper/dshelf2
Checking filesystem on /dev/mapper/dshelf2
UUID: 0f1a0c9f-4e54-4fa7-8736-fd50818ff73d
found 0 bytes used, no error found
total csum bytes: 0
total tree bytes: 0
total fs tree bytes: 0
total extent tree bytes: 0
btree space waste bytes: 0
file data blocks allocated: 0
  referenced 0
gargamel:/var/local/src/btrfs-progs.sy# mount /dev/mapper/dshelf2 /mnt/mnt
[671283.314558] BTRFS info (device dm-2): disk space caching is enabled
[671283.334226] BTRFS info (device dm-2): has skinny extents
[671285.191740] BTRFS info (device dm-2): bdev /dev/mapper/dshelf2 errs: 
wr 0, rd 0, flush 0, corrupt 2, gen 0
[671395.371313] BTRFS info (device dm-2): enabling ssd optimizations
[671400.884013] BTRFS info (device dm-2): checking UUID tree
(hung about 2-3mn but worked eventually)

gargamel:/mnt/mnt# btrfs fi show .
Label: 'dshelf2'  uuid: 0f1a0c9f-4e54-4fa7-8736-fd50818ff73d
         Total devices 1 FS bytes used 12.59TiB
         devid    1 size 14.55TiB used 13.81TiB path /dev/mapper/dshelf2

gargamel:/mnt/mnt# btrfs fi df .
Data, single: total=13.57TiB, used=12.48TiB
System, DUP: total=32.00MiB, used=1.55MiB
Metadata, DUP: total=124.50GiB, used=116.92GiB
Metadata, single: total=216.00MiB, used=0.00B
GlobalReserve, single: total=512.00MiB, used=42.62MiB

gargamel:/mnt/mnt# btrfs subvolume list . | wc -l
270


-- 
"A mouse is a device used to point at the xterm you want to type in" - 
A.S.R.
Microsoft is to operating systems ....
                                       .... what McDonalds is to gourmet 
cooking
Home page: http://marc.merlins.org/                       | PGP 
7F55D5F27AAF9D08


!Error messages bellow:

==================================================================
btrfsck --mode=lowmem --repair /dev/mapper/dshelf2
enabling repair mode
WARNING: low-memory mode repair support is only partial
Checking filesystem on /dev/mapper/dshelf2
UUID: 0f1a0c9f-4e54-4fa7-8736-fd50818ff73d
ERROR: extent[84302495744, 69632] referencer count mismatch (root: 
21872, owner: 374857, offset: 3407872) wanted: 2, have: 3
ERROR: extent[84302495744, 69632] referencer count mismatch (root: 
22911, owner: 374857, offset: 3407872) wanted: 2, have: 4
Delete backref in extent [84302495744 69632]
ERROR: extent[125712527360, 12214272] referencer count mismatch (root: 
21872, owner: 374857, offset: 114540544) wanted: 180, have: 181
Delete backref in extent [125712527360 12214272]
ERROR: extent[125730848768, 5111808] referencer count mismatch (root: 
21872, owner: 374857, offset: 126754816) wanted: 67, have: 68
Delete backref in extent [125730848768 5111808]
ERROR: extent[125730848768, 5111808] referencer count mismatch (root: 
22911, owner: 374857, offset: 126754816) wanted: 67, have: 115
Delete backref in extent [125730848768 5111808]
ERROR: extent[125736914944, 6037504] referencer count mismatch (root: 
21872, owner: 374857, offset: 131866624) wanted: 114, have: 115
ERROR: extent[125736914944, 6037504] referencer count mismatch (root: 
22911, owner: 374857, offset: 131866624) wanted: 114, have: 143
Delete backref in extent [125736914944 6037504]
ERROR: extent[129952120832, 20242432] referencer count mismatch (root: 
21872, owner: 374857, offset: 148234240) wanted: 301, have: 302
Delete backref in extent [129952120832 20242432]
ERROR: extent[129952120832, 20242432] referencer count mismatch (root: 
22911, owner: 374857, offset: 148234240) wanted: 355, have: 433
Delete backref in extent [129952120832 20242432]
ERROR: extent[134925357056, 11829248] referencer count mismatch (root: 
21872, owner: 374857, offset: 180371456) wanted: 160, have: 161
Delete backref in extent [134925357056 11829248]
ERROR: extent[134925357056, 11829248] referencer count mismatch (root: 
22911, owner: 374857, offset: 180371456) wanted: 161, have: 240
Delete backref in extent [134925357056 11829248]
ERROR: extent[147895111680, 12345344] referencer count mismatch (root: 
21872, owner: 374857, offset: 192200704) wanted: 169, have: 170
Delete backref in extent [147895111680 12345344]
ERROR: extent[147895111680, 12345344] referencer count mismatch (root: 
22911, owner: 374857, offset: 192200704) wanted: 171, have: 251
Delete backref in extent [147895111680 12345344]
ERROR: extent[150850146304, 17522688] referencer count mismatch (root: 
21872, owner: 374857, offset: 217653248) wanted: 347, have: 348
Delete backref in extent [150850146304 17522688]
ERROR: extent[156909494272, 55320576] referencer count mismatch (root: 
22911, owner: 374857, offset: 235175936) wanted: 1, have: 1449
Deleted root 2 item[156909494272, 178, 5476627808561673095]
ERROR: extent[156909494272, 55320576] referencer count mismatch (root: 
21872, owner: 374857, offset: 235175936) wanted: 1, have: 556
Deleted root 2 item[156909494272, 178, 7338474132555182983]
ERROR: errors found in extent allocation tree or chunk allocation
cache and super generation don't match, space cache will be invalidated
checking fs roots
Add a hole [4033, 63] in inode [25937109]
ERROR: failed to add hole [8129, 63] in inode [25937109]
ERROR: root 17592 EXTENT_DATA[25937109 8192] gap exists, expected: 
EXTENT_DATA[25937109 8129]
ERROR: failed to add hole [20417, 63] in inode [25937109]
ERROR: root 17592 EXTENT_DATA[25937109 20480] gap exists, expected: 
EXTENT_DATA[25937109 20417]
Add a hole [3349, 747] in inode [25937493]
ERROR: failed to add hole [7445, 747] in inode [25937493]
ERROR: root 17592 EXTENT_DATA[25937493 8192] gap exists, expected: 
EXTENT_DATA[25937493 7445]
ERROR: failed to add hole [11541, 747] in inode [25937493]
ERROR: root 17592 EXTENT_DATA[25937493 12288] gap exists, expected: 
EXTENT_DATA[25937493 11541]
Add a hole [4091, 5] in inode [25941335]
ERROR: failed to add hole [8187, 5] in inode [25941335]
ERROR: root 17592 EXTENT_DATA[25941335 8192] gap exists, expected: 
EXTENT_DATA[25941335 8187]
Can't find file name for inode 0, use 0 instead
ERROR: failed to link the inode 0 to lost+found dir: No such file or 
directory
ERROR: failed to move file '0' to 'lost+found' dir
ERROR: fail to repair nlink of inode 17592 root 0 name 0 filetype 0
ERROR: root 17592 INODE[0] nlink(1061879808) not equal to inode_refs(0)
ERROR: failed to set nbytes in inode 0 root 17592
ERROR: root 17592 INODE[0] nbytes 6640973824 not equal to extent_size 0
...
===============================================================



