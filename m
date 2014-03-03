Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47307 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980AbaCCOZ3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Mar 2014 09:25:29 -0500
Date: Mon, 3 Mar 2014 15:25:28 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: add readahead for send_write
Message-ID: <20140303142528.GC7004@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1393838683-25216-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1393838683-25216-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 03, 2014 at 05:24:43PM +0800, Liu Bo wrote:
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -3972,6 +3972,7 @@ static ssize_t fill_read_buf(struct send_ctx *sctx, u64 offset, u32 len)
>  	pgoff_t last_index;
>  	unsigned pg_offset = offset & ~PAGE_CACHE_MASK;
>  	ssize_t ret = 0;
> +	struct file_ra_state *ra = NULL;
>  
>  	key.objectid = sctx->cur_ino;
>  	key.type = BTRFS_INODE_ITEM_KEY;
> @@ -3991,6 +3992,17 @@ static ssize_t fill_read_buf(struct send_ctx *sctx, u64 offset, u32 len)
>  		goto out;
>  
>  	last_index = (offset + len - 1) >> PAGE_CACHE_SHIFT;
> +
> +	/* initial readahead */
> +	ra = kzalloc(sizeof(*ra), GFP_NOFS);
> +	if (!ra) {
> +		ret = -ENOMEM;

This should not be a hard failure, it can continue without RA for this
buffer. Besides, the RA buffer can be allocated at the beginning of send
operation and pointer stored in the send context.

> +		goto out;
> +	}
> +
> +	file_ra_state_init(ra, inode->i_mapping);
> +	btrfs_force_ra(inode->i_mapping, ra, NULL, index, last_index-index + 1);
> +
>  	while (index <= last_index) {
>  		unsigned cur_len = min_t(unsigned, len,
>  					 PAGE_CACHE_SIZE - pg_offset);
> @@ -4022,6 +4034,7 @@ static ssize_t fill_read_buf(struct send_ctx *sctx, u64 offset, u32 len)
>  		ret += cur_len;
>  	}
>  out:
> +	kfree(ra);
>  	iput(inode);
>  	return ret;
>  }
> -- 
> 1.8.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
