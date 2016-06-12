Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mxout014.mail.hostpoint.ch ([217.26.49.174]:13604 "EHLO
	mxout014.mail.hostpoint.ch" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750856AbcFLKfS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jun 2016 06:35:18 -0400
Received: from [10.0.2.46] (helo=asmtp013.mail.hostpoint.ch)
	by mxout014.mail.hostpoint.ch with esmtp (Exim 4.84 (FreeBSD))
	(envelope-from <btrfs@bueechi.net>)
	id 1bC2jc-000D6o-46
	for linux-btrfs@vger.kernel.org; Sun, 12 Jun 2016 12:35:16 +0200
Received: from 217-162-125-82.dynamic.hispeed.ch ([217.162.125.82] helo=imac.lan)
	by asmtp013.mail.hostpoint.ch with esmtpa (Exim 4.84 (FreeBSD))
	(envelope-from <btrfs@bueechi.net>)
	id 1bC2jc-000Csr-2E
	for linux-btrfs@vger.kernel.org; Sun, 12 Jun 2016 12:35:16 +0200
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: Replacing drives with larger ones in a 4 drive raid1
From: boli <btrfs@bueechi.net>
In-Reply-To: <38F2FB04-0617-4DD3-9D48-ED3C4434003D@bueechi.net>
Date: Sun, 12 Jun 2016 12:35:16 +0200
Message-Id: <0AC846B3-C8B0-45FF-BCA9-F681811A23D7@bueechi.net>
References: <022F65B5-228D-4EEF-95C9-3C269B63B290@bueechi.net> <38F2FB04-0617-4DD3-9D48-ED3C4434003D@bueechi.net>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> It has now been doing "btrfs device delete missing /mnt" for about 90 hours.
> 
> These 90 hours seem like a rather long time, given that a rebalance/convert from 4-disk-raid5 to 4-disk-raid1 took about 20 hours months ago, and a scrub takes about 7 hours (4-disk-raid1).
> 
> OTOH the filesystem will be rather full with only 3 of 4 disks available, so I do expect it to take somewhat "longer than usual".
> 
> Would anyone venture a guess as to how long it might take?

It's done now, and took close to 99 hours to rebalance 8.1 TB of data from a 4x6TB raid1 (12 TB capacity) with 1 drive missing onto the remaining 3x6TB raid1 (9 TB capacity).

Now I made sure quotas were off, then started a screen to fill the new 8 TB disk with zeros, detached it and and checked iotop to get a rough estimate on how long it will take (I'm aware it will become slower in time).

After that I'll add this 8 TB disk to the btrfs raid1 (for yet another rebalance).

The next 3 disks will be replaced with "btrfs replace", so only one rebalance each is needed.

I assume each "btrfs replace" would do a full rebalance, and thus assign chunks according to the normal strategy of choosing the two drives with the most free space, which in this case would be a chunk to the new drive, and a mirrored chunk to that existing 3 drive with most free space.

What I'm wondering is this:
If the goal is to replace 4x 6TB drive (raid1) with 4x 8TB drive (still raid1), is there a way to remove one 6 TB drive at a time, recreate its exact contents from the other 3 drives onto a new 8 TB drive, without doing a full rebalance? That is: without writing any substantial amount of data onto the remaining 3 drives.

It seems to me that would be a lot more efficient, but it would go against the normal chunk assignment strategy.

Cheers, boli

