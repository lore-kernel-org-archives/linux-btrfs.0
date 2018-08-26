Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from titan.nuclearwinter.com ([205.185.120.7]:48034 "EHLO
        titan.nuclearwinter.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbeH0A44 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 26 Aug 2018 20:56:56 -0400
Received: from [IPv6:2601:6c5:8000:6b90:54ff:ba2b:b29:792c] ([IPv6:2601:6c5:8000:6b90:54ff:ba2b:b29:792c])
        (authenticated bits=0)
        by titan.nuclearwinter.com (8.14.7/8.14.7) with ESMTP id w7QKjBXQ019928
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO)
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Aug 2018 16:45:13 -0400
To: linux-btrfs@vger.kernel.org
From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Scrub aborts due to corrupt leaf
Message-ID: <3af15796-2629-ef87-21c9-2bb3c1366732@nuclearwinter.com>
Date: Sun, 26 Aug 2018 16:45:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When I do a scrub it aborts about 10% of the way in due to:

corrupt leaf: root=7 block=7687860535296 slot=0, invalid key objectid 
for csum item, have 18446744073650847734 expect 18446744073709551606

The filesystem in question stores my backups and I have verified all of 
the backups so I know all files that are supposed to be there are there 
and their hashes match. Backups run normally and everything seems to 
work fine, it's just the scrub that doesn't.

I tried:

# btrfs check --repair /dev/Cached/Backups
enabling repair mode
Checking filesystem on /dev/Cached/Backups
UUID: acff5096-1128-4b24-a15e-4ba04261edc3
Fixed 0 roots.
checking extents
leaf free space ret -2002721201, leaf data size 16283, used 2002737484 
nritems 319
leaf free space ret -2002721201, leaf data size 16283, used 2002737484 
nritems 319
leaf free space incorrect 7687860535296 -2002721201
bad block 7687860535296
ERROR: errors found in extent allocation tree or chunk allocation
checking free space cache
block group 34028518375424 has wrong amount of free space
failed to load free space cache for block group 34028518375424
checking fs roots
root 5 inode 6784890 errors 1000, some csum missing
checking csums
there are no extents for csum range 6447630387207159216-6447630390115868080
csum exists for 6447630387207159216-6447630390115868080 but there is no 
extent record
there are no extents for csum range 763548178418734000-763548181428650928
csum exists for 763548178418734000-763548181428650928 but there is no 
extent record
there are no extents for csum range 
10574442573086800664-10574442573732416280
csum exists for 10574442573086800664-10574442573732416280 but there is 
no extent record
ERROR: errors found in csum tree
found 73238589853696 bytes used, error(s) found
total csum bytes: 8117840900
total tree bytes: 34106834944
total fs tree bytes: 23289413632
total extent tree bytes: 1659682816
btree space waste bytes: 6020692848
file data blocks allocated: 73136347418624
  referenced 73135917441024

Nothing changes because when I run the above command again the output is 
identical.

I had been using space_cache v2 but reverted to nospace_cache to run the 
above.

Is there any way to clean this up?

kernel 4.17.14-202.fc28.x86_64
btrfs-progs v4.15.1

Label: none  uuid: acff5096-1128-4b24-a15e-4ba04261edc3
         Total devices 1 FS bytes used 66.61TiB
         devid    1 size 72.77TiB used 68.03TiB path 
/dev/mapper/Cached-Backups

Data, single: total=67.80TiB, used=66.52TiB
System, DUP: total=40.00MiB, used=7.41MiB
Metadata, DUP: total=98.50GiB, used=95.21GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

BTRFS info (device dm-3): disk space caching is enabled
BTRFS info (device dm-3): has skinny extents
BTRFS info (device dm-3): bdev /dev/mapper/Cached-Backups errs: wr 0, rd 
0, flush 0, corrupt 666, gen 25
BTRFS info (device dm-3): enabling ssd optimizations
