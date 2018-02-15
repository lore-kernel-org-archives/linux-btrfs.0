Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60308 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755116AbeBOIiC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 03:38:02 -0500
Subject: Re: [PATCH v2] btrfs: cow_file_range() num_bytes and disk_num_bytes
 are same
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180215042938.18963-1-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <fb33c4c3-e9a6-5a16-275a-353d623720b1@suse.com>
Date: Thu, 15 Feb 2018 10:38:00 +0200
MIME-Version: 1.0
In-Reply-To: <20180215042938.18963-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 15.02.2018 06:29, Anand Jain wrote:
> This patch deletes local variable disk_num_bytes as its value
> is same as num_bytes in the function cow_file_range().
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
> v1->v2:
>   Fix conflict.
>   Removed Reviewed-by: David Sterba <dsterba@suse.com>
>    as there is a conflict fix.
> 
>  fs/btrfs/inode.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 8997e39c8e37..4b156e191592 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -959,7 +959,6 @@ static noinline int cow_file_range(struct inode *inode,
>  	u64 alloc_hint = 0;
>  	u64 num_bytes;
>  	unsigned long ram_size;
> -	u64 disk_num_bytes;
>  	u64 cur_alloc_size = 0;
>  	u64 blocksize = fs_info->sectorsize;
>  	struct btrfs_key ins;
> @@ -977,7 +976,6 @@ static noinline int cow_file_range(struct inode *inode,
>  
>  	num_bytes = ALIGN(end - start + 1, blocksize);
>  	num_bytes = max(blocksize,  num_bytes);
> -	disk_num_bytes = num_bytes;
>  
>  	inode_should_defrag(BTRFS_I(inode), start, end, num_bytes, SZ_64K);
>  
> @@ -1008,15 +1006,15 @@ static noinline int cow_file_range(struct inode *inode,
>  		}
>  	}
>  
> -	BUG_ON(disk_num_bytes >
> +	BUG_ON(num_bytes >
>  	       btrfs_super_total_bytes(fs_info->super_copy));
>  
>  	alloc_hint = get_extent_allocation_hint(inode, start, num_bytes);
>  	btrfs_drop_extent_cache(BTRFS_I(inode), start,
>  			start + num_bytes - 1, 0);
>  
> -	while (disk_num_bytes > 0) {
> -		cur_alloc_size = disk_num_bytes;
> +	while (num_bytes > 0) {
> +		cur_alloc_size = num_bytes;
>  		ret = btrfs_reserve_extent(root, cur_alloc_size, cur_alloc_size,
>  					   fs_info->sectorsize, 0, alloc_hint,
>  					   &ins, 1, 1);
> @@ -1080,11 +1078,10 @@ static noinline int cow_file_range(struct inode *inode,
>  					     delalloc_end, locked_page,
>  					     EXTENT_LOCKED | EXTENT_DELALLOC,
>  					     page_ops);
> -		if (disk_num_bytes < cur_alloc_size)
> -			disk_num_bytes = 0;
> +		if (num_bytes < cur_alloc_size)
> +			num_bytes = 0;
>  		else
> -			disk_num_bytes -= cur_alloc_size;
> -		num_bytes -= cur_alloc_size;
> +			num_bytes -= cur_alloc_size;
>  		alloc_hint = ins.objectid + ins.offset;
>  		start += cur_alloc_size;
>  		extent_reserved = false;
> 
