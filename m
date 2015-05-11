Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38579 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbbEKKOA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 06:14:00 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Yrkik-000730-HO
	for linux-btrfs@vger.kernel.org; Mon, 11 May 2015 12:13:59 +0200
Received: from 168.159.160.57 ([168.159.160.57])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2015 12:13:58 +0200
Received: from toyours_sridhar by 168.159.160.57 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2015 12:13:58 +0200
To: linux-btrfs@vger.kernel.org
From: sri <toyours_sridhar@yahoo.co.in>
Subject: feature like mirror split kind of functionality to btrfs
Date: Mon, 11 May 2015 10:13:52 +0000 (UTC)
Message-ID: <loom.20150511T120703-840@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs can able to handle disk (LVM functionality) and it offers adding new 
disks and delete disks of existing btrfs file system.

I would like to know functionality like below.

say i have 2 disks  (1 and 2) and btrfs created on top of it.

Now I will add 2 more disks (3 and 4) and say RAID1 to existing 2 disks 
while adding to existing btrfs file system.

Then I run sync kind of functionality which replicates data of 1$2 on 3$4.

Once sync is complete, I will ask btrfs to split 3&4 from it.

End of this I will have 3$4 disks as separate copy of existing btrfs. If 
there is a failure I use 3$4 as backed up disks which I can mount on same 
machine during disaster recovery or mount on other machine (assume disks 
are SCSI LUNS from array) and bring the file system back.

Would like to know such functionality exists currently or any plans of 
doing it.

Thanks in advance.

