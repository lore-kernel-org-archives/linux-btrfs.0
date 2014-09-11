Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:56856 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbaIKPWU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Sep 2014 11:22:20 -0400
Received: from mailext.virtall.com (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP id C499540B322
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Sep 2014 17:22:15 +0200 (CEST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: how long should "btrfs device delete missing ..."  =?UTF-8?Q?take=3F?=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Thu, 11 Sep 2014 17:22:15 +0200
From: Tomasz Chmielewski <tch@virtall.com>
Message-ID: <84a98bc5f667c04ca74ff77b56f537d9@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After a disk died and was replaced, "btrfs device delete missing" is 
taking more than 10 days on an otherwise idle server:

# btrfs fi show /home
Label: none  uuid: 84d087aa-3a32-46da-844f-a233237cf04f
         Total devices 3 FS bytes used 362.44GiB
         devid    2 size 1.71TiB used 365.03GiB path /dev/sdb4
         devid    3 size 1.71TiB used 58.00GiB path /dev/sda4
         *** Some devices missing

Btrfs v3.16



So far, it has copied 58 GB out of 365 GB - and it took 10 days. At this 
speed, the whole operation will take 2-3 months (assuming that the only 
healthy disk doesn't die in the meantime).
Is this expected time for btrfs RAID-1?

There are no errors in dmesg/smart, performance of both disks is fine:

# hdparm -t /dev/sda /dev/sdb

/dev/sda:
  Timing buffered disk reads: 442 MB in  3.01 seconds = 146.99 MB/sec

/dev/sdb:
  Timing buffered disk reads: 402 MB in  3.39 seconds = 118.47 MB/sec


# btrfs fi df /home
Data, RAID1: total=352.00GiB, used=351.02GiB
System, RAID1: total=32.00MiB, used=96.00KiB
Metadata, RAID1: total=13.00GiB, used=11.38GiB
unknown, single: total=512.00MiB, used=67.05MiB

# btrfs sub list /home | wc -l
260

# uptime
  17:21:53 up 10 days,  6:01,  2 users,  load average: 3.22, 3.53, 3.55


I've tried running this on the latest 3.16.x kernel earlier, but since 
the progress was so slow, rebooted after about a week to see if the 
latest RC will be any faster.


-- 
Tomasz Chmielewski
http://www.sslrack.com



