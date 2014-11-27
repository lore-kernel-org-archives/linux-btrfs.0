Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from blu004-omc1s5.hotmail.com ([65.55.116.16]:56430 "EHLO
	BLU004-OMC1S5.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaK0S2D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Nov 2014 13:28:03 -0500
Message-ID: <BLU436-SMTP321B1086B6733929314F93AB710@phx.gbl>
Date: Thu, 27 Nov 2014 18:27:55 +0000
From: Boris Chernov <aqs1024@hotmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Changing label few times killed filesystem?
References: <BLU436-SMTP7537F1DDEF63F43667E45CAB770@phx.gbl>	<20141121093543.6685cbe5@natsu>	<BLU437-SMTP10930A5E18E8322A8C259AAB750@phx.gbl> <pan$f37fb$4727340$23550eda$69bcec61@cox.net> <BLU436-SMTP14172AF9A2DA601C46C2DA0AB730@phx.gbl>
In-Reply-To: <BLU436-SMTP14172AF9A2DA601C46C2DA0AB730@phx.gbl>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


     Since nobody had any other suggestions, I decided to attempt to run 
modified btrfsck with --repair option (without BUG_ON(rec->is_root) 
assertion).

     Surprisingly modified btrfsck --repair fixed all errors but one 
(according to btrfsck), but btrfsck asked me to run btrfsck --repair one 
more time to fix the remaining error. Mounting still did not work at 
this point, so I did what btrfsck suggested. At first it said it fixed 
the remaining error but then it found many more errors (not sure if 
btrfsck caused them or they were already present and fixing the 
remaining error just uncovered them).

     btrfs restore (with or with -t option) returns with zero exit code 
without even attempting to do anything (like it did before I tried to 
--repair). Mounting with or without "recovery" option produces the same 
errors (they were exactly the same before --repair so I already 
mentioned them in previous message, but for convenience I mention them 
again in the log below). "btrfs rescue chunk-recover" and "btrfs rescue 
super-recover" say that everything is OK.

     Does anybody have any ideas or suggestions?

     Please do not be afraid to suggest something risky - at this point 
I have nothing to lose, because if I cannot restore files or provide 
further debug information for developers, I have to reformat this 
partition anyway. Ideas what could have caused this corruption are also 
welcome, because currently I find it hard to believe that relabeling or 
mounting/unmounting were the only reasons.

     Below I show what I did exactly and show some parts of terminal 
output (for readability I removed repeated similar messages, please 
download full log if you are interested).

# btrfsck --repair /dev/sdb1  # Full log is can be downloaded here: 
http://pastebin.com/MdyjxY4w
enabling repair mode
Fixed 0 roots.
Checking filesystem on /dev/sdb1
UUID: 787e3bc1-7583-4bd8-a52e-e57fd7fc9243
checking extents
ref mismatch on [20971520 16384] extent item 0, found 1
adding new tree backref on start 20971520 len 16384 parent 3 root 3
Backref 20971520 parent 3 root 3 not found in extent tree
backpointer mismatch on [20971520 16384]
...
owner ref check failed [47529984 16384]
repaired damaged extent references
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
root 5 root dir 256 error
...
root 5 inode 5 errors 1, no inode item
         unresolved ref dir 6 index 0 namelen 7 name default filetype 0 
errors 3, no dir item, no dir index
Failed to find [30769152, 168, 16384]
btrfs unable to find ref byte nr 30769152 parent 0 root 5  owner 0 offset 1
reset isize for dir 6 root 5
root 5 inode 6 errors 2000, link count wrong
         unresolved ref dir 6 index 0 namelen 2 name .. filetype 0 
errors 3, no dir item, no dir index
root 5 inode 7 errors 1, no inode item
root 5 inode 9 errors 1, no inode item
root 5 inode 257 errors 2400, nbytes wrong, link count wrong
...
root 5 inode 18446744073709551607 errors 1, no inode item
found 409600 bytes used err is 1
total csum bytes: 0
total tree bytes: 49152
total fs tree bytes: 0
total extent tree bytes: 16384
btree space waste bytes: 48246
file data blocks allocated: 0
  referenced 0
Btrfs v3.17


     To my surprise, btrfsck showed great improvements (after btrfsck 
--repair) and asked me to run btrfsck --repair one more time to fix 
remaining error:


# btrfsck /dev/sdb1
root item for root 18446744073709551607, current bytenr 29540352, 
current gen 2758, current level 0, new bytenr 29540352, new gen 
4294967296, new level 1
Found 1 roots with an outdated root item.
Please run a filesystem check with the option --repair to fix them.


     Before trying to run btrfsck --repair again, I tried to mount, but 
it did not work:


# mount /dev/sdb1 /mnt
mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
        missing codepage or helper program, or other error
        In some cases useful info is found in syslog - try
        dmesg | tail  or so
# dmesg | tail
...
[268827.386951] BTRFS info (device sdb1): disk space caching is enabled
[268827.389932] parent transid verify failed on 29458432 wanted 5 found 2759
[268827.390161] parent transid verify failed on 29458432 wanted 5 found 2759
[268827.405135] BTRFS: open_ctree failed


     Since btrfsck told me to run it with --repair option again, I did:


# btrfsck --repair /dev/sdb1  # Full log is available here: 
http://pastebin.com/pcWte3Ru
enabling repair mode
fixing root item for root 18446744073709551607, current bytenr 29540352, 
current gen 2758, current level 0, new bytenr 29540352, new gen 
4294967296, new level 1
Fixed 1 roots.
Checking filesystem on /dev/sdb1
UUID: 787e3bc1-7583-4bd8-a52e-e57fd7fc9243
checking extents
parent transid verify failed on 29425664 wanted 1087 found 2763
...
Ignoring transid failure
leaf parent key incorrect 29425664
bad block 29425664
Chunk[256, 228, 0]: length(4194304), offset(0), type(2) is not found in 
block group
Chunk[256, 228, 0] stripe[1, 0] is not found in dev extent
...
Dev extent's total-byte(0) is not equal to byte-used(500107771904) in 
dev[1, 216, 1]
Errors found in extent allocation tree or chunk allocation
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
root 5 root dir 256 error
...
root 5 inode 5 errors 1, no inode item
         unresolved ref dir 6 index 0 namelen 7 name default filetype 0 
errors 3, no dir item, no dir index
root 5 inode 6 errors 2000, link count wrong
         unresolved ref dir 6 index 0 namelen 2 name .. filetype 0 
errors 3, no dir item, no dir index
root 5 inode 7 errors 1, no inode item
root 5 inode 9 errors 1, no inode item
root 5 inode 257 errors 2400, nbytes wrong, link count wrong
...
root 5 inode 18446744073709551607 errors 1, no inode item
parent transid verify failed on 29540352 wanted 4294967296 found 2758
parent transid verify failed on 29540352 wanted 4294967296 found 2758
parent transid verify failed on 29540352 wanted 4294967296 found 2758
parent transid verify failed on 29540352 wanted 4294967296 found 2758
Ignoring transid failure
found 453869568 bytes used err is 1
total csum bytes: 0
total tree bytes: 1785856
total fs tree bytes: 16384
total extent tree bytes: 16384
btree space waste bytes: 809878
file data blocks allocated: 0
  referenced 0
Btrfs v3.17


     If I try to mount it again, error in dmesg remains the same as 
before and btrfsck shows that errors which appeared after second 
--repair are still present (they can be seen in the log above). I also 
tried "btrfs rescue" but this did not make any difference (still can't 
use "btrfs restore" or mount):


# btrfs rescue super-recover /dev/sdb1
All supers are valid, no need to recover

# btrfs rescue chunk-recover /dev/sdb1 -v  # Full log is available here: 
http://pastebin.com/7knR1afA
All Devices:
         Device: id = 1, name = /dev/sdb1

DEVICE SCAN RESULT:
Filesystem Information:
         sectorsize: 4096
         leafsize: 16384
         tree root generation: 2765
         chunk root generation: 952
...
     Bad Chunks:

     Total Chunks:   469
       Heathy:       469
       Bad:  0

     Orphan Block Groups:

     Orphan Device Extents:
     Check chunks successfully with no orphans
     Recover the chunk tree successfully.
