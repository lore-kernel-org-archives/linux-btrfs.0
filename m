Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:36353 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751592AbdF2TVo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Jun 2017 15:21:44 -0400
Received: by mail-pg0-f48.google.com with SMTP id u62so52335939pgb.3
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Jun 2017 12:21:43 -0700 (PDT)
Date: Thu, 29 Jun 2017 12:21:41 -0700
From: Omar Sandoval <osandov@osandov.com>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] btrfs: account for pinned bytes in
 should_alloc_chunk
Message-ID: <20170629192141.GA20229@vader.DHCP.thefacebook.com>
References: <20170622135148.16730-1-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170622135148.16730-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 22, 2017 at 09:51:47AM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> In a heavy write scenario, we can end up with a large number of pinned bytes.
> This can translate into (very) premature ENOSPC because pinned bytes
> must be accounted for when allowing a reservation but aren't accounted for
> when deciding whether to create a new chunk.
> 
> This patch adds the accounting to should_alloc_chunk so that we can
> create the chunk.

Hey, Jeff,

Does this fix your ENOSPC problem on a fresh filesystem? I just tracked
down an ENOSPC issue someone here reported when doing a btrfs send to a
fresh filesystem and it sounds a lot like your issue: metadata
bytes_may_use shoots up but we don't allocate any chunks for it. I'm not
seeing how including bytes_pinned will help for this case. We won't have
any pinned bytes when populating a new fs, right?

I don't have a good solution. Allocating chunks based on bytes_may_use
is going to way over-allocate because of our worst-case estimations. I'm
double-checking now that the flusher is doing the right thing and not
missing anything. I'll keep digging, just wanted to know if you had any
thoughts.

> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 33d979e9ea2a..88b04742beea 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4377,7 +4377,7 @@ static int should_alloc_chunk(struct btrfs_fs_info *fs_info,
>  {
>  	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
>  	u64 num_bytes = sinfo->total_bytes - sinfo->bytes_readonly;
> -	u64 num_allocated = sinfo->bytes_used + sinfo->bytes_reserved;
> +	u64 num_allocated = sinfo->bytes_used + sinfo->bytes_reserved + sinfo->bytes_pinned;
>  	u64 thresh;
>  
>  	if (force == CHUNK_ALLOC_FORCE)
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
