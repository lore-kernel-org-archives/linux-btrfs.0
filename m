Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dnvrco-outbound-snat.email.rr.com ([107.14.73.229]:18443 "EHLO
	dnvrco-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753651AbcASLf2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jan 2016 06:35:28 -0500
Received: from ioko (router.asus.com [10.160.228.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: rian@thelig.ht)
	by email-server.localdomain (Postfix) with ESMTPSA id 646E3301ECF
	for <linux-btrfs@vger.kernel.org>; Tue, 19 Jan 2016 03:28:23 -0800 (PST)
Date: Tue, 19 Jan 2016 03:28:53 -0800 (PST)
From: Rian Hunter <rian@thelig.ht>
To: linux-btrfs@vger.kernel.org
Subject: FS corruption when mounting non-degraded after mounting degraded
Message-ID: <alpine.OSX.2.20.1601190308520.34954@ioko>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In my raid6 setup, a disk was soft-failing on me. I pulled the disk, 
inserted a new one, mounted degraded, then did btrfs-replace while 
running some RW jobs on the FS.

My jobs were taking too long. It seems like raid6 btrfs-replace without 
the source disk is not very fast. So I unmounted the FS, inserted the 
soft-failing disk again, remounted normally (non-degraded) and restarted 
the (now much faster) btrfs-replace.

I checked on the status sometime later and there were hundreds if not 
thousands of "transid verify failure" messages in my dmesg. 
Additionally the btrfs-replace operation had outright failed.

After removing the soft-failing disk, and mounting degraded again, it now 
seemed that some files in the FS were corrupted and in some instances 
accessing certain files would actually cause the kernel to loop 
indefinitely while eating up memory.

Nothing was corrupted before I mounted the soft-failing disk in 
non-degraded mode. This leads me to believe that btrfs doesn't 
intelligently handle remounting normally previously degraded arrays. Can 
anyone confirm this?

I would highly recommend some sort of fast failure or DWIM behavior for 
this, e.g.:

     $ mount -o degraded /dev/sda1 /mnt
     $ touch /mnt/newfile.txt
     $ unmount /mnt
     $ # plugin other device, e.g. /dev/sdb
     $ mount /dev/sda1 /mnt
     STDERR: Ignoring /dev/sdb1, FS has changed since mounting degraded
     without it.

Alternatively:

     STDERR: Cannot mount file system with device /dev/sdb1, FS has changed
     since mounting degraded without it.

Rian
