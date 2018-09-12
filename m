Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44388 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbeILXcL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 19:32:11 -0400
Received: by mail-pg1-f195.google.com with SMTP id r1-v6so1468167pgp.11
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2018 11:26:27 -0700 (PDT)
Date: Wed, 12 Sep 2018 11:26:25 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: wait on caching when putting the bg cache
Message-ID: <20180912182625.GA6052@vader>
References: <20180912144545.5564-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180912144545.5564-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 12, 2018 at 10:45:45AM -0400, Josef Bacik wrote:
> While testing my backport I noticed there was a panic if I ran
> generic/416 generic/417 generic/418 all in a row.  This just happened to
> uncover a race where we had outstanding IO after we destroy all of our
> workqueues, and then we'd go to queue the endio work on those free'd
> workqueues.  This is because we aren't waiting for the caching threads
> to be done before freeing everything up, so to fix this make sure we
> wait on any outstanding caching that's being done before we free up the
> block group, so we're sure to be done with all IO by the time we get to
> btrfs_stop_all_workers().  This fixes the panic I was seeing
> consistently in testing.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/extent-tree.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 414492a18f1e..2eb2e37f2354 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -9889,6 +9889,7 @@ void btrfs_put_block_group_cache(struct btrfs_fs_info *info)
>  
>  		block_group = btrfs_lookup_first_block_group(info, last);
>  		while (block_group) {
> +			wait_block_group_cache_done(block_group);
>  			spin_lock(&block_group->lock);
>  			if (block_group->iref)
>  				break;
> -- 
> 2.14.3
> 
