Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:59342 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbaEPPsW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 May 2014 11:48:22 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id B1C27426574
	for <linux-btrfs@vger.kernel.org>; Fri, 16 May 2014 17:48:19 +0200 (CEST)
Received: from s9 (unknown [88.214.166.36])
	by mail.virtall.com (Postfix) with ESMTPSA id 3C7D1426203
	for <linux-btrfs@vger.kernel.org>; Fri, 16 May 2014 17:48:19 +0200 (CEST)
Date: Fri, 16 May 2014 16:48:15 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RAID-1 - suboptimal write performance?
Message-ID: <20140516164815.1c33149b@s9>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While doing rsyncs of large archives from one RAID-1 btrfs filesystem
to another RAID-1 btrfs filesystem:

btrfs filesystem 1: sda + sdb (RAID-1), being copied to:
btrfs filesystem 2: sdc + sdd (RAID-1)
Server has 32 GB RAM


I can observe the following:


>From time to time, rsync "freezes", while there is high IO on only *one*
of write drives.


To reproduce:

dd if=/dev/urandom of=/mnt/btrfs1/bigfile.img bs=1M count=10000; sync
# cp should work, too, but won't show copy speed/progress
rsync -a -v --progress /mnt/btrfs1/bigfile.img /mnt/btrfs2/

In another terminal, run iostat -m 1:

1) a few seconds of writes to only one RAID-1 member:

Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
sdc             355.00         0.00       177.50          0        177
sdb               0.00         0.00         0.00          0          0
sdd               0.00         0.00         0.00          0          0
sda               0.00         0.00         0.00          0          0


2) then, a few seconds of writes to the other RAID-1 member:

Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
sdc               0.00         0.00         0.00          0          0
sdb               0.00         0.00         0.00          0          0
sdd             351.00         0.00       175.50          0        175
sda               0.00         0.00         0.00          0          0


Is it optimal behaviour? With software RAID-1, I'm seeing writes to
both devices at the same time.

Also, what happens when the system crashes, and one drive has several
hundred megabytes data more than the other one?

-- 
Tomasz Chmielewski
http://wpkg.org
