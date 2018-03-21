Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38578 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751040AbeCUGZq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Mar 2018 02:25:46 -0400
Subject: Re: [PATCH v2 2/2] btrfs: return required error from
 btrfs_check_super_csum
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <cee99011-981a-f515-3a8c-601937ed2596@suse.com>
Date: Wed, 21 Mar 2018 08:25:44 +0200
MIME-Version: 1.0
In-Reply-To: <20180320233316.20653-3-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20180320233316.20653-1-anand.jain@oracle.com>
 <20180320233316.20653-3-anand.jain@oracle.com>



On 21.03.2018 01:33, Anand Jain wrote:
> Return the required -EINVAL and -EUCLEAN from the function
> btrfs_check_super_csum(). And more the error log into the
> parent function.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/disk-io.c | 28 +++++++++++++++++-----------
>  1 file changed, 17 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 582ed6af3c50..4c6de2743250 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -392,9 +392,10 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
>  /*
>   * Return 0 if the superblock checksum type matches the checksum value of that
>   * algorithm. Pass the raw disk superblock data.
> + * Otherwise: -EINVAL  if csum type is not found
> + * 	      -EUCLEAN if csum does not match
>   */
> -static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
> -				  char *raw_disk_sb)
> +static int btrfs_check_super_csum(char *raw_disk_sb)
>  {
>  	struct btrfs_super_block *disk_sb =
>  		(struct btrfs_super_block *)raw_disk_sb;
> @@ -403,11 +404,8 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
>  	char result[sizeof(crc)];
>  
>  	/* We support csum type crc32 only as of now */
> -	if (csum_type != BTRFS_CSUM_TYPE_CRC32) {
> -		btrfs_err(fs_info, "unsupported checksum algorithm %u",
> -			  csum_type);
> -		return 1;
> -	}
> +	if (csum_type != BTRFS_CSUM_TYPE_CRC32)
> +		return -EINVAL;
>  
>  	/*
>  	 * The super_block structure does not span the whole
> @@ -419,7 +417,7 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
>  	btrfs_csum_final(crc, result);
>  
>  	if (memcmp(raw_disk_sb, result, sizeof(result)))
> -		return 1;
> +		return -EUCLEAN;
>  
>  	return 0;
>  }
> @@ -2571,9 +2569,17 @@ int open_ctree(struct super_block *sb,
>  	 * We want to check superblock checksum, the type is stored inside.
>  	 * Pass the whole disk block of size BTRFS_SUPER_INFO_SIZE (4k).
>  	 */
> -	if (btrfs_check_super_csum(fs_info, bh->b_data)) {
> -		btrfs_err(fs_info, "superblock checksum mismatch");
> -		err = -EINVAL;
> +	err = btrfs_check_super_csum(bh->b_data);
> +	if (err) {
> +		if (err == -EINVAL)
> +			pr_err("BTRFS error (device %pg): unsupported checksum algorithm",
> +				fs_devices->latest_bdev);
> +		else if (err == -EUCLEAN)
> +			pr_err("BTRFS error (device %pg): superblock checksum mismatch",
> +				fs_devices->latest_bdev);
> +		else
> +			pr_err("BTRFS error (device %pg): checksum check failed %d",
> +				fs_devices->latest_bdev, err);

This is redundant, it's never going to be executed since only
EINVAL/EUCLEAN is returned.


>  		brelse(bh);
>  		goto fail_alloc;
>  	}
> 
