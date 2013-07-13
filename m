Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:39592 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750844Ab3GMU7n convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Jul 2013 16:59:43 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:57538 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1Uy6us-002hst-Oe
	for linux-btrfs@vger.kernel.org; Sat, 13 Jul 2013 14:59:42 -0600
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: mkfs.btrfs out of memory failure on lvm2 thinp volume
Message-Id: <14AE2C2A-6DC0-4DB6-97F4-6A661E3BF850@colorremedies.com>
Date: Sat, 13 Jul 2013 14:59:45 -0600
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

https://bugzilla.redhat.com/show_bug.cgi?id=984236

kernel-3.10.0-1.fc20.x86_64

Should it be possible to mkfs.btrfs on a virtual LV backed by LVM thinp? I can successfully create an XFS fs on the same virtual device. The virtual LV is 16TB in size, I haven't tried anything smaller yet to see if that's the problem. There is a dmesg attached to the bug report.

Just because it works with mkfs.xfs doesn't mean it's sane. The end goal is testing glusterfs in two VMs, each with two bricks. One VM will use XFS bricks and the other VM will use btrfs bricks. So it's not like I'm in any sort of real trouble. At the moment, this is all being done on baremetal, not within VMs (there are no VMs yet).


Chris Murphy