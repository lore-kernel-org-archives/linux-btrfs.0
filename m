Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f52.google.com ([74.125.83.52]:44650 "EHLO
        mail-pg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751232AbdJCUGg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Oct 2017 16:06:36 -0400
Received: by mail-pg0-f52.google.com with SMTP id b1so3810857pge.1
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Oct 2017 13:06:36 -0700 (PDT)
Received: from [192.168.0.8] (c-24-18-226-98.hsd1.wa.comcast.net. [24.18.226.98])
        by smtp.gmail.com with ESMTPSA id h10sm18202208pgq.86.2017.10.03.13.06.34
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Oct 2017 13:06:34 -0700 (PDT)
To: linux-btrfs@vger.kernel.org
From: Stephen Nesbitt <nesbittmeister@gmail.com>
Subject: Seeking Help on Corruption Issues
Message-ID: <c67167b4-190b-dfdc-33a8-8cb75a4744ef@gmail.com>
Date: Tue, 3 Oct 2017 13:06:50 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All:

I came back to my computer yesterday to find my filesystem in read only 
mode. Running a btrfs scrub start -dB aborts as follows:

btrfs scrub start -dB /mnt
ERROR: scrubbing /mnt failed for device id 4: ret=-1, errno=5 
(Input/output error)
ERROR: scrubbing /mnt failed for device id 5: ret=-1, errno=5 
(Input/output error)
scrub device /dev/sdb (id 4) canceled
     scrub started at Mon Oct  2 21:51:46 2017 and was aborted after 
00:09:02
     total bytes scrubbed: 75.58GiB with 1 errors
     error details: csum=1
     corrected errors: 0, uncorrectable errors: 1, unverified errors: 0
scrub device /dev/sdc (id 5) canceled
     scrub started at Mon Oct  2 21:51:46 2017 and was aborted after 
00:11:11
     total bytes scrubbed: 50.75GiB with 0 errors

The resulting dmesg is:
[  699.534066] BTRFS error (device sdc): bdev /dev/sdb errs: wr 0, rd 0, 
flush 0, corrupt 6, gen 0
[  699.703045] BTRFS error (device sdc): unable to fixup (regular) error 
at logical 1609808347136 on dev /dev/sdb
[  783.306525] BTRFS critical (device sdc): corrupt leaf, bad key order: 
block=2589782867968, root=1, slot=116
[  789.776132] BTRFS critical (device sdc): corrupt leaf, bad key order: 
block=2589782867968, root=1, slot=116
[  911.529842] BTRFS critical (device sdc): corrupt leaf, bad key order: 
block=2589782867968, root=1, slot=116
[  918.365225] BTRFS critical (device sdc): corrupt leaf, bad key order: 
block=2589782867968, root=1, slot=116

Running btrfs check /dev/sdc results in:
btrfs check /dev/sdc
Checking filesystem on /dev/sdc
UUID: 24b768c3-2141-44bf-ae93-1c3833c8c8e3
checking extents
bad key ordering 116 117
bad block 2589782867968
ERROR: errors found in extent allocation tree or chunk allocation
checking free space cache
There is no free space entry for 1623012450304-1623012663296
There is no free space entry for 1623012450304-1623225008128
cache appears valid but isn't 1622151266304
found 288815742976 bytes used err is -22
total csum bytes: 0
total tree bytes: 350781440
total fs tree bytes: 0
total extent tree bytes: 350027776
btree space waste bytes: 115829777
file data blocks allocated: 156499968

uname -a:
Linux sysresccd 4.9.24-std500-amd64 #2 SMP Sat Apr 22 17:14:43 UTC 2017 
x86_64 Intel(R) Core(TM) i5-6500 CPU @ 3.20GHz GenuineIntel GNU/Linux

btrfs --version: btrfs-progs v4.9.1

btrfs fi show:
Label: none  uuid: 24b768c3-2141-44bf-ae93-1c3833c8c8e3
     Total devices 2 FS bytes used 475.08GiB
     devid    4 size 931.51GiB used 612.06GiB path /dev/sdb
     devid    5 size 931.51GiB used 613.09GiB path /dev/sdc

btrfs fi df /mnt:
Data, RAID1: total=603.00GiB, used=468.03GiB
System, RAID1: total=64.00MiB, used=112.00KiB
System, single: total=32.00MiB, used=0.00B
Metadata, RAID1: total=9.00GiB, used=7.04GiB
Metadata, single: total=1.00GiB, used=0.00B
GlobalReserve, single: total=512.00MiB, used=0.00B

What is the recommended procedure at this point? Run btrfs check 
--repair? I have backups so losing a file or two isn't critical, but I 
really don't want to go through the effort of a bare metal reinstall.

In the process of researching this I did uncover a bad DIMM. Am I 
correct that the problems I'm seeing are likely linked to the resulting 
memory errors.

Thx in advance,

-steve

