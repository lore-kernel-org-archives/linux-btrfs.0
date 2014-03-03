Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zixgateway01.papersolve.com ([71.125.1.135]:2851 "EHLO
	sw-email.stardatecomputer.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751743AbaCCR32 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Mar 2014 12:29:28 -0500
Received: from sw-email.stardatecomputer.com (127.0.0.1) id h2itvg0171s8 for <linux-btrfs@vger.kernel.org>; Mon, 3 Mar 2014 12:23:44 -0500 (envelope-from <mike@PaperSolve.com>)
From: Mike Russo <mike@PaperSolve.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: ENOSPC errors during raid1 rebalance
Date: Mon, 3 Mar 2014 17:23:43 +0000
Message-ID: <DF16C10AFF7F394A8C8A09C9405478890BCBE534@EXHOST.stardatecomputer.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi guys -
I'm trying to convert a disk from single (/dev/sdc1) to RAID1 (dev/sdd1), and the filesystem was previously ext4 but the conversion seemed to go just fine, and I have no snapshots. System and metadata convert, and almost all my data converts, but there are 70 stubborn GB (14 blocks of 5GB each) that refuse to convert and I get ENOSPC errors when trying to reallocate them.

Here's my vital stats: (on kernel 3.14-rc4):

root@ossy:/usr/src/btrfs-progs# /usr/src/btrfs-progs/btrfs fi show
Label: MyBook  uuid: c99cbefb-6a56-41e2-8f99-19f8b5f67884
        Total devices 2 FS bytes used 1.09TiB
        devid    1 size 1.82TiB used 1.12TiB path /dev/sdc1
        devid    2 size 1.82TiB used 1.05TiB path /dev/sdd1

Btrfs v3.12
root@ossy:/usr/src/btrfs-progs# /usr/src/btrfs-progs/btrfs fi df /mymedia
Data, RAID1: total=1.04TiB, used=1.03TiB
Data, single: total=70.00GiB, used=64.98GiB
System, RAID1: total=32.00MiB, used=160.00KiB
Metadata, RAID1: total=2.00GiB, used=1.33GiB


I've already done a -dusage=0 and -dusage=5 balance and that cleans up anything that gets left around when these 14 blocks fail get moved.    When mounting with enospc_debug I get messages like this for each block with the problem:


Mar  3 11:58:16 ossy kernel: [52724.423024] BTRFS: block group 935262683136 has 5368709120 bytes, 5321801728 used 0 pinned 0 reserved [readonly]
Mar  3 11:58:16 ossy kernel: [52724.423025] BTRFS info (device sdd1): block group has cluster?: no
Mar  3 11:58:16 ossy kernel: [52724.423026] BTRFS info (device sdd1): 0 blocks of free space at or bigger than bytes is
Mar  3 11:58:16 ossy kernel: [52724.423027] BTRFS: block group 942778875904 has 5368709120 bytes, 5309296640 used 0 pinned 0 reserved [readonly]
Mar  3 11:58:16 ossy kernel: [52724.423028] BTRFS info (device sdd1): block group has cluster?: no
Mar  3 11:58:16 ossy kernel: [52724.423029] BTRFS info (device sdd1): 0 blocks of free space at or bigger than bytes is

I don't have the space to reformat and if this is a genuine bug I'm sure you guys want to fix it too. What else can I do to resolve or help? 


Sincerely,

Michael Russo, Systems Engineer
PaperSolve, Inc.
268 Watchogue Road
Staten Island, NY 10314

