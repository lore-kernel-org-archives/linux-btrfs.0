Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52624 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728059AbeILUUl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 16:20:41 -0400
Subject: Re: [PATCH] btrfs: wait on caching when putting the bg cache
To: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
References: <20180912144545.5564-1-josef@toxicpanda.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <d57f676e-f9c8-9aea-f491-9b6a01408149@suse.com>
Date: Wed, 12 Sep 2018 18:15:41 +0300
MIME-Version: 1.0
In-Reply-To: <20180912144545.5564-1-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12.09.2018 17:45, Josef Bacik wrote:
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

It's not clear whether this is caused by one of the patches in your
latest patchbomb or has the issue been there all along?
> 
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
> 
