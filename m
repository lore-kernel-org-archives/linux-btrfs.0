Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:22144 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753950Ab3HXEYX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 Aug 2013 00:24:23 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:50004 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VD5Og-001o9B-GQ
	for linux-btrfs@vger.kernel.org; Fri, 23 Aug 2013 22:24:22 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: Help interpreting RAID1 space allocation
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <25d36b2410416c9a767766fb9be313b6@lixil.net>
Date: Fri, 23 Aug 2013 22:24:21 -0600
Message-Id: <C0968F38-8432-41C3-B916-DC00C5C69B34@colorremedies.com>
References: <25d36b2410416c9a767766fb9be313b6@lixil.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 23, 2013, at 6:05 PM, Joel Johnson <mrjoel@lixil.net> wrote:

> What is the expectation on hot-adding a failed drive, is an explicit 'device add' or 'replace' expected/required?

I'd expect to have to add a device and then remove missing. There isn't a readd option in btrfs, which in md parlance is used for readding a device previously part of an array. 

When replacing a failed disk, I'd like btrfs to compare states between the available drives and know that it needs to catch up the newly added device, but this doesn't yet happen. It's necessary to call btrfs balance.

However, after adding a device and deleting missing, I see what you see, the btrfs volume is still mounted degraded. 

Further, if I use:

# mount -o remount /dev/sdb /mnt
# mount | grep btrfs
/dev/sdc on /mnt type btrfs (rw,relatime,seclabel,degraded,space_cache)

So it's still degraded. I had to unmount and mount again to clear degraded. That seems to be a problem, to have to unmount the volume in order to remove the degraded flag, which is needed to begin the rebalance. And what if btrfs is the root file system? It needs to be rebooted to clear the degraded option.

And still further, somehow the data profile has reverted to single even though the mkfs.btfs was raid1. So even though the volume now has two devices, has been balanced, is not degraded, the data profile is single and presumably I no longer actually have mirrored data at all on this volume. That is a huge bug. I'll try to come up with some steps to reproduce.


Chris Murphy