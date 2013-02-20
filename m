Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19561 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab3BTBPu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Feb 2013 20:15:50 -0500
Date: Wed, 20 Feb 2013 09:14:32 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Snapshot Cleaner not Working with inode_cache
Message-ID: <20130220011431.GA4757@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <CAKcLGm-Zk_8mZZUwz3Y-rsM-_ySFOSSR0OYcK2VU=2iYFQ=ZWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKcLGm-Zk_8mZZUwz3Y-rsM-_ySFOSSR0OYcK2VU=2iYFQ=ZWA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 19, 2013 at 02:22:27PM -0600, Mitch Harder wrote:
> I've encountered an issue where the space from previously deleted
> snapshots is not being freed up by the cleaner thread.
> 
> I'm only encountering this issue when I mount with the inode_cache option.
> 
> I've reproduced this on a 3.7.9 kernel merged with the latest
> for-linus branch.  No additional patches are involved.  My testing
> partition is 16 GB.
> 
> There is nothing in dmesg indicating any issues.
> 
> A simple manual test can reproduce the issue on my box
> 
> (1)  Format a fresh, scratch btrfs partition (it would probably work
> with an existing test partition, but I always like to test things that
> seem broken on a scratch partition).
> (2)  Mount partition (my options are -o
> compress-force=lzo,inode_cache).  My mount command was:
> mount -o compress-force=lzo,inode_cache /dev/sda7 /mnt/benchmark/
> (3)  Make a subvolume:  cd /mnt/<device>; btrfs su create test1
> (4)  Untar kernel sources to the subvolume:  cd test1; tar -xpf
> <path/to/kernel/source/tarball>
> I believe anything you use to populate the subvolume is sufficient.
> (5)  Make a note of the disk usage:  df -T /mnt/<device>
> (6)  Remove the subvolume:  cd ..; btrfs su delete test1
> (7)  Wait 2 minutes, and notice that the space has not been freed up.
> I've waited much longer, but I forget the exact timeout on the cleaner
> thread.
> df -T /mnt/<device>
> 
> If I unmount and remount the partition with the same mount options,
> the cleaner will begin to correctly free the space.

Hi Mitch,

Good summary.

> 
> I've never used the inode_cache option before, so I'll try a few other
> kernels to see if this is a regression.

I think I know why inode_cache keeps us from freeing space, inode_cache adds
a cache_inode in each btrfs root, and this cache_inode will be iput at the very
last of stage during umount, ie. after we do cleanup work on old
snapshot/subvols, where we free the space.

A remount will force btrfs to do cleanup work on old snapshots during mount.

This may explain the situation.

thanks,
liubo

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
