Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43757 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaGQDAz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 23:00:55 -0400
Date: Thu, 17 Jul 2014 11:00:47 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] Btrfs: fix abnormal long waiting in fsync
Message-ID: <20140717030046.GB4271@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1405416674-17208-1-git-send-email-bo.li.liu@oracle.com>
 <1405496225-22416-1-git-send-email-bo.li.liu@oracle.com>
 <53C64787.70700@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53C64787.70700@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 16, 2014 at 05:36:07PM +0800, Miao Xie wrote:
> On Wed, 16 Jul 2014 15:37:05 +0800, Liu Bo wrote:
> > xfstests generic/127 detected this problem.
> > 
> > With commit 7fc34a62ca4434a79c68e23e70ed26111b7a4cf8, now fsync will only flush
> > data within the passed range.  This is the cause of the above problem,
> > -- btrfs's fsync has a stage called 'sync log' which will wait for all the
> > ordered extents it've recorded to finish.
> > 
> > In xfstests/generic/127, with mixed operations such as truncate, fallocate,
> > punch hole, and mapwrite, we get some pre-allocated extents, and mapwrite will
> > mmap, and then msync.  And I find that msync will wait for quite a long time
> > (about 20s in my case), thanks to ftrace, it turns out that the previous
> > fallocate calls 'btrfs_wait_ordered_range()' to flush dirty pages, but as the
> > range of dirty pages may be larger than 'btrfs_wait_ordered_range()' wants,
> > there can be some ordered extents created but not getting corresponding pages
> > flushed, then they're left in memory until we fsync which runs into the
> > stage 'sync log', and fsync will just wait for the system writeback thread
> > to flush those pages and get ordered extents finished, so the latency is
> > inevitable.
> > 
> > This adds a flush similar to btrfs_start_ordered_extent() in
> > btrfs_wait_logged_extents() to fix that.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> > v2: 
> >    Move flush part into btrfs_wait_logged_extents() to get the flush range
> >    more precise.
> > 
> >  fs/btrfs/ordered-data.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> > index e12441c..3b52a76 100644
> > --- a/fs/btrfs/ordered-data.c
> > +++ b/fs/btrfs/ordered-data.c
> > @@ -484,8 +484,16 @@ void btrfs_wait_logged_extents(struct btrfs_root *log, u64 transid)
> >  					   log_list);
> >  		list_del_init(&ordered->log_list);
> >  		spin_unlock_irq(&log->log_extents_lock[index]);
> > +
> > +		WARN_ON(!ordered->inode);
> > +		if (!test_bit(BTRFS_ORDERED_DIRECT, &ordered->flags))
> > +			filemap_fdatawrite_range(ordered->inode->i_mapping,
> > +				ordered->file_offset,
> > +				ordered->file_offset + ordered->len - 1);
> 
> I can use bytes_left to filter the ordered extents that have been written out.

I prefer to use BTRFS_ORDERED_IO_DONE, but no big difference with bytes_left :)

> 
> The other is OK.
> 
> Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>

thanks,
-liubo

> 
> > +
> >  		wait_event(ordered->wait, test_bit(BTRFS_ORDERED_IO_DONE,
> >  						   &ordered->flags));
> > +
> >  		btrfs_put_ordered_extent(ordered);
> >  		spin_lock_irq(&log->log_extents_lock[index]);
> >  	}
> > 
> 
