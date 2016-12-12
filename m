Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49141 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752100AbcLLNPN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Dec 2016 08:15:13 -0500
Date: Mon, 12 Dec 2016 14:15:07 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: use down_read_nested to make lockdep silent
Message-ID: <20161212131507.GO12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1480628659-17731-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1480628659-17731-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 01, 2016 at 01:44:19PM -0800, Liu Bo wrote:
> If @block_group is not @used_bg, it'll try to get @used_bg's lock without
> droping @block_group 's lock and lockdep has throwed a scary deadlock warning
> about it.
> Fix it by using down_read_nested.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/extent-tree.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 210c94a..cdb082a 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -7394,7 +7394,8 @@ btrfs_lock_cluster(struct btrfs_block_group_cache *block_group,
>  
>  		spin_unlock(&cluster->refill_lock);
>  
> -		down_read(&used_bg->data_rwsem);
> +		/* We should only have one-level nested. */
> +		down_read_nested(&used_bg->data_rwsem, 1);

While looking what down_read_nested does, I've found
SINGLE_DEPTH_NESTING, defined to 1. I'd rather use it instead of '1', as
it gives more more pointers to the docs.
