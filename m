Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38236 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755039AbeCVNOM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 09:14:12 -0400
Subject: Re: [PATCH v2] btrfs: check if the fsid in the primary sb and copy sb
 are same
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180322130141.19894-1-anand.jain@oracle.com>
 <20180322130141.19894-2-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <c94f946d-1447-8644-b6e3-49f7a27d16d3@suse.com>
Date: Thu, 22 Mar 2018 15:14:07 +0200
MIME-Version: 1.0
In-Reply-To: <20180322130141.19894-2-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 22.03.2018 15:01, Anand Jain wrote:
> During the btrfs dev scan make sure that other copies of superblock
> contain the same fsid as the primary SB. So that we bring to the
> users notice if the superblock has been overwritten.
> 
>  mkfs.btrfs -fq /dev/sdc
>  mkfs.btrfs -fq /dev/sdb
>  dd if=/dev/sdb of=/dev/sdc count=4K skip=64K seek=64K obs=1 ibs=1
>  mount /dev/sdc /btrfs
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/volumes.c | 43 ++++++++++++++++++++++++++++++++-----------
>  1 file changed, 32 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 87d183accdb2..b79e3ffd2047 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1203,24 +1203,45 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>  	struct block_device *bdev;
>  	struct page *page;
>  	int ret = 0;
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
>  	flags |= FMODE_EXCL;
>  
>  	bdev = blkdev_get_by_path(path, flags, holder);
>  	if (IS_ERR(bdev))
>  		return PTR_ERR(bdev);
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

So the code per-se makes sense. However, have you came across such a
case in the real world or are you just fixing a theoretical (but real)
issue?

>  	}
>  
>  	mutex_lock(&uuid_mutex);
> 
