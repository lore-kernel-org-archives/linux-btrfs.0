Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25868 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756943AbdJKA4c (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Oct 2017 20:56:32 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9B0uVER011938
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 00:56:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9B0uU84004196
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 00:56:31 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v9B0uU20021679
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 00:56:30 GMT
Date: Tue, 10 Oct 2017 17:52:29 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/4] btrfs: add_missing_dev() should return the actual
 error
Message-ID: <20171011005229.GB3283@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20171009030746.16680-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171009030746.16680-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 09, 2017 at 11:07:43AM +0800, Anand Jain wrote:
> add_missing_dev() can return device pointer so that IS_ERR/
> PTR_ERR can be used to check for the actual error occurred
> in the function.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v2: This patch is a split from
>     [PATCH 1/2] btrfs: fix read_one_chunk() return error code
> 
>  fs/btrfs/volumes.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 0e8f16c305df..2f500a32089e 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -6249,7 +6249,7 @@ static struct btrfs_device *add_missing_dev(struct btrfs_fs_devices *fs_devices,
>  
>  	device = btrfs_alloc_device(NULL, &devid, dev_uuid);
>  	if (IS_ERR(device))
> -		return NULL;
> +		return device;
>  
>  	list_add(&device->dev_list, &fs_devices->devices);
>  	device->fs_devices = fs_devices;
> @@ -6454,9 +6454,12 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
>  			map->stripes[i].dev =
>  				add_missing_dev(fs_info->fs_devices, devid,
>  						uuid);
> -			if (!map->stripes[i].dev) {
> +			if (IS_ERR(map->stripes[i].dev)) {
>  				free_extent_map(em);
> -				return -EIO;
> +				btrfs_err(fs_info,
> +					"failed to init missing dev %llu %ld",
> +					devid, PTR_ERR(map->stripes[i].dev));
> +				return PTR_ERR(map->stripes[i].dev);
>  			}
>  			btrfs_report_missing_device(fs_info, devid, uuid);
>  		}
> @@ -6582,8 +6585,8 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
>  		}
>  
>  		device = add_missing_dev(fs_devices, devid, dev_uuid);
> -		if (!device)
> -			return -ENOMEM;
> +		if (IS_ERR(device))
> +			return PTR_ERR(device);

Could you please also add a btrfs_err() like above?

With that,

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

-liubo

>  		btrfs_report_missing_device(fs_info, devid, dev_uuid);
>  	} else {
>  		if (!device->bdev) {
> -- 
> 2.7.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
