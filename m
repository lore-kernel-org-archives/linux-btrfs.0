Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:56500 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754553AbdJQUnV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Oct 2017 16:43:21 -0400
Received: by mail-pf0-f179.google.com with SMTP id b85so2192835pfj.13
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Oct 2017 13:43:20 -0700 (PDT)
Received: from [192.168.0.200] ([67.159.144.49])
        by smtp.gmail.com with ESMTPSA id b27sm20109191pfc.110.2017.10.17.13.43.18
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Oct 2017 13:43:19 -0700 (PDT)
From: Cameron Kelley <cameronkelley28@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Mount failing - unable to find logical
Message-ID: <8aa155ab-4722-9448-0f9e-b383f37d7973@gmail.com>
Date: Tue, 17 Oct 2017 13:43:18 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey btrfs gurus,

I have a 4 disk btrfs filesystem that has suddenly stopped mounting after a recent reboot. The data is in an odd configuration due to originally being in a 3 disk RAID1 before adding a 4th disk and running a balance to convert to RAID10. There wasn't enough free space to completely convert, so about half the data is still in RAID1 while the other half is in RAID10. Both metadata and system are RAID10. It has been in this configuration for 6 months or so now since adding the 4th disk. It just holds archived media and hasn't had any data added or modified in quite some time. I feel pretty stupid now for not correcting that sooner though.

I have tried mounting with different mount options for recovery, ro, degraded, etc. Log shows errors about "unable to find logical 3746892939264 length 4096"

When I do a btrfs check, it doesn't find any issues. Running btrfs-find-root comes up with a message about a block that the generation doesn't match. If I specify that block on the btrfs check, I get transid verify failures.

I ran a dry run of a recovery of the entire filesystem which runs through every file with no errors. I would just restore the data and start fresh, but unfortunately I don't have the free space at the moment for the ~4.5TB of data.

I also ran full smart self tests on all 4 disks with no errors.

root@nas2:~# uname -a
Linux nas2 4.13.7-041307-generic #201710141430 SMP Sat Oct 14 14:39:06 UTC 2017 i686 i686 i686 GNU/Linux

root@nas2:~# btrfs version
btrfs-progs v4.13.2

root@nas2:~# btrfs fi show
Label: none  uuid: 827029a4-8625-4a50-a22d-0fd28dbe2d36
         Total devices 4 FS bytes used 4.60TiB
         devid    1 size 2.73TiB used 2.33TiB path /dev/sdb1
         devid    2 size 2.73TiB used 2.33TiB path /dev/sdc
         devid    3 size 2.73TiB used 2.33TiB path /dev/sdd1
         devid    4 size 2.73TiB used 2.33TiB path /dev/sde1

root@nas2:~# mount /dev/sdb1 /mnt/nas2/
mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
        missing codepage or helper program, or other error

        In some cases useful info is found in syslog - try
        dmesg | tail or so.

root@nas2:~# dmesg | tail
[  801.332623] BTRFS info (device sdb1): disk space caching is enabled
[  801.332627] BTRFS info (device sdb1): has skinny extents
[  801.333386] BTRFS critical (device sdb1): unable to find logical 3746892939264 length 4096
[  801.333472] BTRFS critical (device sdb1): unable to find logical 3746892939264 length 4096
[  801.333769] BTRFS critical (device sdb1): unable to find logical 3746892939264 length 4096
[  801.333835] BTRFS critical (device sdb1): unable to find logical 3746892939264 length 4096
[  801.333909] BTRFS critical (device sdb1): unable to find logical 3746892939264 length 4096
[  801.333968] BTRFS critical (device sdb1): unable to find logical 3746892939264 length 4096
[  801.334028] BTRFS error (device sdb1): failed to read chunk root
[  801.365452] BTRFS error (device sdb1): open_ctree failed

root@nas2:~# btrfs check /dev/sdb1
Checking filesystem on /dev/sdb1
UUID: 827029a4-8625-4a50-a22d-0fd28dbe2d36
checking extents
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
checking csums
checking root refs
found 5054297628672 bytes used, no error found
total csum bytes: 4929567064
total tree bytes: 5197856768
total fs tree bytes: 15237120
total extent tree bytes: 43433984
btree space waste bytes: 161510789
file data blocks allocated: 5050024812544
  referenced 5049610178560

root@nas2:~# btrfs-find-root /dev/sdb1
Superblock thinks the generation is 147970
Superblock thinks the level is 1
Found tree root at 21335861559296 gen 147970 level 1
Well block 21335857758208(gen: 147969 level: 1) seems good, but generation/level doesn't match, want gen: 147970 level: 1

root@nas2:~# btrfs check -r 21335857758208 /dev/sdb1
parent transid verify failed on 21335857758208 wanted 147970 found 147969
parent transid verify failed on 21335857758208 wanted 147970 found 147969
parent transid verify failed on 21335857758208 wanted 147970 found 147969
parent transid verify failed on 21335857758208 wanted 147970 found 147969
Ignoring transid failure
Checking filesystem on /dev/sdb1
UUID: 827029a4-8625-4a50-a22d-0fd28dbe2d36
checking extents
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
checking csums
checking root refs
ERROR: transid errors in file system
found 5054297628672 bytes used, error(s) found
total csum bytes: 4929567064
total tree bytes: 5197856768
total fs tree bytes: 15237120
total extent tree bytes: 43433984
btree space waste bytes: 161510789
file data blocks allocated: 5050024812544
  referenced 5049610178560
