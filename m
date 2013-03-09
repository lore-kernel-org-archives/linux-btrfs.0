Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:55774 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757854Ab3CIPDX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Mar 2013 10:03:23 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id AD0AF7C034A
	for <linux-btrfs@vger.kernel.org>; Sat,  9 Mar 2013 08:03:22 -0700 (MST)
Date: Sat, 9 Mar 2013 10:03:20 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Eric Sandeen <sandeen@redhat.com>
CC: Chris Mason <clmason@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] use rcu_barrier() to wait for bdev puts at unmount
Message-ID: <20130309150320.GB15521@shiny.masoncoding.com>
References: <513AC735.1090500@redhat.com>
 <20130309122710.GA15521@shiny.masoncoding.com>
 <513B4460.5090607@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <513B4460.5090607@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 09, 2013 at 07:17:04AM -0700, Eric Sandeen wrote:
> On 3/9/13 6:27 AM, Chris Mason wrote:
> > On Fri, Mar 08, 2013 at 10:23:01PM -0700, Eric Sandeen wrote:
> >> Doing this would reliably fail with -EBUSY for me:
> >>
> >> # mount /dev/sdb2 /mnt/scratch; umount /mnt/scratch; mkfs.btrfs -f /dev/sdb2
> >> ...
> >> unable to open /dev/sdb2: Device or resource busy
> >>
> >> because mkfs.btrfs tries to open the device O_EXCL, and somebody still has it.
> >>
> >> Using systemtap to track bdev gets & puts shows a kworker thread doing a
> >> blkdev put after mkfs attempts a get; this is left over from the unmount.
> >>
> >> Adding an rcu_barrier() to btrfs_close_devices() causes unmount to wait
> >> until all blkdev_put()s are done, and the device is truly free once
> >> unmount completes.
> > 
> > Thanks for tracking this down Eric.  
> 
> Sure thing, sorry it took so long.
> 
> > Is this kworker triggered by btrfs
> > or is this something we should be doing for the other filesystems too?
> 
> It's all btrfs ;)
> 
> btrfs_close_devices
> 	__btrfs_close_devices
> 		call_rcu(&device->rcu, free_device);
> 			free_device
> 				INIT_WORK(&device->rcu_work, __free_device);
> 				schedule_work(&device->rcu_work);
> 

Great, that makes a ton more sense.  I'm a little confused on why we're
seeing it so much more now than in the past.

> 
> The behavior came from:
> 
> commit 1f78160ce1b1b8e657e2248118c4d91f881763f0
> Author: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> Date:   Wed Apr 20 10:09:16 2011 +0000
> 
>     Btrfs: using rcu lock in the reader side of devices list
> 
> Anyway, I can send V2 in close_ctree if you like. Thinking about it more
> though, btrfs_close_devices is closer to the action, so now I think
> I'd leave it there. :)
> 
> I probably should have put a comment in to say what the heck it's for,
> too.  Feel free to fix on merge or I can send another patch.

Ok, please add the comment and a cc to stable.  Thanks again.

-chris

