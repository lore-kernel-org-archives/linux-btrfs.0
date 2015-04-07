Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27182 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbbDGLOs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Apr 2015 07:14:48 -0400
Date: Tue, 7 Apr 2015 19:14:31 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/9] btrfs: Fix tail space processing in
 find_free_dev_extent()
Message-ID: <20150407111329.GA30844@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1428062473.git.zhaolei@cn.fujitsu.com>
 <5493abf5d0e08b335de6a5a15f0e72019062b80d.1428062473.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5493abf5d0e08b335de6a5a15f0e72019062b80d.1428062473.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 03, 2015 at 08:11:57PM +0800, Zhaolei wrote:
> From: Zhao Lei <zhaolei@cn.fujitsu.com>
> 
> It is another reason for NO_SPACE case.
> 
> When we found enough free space in loop and saved them to
> max_hole_start/size before, and tail space contains pending extent,
> origional innocent max_hole_start/size are reset in retry.
> 
> As a result, find_free_dev_extent() returns less space than it can,
> and cause NO_SPACE in user program.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  fs/btrfs/volumes.c | 24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 8222f6f..586824a 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1136,11 +1136,11 @@ int find_free_dev_extent(struct btrfs_trans_handle *trans,
>  	path = btrfs_alloc_path();
>  	if (!path)
>  		return -ENOMEM;
> -again:
> +
>  	max_hole_start = search_start;
>  	max_hole_size = 0;
> -	hole_size = 0;
>  
> +again:
>  	if (search_start >= search_end || device->is_tgtdev_for_dev_replace) {
>  		ret = -ENOSPC;
>  		goto out;
> @@ -1233,21 +1233,23 @@ next:
>  	 * allocated dev extents, and when shrinking the device,
>  	 * search_end may be smaller than search_start.
>  	 */
> -	if (search_end > search_start)
> +	if (search_end > search_start) {
>  		hole_size = search_end - search_start;
>  
> -	if (hole_size > max_hole_size) {
> -		max_hole_start = search_start;
> -		max_hole_size = hole_size;
> -	}
> +		if (contains_pending_extent(trans, device, &search_start,
> +					    hole_size)) {
> +			btrfs_release_path(path);
> +			goto again;
> +		}
>  
> -	if (contains_pending_extent(trans, device, &search_start, hole_size)) {
> -		btrfs_release_path(path);
> -		goto again;
> +		if (hole_size > max_hole_size) {
> +			max_hole_start = search_start;
> +			max_hole_size = hole_size;
> +		}
>  	}
>  
>  	/* See above. */
> -	if (hole_size < num_bytes)
> +	if (max_hole_size < num_bytes)
>  		ret = -ENOSPC;
>  	else
>  		ret = 0;
> -- 
> 1.8.5.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
