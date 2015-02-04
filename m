Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40570 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbbBDHOz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Feb 2015 02:14:55 -0500
Date: Wed, 4 Feb 2015 15:14:44 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Forrest Liu <forrestl@synology.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix find_free_dev_extent() malfunction in case
 device tree has hole
Message-ID: <20150204071443.GA15258@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1422862299-7361-1-git-send-email-forrestl@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1422862299-7361-1-git-send-email-forrestl@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 02, 2015 at 03:31:39PM +0800, Forrest Liu wrote:
> If device tree has hole, find_free_dev_extent() cannot find available
> address properly.
> 
> The example below, has one BIG hole in device tree, and can only
> allocate just one chunk in a transaction.
> 
>     item 9 key (1 DEV_EXTENT 273841913856) itemoff 15811 itemsize 48
>         dev extent chunk_tree 3
>         chunk objectid 256 chunk offset 272759783424 length 1073741824
>     item 10 key (1 DEV_EXTENT 1071632089088) itemoff 15763 itemsize 48
>         dev extent chunk_tree 3
>         chunk objectid 256 chunk offset 1070549958656 length 1073741824
>     item 11 key (1 DEV_EXTENT 1072705830912) itemoff 15715 itemsize 48
>             dev extent chunk_tree 3
>             chunk objectid 256 chunk offset 1071623700480 length
> 
> Signed-off-by: Forrest Liu <forrestl@synology.com>
> ---
>  fs/btrfs/volumes.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index da7e0e1..61be789 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1060,6 +1060,7 @@ static int contains_pending_extent(struct btrfs_trans_handle *trans,
>  	struct extent_map *em;
>  	struct list_head *search_list = &trans->transaction->pending_chunks;
>  	int ret = 0;
> +	u64 physical_start = *start;
>  
>  again:
>  	list_for_each_entry(em, search_list, list) {
> @@ -1070,9 +1071,9 @@ again:
>  		for (i = 0; i < map->num_stripes; i++) {
>  			if (map->stripes[i].dev != device)
>  				continue;
> -			if (map->stripes[i].physical >= *start + len ||
> +			if (map->stripes[i].physical >= physical_start + len ||
>  			    map->stripes[i].physical + em->orig_block_len <=
> -			    *start)
> +			    physical_start)
>  				continue;
>  			*start = map->stripes[i].physical +
>  				em->orig_block_len;

This part looks good.

> @@ -1195,8 +1196,14 @@ again:
>  			 */
>  			if (contains_pending_extent(trans, device,
>  						    &search_start,
> -						    hole_size))
> -				hole_size = 0;
> +						    hole_size)) {
> +				if (key.offset >= search_start)
> +					hole_size = key_offset - search_start;
> +				else {
> +					WARN_ON(1);
> +					hole_size = 0;

I'd prefer WARN_ON_ONCE(1) since key.offset should not be less than search_start by design.

Other looks good.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo

> +				}
> +			}
>  
>  			if (hole_size > max_hole_size) {
>  				max_hole_start = search_start;
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
