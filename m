Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:55849 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbcEOKoO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 May 2016 06:44:14 -0400
Received: from localhost (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP id 278E134E893
	for <linux-btrfs@vger.kernel.org>; Sun, 15 May 2016 12:24:48 +0200 (CEST)
Received: from mailext.virtall.com ([127.0.0.1])
	by localhost (web1.virtall.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vC1E1f5a0mWN for <linux-btrfs@vger.kernel.org>;
	Sun, 15 May 2016 12:24:47 +0200 (CEST)
Received: from admin.virtall.com (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP
	for <linux-btrfs@vger.kernel.org>; Sun, 15 May 2016 12:24:47 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Sun, 15 May 2016 19:24:47 +0900
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: btrfs RAID-1 vs md RAID-1?
Message-ID: <83719f27dd5cdc406fd3fd24e7b82a9f@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm trying to read two large files in parallel from a 2-disk RAID-1 
btrfs setup (using kernel 4.5.3).

According to iostat, one of the disks is 100% saturated, while the other 
disk is around 0% busy.

Is it expected?

With two readers from the same disk, each file is being read with ~50 
MB/s from disk (with just one reader from disk, the speed goes up to 
around ~150 MB/s).


In md RAID, with many readers, it will try to distribute the reads - 
after md manual on http://linux.die.net/man/4/md:

     Raid1
     (...)
     Data is read from any one device. The driver attempts to distribute 
read requests across all devices
     to maximise performance.

     Raid5
     (...)
     This also allows more parallelism when reading, as read requests are 
distributed over all the devices
     in the array instead of all but one.


Are there any plans to improve this is btrfs?


Tomasz Chmielewski
http://wpkg.org

