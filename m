Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60748 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754976AbeBOInd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 03:43:33 -0500
Subject: Re: [PATCH] btrfs: use ASSERT to report logical error in
 cow_file_range()
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180215043044.19248-1-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <8fd2c67e-3808-f9a8-043c-54a296fc40c6@suse.com>
Date: Thu, 15 Feb 2018 10:43:30 +0200
MIME-Version: 1.0
In-Reply-To: <20180215043044.19248-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 15.02.2018 06:30, Anand Jain wrote:
> Use ASSERT to report logical error in cow_file_range(), also move
> it a bit closer to when the num_bytes is derived.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/inode.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 4b156e191592..5648c4425f1e 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -976,6 +976,8 @@ static noinline int cow_file_range(struct inode *inode,
>  
>  	num_bytes = ALIGN(end - start + 1, blocksize);
>  	num_bytes = max(blocksize,  num_bytes);
> +	ASSERT(!(num_bytes >
> +		 btrfs_super_total_bytes(fs_info->super_copy)));

The gist of the assert is to see if the range we want to cow is not
larger than the actual filesystem size. So just write it like:

ASSERT(numbytes <= btrfs_super_total_bytes(fs_info->super_copy))

It's a lot easier to grok.

>  
>  	inode_should_defrag(BTRFS_I(inode), start, end, num_bytes, SZ_64K);
>  
> @@ -1006,9 +1008,6 @@ static noinline int cow_file_range(struct inode *inode,
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
