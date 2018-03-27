Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40792 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751241AbeC0MKS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 08:10:18 -0400
Subject: Re: [PATCH 1/8] btrfs: cleanup btrfs_check_super_csum() for better
 code flow
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180326082742.9235-1-anand.jain@oracle.com>
 <20180326082742.9235-2-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <da1fd182-5ed8-f39e-6e21-3d064e98b7ae@suse.com>
Date: Tue, 27 Mar 2018 15:10:16 +0300
MIME-Version: 1.0
In-Reply-To: <20180326082742.9235-2-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 26.03.2018 11:27, Anand Jain wrote:
> We check the %csum_type twice. Drop one. Check for the csum_type and
> then for the csum. Which also matches with the progs which have better
> logic. This is preparatory patch to get proper error code from
> btrfs_check_super_csum().
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/disk-io.c | 38 +++++++++++++++++---------------------
>  1 file changed, 17 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 1657d6aa4fa6..b9b435579527 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -399,32 +399,28 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
>  	struct btrfs_super_block *disk_sb =
>  		(struct btrfs_super_block *)raw_disk_sb;
>  	u16 csum_type = btrfs_super_csum_type(disk_sb);
> -	int ret = 0;
> -
> -	if (csum_type == BTRFS_CSUM_TYPE_CRC32) {
> -		u32 crc = ~(u32)0;
> -		char result[sizeof(crc)];
> -
> -		/*
> -		 * The super_block structure does not span the whole
> -		 * BTRFS_SUPER_INFO_SIZE range, we expect that the unused space
> -		 * is filled with zeros and is included in the checksum.
> -		 */
> -		crc = btrfs_csum_data(raw_disk_sb + BTRFS_CSUM_SIZE,
> -				crc, BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
> -		btrfs_csum_final(crc, result);
> -
> -		if (memcmp(raw_disk_sb, result, sizeof(result)))
> -			ret = 1;
> -	}
> +	u32 crc = ~(u32)0;
> +	char result[sizeof(crc)];
>  
>  	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
>  		btrfs_err(fs_info, "unsupported checksum algorithm %u",
> -				csum_type);
> -		ret = 1;
> +			  csum_type);
> +		return 1;
>  	}
>  
> -	return ret;
> +	/*
> +	 * The super_block structure does not span the whole
> +	 * BTRFS_SUPER_INFO_SIZE range, we expect that the unused space
> +	 * is filled with zeros and is included in the checksum.
> +	 */
> +	crc = btrfs_csum_data(raw_disk_sb + BTRFS_CSUM_SIZE,
> +			      crc, BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
> +	btrfs_csum_final(crc, result);
> +
> +	if (memcmp(raw_disk_sb, result, sizeof(result)))
> +		return 1;
> +
> +	return 0;
>  }
>  
>  /*
> 
