Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:45133 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751994AbdCGFOJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Mar 2017 00:14:09 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v274iM3A002284
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 7 Mar 2017 04:44:22 GMT
Subject: Re: [PATCH v2 6/6] btrfs: Enhance missing device kernel message
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20170306085855.11403-1-quwenruo@cn.fujitsu.com>
 <20170306085855.11403-7-quwenruo@cn.fujitsu.com>
Cc: lists@colorremedies.com
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <9a8f6482-63d9-7079-7431-0fe1ad140918@oracle.com>
Date: Tue, 7 Mar 2017 12:47:55 +0800
MIME-Version: 1.0
In-Reply-To: <20170306085855.11403-7-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/06/2017 04:58 PM, Qu Wenruo wrote:
> For missing device, btrfs will just refuse to mount with almost
> meaningless kernel message like:
>
>  BTRFS info (device vdb6): disk space caching is enabled
>  BTRFS info (device vdb6): has skinny extents
>  BTRFS error (device vdb6): failed to read the system array: -5
>  BTRFS error (device vdb6): open_ctree failed
>
> This patch will add extra device missing output, making the result to:
>
>  BTRFS info (device vdb6): disk space caching is enabled
>  BTRFS info (device vdb6): has skinny extents
>  BTRFS warning (device vdb6): devid 2 uuid 80470722-cad2-4b90-b7c3-fee294552f1b is missing
>  BTRFS error (device vdb6): failed to read the system array: -5
>  BTRFS error (device vdb6): open_ctree failed


Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand


> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  fs/btrfs/volumes.c | 25 ++++++++++++++++++-------
>  fs/btrfs/volumes.h |  2 ++
>  2 files changed, 20 insertions(+), 7 deletions(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 72c78f096755..b33e96495934 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -6442,6 +6442,7 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
>  		if (!map->stripes[i].dev &&
>  		    !btrfs_test_opt(fs_info, DEGRADED)) {
>  			free_extent_map(em);
> +			btrfs_report_missing_device(fs_info, devid, uuid);
>  			return -EIO;
>  		}
>  		if (!map->stripes[i].dev) {
> @@ -6452,8 +6453,7 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
>  				free_extent_map(em);
>  				return -EIO;
>  			}
> -			btrfs_warn(fs_info, "devid %llu uuid %pU is missing",
> -				   devid, uuid);
> +			btrfs_report_missing_device(fs_info, devid, uuid);
>  		}
>  		map->stripes[i].dev->in_fs_metadata = 1;
>  	}
> @@ -6570,17 +6570,21 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
>
>  	device = btrfs_find_device(fs_info, devid, dev_uuid, fs_uuid);
>  	if (!device) {
> -		if (!btrfs_test_opt(fs_info, DEGRADED))
> +		if (!btrfs_test_opt(fs_info, DEGRADED)) {
> +			btrfs_report_missing_device(fs_info, devid, dev_uuid);
>  			return -EIO;
> +		}
>
>  		device = add_missing_dev(fs_devices, devid, dev_uuid);
>  		if (!device)
>  			return -ENOMEM;
> -		btrfs_warn(fs_info, "devid %llu uuid %pU missing",
> -				devid, dev_uuid);
> +		btrfs_report_missing_device(fs_info, devid, dev_uuid);
>  	} else {
> -		if (!device->bdev && !btrfs_test_opt(fs_info, DEGRADED))
> -			return -EIO;
> +		if (!device->bdev) {
> +			btrfs_report_missing_device(fs_info, devid, dev_uuid);
> +			if (!btrfs_test_opt(fs_info, DEGRADED))
> +				return -EIO;
> +		}
>
>  		if(!device->bdev && !device->missing) {
>  			/*
> @@ -6591,6 +6595,7 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
>  			 */
>  			device->fs_devices->missing_devices++;
>  			device->missing = 1;
> +			btrfs_report_missing_device(fs_info, devid, dev_uuid);
>  		}
>
>  		/* Move the device to its own fs_devices */
> @@ -6748,6 +6753,12 @@ int btrfs_read_sys_array(struct btrfs_fs_info *fs_info)
>  	return -EIO;
>  }
>
> +void btrfs_report_missing_device(struct btrfs_fs_info *fs_info, u64 devid,
> +				 u8 *uuid)
> +{
> +	btrfs_warn_rl(fs_info, "devid %llu uuid %pU is missing", devid, uuid);
> +}
> +
>  /*
>   * Check if all chunks in the fs is OK for read-write degraded mount
>   *
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 112fccacdabc..4f981b75958d 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -543,4 +543,6 @@ void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info);
>  void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
>
>  bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info);
> +void btrfs_report_missing_device(struct btrfs_fs_info *fs_info, u64 devid,
> +				 u8 *uuid);
>  #endif
>
