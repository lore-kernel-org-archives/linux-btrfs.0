Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53848 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726913AbeIMOVF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Sep 2018 10:21:05 -0400
Subject: Re: [PATCH] btrfs-progs: lowmem: fix false alert about the existence
 of gaps in the check_file_extent
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180913082026.16996-1-lufq.fnst@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <6324321e-28b1-2bf5-4a8b-acbac5ca226c@suse.com>
Date: Thu, 13 Sep 2018 12:12:27 +0300
MIME-Version: 1.0
In-Reply-To: <20180913082026.16996-1-lufq.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 13.09.2018 11:20, Lu Fengqi wrote:
> In the check_inode_item function, the extent_end variable used to store the
> end of the last file extent that has checked. When it passes to
> check_file_extent, if the offset of the next file extent is not equal to
> it, there is a gap between the two file extents.

The 'end' parameter of check_file_extent tracks the ending offset of the
last checked extent. This is used to detect gaps between adjacent extents.

> 
> In the case of a gap existing, it is wrong that only add the
> extent_num_bytes of this file extent to the invalid extent_end variable as
> before. Therefore, lowmem check will false alert that there are gaps
> between the subsequent file extents of this inode due to the wrong
> extent_end variable.

Currently such gaps are wrongly detected since for regular extents only
the size of the extent is added to the 'end' parameter. This results in
wrongly considering all extents of a file as having gaps between them
when only 2 of them really have a gap as seen in the example below.

> 
> Solution:
> The extent_end variable should set to the sum of the offset and the
> extent_num_bytes of the file extent.
> 
> Example:
> Suppose that lowmem check the following file extent of inode 257.
> 
>         item 6 key (257 EXTENT_DATA 0) itemoff 15813 itemsize 53
>                 generation 6 type 1 (regular)
>                 extent data disk byte 13631488 nr 4096
>                 extent data offset 0 nr 4096 ram 4096
>                 extent compression 0 (none)
>         item 7 key (257 EXTENT_DATA 8192) itemoff 15760 itemsize 53
>                 generation 6 type 1 (regular)
>                 extent data disk byte 13631488 nr 4096
>                 extent data offset 0 nr 4096 ram 4096
>                 extent compression 0 (none)
>         item 8 key (257 EXTENT_DATA 12288) itemoff 15707 itemsize 53
>                 generation 6 type 1 (regular)
>                 extent data disk byte 13631488 nr 4096
>                 extent data offset 0 nr 4096 ram 4096
>                 extent compression 0 (none)
> 
> For inode 257, check_inode_item set extent_end to 0, then call
> check_file_extent to check item {6,7,8}.
> item 6)
> 	offset(0) == extent_end(0)
> 	extent_end = extent_end(0) + extent_num_bytes(4096)
> item 7)
> 	offset(8192) != extent_end(4096)
> 	extent_end = extent_end(4096) + extent_num_bytes(4096)
> 			^^^
> 	The old extent_end should replace by offset(8192).
> item 8)
> 	offset(12288) != extent_end(8192)
> 		^^^
> 	But there is no gap between item {7,8}.

The example makes sense. But can the same thing happen with the inline
extents, ie should the same adjustments be made for the code in if
(extent_type == BTRFS_FILE_EXTENT_INLINE) ?

> 
> Fixes: d88da10ddd42 ("btrfs-progs: check: introduce function to check file extent")
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> ---
>  check/mode-lowmem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
> index 1bce44f5658a..370318f0e631 100644
> --- a/check/mode-lowmem.c
> +++ b/check/mode-lowmem.c
> @@ -1974,7 +1974,7 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_path *path,
>  		}
>  	}
>  
> -	*end += extent_num_bytes;
> +	*end = fkey.offset + extent_num_bytes;
>  	if (!is_hole)
>  		*size += extent_num_bytes;
>  
> 
