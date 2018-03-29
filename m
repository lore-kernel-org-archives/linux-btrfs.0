Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40262 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751927AbeC2MtR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Mar 2018 08:49:17 -0400
Subject: Re: [PATCH v2 2/7] btrfs: return required error from
 btrfs_check_super_csum
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180329103705.13566-1-anand.jain@oracle.com>
 <20180329103705.13566-3-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <362e2f2e-f3f1-6cb5-a7fd-90998a428e07@suse.com>
Date: Thu, 29 Mar 2018 15:49:09 +0300
MIME-Version: 1.0
In-Reply-To: <20180329103705.13566-3-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 29.03.2018 13:36, Anand Jain wrote:
> Return the required -EINVAL and -EUCLEAN from the function
> btrfs_check_super_csum(). And more the error log into the
> parent function.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> v1->v2:
>  Fix commit indent reported by checkpatch.pl
>  Fix pr_err split string

The change log has to go below the scissors line. I guess it can be
fixed at merge time so I don't think a resubmit is warranted.

There is one nit below but I don't think it's critical so :

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/disk-io.c | 25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index b9b435579527..4c573602480c 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -392,9 +392,10 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
>  /*
>   * Return 0 if the superblock checksum type matches the checksum value of that
>   * algorithm. Pass the raw disk superblock data.
> + * Otherwise:	-EINVAL  if csum type is not found
> + *		-EUCLEAN if csum does not match
>   */
> -static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
> -				  char *raw_disk_sb)
> +static int btrfs_check_super_csum(char *raw_disk_sb)
>  {
>  	struct btrfs_super_block *disk_sb =
>  		(struct btrfs_super_block *)raw_disk_sb;
> @@ -402,11 +403,8 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
>  	u32 crc = ~(u32)0;
>  	char result[sizeof(crc)];
>  
> -	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
> -		btrfs_err(fs_info, "unsupported checksum algorithm %u",
> -			  csum_type);
> -		return 1;
> -	}
> +	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes))
> +		return -EINVAL;
>  
>  	/*
>  	 * The super_block structure does not span the whole
> @@ -418,7 +416,7 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
>  	btrfs_csum_final(crc, result);
>  
>  	if (memcmp(raw_disk_sb, result, sizeof(result)))
> -		return 1;
> +		return -EUCLEAN;
>  
>  	return 0;
>  }
> @@ -2570,9 +2568,14 @@ int open_ctree(struct super_block *sb,
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
> +		else
> +			pr_err("BTRFS error (device %pg): superblock checksum mismatch",
> +				fs_devices->latest_bdev);

nit: I think your initial version of specifically checking for EUCLEAN
was better but I don't have strong preferences.
>  		brelse(bh);
>  		goto fail_alloc;
>  	}
> 
