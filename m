Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ijp134o.incoming.jp ([157.7.129.17]:43208 "EHLO
        ijp134o.incoming.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933430AbcJMBiX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 21:38:23 -0400
Received: from localhost (localhost [127.0.0.1])
        by ijp134o.incoming.jp (Postfix) with ESMTP id 7E523A0535
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Oct 2016 10:28:19 +0900 (JST)
Received: from ijp134o.incoming.jp ([127.0.0.1])
        by localhost (ijp134o.incoming.jp [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id YsCs8AuQmpHH for <linux-btrfs@vger.kernel.org>;
        Thu, 13 Oct 2016 10:28:19 +0900 (JST)
Received: from [172.16.215.137] (tokyo7d-173.digitalswift.net [210.175.55.173])
        by ijp134o.incoming.jp (Postfix) with ESMTPSA id 65109A052A
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Oct 2016 10:28:19 +0900 (JST)
Date: Thu, 13 Oct 2016 10:28:19 +0900
From: Hiroshi Honda <xero@incoming.jp>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Subject: Unable to rescue RAID5
Message-Id: <20161013102819.214E.13A92CCA@incoming.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am using Btrfs RAID5 with 10x4T disks.
Around 2 weeks ago, one disk of it was taking long time when read and write.
So, I tried replace the disk with new disk by replace command ( btrfs replace ... ).
But, it failed. So, I added new disk into the array by add command and then deleted the bad disk by delete command.
But, this deletion failed with error message as well. So, I deleted new disk from the array at the moment to return to first situation.
But, system is showing some error message with number and the number is counting up.
So, I rebooted the OS. Because, I felt this situation is something bad.
After that, I can not mount the array...
I copied those disk image by dd and then removed real disks from the system and mounted those image files by losetup.

I would appreciate it if you could help this.

# uname -a
Linux L176 4.7.4-1-ARCH #1 SMP PREEMPT Thu Sep 15 15:24:29 CEST 2016 x86_64 GNU/Linux

# ./btrfs version
btrfs-progs v4.8.1

# ./btrfs fi show
Label: 'space1'  uuid: b27e1505-4203-464b-a9d5-96881ca550e0
        Total devices 10 FS bytes used 14.47TiB
        devid    1 size 3.64TiB used 1.61TiB path /dev/loop8
        devid    2 size 3.64TiB used 1.61TiB path /dev/loop6
        devid    3 size 3.64TiB used 1.61TiB path /dev/loop4
        devid    4 size 3.64TiB used 1.61TiB path /dev/loop7
        devid    5 size 3.64TiB used 1.61TiB path /dev/loop9
        devid    6 size 3.64TiB used 1.61TiB path /dev/loop0
        devid    7 size 3.64TiB used 1.61TiB path /dev/loop5
        devid    8 size 3.64TiB used 1.61TiB path /dev/loop2
        devid    9 size 3.64TiB used 1.61TiB path /dev/loop3
        devid   10 size 3.64TiB used 1.61TiB path /dev/loop1


# mount -t btrfs -o ro,degraded,recovery /dev/loop3 /root/oo/
mount: wrong fs type, bad option, bad superblock on /dev/loop3,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.

"-o ro,degraded", "-o ro,recovery" and "-o ro" are same result..


# ./btrfs restore /dev/loop3 /root/oo/
checksum verify failed on 16091506147328 found 1E4E4207 wanted 00000000
checksum verify failed on 16091506147328 found 1E4E4207 wanted 00000000
checksum verify failed on 16091506147328 found 58D16B1B wanted 64109AAB
checksum verify failed on 16091506147328 found 58D16B1B wanted 64109AAB
bytenr mismatch, want=16091506147328, have=3144945314663302585
ERROR: cannot read chunk root
Could not open root, trying backup super
warning, device 10 is missing
warning, device 8 is missing
warning, device 7 is missing
warning, device 6 is missing
warning, device 5 is missing
warning, device 4 is missing
warning, device 3 is missing
warning, device 2 is missing
warning, device 1 is missing
warning, device 2 is missing
warning, device 3 is missing
warning, device 4 is missing
warning, device 5 is missing
warning, device 6 is missing
warning, device 7 is missing
warning, device 8 is missing
warning, device 10 is missing
warning, device 1 is missing
checksum verify failed on 16091506147328 found 1E4E4207 wanted 00000000
checksum verify failed on 16091506147328 found 1E4E4207 wanted 00000000
checksum verify failed on 16091506147328 found 1E4E4207 wanted 00000000
bytenr mismatch, want=16091506147328, have=0
ERROR: cannot read chunk root
Could not open root, trying backup super
warning, device 10 is missing
warning, device 8 is missing
warning, device 7 is missing
warning, device 6 is missing
warning, device 5 is missing
warning, device 4 is missing
warning, device 3 is missing
warning, device 2 is missing
warning, device 1 is missing
warning, device 2 is missing
warning, device 3 is missing
warning, device 4 is missing
warning, device 5 is missing
warning, device 6 is missing
warning, device 7 is missing
warning, device 8 is missing
warning, device 10 is missing
warning, device 1 is missing
checksum verify failed on 16091506147328 found 1E4E4207 wanted 00000000
checksum verify failed on 16091506147328 found 1E4E4207 wanted 00000000
checksum verify failed on 16091506147328 found 1E4E4207 wanted 00000000
bytenr mismatch, want=16091506147328, have=0
ERROR: cannot read chunk root
Could not open root, trying backup super


# ./btrfs-image /dev/loop3 diskid9.img
checksum verify failed on 16091506147328 found 1E4E4207 wanted 00000000
checksum verify failed on 16091506147328 found 1E4E4207 wanted 00000000
checksum verify failed on 16091506147328 found 58D16B1B wanted 64109AAB
checksum verify failed on 16091506147328 found 58D16B1B wanted 64109AAB
bytenr mismatch, want=16091506147328, have=3144945314663302585
ERROR: cannot read chunk root
ERROR: open ctree failed
ERROR: create failed: Success


# ./btrfs check --readonly /dev/loop3
checksum verify failed on 16091506147328 found 1E4E4207 wanted 00000000
checksum verify failed on 16091506147328 found 1E4E4207 wanted 00000000
checksum verify failed on 16091506147328 found 58D16B1B wanted 64109AAB
checksum verify failed on 16091506147328 found 58D16B1B wanted 64109AAB
bytenr mismatch, want=16091506147328, have=3144945314663302585
ERROR: cannot read chunk root
ERROR: cannot open file system

# ./btrfs-show-super -f -a /dev/loop[0-9]
http://xero.incoming.jp/btrfshelp/showsuper.txt
(148kB)

# ./btrfs rescue super-recover -v /dev/loop3
http://xero.incoming.jp/btrfshelp/rescue_super-recover.txt
(3kB)

"./btrfs rescue super-recover" says /dev/loop3 is bad.
But, I suppose /dev/loop3 is sole correct disk. Because the generation is old than another.
I guess perhaps this bad disk was rejected when I did "btrfs delete..." command.
That's why this disk's generation is being stop.
If so, If I could use this information, I wonder rescue files from the array??
But I have no idea about the method...

Thank you
Hiroshi Honda

