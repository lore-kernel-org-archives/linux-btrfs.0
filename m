Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49541 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753380AbdJHJ6L (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 8 Oct 2017 05:58:11 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 1066E20E5F
        for <linux-btrfs@vger.kernel.org>; Sun,  8 Oct 2017 05:58:11 -0400 (EDT)
Message-Id: <1507456690.745489.1131538472.25270157@webmail.messagingengine.com>
From: Kai Hendry <hendry@iki.fi>
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Date: Sun, 08 Oct 2017 17:58:10 +0800
Subject: USB upgrade fun
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

My /mnt/raid1 suddenly became full somewhat expectedly, so I bought 2
new USB 4TB hard drives (one WD, one Seagate) to upgrade to.

After adding sde and sdd I started to see errors in dmesg [2].
https://s.natalian.org/2017-10-07/raid1-newdisks.txt
[2] https://s.natalian.org/2017-10-07/btrfs-errors.txt


I assumed it had to perhaps with the USB bus on my NUC5CPYB being maxed
out, and to expedite the sync, I tried to remove one of the older 2TB
sdc1.  However the load went crazy and my system went completely
unstable. I shutdown the machine and after an hour I hard powered it
down since it seemed to hang (it's headless).

Sidenote: I've since learnt that removing a drive actually deletes the
contents of the drive? I don't want that. I was hoping to put that drive
into cold storage. How do I remove a drive without losing data from a
RAID1 configuration?


After a reboot it failed, namely because "nofail" wasn't in my fstab and
systemd is pedantic by default. After managing to get it booting into my
system without /mnt/raid1 I faced these "open ctree failed" issues. 
After running btrfs check on all the drives and getting nowhere, I
decided to unplug the new drives and I discovered that when I take out
the new 4TB WD drive, I could mount it with -o degraded.

dmesg errors with the WD include "My Passport" Wrong diagnostic page;
asked for 1 got 8 "Failed to get diagnostic page 0xffffffea" which
raised my suspicions. The model number btw is WDBYFT0040BYI-WESN

Anyway, I'm back up and running with 2x2TB  (one of them didn't finish
removing, I don't know which) & 1x4TB.

[1] https://s.natalian.org/2017-10-08/usb-btrfs.txt

I've decided to send the WD back for a refund. I've decided I want keep
the 2x2TB and RAID1 with the new 1x4TB disk. So 4TB total. btrfs
complains now of "Some devices missing" [1]. How do I fix this
situation?

Any tips how to name this individual disks? hdparm -I isn't a lot to go
on.

[hendry@nuc ~]$ sudo hdparm -I /dev/sdb1 | grep Model
        Model Number:       ST4000LM024-2AN17V
[hendry@nuc ~]$ sudo hdparm -I /dev/sdc1 | grep Model
        Model Number:       ST2000LM003 HN-M201RAD
[hendry@nuc ~]$ sudo hdparm -I /dev/sdd1 | grep Model
        Model Number:       ST2000LM005 HN-M201AAD


Ok, thanks. Hope you can guide me,
