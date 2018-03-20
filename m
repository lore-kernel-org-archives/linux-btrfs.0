Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46115 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752015AbeCTKNe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Mar 2018 06:13:34 -0400
Subject: Re: [PATCH 2/3] btrfs: return required error from
 btrfs_check_super_csum
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180320095310.6355-1-anand.jain@oracle.com>
 <20180320095310.6355-3-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <fc5778d9-1674-395b-c010-571d96b0228a@suse.com>
Date: Tue, 20 Mar 2018 12:13:32 +0200
MIME-Version: 1.0
In-Reply-To: <20180320095310.6355-3-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 20.03.2018 11:53, Anand Jain wrote:
> Return the required -EINVAL from the function btrfs_check_super_csum()
> and move the error logging into the btrfs_check_super_csum() itself.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/disk-io.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 582ed6af3c50..aafd836af61d 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -406,7 +406,7 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
>  	if (csum_type != BTRFS_CSUM_TYPE_CRC32) {
>  		btrfs_err(fs_info, "unsupported checksum algorithm %u",
>  			  csum_type);
> -		return 1;
> +		return -EINVAL;
>  	}
>  
>  	/*
> @@ -418,8 +418,10 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
>  			      crc, BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
>  	btrfs_csum_final(crc, result);
>  
> -	if (memcmp(raw_disk_sb, result, sizeof(result)))
> -		return 1;
> +	if (memcmp(raw_disk_sb, result, sizeof(result))) {
> +		btrfs_err(fs_info, "superblock checksum mismatch");
> +		return -EINVAL;

Don't we want EUCLEAN here, since an error in the checksum indicates
corruption?

> +	}
>  
>  	return 0;
>  }
> @@ -2571,9 +2573,8 @@ int open_ctree(struct super_block *sb,
>  	 * We want to check superblock checksum, the type is stored inside.
>  	 * Pass the whole disk block of size BTRFS_SUPER_INFO_SIZE (4k).
>  	 */
> -	if (btrfs_check_super_csum(fs_info, bh->b_data)) {
> -		btrfs_err(fs_info, "superblock checksum mismatch");
> -		err = -EINVAL;
> +	err = btrfs_check_super_csum(fs_info, bh->b_data);
> +	if (err) {
>  		brelse(bh);
>  		goto fail_alloc;
>  	}
> 
