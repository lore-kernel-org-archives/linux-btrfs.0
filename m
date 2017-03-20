Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:46420 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755195AbdCTVKZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Mar 2017 17:10:25 -0400
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v2KL6Rtc014382
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Mar 2017 21:06:27 GMT
Date: Mon, 20 Mar 2017 14:04:44 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 7/7] btrfs: remove local blocksize variable in
 reada_find_extent
Message-ID: <20170320210443.GJ5540@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1489593696.git.dsterba@suse.com>
 <9355f3bb85dcdb05a30ad8f7e11bedae2f08afb0.1489593696.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9355f3bb85dcdb05a30ad8f7e11bedae2f08afb0.1489593696.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 15, 2017 at 05:02:42PM +0100, David Sterba wrote:
> The name is misleading and the local variable serves no purpose.
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/reada.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
> index 91df381a60ce..64425c3fe4f5 100644
> --- a/fs/btrfs/reada.c
> +++ b/fs/btrfs/reada.c
> @@ -318,7 +318,6 @@ static struct reada_extent *reada_find_extent(struct btrfs_fs_info *fs_info,
>  	struct btrfs_bio *bbio = NULL;
>  	struct btrfs_device *dev;
>  	struct btrfs_device *prev_dev;
> -	u32 blocksize;
>  	u64 length;
>  	int real_stripes;
>  	int nzones = 0;
> @@ -339,7 +338,6 @@ static struct reada_extent *reada_find_extent(struct btrfs_fs_info *fs_info,
>  	if (!re)
>  		return NULL;
>  
> -	blocksize = fs_info->nodesize;
>  	re->logical = logical;
>  	re->top = *top;
>  	INIT_LIST_HEAD(&re->extctl);
> @@ -349,10 +347,10 @@ static struct reada_extent *reada_find_extent(struct btrfs_fs_info *fs_info,
>  	/*
>  	 * map block
>  	 */
> -	length = blocksize;
> +	length = fs_info->nodesize;
>  	ret = btrfs_map_block(fs_info, BTRFS_MAP_GET_READ_MIRRORS, logical,
>  			&length, &bbio, 0);
> -	if (ret || !bbio || length < blocksize)
> +	if (ret || !bbio || length < fs_info->nodesize)
>  		goto error;
>  
>  	if (bbio->num_stripes > BTRFS_MAX_MIRRORS) {
> -- 
> 2.12.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
