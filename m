Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:35280 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757140Ab3BAOkj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Feb 2013 09:40:39 -0500
Date: Fri, 1 Feb 2013 09:40:36 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] Btrfs: serialize unlocked dio reads with truncate
Message-ID: <20130201144036.GC11835@localhost.localdomain>
References: <510A3807.1040306@cn.fujitsu.com>
 <20130131164041.GP3660@localhost.localdomain>
 <510B5912.7000908@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <510B5912.7000908@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 31, 2013 at 10:56:34PM -0700, Miao Xie wrote:
> On Thu, 31 Jan 2013 11:40:41 -0500, Josef Bacik wrote:
> > On Thu, Jan 31, 2013 at 02:23:19AM -0700, Miao Xie wrote:
> >> Currently, we can do unlocked dio reads, but the following race
> >> is possible:
> >>
> >> dio_read_task			truncate_task
> >> 				->btrfs_setattr()
> >> ->btrfs_direct_IO
> >>     ->__blockdev_direct_IO
> >>       ->btrfs_get_block
> >> 				  ->btrfs_truncate()
> >> 				 #alloc truncated blocks
> >> 				 #to other inode
> >>       ->submit_io()
> >>      #INFORMATION LEAK
> >>
> >> In order to avoid this problem, we must serialize unlocked dio reads with
> >> truncate by inode_dio_wait().
> >>
> > 
> > So I had thinking about this, are we sure we don't want to just lock the extent
> > range when we truncate?  I'm good with this, but it seems like we might as well
> > and be consistent and use the extent locks.  What do you think?  Thanks,
> 
> But comparing with the current approach, the extent lock has the following problem:
> 	Dio_Read_Task			Truncate_task
> 					truncate file
> 					  set isize to 4096
> 					  drop pages
> 	lock extent[4096, 8191]
> 	read extent[4096, 8191]
> 	unlock extent[4096, 8191]
> 					  lock extent[4096, -1ULL]
> 					  truncate item
> 					  unlock extent[4096, -1ULL]
> 	lock extent[8192, ...]
> 	read extent[8192, ...]
> 	  no extent item
> 	  zero the buffer
> 	unlock extent[8192, ...]
> 
> we get the data that is mixed with new data.(Punch hole also has this problem, we need
> fix)

So this case is fine, since we'll still get valid data, the extents would still
be there.  If you are mixing dio reads with simultaneous truncate/hole punching
you deserve to get your ass bitten :).  The other option would be to lock before
we set the isize, or check the isize in get_extents.  Thanks,

Josef
