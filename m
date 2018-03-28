Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:41299 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752759AbeC1B4q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 21:56:46 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 1C1D3AC010B
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Mar 2018 10:56:38 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: error report: misc-test 006 sometimes fails in current devel branch
To: linux-btrfs <linux-btrfs@vger.kernel.org>, <dsterba@suse.com>
Message-ID: <cfacefc4-3bd0-8e27-3c51-d681502da6ae@jp.fujitsu.com>
Date: Wed, 28 Mar 2018 10:55:56 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

current devel branch of btrfs-progs (github) occasionally fails at misc-test 006:
(kernel is 4.16.0-rc7)

======
$ sudo make test-misc TEST=006\*
    [LD]     fssum
    [TEST]   misc-tests.sh
    [TEST/misc]   006-image-on-missing-device
/usr/data/src/btrfs-progs/tests//common: line 177: 10819 Aborted
                 (core dumped) $INSTRUMENT "$@" >> "$RESULTS" 2>&1
mayfail: returned code 134 (SIGABRT), not ignored
test failed for case 006-image-on-missing-device
make: *** [Makefile:329: test-misc] Error 1
======

git bisect points the commit fa754dddc204 "btrfs-progs: mkfs: precreate the uuid tree"
and after reverting this, it seems that the test always runs correctly.

Full log of misc-tests-resut.txt when the test fails is below:
----------
=== Entering /usr/data/src/btrfs-progs/tests//misc-tests/006-image-on-missing-device
############### losetup --find --show img1
/dev/loop0
############### losetup --find --show img2
/dev/loop1
############### /usr/data/src/btrfs-progs/mkfs.btrfs -f -d raid1 -m raid1 /dev/loop0 /dev/loop1
btrfs-progs v4.15.1
See http://btrfs.wiki.kernel.org for more information.

Performing full device TRIM /dev/loop0 (2.00GiB) ...
Performing full device TRIM /dev/loop1 (2.00GiB) ...
Label:              (null)
UUID:               220272d0-2454-429c-a198-83eaf954aceb
Node size:          16384
Sector size:        4096
Filesystem size:    4.00GiB
Block group profiles:
  Data:             RAID1           204.75MiB
  Metadata:         RAID1           204.75MiB
  System:           RAID1             8.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata
Number of devices:  2
Devices:
   ID        SIZE  PATH
    1     2.00GiB  /dev/loop0
    2     2.00GiB  /dev/loop1

############### mount /dev/loop0 /usr/data/src/btrfs-progs/tests//mnt
############### dd if=/dev/zero of=/usr/data/src/btrfs-progs/tests//mnt/a bs=1M count=10
10+0 records in
10+0 records out
10485760 bytes (10 MB, 10 MiB) copied, 0.00643606 s, 1.6 GB/s
############### dd if=/dev/zero of=/usr/data/src/btrfs-progs/tests//mnt/b bs=4k count=1000 conv=sync
1000+0 records in
1000+0 records out
4096000 bytes (4.1 MB, 3.9 MiB) copied, 0.0056388 s, 726 MB/s
############### umount /usr/data/src/btrfs-progs/tests//mnt
############### /usr/data/src/btrfs-progs/btrfs check /dev/loop0
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
Checking filesystem on /dev/loop0
UUID: 220272d0-2454-429c-a198-83eaf954aceb
found 14843904 bytes used, no error found
total csum bytes: 14240
total tree bytes: 131072
total fs tree bytes: 32768
total extent tree bytes: 16384
btree space waste bytes: 108171
file data blocks allocated: 14712832
 referenced 14712832
############### /usr/data/src/btrfs-progs/btrfs-image /dev/loop0 /tmp/test-img.dump
############### /usr/data/src/btrfs-progs/btrfs filesystem show /dev/loop0
Label: none  uuid: 220272d0-2454-429c-a198-83eaf954aceb
        Total devices 2 FS bytes used 14.16MiB
        devid    1 size 2.00GiB used 417.50MiB path /dev/loop0
        devid    2 size 2.00GiB used 417.50MiB path /dev/loop1

############### wipefs -a /dev/loop1
/dev/loop1: 8 bytes were erased at offset 0x00010040 (btrfs): 5f 42 48 52 66 53 5f 4d
############### losetup -d /dev/loop1
############### /usr/data/src/btrfs-progs/btrfs filesystem show /dev/loop0
warning, device 2 is missing
Label: none  uuid: 220272d0-2454-429c-a198-83eaf954aceb
        Total devices 2 FS bytes used 14.16MiB
        devid    1 size 2.00GiB used 417.50MiB path /dev/loop0
        *** Some devices missing

############### /usr/data/src/btrfs-progs/btrfs check /dev/loop0
checking extents
checking free space cache
failed to load free space cache for block group 30408704
failed to load free space cache for block group 245104640
checking fs roots
checking csums
checking root refs
warning, device 2 is missing
Checking filesystem on /dev/loop0
UUID: 220272d0-2454-429c-a198-83eaf954aceb
found 14843904 bytes used, no error found
total csum bytes: 14240
total tree bytes: 131072
total fs tree bytes: 32768
total extent tree bytes: 16384
btree space waste bytes: 108171
file data blocks allocated: 14712832
 referenced 14712832
############### /usr/data/src/btrfs-progs/btrfs-image /dev/loop0 /tmp/test-img.dump
Couldn't map the block 459800576
free(): invalid pointer
failed (ignored, ret=134): /usr/data/src/btrfs-progs/btrfs-image /dev/loop0 /tmp/test-img.dump
mayfail: returned code 134 (SIGABRT), not ignored
test failed for case 006-image-on-missing-device
----------

So, the last btrfs-image failed.
Also, it seems that even when the test succeeds, the last btrfs-image actually fails:
----------
############### /usr/data/src/btrfs-progs/btrfs-image /dev/loop0 /tmp/test-img.dump
Couldn't map the block 459800576
ERROR: failed to flush pending data: -5
ERROR: create failed: Bad address
warning, device 2 is missing
failed (ignored, ret=1): /usr/data/src/btrfs-progs/btrfs-image /dev/loop0 /tmp/test-img.dump
----------
The test uses may_fail and the test succeeds.


However, when v.4.15.1 is used (or reverting the commit), last btrfs-image does not fail:
----------
############### /usr/data/src/btrfs-progs/btrfs-image /dev/loop0 /tmp/test-img.dump
warning, device 2 is missing
----------


Regards,
Tomohiro Misono

