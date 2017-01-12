Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from amphorawinery.eu ([138.201.173.239]:59458 "EHLO
        mail.amphorawinery.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750860AbdALJzX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jan 2017 04:55:23 -0500
Received: from _ (amphorawinery.eu [138.201.173.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: gregory@amphorawinery.eu)
        by mail.amphorawinery.eu (Postfix) with ESMTPSA id A47051E0467
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jan 2017 10:45:47 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Thu, 12 Jan 2017 10:45:47 +0100
From: Gregory Petit <gregory@amphorawinery.eu>
To: linux-btrfs@vger.kernel.org
Subject: RAID10: uncorrectable errors
Message-ID: <707f7f482dd48c08544574b71ab77299@amphorawinery.eu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm currently facing some uncorrectable errors in my RAID10 
configuration.

I'm running Proxmox (on debian) and my virtual machines are running on a 
btrfs RAID10 configuration. Before I was running RAID5 and had also 
uncorrectable errors. I found out then that RAID5 is not stable yet, so 
I reformatted the disks to RAID10.

Now, 2 days after formatting, I'm facing the same issue again. I don't 
use anything special like snapshots, the whole disk space is available 
for the VM's. All disks are about 1 year old and are SSD.

Here are the details:

scrub started at Wed Jan 11 18:00:01 2017 and finished after 00:19:23
total bytes scrubbed: 1.14TiB with 4 errors
error details: csum=4
corrected errors: 0, uncorrectable errors: 4, unverified errors: 0

 From dmesg:
Wed Jan 11 18:10:35 2017] BTRFS error (device sda): bdev /dev/sda errs: 
wr 0, rd 0, flush 0, corrupt 1, gen 0
[Wed Jan 11 18:10:35 2017] BTRFS error (device sda): unable to fixup 
(regular) error at logical 631657844736 on dev /dev/sda
[Wed Jan 11 18:10:51 2017] BTRFS error (device sda): bdev /dev/sdb errs: 
wr 0, rd 0, flush 0, corrupt 1, gen 0
[Wed Jan 11 18:10:51 2017] BTRFS error (device sda): unable to fixup 
(regular) error at logical 632954847232 on dev /dev/sdb
[Wed Jan 11 18:18:57 2017] BTRFS error (device sda): bdev /dev/sdc errs: 
wr 0, rd 0, flush 0, corrupt 1, gen 0
[Wed Jan 11 18:18:57 2017] BTRFS error (device sda): unable to fixup 
(regular) error at logical 632954847232 on dev /dev/sdc
[Wed Jan 11 18:19:19 2017] BTRFS error (device sda): bdev /dev/sde errs: 
wr 0, rd 0, flush 0, corrupt 1, gen 0
[Wed Jan 11 18:19:19 2017] BTRFS error (device sda): unable to fixup 
(regular) error at logical 631657844736 on dev /dev/sde

root@proxmox:~# uname -a
Linux proxmox 4.4.35-2-pve #1 SMP Mon Jan 9 10:21:44 CET 2017 x86_64 
GNU/Linux

root@proxmox:~# btrfs filesystem show /mnt/big_data/
Label: 'BIG_DATA'  uuid: 1d0c910a-648e-48fd-9c19-d344c2feb6e2
Total devices 4 FS bytes used 585.96GiB
devid    1 size 465.76GiB used 296.54GiB path /dev/sda
devid    2 size 465.76GiB used 296.54GiB path /dev/sdb
devid    3 size 465.76GiB used 296.54GiB path /dev/sdc
devid    4 size 465.76GiB used 296.54GiB path /dev/sde

root@proxmox:~# btrfs fi df /mnt/big_data/
Data, RAID10: total=590.00GiB, used=585.32GiB
System, RAID10: total=80.00MiB, used=80.00KiB
Metadata, RAID10: total=3.00GiB, used=658.00MiB
GlobalReserve, single: total=224.00MiB, used=0.00B

root@proxmox:~# btrfs check --repair /dev/sda
enabling repair mode
Checking filesystem on /dev/sda
UUID: 1d0c910a-648e-48fd-9c19-d344c2feb6e2
checking extents
Fixed 0 roots.
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
checking csums
checking root refs
found 629498146816 bytes used err is 0
total csum bytes: 613917644
total tree bytes: 691027968
total fs tree bytes: 25133056
total extent tree bytes: 27066368
btree space waste bytes: 24605870
file data blocks allocated: 4390718836736
  referenced 622326341632

root@proxmox:~# btrfs check --repair /dev/sdb
enabling repair mode
Checking filesystem on /dev/sdb
UUID: 1d0c910a-648e-48fd-9c19-d344c2feb6e2
checking extents
Fixed 0 roots.
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
checking csums
checking root refs
found 629498146816 bytes used err is 0
total csum bytes: 613917644
total tree bytes: 691027968
total fs tree bytes: 25133056
total extent tree bytes: 27066368
btree space waste bytes: 24605870
file data blocks allocated: 4390718836736
  referenced 622326341632

root@proxmox:~# btrfs check --repair /dev/sdc
enabling repair mode
Checking filesystem on /dev/sdc
UUID: 1d0c910a-648e-48fd-9c19-d344c2feb6e2
checking extents
Fixed 0 roots.
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
checking csums
checking root refs
found 629498146816 bytes used err is 0
total csum bytes: 613917644
total tree bytes: 691027968
total fs tree bytes: 25133056
total extent tree bytes: 27066368
btree space waste bytes: 24605870
file data blocks allocated: 4390718836736
  referenced 622326341632

root@proxmox:~# btrfs check --repair /dev/sde
enabling repair mode
Checking filesystem on /dev/sde
UUID: 1d0c910a-648e-48fd-9c19-d344c2feb6e2
checking extents
Fixed 0 roots.
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
checking csums
checking root refs
found 629498163200 bytes used err is 0
total csum bytes: 613917644
total tree bytes: 691044352
total fs tree bytes: 25133056
total extent tree bytes: 27082752
btree space waste bytes: 24622062
file data blocks allocated: 4390718836736
  referenced 622326341632

Scrub after the repair:
btrfs scrub status /mnt/big_data/
scrub status for 1d0c910a-648e-48fd-9c19-d344c2feb6e2
scrub started at Thu Jan 12 10:22:10 2017 and finished after 00:19:29
total bytes scrubbed: 1.14TiB with 4 errors
error details: csum=4
corrected errors: 0, uncorrectable errors: 4, unverified errors: 0

dmesg again:
[Thu Jan 12 10:21:46 2017] BTRFS: has skinny extents
[Thu Jan 12 10:21:46 2017] BTRFS info (device sda): bdev /dev/sda errs: 
wr 0, rd 0, flush 0, corrupt 1, gen 0
[Thu Jan 12 10:21:46 2017] BTRFS info (device sda): bdev /dev/sdb errs: 
wr 0, rd 0, flush 0, corrupt 1, gen 0
[Thu Jan 12 10:21:46 2017] BTRFS info (device sda): bdev /dev/sdc errs: 
wr 0, rd 0, flush 0, corrupt 1, gen 0
[Thu Jan 12 10:21:46 2017] BTRFS info (device sda): bdev /dev/sde errs: 
wr 0, rd 0, flush 0, corrupt 1, gen 0
[Thu Jan 12 10:21:46 2017] BTRFS: detected SSD devices, enabling SSD 
mode
[Thu Jan 12 10:21:46 2017] BTRFS: checking UUID tree
[Thu Jan 12 10:32:51 2017] BTRFS error (device sda): bdev /dev/sda errs: 
wr 0, rd 0, flush 0, corrupt 2, gen 0
[Thu Jan 12 10:32:51 2017] BTRFS error (device sda): unable to fixup 
(regular) error at logical 631657844736 on dev /dev/sda
[Thu Jan 12 10:33:05 2017] BTRFS error (device sda): bdev /dev/sdb errs: 
wr 0, rd 0, flush 0, corrupt 2, gen 0
[Thu Jan 12 10:33:05 2017] BTRFS error (device sda): unable to fixup 
(regular) error at logical 632954847232 on dev /dev/sdb
[Thu Jan 12 10:41:14 2017] BTRFS error (device sda): bdev /dev/sdc errs: 
wr 0, rd 0, flush 0, corrupt 2, gen 0
[Thu Jan 12 10:41:14 2017] BTRFS error (device sda): unable to fixup 
(regular) error at logical 632954847232 on dev /dev/sdc
[Thu Jan 12 10:41:36 2017] BTRFS error (device sda): bdev /dev/sde errs: 
wr 0, rd 0, flush 0, corrupt 2, gen 0
[Thu Jan 12 10:41:36 2017] BTRFS error (device sda): unable to fixup 
(regular) error at logical 631657844736 on dev /dev/sde

Does someone have an idea why those errors happen so fast? Since it is 
RAID 10 I would assume it repairs an error based on the mirror, but it 
seems to do the opposite and duplicate the error to the mirror.

Thanks a lot,

Gregory
