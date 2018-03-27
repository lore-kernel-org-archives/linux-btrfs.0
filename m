Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59612 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752082AbeC0IF4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 04:05:56 -0400
Subject: Re: [PATCH 2/8] btrfs: return required error from
 btrfs_check_super_csum
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180326082742.9235-1-anand.jain@oracle.com>
 <20180326082742.9235-3-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <4203fb44-3fd4-1e26-bf03-40d640de09af@suse.com>
Date: Tue, 27 Mar 2018 11:05:53 +0300
MIME-Version: 1.0
In-Reply-To: <20180326082742.9235-3-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 26.03.2018 11:27, Anand Jain wrote:
> Return the required -EINVAL and -EUCLEAN from the function
> btrfs_check_super_csum(). And more the error log into the
> parent function.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/disk-io.c | 27 ++++++++++++++++-----------
>  1 file changed, 16 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index b9b435579527..8b4e602ed60a 100644
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
> @@ -2570,9 +2568,16 @@ int open_ctree(struct super_block *sb,
>  	 * We want to check superblock checksum, the type is stored inside.
>  	 * Pass the whole disk block of size BTRFS_SUPER_INFO_SIZE (4k).
>  	 */
> -	if (btrfs_check_super_csum(fs_info, bh->b_data)) {
> -		btrfs_err(fs_info, "superblock checksum mismatch");
> -		err = -EINVAL;
> +	err = btrfs_check_super_csum(bh->b_data);
> +	if (err) {
> +		if (err == -EINVAL)
> +			pr_err("BTRFS error (device %pg): "\
> +				"unsupported checksum algorithm",
> +				fs_devices->latest_bdev);

I don't think strings should be idented. I.e the correct thing here
should be to have only fs_devices->latest_bdev on a new line, even if
the string goes above the char limit of 80. In any case the \ is not
needed due to gcc's support for string literal concatenation:

pr_err("BTRFS error (device %pg): "
       "unsupported checksum algorithm",
       fs_devices->latest_bdev)

should work equally well. But as I said I don't think this is even
needed. Let's wait and see what David says.

> +		else
> +			pr_err("BTRFS error (device %pg): "\
> +				"superblock checksum mismatch",
> +				fs_devices->latest_bdev);
>  		brelse(bh);
>  		goto fail_alloc;
>  	}
> 
