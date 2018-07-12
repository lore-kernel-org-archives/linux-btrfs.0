Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36293 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732628AbeGLWbN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jul 2018 18:31:13 -0400
Received: by mail-pg1-f195.google.com with SMTP id m19-v6so4313587pgv.3
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jul 2018 15:19:38 -0700 (PDT)
Date: Thu, 12 Jul 2018 15:19:36 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Ethan Lien <ethanlien@synology.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: use customized batch size for
 total_bytes_pinned
Message-ID: <20180712221936.GA8064@vader>
References: <20180711155936.11511-1-ethanlien@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180711155936.11511-1-ethanlien@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 11, 2018 at 11:59:36PM +0800, Ethan Lien wrote:
> In commit b150a4f10d878 ("Btrfs: use a percpu to keep track of possibly
> pinned bytes") we use total_bytes_pinned to track how many bytes we are
> going to free in this transaction. When we are close to ENOSPC, we check it
> and know if we can make the allocation by commit the current transaction.
> For every data/metadata extent we are going to free, we add
> total_bytes_pinned in btrfs_free_extent() and btrfs_free_tree_block(), and
> release it in unpin_extent_range() when we finish the transaction. So this
> is a variable we frequently update but rarely read - just the suitable
> use of percpu_counter. But in previous commit we update total_bytes_pinned
> by default 32 batch size, making every update essentially a spin lock
> protected update. Since every spin lock/unlock operation involves syncing
> a globally used variable and some kind of barrier in a SMP system, this is
> more expensive than using total_bytes_pinned as a simple atomic64_t. So
> fix this by using a customized batch size. Since we only read
> total_bytes_pinned when we are close to ENOSPC and fail to alloc new chunk,
> we can use a really large batch size and have nearly no penalty in most
> cases.
> 
> 
> [Test]
> We test the patch on a 4-cores x86 machine:
> 1. falloate a 16GiB size test file.
> 2. take snapshot (so all following writes will be cow write).
> 3. run a 180 sec, 4 jobs, 4K random write fio on test file.
> 
> We also add a temporary lockdep class on percpu_counter's spin lock used
> by total_bytes_pinned to track lock_stat.
> 
> 
> [Results]
> unpatched:
> lock_stat version 0.4
> -----------------------------------------------------------------------
>                               class name    con-bounces    contentions
> waittime-min   waittime-max waittime-total   waittime-avg    acq-bounces
> acquisitions   holdtime-min   holdtime-max holdtime-total   holdtime-avg
> 
>                total_bytes_pinned_percpu:            82             82
>         0.21           0.61          29.46           0.36         298340
>       635973           0.09          11.01      173476.25           0.27
> 
> 
> patched:
> lock_stat version 0.4
> -----------------------------------------------------------------------
>                               class name    con-bounces    contentions
> waittime-min   waittime-max waittime-total   waittime-avg    acq-bounces
> acquisitions   holdtime-min   holdtime-max holdtime-total   holdtime-avg
> 
>                total_bytes_pinned_percpu:             1              1
>         0.62           0.62           0.62           0.62          13601
>        31542           0.14           9.61       11016.90           0.35
> 
> 
> [Analysis]
> Since the spin lock only protect a single in-memory variable, the
> contentions (number of lock acquisitions that had to wait) in both
> unpatched and patched version are low. But when we see acquisitions and
> acq-bounces, we get much lower counts in patched version. Here the most
> important metric is acq-bounces. It means how many times the lock get
> transferred between different cpus, so the patch can really recude
> cacheline bouncing of spin lock (also the global counter of percpu_counter)
> in a SMP system.
> 
> Fixes: b150a4f10d878 ("Btrfs: use a percpu to keep track of possibly
> pinned bytes")
> 
> Signed-off-by: Ethan Lien <ethanlien@synology.com>
> ---
> 
> V2:
> 	Rewrite commit comments.
> 	Add lock_stat test.
> 	Pull dirty_metadata_bytes out to a separate patch.
> 
>  fs/btrfs/ctree.h       |  1 +
>  fs/btrfs/extent-tree.c | 46 ++++++++++++++++++++++++++++--------------
>  2 files changed, 32 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 118346aceea9..df682a521635 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -422,6 +422,7 @@ struct btrfs_space_info {
>  	 * time the transaction commits.
>  	 */
>  	struct percpu_counter total_bytes_pinned;
> +	s32 total_bytes_pinned_batch;

Can this just be a constant instead of adding it to space_info?
