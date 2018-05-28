Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35804 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1032809AbeE1PcR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 11:32:17 -0400
Date: Mon, 28 May 2018 16:32:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 5/6] Btrfs: grab write lock directly if
 write_lock_level is the max level
Message-ID: <20180528143213.GB6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1526612424-97061-1-git-send-email-bo.liu@linux.alibaba.com>
 <1526612424-97061-6-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1526612424-97061-6-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 18, 2018 at 11:00:23AM +0800, Liu Bo wrote:
> Typically, when acquiring root node's lock, btrfs tries its best to get
> read lock and trade for write lock if @write_lock_level implies to do so.
> 
> In case of (cow && (p->keep_locks || p->lowest_level)), write_lock_level
> is set to BTRFS_MAX_LEVEL, which means we need to acquire root node's
> write lock directly.
> 
> In this particular case, the dance of acquiring read lock and then trading
> for write lock can be saved.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

Reviewed-by: David Sterba <dsterba@suse.com>

> ---
>  fs/btrfs/ctree.c | 29 ++++++++++++++++-------------
>  1 file changed, 16 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 8d3b09038f37..e619f7e01794 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -2633,20 +2633,23 @@ static struct extent_buffer *btrfs_search_slot_get_root(struct btrfs_root *root,
>  		goto out;
>  	}
>  
> -	/*
> -	 * we don't know the level of the root node until we actually
> -	 * have it read locked
> -	 */
> -	b = btrfs_read_lock_root_node(root);
> -	level = btrfs_header_level(b);
> -	if (level > write_lock_level)
> -		goto out;

I've added a comment why the check below is done.

> +	if (write_lock_level < BTRFS_MAX_LEVEL) {
