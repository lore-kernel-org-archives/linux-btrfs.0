Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32262 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbcFDBOn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jun 2016 21:14:43 -0400
Date: Fri, 3 Jun 2016 18:16:18 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: clear uptodate flags of pages in sys_array eb
Message-ID: <20160604011617.GA8214@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1465000902-3205-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1465000902-3205-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 03, 2016 at 05:41:42PM -0700, Liu Bo wrote:
> We set uptodate flag to pages in the temporary sys_array eb,
> but do not clear the flag after free eb.  As the special
> btree inode may still hold a reference on those pages, the
> uptodate flag can remain alive in them.
> 
> If btrfs_super_chunk_root has been intentionally changed to the
> offset of this sys_array eb, reading chunk_root will read content
> of sys_array and it will pass our beautiful checks in

s/pass/skip/

My mistake, sorry.

Thanks,

-liubo

> btree_readpage_end_io_hook() because of
> "pages of eb are uptodate => eb is uptodate"
> 
> This adds the 'clear uptodate' part to force it to read from disk.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/volumes.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 7a169de..d2ca03b 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -6681,12 +6681,14 @@ int btrfs_read_sys_array(struct btrfs_root *root)
>  		sb_array_offset += len;
>  		cur_offset += len;
>  	}
> +	clear_extent_buffer_uptodate(sb);
>  	free_extent_buffer_stale(sb);
>  	return ret;
>  
>  out_short_read:
>  	printk(KERN_ERR "BTRFS: sys_array too short to read %u bytes at offset %u\n",
>  			len, cur_offset);
> +	clear_extent_buffer_uptodate(sb);
>  	free_extent_buffer_stale(sb);
>  	return -EIO;
>  }
> -- 
> 2.5.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
