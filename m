Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38663 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755240AbeBOKJN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 05:09:13 -0500
Subject: Re: [PATCH v2] btrfs: use ASSERT to report logical error in
 cow_file_range()
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <8fd2c67e-3808-f9a8-043c-54a296fc40c6@suse.com>
 <20180215100759.11647-1-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <b64c97e2-0aac-ef3f-c63e-021884ab166b@suse.com>
Date: Thu, 15 Feb 2018 12:09:10 +0200
MIME-Version: 1.0
In-Reply-To: <20180215100759.11647-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 15.02.2018 12:07, Anand Jain wrote:
> Use ASSERT to report logical error in cow_file_range(), also move
> it a bit closer to when the num_bytes is derived.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
> v1->v2:
>    ASSERT logic changed. Thanks Nikolay.
> 
>  fs/btrfs/inode.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 4b156e191592..260fd8139951 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -976,6 +976,7 @@ static noinline int cow_file_range(struct inode *inode,
>  
>  	num_bytes = ALIGN(end - start + 1, blocksize);
>  	num_bytes = max(blocksize,  num_bytes);
> +	ASSERT(num_bytes <= btrfs_super_total_bytes(fs_info->super_copy));
>  
>  	inode_should_defrag(BTRFS_I(inode), start, end, num_bytes, SZ_64K);
>  
> @@ -1006,9 +1007,6 @@ static noinline int cow_file_range(struct inode *inode,
>  		}
>  	}
>  
> -	BUG_ON(num_bytes >
> -	       btrfs_super_total_bytes(fs_info->super_copy));
> -
>  	alloc_hint = get_extent_allocation_hint(inode, start, num_bytes);
>  	btrfs_drop_extent_cache(BTRFS_I(inode), start,
>  			start + num_bytes - 1, 0);
> 
