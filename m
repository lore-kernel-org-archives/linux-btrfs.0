Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay07.libero.it ([212.52.84.111]:46662 "EHLO
	outrelay07.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab3J2WDT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Oct 2013 18:03:19 -0400
Message-ID: <52702F49.5060306@inwind.it>
Date: Tue, 29 Oct 2013 22:57:29 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [patch 00/13] sysfs publishing patchset
References: <20131021211940.432195222@suse.com> <526FFDB2.3040301@gmail.com> <527019EF.5040608@suse.com>
In-Reply-To: <527019EF.5040608@suse.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jeff

On 2013-10-29 21:26, Jeff Mahoney wrote:
>> This for two reasons:
>> > 1) so it would be possible to show also the disks informations under a
>> > dev/ directory. It would be possible to handle the case that some disks
>> > are registered in btrfs but the related filesystems aren't mounted (like
>> > after a "btrfs dev scan" command)
>> >
>> > 2) it would help the browsing of the /sys/btrfs/ hierarchy: every
>> > directory under /sys/btrfs/fs/ represents a filesystem. With the current
>> > structure not all the directory under /sys/btrfs are related to a
>> > filesystem (like the features/ one, but I am sure that other directories
>> > sooner or later will appear)

> I'd like to define /sys/fs/btrfs/<fsid> as filesystem-specific and
> anything else as btrfs-wide. 

I fully agree. My idea was to put under btrfs/dev *only* the device
which are registered in BTRFS by "btrfs dev scan" and/or mount commands.

> This is what ext4 already does with the
> exception that they use block device names instead of fsids. Your device
> use case is interesting, but a tough one to implement well since it is a
> cache that can be wrong as soon as the user decides to mkfs a device
> (either as btrfs or anything else) without calling btrfs dev scan
> afterward. 

Right, I never though about this case.


> I wouldn't necessarily oppose such a feature; I just don't
> think it merits moving the primary case of per-filesystem information
> deeper into the hierarchy.

Fortunately the two thing are unrelated. The
/sys/fs/btrfs/dev/<device-uuid>/... hierarchy can live with
/sys/fs/btrfs/<fsid>/... or /sys/fs/btrfs/fs/<fsid>.



BTW, I am playing with your patch. What is the means of the field
<fsid>/allocation/*/disk_total ? In a RAID5 it seems to be the space
available ( == (<number-of-disk> - 1)*<size-of-chunk> ) and not the disk
space consumed ( == <number-of-disk> * <size-of-chunk> ). In fact it
seems that disk_total == total_bytes...

Ok looking at the kernel code (update_space_info() in extent-tree.c) it
seems that the info contained in space_info is bogus in case of
RAID5/RAID6....



-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
