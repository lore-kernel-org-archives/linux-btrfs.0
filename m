Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34336 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753910AbcJYTvT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Oct 2016 15:51:19 -0400
Date: Tue, 25 Oct 2016 15:50:37 -0400
From: Tejun Heo <htejun@fb.com>
To: Josef Bacik <jbacik@fb.com>
CC: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>, <david@fromorbit.com>,
        <jack@suse.cz>, <linux-fsdevel@vger.kernel.org>,
        <viro@zeniv.linux.org.uk>, <hch@infradead.org>, <jweiner@fb.com>
Subject: Re: [PATCH 3/5] writeback: add counters for metadata usage
Message-ID: <20161025195037.GC13857@htj.duckdns.org>
References: <1477420904-1399-1-git-send-email-jbacik@fb.com>
 <1477420904-1399-4-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1477420904-1399-4-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

On Tue, Oct 25, 2016 at 02:41:42PM -0400, Josef Bacik wrote:
> Btrfs has no bounds except memory on the amount of dirty memory that we have in
> use for metadata.  Historically we have used a special inode so we could take
> advantage of the balance_dirty_pages throttling that comes with using pagecache.
> However as we'd like to support different blocksizes it would be nice to not
> have to rely on pagecache, but still get the balance_dirty_pages throttling
> without having to do it ourselves.
> 
> So introduce *METADATA_DIRTY_BYTES and *METADATA_WRITEBACK_BYTES.  These are
> zone and bdi_writeback counters to keep track of how many bytes we have in
> flight for METADATA.  We need to count in bytes as blocksizes could be
> percentages of pagesize.  We simply convert the bytes to number of pages where
> it is needed for the throttling.
> 
> Also introduce NR_METADATA_BYTES so we can keep track of the total amount of
> pages used for metadata on the system.  This is also needed so things like dirty
> throttling know that this is dirtyable memory as well and easily reclaimed.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Some nits.

It'd be nice to note that this patch just introduces new fields
without using them and thus doesn't cause any behavioral changes.

> @@ -51,6 +51,8 @@ static DEVICE_ATTR(cpumap,  S_IRUGO, node_read_cpumask, NULL);
>  static DEVICE_ATTR(cpulist, S_IRUGO, node_read_cpulist, NULL);
>  
>  #define K(x) ((x) << (PAGE_SHIFT - 10))
> +#define BtoK(x) ((x) >> 10)

This would belong in a separate patch but any chance we can share
these definitions?  It's fine to have the definitions in a couple
places but these are getting duplicated in multiple spots and actually
getting confusing with K meaning pages to kilobytes.  I'm not sure how
it exactly should be tho.

> @@ -2473,6 +2504,100 @@ void account_page_dirtied(struct page *page, struct address_space *mapping)
>  EXPORT_SYMBOL(account_page_dirtied);
>  
>  /*

/**

> + * account_metadata_dirtied
> + * @page - the page being dirited
> + * @bdi - the bdi that owns this page
> + * @bytes - the number of bytes being dirtied
> + *
> + * Do the dirty page accounting for metadata pages that aren't backed by an
> + * address_space.
> + */
> +void account_metadata_dirtied(struct page *page, struct backing_dev_info *bdi,
> +			      long bytes)
> +{
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	__mod_node_page_state(page_pgdat(page), NR_METADATA_DIRTY_BYTES,
> +			      bytes);
> +	__add_wb_stat(&bdi->wb, WB_DIRTIED_BYTES, bytes);
> +	__add_wb_stat(&bdi->wb, WB_METADATA_DIRTY_BYTES, bytes);
> +	current->nr_dirtied++;
> +	task_io_account_write(bytes);
> +	this_cpu_inc(bdp_ratelimits);
> +	local_irq_restore(flags);

Again, I'm not sure about the explicit irq ops especially as some of
the counters are already irq safe.

> +}
> +EXPORT_SYMBOL(account_metadata_dirtied);
> +
> +/*

/**

> + * account_metadata_cleaned
> + * @page - the page being cleaned
> + * @bdi - the bdi that owns this page
> + * @bytes - the number of bytes cleaned
> + *
> + * Called on a no longer dirty metadata page.
> + */
> +void account_metadata_cleaned(struct page *page, struct backing_dev_info *bdi,
> +			      long bytes)
> +{
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	__mod_node_page_state(page_pgdat(page), NR_METADATA_DIRTY_BYTES,
> +			      -bytes);
> +	__add_wb_stat(&bdi->wb, WB_METADATA_DIRTY_BYTES, -bytes);
> +	task_io_account_cancelled_write(bytes);
> +	local_irq_restore(flags);

Ditto with irq and the following functions.

> @@ -3701,7 +3703,20 @@ static unsigned long node_pagecache_reclaimable(struct pglist_data *pgdat)
>  	if (unlikely(delta > nr_pagecache_reclaimable))
>  		delta = nr_pagecache_reclaimable;
>  
> -	return nr_pagecache_reclaimable - delta;
> +	nr_metadata_reclaimable =
> +		node_page_state(pgdat, NR_METADATA_BYTES) >> PAGE_SHIFT;
> +	/*
> +	 * We don't do writeout through the shrinkers so subtract any
> +	 * dirty/writeback metadata bytes from the reclaimable count.
> +	 */

Hmm... up until this point, the dirty metadata was handled the same
way as regular dirty data but it deviates here.  Is this right?  The
calculations in writeback code also assumes that the dirty pages are
reclaimable.  If this is inherently different, it'd be nice to explain
more explicitly why this is different from others.

Thanks.

-- 
tejun
