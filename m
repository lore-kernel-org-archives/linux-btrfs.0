Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:2025 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754678Ab3HXE6T convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 Aug 2013 00:58:19 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:50017 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VD5vU-001x7K-Re
	for linux-btrfs@vger.kernel.org; Fri, 23 Aug 2013 22:58:16 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: Help interpreting RAID1 space allocation
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <C0968F38-8432-41C3-B916-DC00C5C69B34@colorremedies.com>
Date: Fri, 23 Aug 2013 22:58:14 -0600
Message-Id: <27E06913-DDBB-4B75-86D3-A8F6C5B09F99@colorremedies.com>
References: <25d36b2410416c9a767766fb9be313b6@lixil.net> <C0968F38-8432-41C3-B916-DC00C5C69B34@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 23, 2013, at 10:24 PM, Chris Murphy <lists@colorremedies.com> wrote:
> 
> When replacing a failed disk, I'd like btrfs to compare states between the available drives and know that it needs to catch up the newly added device, but this doesn't yet happen. It's necessary to call btrfs balance.

I can only test device replacement, not a readd. Upon 'btrfs device delete missing /mnt' there's a delay, and it's doing a balance. I don't know what happens for a readd, if the whole volume needs balancing or if it's able to just write the changes.

> And still further, somehow the data profile has reverted to single even though the mkfs.btfs was raid1. [SNIP] That is a huge bug. I'll try to come up with some steps to reproduce.

If I create the file system, mount it, but I do not copy any data, upon adding new and deleting missing, the data profile is changed from raid1 to single. If I've first copied data to the volume prior to device failure/missing, this doesn't happen, it remains raid1.

Also, again after the missing device is replaced, and the volume rebalanced, while the mount option is degraded, subsequent file copies end up on both virtual disks. So it says it's degraded but it really isn't? I'm not sure what's up here.


Chris Murphy