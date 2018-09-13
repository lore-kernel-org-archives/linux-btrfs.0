Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:57699 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725757AbeINEUS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 00:20:18 -0400
Subject: Re: [PATCH 3/3] btrfs-progs: check: lowmem: Refactor extent type
 checks in check_file_extent
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20180913120507.18197-1-nborisov@suse.com>
 <20180913120507.18197-4-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <abc403df-7328-c169-197a-9d78ee253110@gmx.com>
Date: Fri, 14 Sep 2018 07:08:32 +0800
MIME-Version: 1.0
In-Reply-To: <20180913120507.18197-4-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018/9/13 下午8:05, Nikolay Borisov wrote:
> Make the checks in check_file_extent a bit more explicit. First we check
> for unknown type and fail accordingly. Then we check for inline extent
> and handle it in the newly introduced check_file_extent_inline. Finally
> if none of the above checks triggered then we must have a regular or
> prealloc extents.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  check/mode-lowmem.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
> index 3a6fbb33c858..aa946a1307de 100644
> --- a/check/mode-lowmem.c
> +++ b/check/mode-lowmem.c
> @@ -1915,21 +1915,23 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_path *path,
>  
>  	btrfs_item_key_to_cpu(node, &fkey, slot);
>  	fi = btrfs_item_ptr(node, slot, struct btrfs_file_extent_item);
> -
> -	/* Check inline extent */
>  	extent_type = btrfs_file_extent_type(node, fi);
> -	if (extent_type == BTRFS_FILE_EXTENT_INLINE)
> -		return check_file_extent_inline(root, path, size, end);
>  
>  	/* Check extent type */
>  	if (extent_type != BTRFS_FILE_EXTENT_REG &&
> -			extent_type != BTRFS_FILE_EXTENT_PREALLOC) {
> +	    extent_type != BTRFS_FILE_EXTENT_PREALLOC &&
> +	    extent_type != BTRFS_FILE_EXTENT_INLINE) {
>  		err |= FILE_EXTENT_ERROR;
>  		error("root %llu EXTENT_DATA[%llu %llu] type bad",
>  		      root->objectid, fkey.objectid, fkey.offset);
>  		return err;
>  	}
>  
> +	/* Check inline extent */
> +	if (extent_type == BTRFS_FILE_EXTENT_INLINE)
> +		return check_file_extent_inline(root, path, size, end);
> +
> +
>  	/* Check REG_EXTENT/PREALLOC_EXTENT */
>  	disk_bytenr = btrfs_file_extent_disk_bytenr(node, fi);
>  	disk_num_bytes = btrfs_file_extent_disk_num_bytes(node, fi);
> 
