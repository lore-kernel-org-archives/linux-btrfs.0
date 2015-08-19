Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.trendhosting.net ([195.8.117.5]:39630 "EHLO
	mail1.trendhosting.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbbHSJCJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Aug 2015 05:02:09 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail1.trendhosting.net (Postfix) with ESMTP id B912F1511C
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Aug 2015 09:53:51 +0100 (BST)
Received: from mail1.trendhosting.net ([127.0.0.1])
	by localhost (thp003.trendhosting.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id u-jbpw4bEGK6 for <linux-btrfs@vger.kernel.org>;
	Wed, 19 Aug 2015 09:53:30 +0100 (BST)
Message-ID: <55D44409.40100@pocock.pro>
Date: Wed, 19 Aug 2015 10:53:29 +0200
From: Daniel Pocock <daniel@pocock.pro>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: disk failure but no alert
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



There are two large disks, part of the disks partitioned for MD RAID1
and the rest of the disks partitioned for BtrFs RAID1

One of the disks (/dev/sdd) appears to have failed, there were plenty of
alerts from MD (including dmesg and emails) but nothing from the BtrFs
filesystem

Could this just be a problem on a sector within the MD RAID1 partition
(/dev/sdd2) or is BtrFs failing to alert?  If there is a failure on
another partition on the same disk, should BtrFs be notified by the
kernel in some way and should it consider the filesystem to be at risk?

Should I do anything proactively to stop BtrFs using the /dev/sdd3
partition now?  Unfortunately it is not possible to get a new disk to
this server in the same day and it may just be shut down until the disk
can be replaced.

# uname -a
Linux - 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt11-1+deb8u3 (2015-08-04)
x86_64 GNU/Linux

# btrfs fi show /dev/sdd3
Label: none  uuid: -----------------------------
    Total devices 2 FS bytes used 1.74TiB
    devid    1 size 4.55TiB used 1.75TiB path /dev/sdd3
    devid    2 size 4.55TiB used 1.75TiB path /dev/sda3

Btrfs v3.17


Here is the dmesg output:

[996932.734999] sd 0:0:3:0: [sdd] 
[996932.735039] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[996932.735047] sd 0:0:3:0: [sdd] 
[996932.735053] Sense Key : Illegal Request [current]
[996932.735062] Info fld=0x80808
[996932.735069] sd 0:0:3:0: [sdd] 
[996932.735078] Add. Sense: Logical block address out of range
[996932.735085] sd 0:0:3:0: [sdd] CDB:
[996932.735089] Write(16): 8a 00 00 00 00 00 00 08 08 08 00 00 00 02 00 00
[996932.735110] end_request: critical target error, dev sdd, sector 526344
[996932.735280] md: super_written gets error=-121, uptodate=0
[996932.735290] md/raid1:md2: Disk failure on sdd2, disabling device.
md/raid1:md2: Operation continuing on 1 devices.
[996932.777853] RAID1 conf printout:
[996932.777917]  --- wd:1 rd:2
[996932.777925]  disk 0, wo:0, o:1, dev:sda2
[996932.777931]  disk 1, wo:1, o:0, dev:sdd2
[996932.794052] RAID1 conf printout:
[996932.794063]  --- wd:1 rd:2
[996932.794069]  disk 0, wo:0, o:1, dev:sda2


