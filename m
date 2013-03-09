Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:55321 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757220Ab3CIM1O (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Mar 2013 07:27:14 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 768B37C041D
	for <linux-btrfs@vger.kernel.org>; Sat,  9 Mar 2013 05:27:13 -0700 (MST)
Date: Sat, 9 Mar 2013 07:27:10 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] use rcu_barrier() to wait for bdev puts at unmount
Message-ID: <20130309122710.GA15521@shiny.masoncoding.com>
References: <513AC735.1090500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <513AC735.1090500@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 08, 2013 at 10:23:01PM -0700, Eric Sandeen wrote:
> Doing this would reliably fail with -EBUSY for me:
> 
> # mount /dev/sdb2 /mnt/scratch; umount /mnt/scratch; mkfs.btrfs -f /dev/sdb2
> ...
> unable to open /dev/sdb2: Device or resource busy
> 
> because mkfs.btrfs tries to open the device O_EXCL, and somebody still has it.
> 
> Using systemtap to track bdev gets & puts shows a kworker thread doing a
> blkdev put after mkfs attempts a get; this is left over from the unmount.
> 
> Adding an rcu_barrier() to btrfs_close_devices() causes unmount to wait
> until all blkdev_put()s are done, and the device is truly free once
> unmount completes.

Thanks for tracking this down Eric.  Is this kworker triggered by btrfs
or is this something we should be doing for the other filesystems too?

I'd move it down to close_ctree, but I don't really have a good reason.

-chris
