Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail14.tpgi.com.au ([203.12.160.182]:59609 "EHLO
	mail14.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbbBOEkv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Feb 2015 23:40:51 -0500
Received: from office.waterlogic.com.au (14-203-212-247.tpgi.com.au [14.203.212.247])
	by mail14.tpgi.com.au (envelope-from paul@pauljones.id.au) (8.14.3/8.14.3) with ESMTP id t1F4emOf004734
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 15 Feb 2015 15:40:49 +1100
From: Paul Jones <paul@pauljones.id.au>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: csum error shows wrong device
Date: Sun, 15 Feb 2015 04:40:45 +0000
Message-ID: <B7F2379062E32745A8651FBDB20F645940D1E934@Server.waterlogic.com.au>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a failing SSD I need to replace so I added another disk to my array, but didn't get around to removing the faulty one. A few days later I went to remove the faulty one and there were no more errors, I presume because the bad portion of the SSD was now not in use. Because I didn't know what disk to remove (2 are identical) I removed the new one in the hope to trigger the error with the old one so I could note it's serial number.
This was successful, but btrfs is claiming the error is on the disk that I removed. I presume this is a bug?
This is the command I used to remove the new disks:
btrfs dev del /dev/sda1 /dev/sdb1 /media/fast/

I note in dmesg there was no mention of /dev/sda1

'Fast' is the filesystem in question.

..
[46474.872519] BTRFS info (device sdb1): relocating block group 382315003904 flags 17
[46477.090985] BTRFS info (device sdb1): found 8 extents
[46479.747538] BTRFS info (device sdb1): found 8 extents
[46479.921532] BTRFS info (device sdb1): relocating block group 383388745728 flags 17
[46482.140193] BTRFS info (device sdb1): found 8 extents
[46484.880514] BTRFS info (device sdb1): found 8 extents
[46485.024671] BTRFS info (device sdb1): relocating block group 384462487552 flags 17
[46487.291166] BTRFS info (device sdb1): found 8 extents
[46490.073738] BTRFS info (device sdb1): found 8 extents
[46490.235649] BTRFS info (device sdb1): relocating block group 385536229376 flags 17
[46492.364366] BTRFS info (device sdb1): found 3903 extents
[46495.326886] BTRFS info (device sdb1): found 3902 extents
[46495.446426] BTRFS info (device sdb1): disk deleted /dev/sdb1
[59516.406169] BTRFS info (device sdb1): csum failed ino 40605 off 54317748224 csum 3288447127 expected csum 2629848265
[59516.406175] BTRFS info (device sdb1): csum failed ino 40605 off 54412632064 csum 4245055996 expected csum 3450832795
[59516.406359] BTRFS: read error corrected: ino 40605 off 54317748224 (dev /dev/sde1 sector 431254408)
[59516.406449] BTRFS: read error corrected: ino 40605 off 54412632064 (dev /dev/sde1 sector 431439728)
[59516.406548] BTRFS info (device sdb1): csum failed ino 40605 off 55994003456 csum 42039089 expected csum 2302529568
[59516.406727] BTRFS: read error corrected: ino 40605 off 55994003456 (dev /dev/sdf1 sector 434440280)
[59516.408562] BTRFS info (device sdb1): csum failed ino 40605 off 14022791168 csum 3859837505 expected csum 3337046449
[59516.408573] BTRFS info (device sdb1): csum failed ino 40605 off 55445471232 csum 1108896639 expected csum 3859837505
[59516.408683] BTRFS info (device sdb1): csum failed ino 40605 off 56895586304 csum 2469353283 expected csum 761457267
[59516.408691] BTRFS info (device sdb1): csum failed ino 40605 off 61744017408 csum 1385882588 expected csum 2439148438
[59516.408702] BTRFS info (device sdb1): csum failed ino 40605 off 63789928448 csum 3337046449 expected csum 2586270899
[59516.408717] BTRFS info (device sdb1): csum failed ino 40605 off 14022791168 csum 1108896639 expected csum 3337046449
[59516.408785] BTRFS info (device sdb1): csum failed ino 40605 off 55445471232 csum 3867769240 expected csum 3859837505
[59516.408894] BTRFS: read error corrected: ino 40605 off 56895586304 (dev /dev/sde1 sector 434192096)
[59516.409129] BTRFS: read error corrected: ino 40605 off 63789928448 (dev /dev/sde1 sector 574273160)
[59516.409230] BTRFS: read error corrected: ino 40605 off 61744017408 (dev /dev/sde1 sector 505265528)
[59516.417206] BTRFS: read error corrected: ino 40605 off 62792196096 (dev /dev/sdf1 sector 441426544)
[59516.417241] BTRFS: read error corrected: ino 40605 off 59971190784 (dev /dev/sdf1 sector 579309536)
[59517.423114] BTRFS: read error corrected: ino 40605 off 59917271040 (dev /dev/sde1 sector 505891968)
[59518.423088] BTRFS: read error corrected: ino 40605 off 22458654720 (dev /dev/sde1 sector 400486896)

Linux vm-server 3.19.0-gentoo #1 SMP PREEMPT Wed Feb 11 16:48:13 AEDT 2015 x86_64 Intel(R) Core(TM) i7-2600K CPU @ 3.40GHz GenuineIntel GNU/Linux

Label: 'Root'  uuid: 58d27dbd-7c1e-4ef7-8d43-e93df1537b08
        Total devices 3 FS bytes used 14.85GiB
        devid    3 size 40.00GiB used 33.03GiB path /dev/sdf3
        devid    4 size 40.00GiB used 33.03GiB path /dev/sde3
        devid    6 size 40.00GiB used 0.00B path /dev/sdb2

Label: 'Storage'  uuid: 63ec312b-5f7a-4137-a8f0-e877d5a85902
        Total devices 2 FS bytes used 1.07TiB
        devid    1 size 3.64TiB used 1.08TiB path /dev/sdd1
        devid    2 size 3.64TiB used 1.08TiB path /dev/sdj1

Label: 'Backup'  uuid: 8149e719-022b-4a7a-8465-704e24ba7898
        Total devices 4 FS bytes used 1.11TiB
        devid    1 size 2.73TiB used 1.12TiB path /dev/sdc1
        devid    2 size 931.51GiB used 567.00GiB path /dev/sdi1
        devid    3 size 931.51GiB used 569.03GiB path /dev/sdh1
        devid    4 size 2.73TiB used 7.00GiB path /dev/sdg1

Label: 'Fast'  uuid: e15bab07-1fcf-48b1-92d5-a2609f0fe469
        Total devices 2 FS bytes used 293.71GiB
        devid    1 size 407.12GiB used 295.03GiB path /dev/sde1
        devid    3 size 407.12GiB used 295.03GiB path /dev/sdf1

Btrfs v3.18.2
