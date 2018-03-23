Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:33686 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750789AbeCWJhk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Mar 2018 05:37:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2N9bdjM137485
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Mar 2018 09:37:39 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2gvy48g002-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Mar 2018 09:37:39 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w2N9bd4P002324
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Mar 2018 09:37:39 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w2N9bdb5017253
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Mar 2018 09:37:39 GMT
Subject: Re: [PATCH v2] btrfs: check if the fsid in the primary sb and copy sb
 are same
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
References: <20180322130141.19894-1-anand.jain@oracle.com>
 <20180322130141.19894-2-anand.jain@oracle.com>
Message-ID: <f1ff565b-86f7-64f7-4fea-b7d0de00aa53@oracle.com>
Date: Fri, 23 Mar 2018 17:39:31 +0800
MIME-Version: 1.0
In-Reply-To: <20180322130141.19894-2-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  Pls, ignore this. I need to handle the mapped page in a better way.

Thanks, Anand

On 03/22/2018 09:01 PM, Anand Jain wrote:
> During the btrfs dev scan make sure that other copies of superblock
> contain the same fsid as the primary SB. So that we bring to the
> users notice if the superblock has been overwritten.
> 
>   mkfs.btrfs -fq /dev/sdc
>   mkfs.btrfs -fq /dev/sdb
>   dd if=/dev/sdb of=/dev/sdc count=4K skip=64K seek=64K obs=1 ibs=1
>   mount /dev/sdc /btrfs
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>   fs/btrfs/volumes.c | 43 ++++++++++++++++++++++++++++++++-----------
>   1 file changed, 32 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 87d183accdb2..b79e3ffd2047 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1203,24 +1203,45 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>   	struct block_device *bdev;
>   	struct page *page;
>   	int ret = 0;
> -	u64 bytenr;
> +	int i;
> +	u8 fsid_tmp[BTRFS_FSID_SIZE];
>   
> -	/*
> -	 * we would like to check all the supers, but that would make
> -	 * a btrfs mount succeed after a mkfs from a different FS.
> -	 * So, we need to add a special mount option to scan for
> -	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead
> -	 */
> -	bytenr = btrfs_sb_offset(0);
>   	flags |= FMODE_EXCL;
>   
>   	bdev = blkdev_get_by_path(path, flags, holder);
>   	if (IS_ERR(bdev))
>   		return PTR_ERR(bdev);
>   
> -	if (btrfs_read_disk_super(bdev, bytenr, &page, &disk_super)) {
> -		ret = -EINVAL;
> -		goto error_bdev_put;
> +	/*
> +	 * We would like to check all the supers and use one good copy,
> +	 * but that would make a btrfs mount succeed after a mkfs from
> +	 * a different FS.
> +	 * So, we need to add a special mount option to scan for
> +	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead.
> +	 * So, just validate if all copies of the superblocks are ok
> +	 * and have the same fsid.
> +	 */
> +	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
> +		u64 bytenr = btrfs_sb_offset(i);
> +
> +		if (btrfs_read_disk_super(bdev, bytenr, &page, &disk_super)) {
> +			if (i != 0)
> +				continue;
> +			ret = -EINVAL;
> +			goto error_bdev_put;
> +		}
> +		if (i == 0) {
> +			memcpy(fsid_tmp, disk_super->fsid, BTRFS_FSID_SIZE);
> +			continue;
> +		}
> +
> +		if (memcmp(fsid_tmp, disk_super->fsid, BTRFS_FSID_SIZE)) {
> +			pr_err("BTRFS: (device %pg) SB copy#%d fsid %pU "\
> +				"doesn't match with the primary SB fsid %pU\n",
> +				bdev, i, disk_super->fsid, fsid_tmp);
> +			ret = -EINVAL;
> +			goto error_bdev_put;
> +		}
>   	}
>   
>   	mutex_lock(&uuid_mutex);
> 
