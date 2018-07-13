Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40390 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729770AbeGMQXH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Jul 2018 12:23:07 -0400
Date: Fri, 13 Jul 2018 18:07:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Ethan Lien <ethanlien@synology.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: use customized batch size for
 total_bytes_pinned
Message-ID: <20180713160745.GC3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180713085042.25600-1-ethanlien@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180713085042.25600-1-ethanlien@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 13, 2018 at 04:50:42PM +0800, Ethan Lien wrote:
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
> [Test]
> We test the patch on a 4-cores x86 machine:
> 1. falloate a 16GiB size test file.
> 2. take snapshot (so all following writes will be cow write).
> 3. run a 180 sec, 4 jobs, 4K random write fio on test file.
> 
> We also add a temporary lockdep class on percpu_counter's spin lock used
> by total_bytes_pinned to track lock_stat.
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
> [Analysis]
> Since the spin lock only protect a single in-memory variable, the
> contentions (number of lock acquisitions that had to wait) in both
> unpatched and patched version are low. But when we see acquisitions and
> acq-bounces, we get much lower counts in patched version. Here the most
> important metric is acq-bounces. It means how many times the lock get
> transferred between different cpus, so the patch can really reduce
> cacheline bouncing of spin lock (also the global counter of percpu_counter)
> in a SMP system.

Very nice, thank you for the detailed description and analysis.

> Fixes: b150a4f10d878 ("Btrfs: use a percpu to keep track of possibly
> pinned bytes")
> 
> Signed-off-by: Ethan Lien <ethanlien@synology.com>

> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -51,6 +51,14 @@ enum {
>  	CHUNK_ALLOC_FORCE = 2,
>  };
>  
> +/*
> + * Use large batch size to reduce update overhead.
> + * For reader side, we only read it when we are close to ENOSPC and
> + * the read overhead is mostly related to # of cpus, so it is OK to
> + * use arbitrary large value here.
> + */
> +#define TOTAL_BYTES_PINNED_BATCH SZ_128M

One minor update, I've renamed that to BTRFS_TOTAL_BYTES_PINNED_BATCH
and moved the defintion next to BTRFS_DIRTY_METADATA_THRESH in ctree.h.
