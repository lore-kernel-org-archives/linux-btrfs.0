Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20369 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481AbcBPJIc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Feb 2016 04:08:32 -0500
Subject: Re: [PATCH 11/15] btrfs: pass number of devices to
 btrfs_check_raid_min_devices
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1455556900.git.dsterba@suse.com>
 <83c7c8cf473c48f6dd8eaccb2d80fcc84cf8919e.1455556900.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56C2E70B.80502@oracle.com>
Date: Tue, 16 Feb 2016 17:08:27 +0800
MIME-Version: 1.0
In-Reply-To: <83c7c8cf473c48f6dd8eaccb2d80fcc84cf8919e.1455556900.git.dsterba@suse.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



looks good.

Reviewed-by: Anand Jain <anand.jain@oracle.com>
Tested-by: Anand Jain <anand.jain@oracle.com>

Thanks.

On 02/16/2016 01:34 AM, David Sterba wrote:
> Before this patch, btrfs_check_raid_min_devices would do an off-by-one
> check of the constraints and not the miminmum check, as its name
> suggests. This is not a problem if the only caller is device remove, but
> would be confusing for others.
>
> Add an argument with the exact number and let the caller(s) decide if
> this needs any adjustments, like when device replace is running.
>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>   fs/btrfs/volumes.c | 35 ++++++++++++++++++++---------------
>   1 file changed, 20 insertions(+), 15 deletions(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 4fa4a836a072..ae94e06f3e61 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1705,20 +1705,17 @@ static int btrfs_rm_dev_item(struct btrfs_root *root,
>   	return ret;
>   }
>
> -static int btrfs_check_raid_min_devices(struct btrfs_fs_info *fs_info)
> +/*
> + * Verify that @num_devices satisfies the RAID profile constraints in the whole
> + * filesystem. It's up to the caller to adjust that number regarding eg. device
> + * replace.
> + */
> +static int btrfs_check_raid_min_devices(struct btrfs_fs_info *fs_info,
> +		u64 num_devices)
>   {
>   	u64 all_avail;
> -	u64 num_devices;
>   	unsigned seq;
>
> -	num_devices = fs_info->fs_devices->num_devices;
> -	btrfs_dev_replace_lock(&fs_info->dev_replace);
> -	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
> -		WARN_ON(num_devices < 1);
> -		num_devices--;
> -	}
> -	btrfs_dev_replace_unlock(&fs_info->dev_replace);
> -
>   	do {
>   		seq = read_seqbegin(&fs_info->profiles_lock);
>
> @@ -1727,21 +1724,21 @@ static int btrfs_check_raid_min_devices(struct btrfs_fs_info *fs_info)
>   			    fs_info->avail_metadata_alloc_bits;
>   	} while (read_seqretry(&fs_info->profiles_lock, seq));
>
> -	if ((all_avail & BTRFS_BLOCK_GROUP_RAID10) && num_devices <= 4) {
> +	if ((all_avail & BTRFS_BLOCK_GROUP_RAID10) && num_devices < 4) {
>   		return BTRFS_ERROR_DEV_RAID10_MIN_NOT_MET;
>   	}
>
> -	if ((all_avail & BTRFS_BLOCK_GROUP_RAID1) && num_devices <= 2) {
> +	if ((all_avail & BTRFS_BLOCK_GROUP_RAID1) && num_devices < 2) {
>   		return BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET;
>   	}
>
>   	if ((all_avail & BTRFS_BLOCK_GROUP_RAID5) &&
> -	    fs_info->fs_devices->rw_devices <= 2) {
> +	    fs_info->fs_devices->rw_devices < 2) {
>   		return BTRFS_ERROR_DEV_RAID5_MIN_NOT_MET;
>   	}
>
>   	if ((all_avail & BTRFS_BLOCK_GROUP_RAID6) &&
> -	    fs_info->fs_devices->rw_devices <= 3) {
> +	    fs_info->fs_devices->rw_devices < 3) {
>   		return BTRFS_ERROR_DEV_RAID6_MIN_NOT_MET;
>   	}
>
> @@ -1760,7 +1757,15 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path, u64 devid)
>
>   	mutex_lock(&uuid_mutex);
>
> -	ret = btrfs_check_raid_min_devices(root->fs_info);
> +	num_devices = root->fs_info->fs_devices->num_devices;
> +	btrfs_dev_replace_lock(&root->fs_info->dev_replace);
> +	if (btrfs_dev_replace_is_ongoing(&root->fs_info->dev_replace)) {
> +		WARN_ON(num_devices < 1);
> +		num_devices--;
> +	}
> +	btrfs_dev_replace_unlock(&root->fs_info->dev_replace);
> +
> +	ret = btrfs_check_raid_min_devices(root->fs_info, num_devices - 1);
>   	if (ret)
>   		goto out;
>
>
