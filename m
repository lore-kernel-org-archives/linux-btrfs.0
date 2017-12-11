Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:29548 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751347AbdLKXn7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Dec 2017 18:43:59 -0500
Date: Tue, 12 Dec 2017 10:36:19 +1100
From: Dave Chinner <david@fromorbit.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: hannes@cmpxchg.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        jack@suse.cz, linux-fsdevel@vger.kernel.org, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH v3 06/10] writeback: introduce
 super_operations->write_metadata
Message-ID: <20171211233619.GQ4094@dastard>
References: <1513029335-5112-1-git-send-email-josef@toxicpanda.com>
 <1513029335-5112-7-git-send-email-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1513029335-5112-7-git-send-email-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 11, 2017 at 04:55:31PM -0500, Josef Bacik wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> Now that we have metadata counters in the VM, we need to provide a way to kick
> writeback on dirty metadata.  Introduce super_operations->write_metadata.  This
> allows file systems to deal with writing back any dirty metadata we need based
> on the writeback needs of the system.  Since there is no inode to key off of we
> need a list in the bdi for dirty super blocks to be added.  From there we can
> find any dirty sb's on the bdi we are currently doing writeback on and call into
> their ->write_metadata callback.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Tejun Heo <tj@kernel.org>
> ---
>  fs/fs-writeback.c                | 72 ++++++++++++++++++++++++++++++++++++----
>  fs/super.c                       |  6 ++++
>  include/linux/backing-dev-defs.h |  2 ++
>  include/linux/fs.h               |  4 +++
>  mm/backing-dev.c                 |  2 ++
>  5 files changed, 80 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 987448ed7698..fba703dff678 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1479,6 +1479,31 @@ static long writeback_chunk_size(struct bdi_writeback *wb,
>  	return pages;
>  }
>  
> +static long writeback_sb_metadata(struct super_block *sb,
> +				  struct bdi_writeback *wb,
> +				  struct wb_writeback_work *work)
> +{
> +	struct writeback_control wbc = {
> +		.sync_mode		= work->sync_mode,
> +		.tagged_writepages	= work->tagged_writepages,
> +		.for_kupdate		= work->for_kupdate,
> +		.for_background		= work->for_background,
> +		.for_sync		= work->for_sync,
> +		.range_cyclic		= work->range_cyclic,
> +		.range_start		= 0,
> +		.range_end		= LLONG_MAX,
> +	};
> +	long write_chunk;
> +
> +	write_chunk = writeback_chunk_size(wb, work);
> +	wbc.nr_to_write = write_chunk;
> +	sb->s_op->write_metadata(sb, &wbc);
> +	work->nr_pages -= write_chunk - wbc.nr_to_write;
> +
> +	return write_chunk - wbc.nr_to_write;

Ok, writeback_chunk_size() returns a page count. We've already gone
through the "metadata is not page sized" dance on the dirty
accounting side, so how are we supposed to use pages to account for
metadata writeback?

And, from what I can tell, if work->sync_mode = WB_SYNC_ALL or
work->tagged_writepages is set, this will basically tell us to flush
the entire dirty metadata cache because write_chunk will get set to
LONG_MAX.

IOWs, this would appear to me to change sync() behaviour quite
dramatically on filesystems where ->write_metadata is implemented.
That is, instead of leaving all the metadata dirty in memory and
just forcing the journal to stable storage, filesystems will be told
to also write back all their dirty metadata before sync() returns,
even though it is not necessary to provide correct sync()
semantics....

Mind you, writeback invocation is so convoluted now I could easily
be mis-interpretting this code, but it does seem to me like this
code is going to have some unintended behaviours....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
