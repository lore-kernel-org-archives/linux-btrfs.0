Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25830 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752579AbdI3Bbz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 21:31:55 -0400
Date: Fri, 29 Sep 2017 18:28:00 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] Btrfs: remove nr_async_bios
Message-ID: <20170930012800.GA20449@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170907172222.20444-1-bo.li.liu@oracle.com>
 <20170907172222.20444-2-bo.li.liu@oracle.com>
 <20170927113013.GY31640@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170927113013.GY31640@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 27, 2017 at 01:30:13PM +0200, David Sterba wrote:
> On Thu, Sep 07, 2017 at 11:22:20AM -0600, Liu Bo wrote:
> > This was intended to congest higher layers to not send bios, but as
> > 
> > 1) the congested bit has been taken by writeback
> 
> Can you please be more specific here?
>

Sure, async bios comes from buffered writes and DIO writes.

For DIO writes, we want to submit them ASAP, while for buffered
writes, writeback uses balance_dirty_pages() to throttle how much
dirty pages we can have.

> > 2) and no one is waiting for %nr_async_bios down to zero,
> > 
> > we can safely remove this now.
> 
> From the original commit it looks like mechanism to avoid some write
> patterns (streaming not becoming random), but the commit is from 2008,
> lot of things have changed.

I did check the history, but have to check it again before typing the
following...

IIUC, it was introduced along with changes which makes checksumming
workload spread accross different cpus.  And at that time, seems
pdflush is used instead of per-bdi flush, perhaps pdflush doesn't have
the necessary information for writeback to do throttling, Chris should
answer this better.

> 
> I think we should at least document whats' the congestion behaviour we
> rely on nowadays, so that' sfor the 1). Otherwise patch looks ok.
>

Sounds good.

> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/ctree.h   |  1 -
> >  fs/btrfs/disk-io.c |  1 -
> >  fs/btrfs/volumes.c | 14 --------------
> >  3 files changed, 16 deletions(-)
> > 
> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index 3f3eb7b..27cd882 100644
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -881,7 +881,6 @@ struct btrfs_fs_info {
> >  
> >  	atomic_t nr_async_submits;
> >  	atomic_t async_submit_draining;
> > -	atomic_t nr_async_bios;
> >  	atomic_t async_delalloc_pages;
> >  	atomic_t open_ioctl_trans;
> >  
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index f45b61f..95583e2 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -2657,7 +2657,6 @@ int open_ctree(struct super_block *sb,
> >  	atomic_set(&fs_info->nr_async_submits, 0);
> >  	atomic_set(&fs_info->async_delalloc_pages, 0);
> >  	atomic_set(&fs_info->async_submit_draining, 0);
> > -	atomic_set(&fs_info->nr_async_bios, 0);
> >  	atomic_set(&fs_info->defrag_running, 0);
> >  	atomic_set(&fs_info->qgroup_op_seq, 0);
> >  	atomic_set(&fs_info->reada_works_cnt, 0);
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index bd679bc..6e9df4d 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -450,13 +450,6 @@ static noinline void run_scheduled_bios(struct btrfs_device *device)
> >  		pending = pending->bi_next;
> >  		cur->bi_next = NULL;
> >  
> > -		/*
> > -		 * atomic_dec_return implies a barrier for waitqueue_active
> > -		 */
> > -		if (atomic_dec_return(&fs_info->nr_async_bios) < limit &&
> 
> And after that the variable 'limit' becomes unused, please remove it as
> well.
>

OK, thanks for the comments.

thanks,

-liubo
> > -		    waitqueue_active(&fs_info->async_submit_wait))
> > -			wake_up(&fs_info->async_submit_wait);
> > -
> >  		BUG_ON(atomic_read(&cur->__bi_cnt) == 0);
> >  
> >  		/*
> > @@ -6132,13 +6125,6 @@ static noinline void btrfs_schedule_bio(struct btrfs_device *device,
> >  		return;
> >  	}
> >  
> > -	/*
> > -	 * nr_async_bios allows us to reliably return congestion to the
> > -	 * higher layers.  Otherwise, the async bio makes it appear we have
> > -	 * made progress against dirty pages when we've really just put it
> > -	 * on a queue for later
> > -	 */
> > -	atomic_inc(&fs_info->nr_async_bios);
> >  	WARN_ON(bio->bi_next);
> >  	bio->bi_next = NULL;
> >  
> > -- 
> > 2.9.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
