Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.trendhosting.net ([195.8.117.5]:38967 "EHLO
        mail1.trendhosting.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751770AbdANKhJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 14 Jan 2017 05:37:09 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail1.trendhosting.net (Postfix) with ESMTP id AA6DF150B4
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Jan 2017 10:29:24 +0000 (GMT)
Received: from mail1.trendhosting.net ([127.0.0.1])
        by localhost (thp003.trendhosting.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id I07qAgOSTfRH for <linux-btrfs@vger.kernel.org>;
        Sat, 14 Jan 2017 10:29:22 +0000 (GMT)
To: linux-btrfs@vger.kernel.org
From: Daniel Pocock <daniel@pocock.pro>
Subject: could not do orphan cleanup -22, btrfsck using 100% CPU, no activity
Message-ID: <98610bec-fc49-af0e-9dcf-49e80ee92070@pocock.pro>
Date: Sat, 14 Jan 2017 11:29:21 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


I had a system that experienced a kernel panic and after rebooting, one
of the btrfs filesystems doesn't mount on the first attempt

The filesystem does mount if I run the mount command manually in the
emergency shell

The following messages appear in the kernel log:


BTRFS critical (device sdc1): corrupt leaf, bad key order:
block=790251626496,root=1, slot=46
BTRFS error (device sdc1): Error removing orphan entry, stopping orphan
cleanup
BTRFS error (device sdc1): could not do orphan cleanup -22



There is a particular file that is now inaccessible.  It is not
important, but any attempt to access it gives an IO error.  When I look
at it with 'ls', it shows lots of question marks:

$ ls broken-file.txt
?????     ?    ?    filename



I was able to copy all files off the filesystem, except that one, using
rsync, so I just created a new filesystem and started using that instead.

However, I kept a copy of the broken filesystem for troubleshooting

I tried running

    # btrfsck /dev/sdc1

and a lot of output appears:

checking extents
bad key ordering 46 47
bad block 790251626496
Errors found in extent allocation tree or chunk allocation
checking free space cache
checking fs roots
bad key ordering 46 47
root 367 inode 474635 errors 2000, link count wrong
        unresolved ref dir 20136875 index 5 namelen 6 name foobar
filetype 0 errors 3, no dir item, no dir index
  .. many errors like that


root 367 inode 19964842 errors 400, nbytes wrong

root 367 inode 19964855 errors 2001, no inode item, link count wrong
        unresolved ref dir 11208629 index 100627 namelen 6 name Tb8Qlf
filetype 1 errors 4, no inode ref
  ... and many like that 

Checking filesystem on /dev/sdc1
UUID:
found 92684783616 bytes used err is 1
total csum bytes: 88527744
total tree bytes: 439730176
total fs tree bytes: 174620672
total extent tree bytes: 127827968
btree space waste bytes: 131661981
file data blocks allocated: 6149394432
 referenced 2896289792



Then I tried btrfsck --repair while monitoring with top and iostat

I notice that there is read activity for about a minute, btrfsck sits
there for a long time (over 30 minutes) using 100% CPU and a constant
4.4% of RAM and no more disk activity

If I enable the btrfsck progress indicator, the animation appears, but
still no disk activity

I saw previous discussions about the "could not do orphan cleanup -22"
messages and it is not clear if this is something that needs to be fixed.

The kernel is 4.8.0-2-amd64 and I tried both btrfs-progs v4.7.3 (Debian)
and v4.9 (compiled myself)

Regards,

Daniel


