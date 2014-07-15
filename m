Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22364 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758038AbaGOKsE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jul 2014 06:48:04 -0400
Date: Tue, 15 Jul 2014 18:47:52 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix abnormal long waiting in fsync
Message-ID: <20140715104751.GB26977@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1405416674-17208-1-git-send-email-bo.li.liu@oracle.com>
 <53C500D2.3060801@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53C500D2.3060801@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 15, 2014 at 06:22:10PM +0800, Miao Xie wrote:
> On Tue, 15 Jul 2014 17:31:14 +0800, Liu Bo wrote:
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
> 
> btrfs_sync_file also calls 'btrfs_wait_ordered_range()' and introduces the same
> problem.

Yeah, looks that it will.

> 
> > there can be some ordered extents created but not getting corresponding pages
> > flushed, then they're left in memory until we fsync which runs into the
> > stage 'sync log', and fsync will just wait for the system writeback thread
> > to flush those pages and get ordered extents finished, so the latency is
> > inevitable.
> > 
> > This adds a non-blocked flush, filemap_flush(), in btrfs_sync_file() to fix
> > that.
> 
> I think this fix is not so good, because it will flush the pages that is not
> relative to the current sync. I think the key reason is btrfs_wait_logged_extents(),
> that just wait the ordered extents, not flush the relative dirty pages.
> 
> So the more reasonable fix is to use btrfs_start_ordered_extent() instead of
> wait_event in btrfs_wait_logged_extents().

It should work, the only difference is that here we wait for
BTRFS_ORDERED_IO_DONE instead of COMPLETE.  Will give a shot.

thanks,
-liubo

> 
> (This above is just my analysis)
> 
> Thanks
> Miao
> 
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/file.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> > index 1f2b99c..1af395d 100644
> > --- a/fs/btrfs/file.c
> > +++ b/fs/btrfs/file.c
> > @@ -2002,6 +2002,8 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
> >  
> >  	if (ret != BTRFS_NO_LOG_SYNC) {
> >  		if (!ret) {
> > +			filemap_flush(inode->i_mapping);
> > +
> >  			ret = btrfs_sync_log(trans, root, &ctx);
> >  			if (!ret) {
> >  				ret = btrfs_end_transaction(trans, root);
> > 
> 
