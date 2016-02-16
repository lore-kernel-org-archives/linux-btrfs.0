Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23762 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694AbcBPJNp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Feb 2016 04:13:45 -0500
Subject: Re: [PATCH 13/15] btrfs: use existing device constraints table
 btrfs_raid_array
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1455556900.git.dsterba@suse.com>
 <1294a3215cb0e28a81c33ed1b8921aae95043619.1455556900.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56C2E842.5010305@oracle.com>
Date: Tue, 16 Feb 2016 17:13:38 +0800
MIME-Version: 1.0
In-Reply-To: <1294a3215cb0e28a81c33ed1b8921aae95043619.1455556900.git.dsterba@suse.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



yep required optimization. Deleting from my todo list.

Reviewed-by: Anand Jain <anand.jain@oracle.com>


On 02/16/2016 01:34 AM, David Sterba wrote:
> We should avoid duplicating the device constraints, let's use the
> btrfs_raid_array in btrfs_check_raid_min_devices.
>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>   fs/btrfs/volumes.c | 23 +++++++++--------------
>   1 file changed, 9 insertions(+), 14 deletions(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index a67249582a6f..8fee24f92574 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1730,6 +1730,7 @@ static int btrfs_check_raid_min_devices(struct btrfs_fs_info *fs_info,
>   {
>   	u64 all_avail;
>   	unsigned seq;
> +	int i;
>
>   	do {
>   		seq = read_seqbegin(&fs_info->profiles_lock);
> @@ -1739,22 +1740,16 @@ static int btrfs_check_raid_min_devices(struct btrfs_fs_info *fs_info,
>   			    fs_info->avail_metadata_alloc_bits;
>   	} while (read_seqretry(&fs_info->profiles_lock, seq));
>
> -	if ((all_avail & BTRFS_BLOCK_GROUP_RAID10) && num_devices < 4) {
> -		return BTRFS_ERROR_DEV_RAID10_MIN_NOT_MET;
> -	}
> -
> -	if ((all_avail & BTRFS_BLOCK_GROUP_RAID1) && num_devices < 2) {
> -		return BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET;
> -	}
> +	for (i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
> +		if (!(all_avail & btrfs_raid_group[i]))
> +			continue;
>
> -	if ((all_avail & BTRFS_BLOCK_GROUP_RAID5) &&
> -	    fs_info->fs_devices->rw_devices < 2) {
> -		return BTRFS_ERROR_DEV_RAID5_MIN_NOT_MET;
> -	}
> +		if (num_devices < btrfs_raid_array[i].devs_min) {
> +			int ret = btrfs_raid_mindev_error[i];
>
> -	if ((all_avail & BTRFS_BLOCK_GROUP_RAID6) &&
> -	    fs_info->fs_devices->rw_devices < 3) {
> -		return BTRFS_ERROR_DEV_RAID6_MIN_NOT_MET;
> +			if (ret)
> +				return ret;
> +		}
>   	}
>
>   	return 0;
>
