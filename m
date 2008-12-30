From: Chris Mason <chris.mason@oracle.com>
Subject: Re: A bug with multiple devices?
Date: Tue, 30 Dec 2008 16:19:27 -0500
Message-ID: <1230671967.4229.3.camel@think.oraclecorp.com>
References: <49597D06.1050806@cn.fujitsu.com>
	 <200812302145.25796.chris@csamuel.org>
	 <200812302214.32650.chris@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200812302214.32650.chris@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-12-30 at 22:14 +1100, Chris Samuel wrote:
> On Tue, 30 Dec 2008 9:45:22 pm Chris Samuel wrote:
> 
> > mkfs.btrfs -m raid1 /dev/sda10 /dev/sda11
> 
> Even doing what appears to be the correct method of:
> 
> mkfs.btrfs -d raid1 -m raid1 /dev/sda10 /dev/sda11
> 
> doesn't give any love, mkfs.btrfs still tells me the filesystem will be 60GB 
> (and the kernel agrees when it is mounted).
> 
> But mkfs.btrfs does correctly set data_profile to include 
> BTRFS_BLOCK_GROUP_RAID1 and does indeed call create_one_raid_group() with 
> BTRFS_BLOCK_GROUP_DATA in create_raid_groups() in mkfs.c.

This is one of those things I've left for later.

Basically df tells you the total storage in the FS.  This storage might
be raid0, raid1 or single spindle duplication, so the usable space may
be different from the total storage.

In the future we'll have the data sent to df give better estimates of
usable space.

Changing btrfs-show to show the chunks too is a good idea.

-chris


