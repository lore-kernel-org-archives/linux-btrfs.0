Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51913 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab3CKOwF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 10:52:05 -0400
Date: Mon, 11 Mar 2013 22:50:23 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Michael Johnson - MJ <mj@revmj.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: snapshot deletion / unmount slowness
Message-ID: <20130311145022.GD28468@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <CAHGunUmrWW1-Tb3e4ov9dHcjQN9yHcNZGXMVydzKAKWky2PL8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAHGunUmrWW1-Tb3e4ov9dHcjQN9yHcNZGXMVydzKAKWky2PL8w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 10, 2013 at 10:31:08PM -0700, Michael Johnson - MJ wrote:
> I currently have a btrfs filesystem that I am unmounting and it has
> been has been "unmounting" for the last 20 minutes.
> 
> I'm pretty sure I know exactly what is going on and in my current
> situation it's not a huge issues, but it would be a problem if this
> was a production system and I was trying to do a maintenance.
> 
> Here is how I got into this situation:
> 
> I am migrating my data from one pair of disks (mirrored with btrfs) to
> another pair of disks.  I rsync'd my data from the original btrfs file
> system to the other.  When it completed, my new filesystem showed
> 165GB used. The original show 1.8TB used.  I came to the conclusion
> that it must be the daily snapshots I have that were using the
> majority of the space and because I was going to destroy the
> filesystem, I decided, what the heck, let me destroy the snapshots and
> see what it looks like.
> 
> To my surprise, removing all the snapshots resulted in the usage
> dropping from 1.8TB to 1.7TB.  I re-ran my rsync, it complete without
> transferring any new data.  I then did a du -s in the mountpoint for
> the original filesystem and is reported back 165GB which agrees with
> what rsync and df on the new filesystem reports.
> 
> My first thought was that I must have some sort of bizarre corruption
> on the original filesystem.  And then I went to unmount it and it
> still has not returned.
> 
> What I now suspect is going on is that while deleting the snapshots
> was quick, that probably kicks of a background thread which actually
> does the heavy lifting.  I noticed a btrfs-cleaner process that was in
> an io wait state, which I presumed was the process in question.
> However, now 40 minutes later, my unmount is still hung and the
> btrfs-cleaner process is sleeping, so perhaps I am wrong.

You're right, umount will wake up cleaner kthread to do 'real work' of cleanup
marked 'delete' snapshot/subvolume.

but while btrfs-cleaner is sleeping, could you please show what unmount is
waiting for?

Maybe 'cat /proc/xxxx/stack' will be helpful on figuring out why.

thanks,
liubo

> 
> At this point I am going to powercycle my system, but I figured I
> would check and see if anyone else knew for certain it this was the
> type of behavior one would expect to see when removing large snapshots
> and then immediately trying to unmount the filesystem.  If so, it
> seems like this is something that would need to change before someone
> would want to seriously consider using btrfs w/ snapshots in a
> production environment.  I know btrfs is not considered production
> ready yet (well, at least not by the developers, regardless of what
> Oracle and Suse say).  At the same time, I've not been able to find
> any mention of similar problems, so I figured it was worth mentioning.
> 
> --
> Michael Johnson - MJ
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
