Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:56844 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab3LSJ1B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Dec 2013 04:27:01 -0500
Received: by mail-pa0-f53.google.com with SMTP id hz1so916995pad.12
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Dec 2013 01:27:00 -0800 (PST)
Received: from [10.20.30.13] (c-67-160-236-141.hsd1.ca.comcast.net. [67.160.236.141])
        by mx.google.com with ESMTPSA id jn12sm5702774pbd.37.2013.12.19.01.26.58
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 19 Dec 2013 01:26:58 -0800 (PST)
Message-ID: <52B2BBE1.8090306@gmail.com>
Date: Thu, 19 Dec 2013 01:26:57 -0800
From: Chris Kastorff <encryptio@gmail.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Unmountable Array After Drive Failure During Device Deletion
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm using btrfs in data and metadata RAID10 on drives (not on md or any
other fanciness.)

I was removing a drive (btrfs dev del) and during that operation, a
different drive in the array failed. Having not had this happen before,
I shut down the machine immediately due to the extremely loud piezo
buzzer on the drive controller card. I attempted to do so cleanly, but
the buzzer cut through my patience and after 4 minutes I cut the power.

Afterwards, I located and removed the failed drive from the system, and
then got back to linux. The array no longer mounts ("failed to read the
system array on sdc"), with nearly identical messages when attempted
with -o recovery and -o recovery,ro.

btrfsck asserts and coredumps, as usual.

The drive that was being removed is devid 9 in the array, and is
/dev/sdm1 in the btrfs fi show seen below.

Kernel 3.12.4-1-ARCH, btrfs-progs v0.20-rc1-358-g194aa4a-dirty
(archlinux build.)

Can I recover the array?

== dmesg during failure ==

...
sd 0:2:3:0: [sdd] Unhandled error code
sd 0:2:3:0: [sdd]
Result: hostbyte=0x04 driverbyte=0x00
sd 0:2:3:0: [sdd] CDB:
cdb[0]=0x2a: 2a 00 26 89 5b 00 00 00 80 00
end_request: I/O error, dev sdd, sector 646535936
btrfs_dev_stat_print_on_error: 7791 callbacks suppressed
btrfs: bdev /dev/sdd errs: wr 315858, rd 230194, flush 0, corrupt 0, gen 0
sd 0:2:3:0: [sdd] Unhandled error code
sd 0:2:3:0: [sdd]
Result: hostbyte=0x04 driverbyte=0x00
sd 0:2:3:0: [sdd] CDB:
cdb[0]=0x2a: 2a 00 26 89 5b 80 00 00 80 00
end_request: I/O error, dev sdd, sector 646536064
...

== dmesg after new boot, mounting attempt ==

btrfs: device label lake devid 11 transid 4893967 /dev/sda
btrfs: disk space caching is enabled
btrfs: failed to read the system array on sdc
btrfs: open_ctree failed

== dmesg after new boot, mounting attempt with -o recovery,ro ==

btrfs: device label lake devid 11 transid 4893967 /dev/sda
btrfs: enabling auto recovery
btrfs: disk space caching is enabled
btrfs: failed to read the system array on sdc
btrfs: open_ctree failed

== btrfsck ==

deep# btrfsck /dev/sda
warning, device 14 is missing
warning devid 14 not found already
parent transid verify failed on 87601116364800 wanted 4893969 found 4893913
parent transid verify failed on 87601116364800 wanted 4893969 found 4893913
parent transid verify failed on 87601116381184 wanted 4893969 found 4893913
parent transid verify failed on 87601116381184 wanted 4893969 found 4893913
parent transid verify failed on 87601115320320 wanted 4893969 found 4893913
parent transid verify failed on 87601115320320 wanted 4893969 found 4893913
parent transid verify failed on 87601117097984 wanted 4893969 found 4892460
parent transid verify failed on 87601117097984 wanted 4893969 found 4892460
Ignoring transid failure
Checking filesystem on /dev/sda
UUID: d5e17c49-d980-4bde-bd96-3c8bc95ea077
checking extents
parent transid verify failed on 87601117159424 wanted 4893969 found 4893913
parent transid verify failed on 87601117159424 wanted 4893969 found 4893913
parent transid verify failed on 87601116368896 wanted 4893969 found 4893913
parent transid verify failed on 87601116368896 wanted 4893969 found 4893913
parent transid verify failed on 87601117163520 wanted 4893969 found 4893913
parent transid verify failed on 87601117163520 wanted 4893969 found 4893913
parent transid verify failed on 87601117638656 wanted 4893969 found 4893913
parent transid verify failed on 87601117638656 wanted 4893969 found 4893913
Ignoring transid failure
parent transid verify failed on 87601117171712 wanted 4893969 found 4893913
parent transid verify failed on 87601117171712 wanted 4893969 found 4893913
parent transid verify failed on 87601117175808 wanted 4893969 found 4893913
parent transid verify failed on 87601117175808 wanted 4893969 found 4893913
parent transid verify failed on 87601117188096 wanted 4893969 found 4893913
parent transid verify failed on 87601117188096 wanted 4893969 found 4893913
parent transid verify failed on 87601116807168 wanted 4893969 found 4893913
parent transid verify failed on 87601116807168 wanted 4893969 found 4893913
Ignoring transid failure
parent transid verify failed on 87601117642752 wanted 4893969 found 4893913
parent transid verify failed on 87601117642752 wanted 4893969 found 4893913
Ignoring transid failure
parent transid verify failed on 87601117650944 wanted 4893969 found 4893913
parent transid verify failed on 87601117650944 wanted 4893969 found 4893913
Ignoring transid failure
Couldn't map the block 5764607523034234880
btrfsck: volumes.c:1019: btrfs_num_copies: Assertion `!(!ce)' failed.
zsh: abort (core dumped)  btrfsck /dev/sda

== btrfs fi show ==

Label: 'lake'  uuid: d5e17c49-d980-4bde-bd96-3c8bc95ea077
        Total devices 10 FS bytes used 7.43TB
        devid    9 size 1.82TB used 1.61TB path /dev/sdm1
        devid   12 size 1.82TB used 1.47TB path /dev/sdb
        devid   16 size 1.82TB used 1.47TB path /dev/sde
        devid   13 size 1.82TB used 1.47TB path /dev/sdc
        devid   11 size 1.82TB used 1.47TB path /dev/sda
        devid   19 size 1.82TB used 1.47TB path /dev/sdk
        devid   17 size 1.82TB used 1.47TB path /dev/sdf
        devid   18 size 1.82TB used 1.47TB path /dev/sdg
        devid   15 size 1.82TB used 1.47TB path /dev/sdd
        *** Some devices missing
