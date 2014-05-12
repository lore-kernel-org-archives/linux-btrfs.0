Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21243 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932434AbaELPAi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 May 2014 11:00:38 -0400
Date: Mon, 12 May 2014 23:00:23 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Zach Brown <zab@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: fix inline compressed read err corruption
Message-ID: <20140512150022.GA15727@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1399590979-15331-1-git-send-email-zab@redhat.com>
 <1399590979-15331-3-git-send-email-zab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1399590979-15331-3-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 08, 2014 at 07:16:19PM -0400, Zach Brown wrote:
> uncompress_inline() is silently dropping an error from
> btrfs_decompress() after testing it and zeroing the page that was
> supposed to hold decompressed data.  This can silently turn compressed
> inline data in to zeros if decompression fails due to corrupt compressed
> data or memory allocation failure.
> 
> I have no idea why uncompress_inline() is zeroing the page for an error
> from btrfs_decompress() but not for the earlier ENOMEM from kmalloc().
> Can someone explain this?

I guess that's because decompress() may have put part of real data on the page
and then bail out, and we don't want those data to be exposed to users in this
error case.

And kmalloc() 's ENOMEM runs before that decompress(), page has whatever random
data.

-liubo

> 
> The fix is to pass the error to its caller.  Which still has a BUG_ON().
> So we fix that too.
> 
> I verified this by manually forcing the error from btrfs_decompress()
> for a silly named copy of od:
> 
> 	if (!strcmp(current->comm, "failod"))
> 		ret = -ENOMEM;
> 
>   # od -x /mnt/btrfs/dir/80 | head -1
>   0000000 3031 3038 310a 2d30 6f70 6e69 0a74 3031
>   # echo 3 > /proc/sys/vm/drop_caches
>   # cp $(which od) /tmp/failod
>   # /tmp/failod -x /mnt/btrfs/dir/80 | head -1
>   0000000 0000 0000 0000 0000 0000 0000 0000 0000
> 
> Signed-off-by: Zach Brown <zab@redhat.com>
> ---
>  fs/btrfs/inode.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 0c0bb45..fc89fa7 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6091,7 +6091,7 @@ static noinline int uncompress_inline(struct btrfs_path *path,
>  		kunmap_atomic(kaddr);
>  	}
>  	kfree(tmp);
> -	return 0;
> +	return ret;
>  }
>  
>  /*
> @@ -6292,7 +6292,10 @@ next:
>  				ret = uncompress_inline(path, inode, page,
>  							pg_offset,
>  							extent_offset, item);
> -				BUG_ON(ret); /* -ENOMEM */
> +				if (ret) {
> +					err = ret;
> +					goto out;
> +				}
>  			} else {
>  				map = kmap(page);
>  				read_extent_buffer(leaf, map + pg_offset, ptr,
> -- 
> 1.8.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
