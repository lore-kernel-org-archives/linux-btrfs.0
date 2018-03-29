Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41369 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750858AbeC2M4V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Mar 2018 08:56:21 -0400
Subject: Re: [PATCH v2 4/7] btrfs: check if the fsid in the primary sb and
 copy sb are same
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180329103705.13566-1-anand.jain@oracle.com>
 <20180329103705.13566-5-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <36e7f186-0b9e-8dde-7be8-0afc7f279147@suse.com>
Date: Thu, 29 Mar 2018 15:56:18 +0300
MIME-Version: 1.0
In-Reply-To: <20180329103705.13566-5-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 29.03.2018 13:37, Anand Jain wrote:
> During the btrfs dev scan make sure that other copies of superblock
> contain the same fsid as the primary SB. So that we bring to the
> user notice if the superblock has been overwritten.
> 
>  mkfs.btrfs -fq /dev/sdc
>  mkfs.btrfs -fq /dev/sdb
>  dd if=/dev/sdb of=/dev/sdc count=4K skip=64K seek=64K obs=1 ibs=1
>  mount /dev/sdc /btrfs
> 
> Caveat: Pls note that older btrfs-progs do not wipe the non-overwriting
> stale superblock like copy2 if a smaller mkfs.btrfs -b  <size> is created.
> Thus this patch in the kernel will report error. The workaround is to wipe
> the superblock manually, like
>   dd if=/dev/zero of=<dev> seek=274877906944 ibs=1 obs=1 count4K
> OR apply the btrfs-progs patch
>   btrfs-progs: wipe copies of the stale superblock beyond -b size
> which shall find and wipe the non overwriting superblock during mkfs.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> v1->v2:
>   Do an explicit read for primary superblock. Drop kzalloc().
>   Fix split pr_err().

Same thing about the change log as in 2/7. Otherwise :

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/volumes.c | 48 ++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 38 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index e63723f23227..035affa447fa 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1198,39 +1198,67 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
>  int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>  			  struct btrfs_fs_devices **fs_devices_ret)
>  {
> +	struct btrfs_super_block *disk_super_primary;
>  	struct btrfs_super_block *disk_super;
>  	struct btrfs_device *device;
>  	struct block_device *bdev;
> +	struct page *page_primary;
>  	struct page *page;
>  	int ret = 0;
>  	u64 bytenr;
> +	int i;
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
> -	ret = btrfs_read_disk_super(bdev, bytenr, &page, &disk_super);
> +	/*
> +	 * We would like to check all the supers and use one good copy,
> +	 * but that would make a btrfs mount succeed after a mkfs from
> +	 * a different FS.
> +	 * So, we need to add a special mount option to scan for
> +	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead.
> +	 * So, just validate if all copies of the superblocks are ok
> +	 * and have the same fsid.
> +	 */
> +	bytenr = btrfs_sb_offset(0);
> +	ret = btrfs_read_disk_super(bdev, bytenr, &page_primary,
> +				    &disk_super_primary);
>  	if (ret < 0)
>  		goto error_bdev_put;
>  
> +	for (i = 1; i < BTRFS_SUPER_MIRROR_MAX; i++) {
> +		bytenr = btrfs_sb_offset(i);
> +		ret = btrfs_read_disk_super(bdev, bytenr, &page, &disk_super);
> +		if (ret < 0) {
> +			ret = 0;
> +			continue;
> +		}
> +
> +		if (memcmp(disk_super_primary->fsid, disk_super->fsid,
> +			   BTRFS_FSID_SIZE)) {
> +			pr_err("BTRFS (device %pg): superblock fsid mismatch, primary %pU copy%d %pU",
> +				bdev, disk_super_primary->fsid, i,
> +				disk_super->fsid);
> +			ret = -EINVAL;
> +			btrfs_release_disk_super(page);
> +			goto error_rel_primary;
> +		}
> +		btrfs_release_disk_super(page);
> +	}
> +
>  	mutex_lock(&uuid_mutex);
> -	device = device_list_add(path, disk_super);
> +	device = device_list_add(path, disk_super_primary);
>  	if (IS_ERR(device))
>  		ret = PTR_ERR(device);
>  	else
>  		*fs_devices_ret = device->fs_devices;
>  	mutex_unlock(&uuid_mutex);
>  
> -	btrfs_release_disk_super(page);
> +error_rel_primary:
> +	btrfs_release_disk_super(page_primary);
>  
>  error_bdev_put:
>  	blkdev_put(bdev, flags);
> 
