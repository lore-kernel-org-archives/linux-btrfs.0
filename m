Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46001 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751806AbeCTKLK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Mar 2018 06:11:10 -0400
Subject: Re: [PATCH 1/3] btrfs: cleanup btrfs_check_super_csum() to check the
 csum_type to the type
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180320095310.6355-1-anand.jain@oracle.com>
 <20180320095310.6355-2-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <2e0961a6-b92b-907b-4a60-a7e78b5a78cf@suse.com>
Date: Tue, 20 Mar 2018 12:11:06 +0200
MIME-Version: 1.0
In-Reply-To: <20180320095310.6355-2-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 20.03.2018 11:53, Anand Jain wrote:
> %csum_type is being checked to check the number of csum types we support,
> which is 1 as of now. Instead just check if the type matches with the
> only type we support, that is BTRFS_CSUM_TYPE_CRC32. And further adds
> cleanup.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/disk-io.c | 41 +++++++++++++++++++----------------------
>  1 file changed, 19 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 1657d6aa4fa6..582ed6af3c50 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -399,32 +399,29 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
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
> -	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
> +	/* We support csum type crc32 only as of now */
> +	if (csum_type != BTRFS_CSUM_TYPE_CRC32) {
>  		btrfs_err(fs_info, "unsupported checksum algorithm %u",
> -				csum_type);
> -		ret = 1;
> +			  csum_type);
> +		return 1;

I think it would make sense to return EINVAL here. Then the sole caller
of this function (open_ctree) can use the code a bit more idiomatically:

ret = btrfs_check_super_csum()

if (ret < 0) {
handle failure
}

Right now we return 1 on both when the function fails due to invalid CRC
algorithm and if the checksum doesn't match. And we are going to print 2
things: unsupported checksum algorithm and the
btrfs_err(fs_info, "superblock checksum mismatch");    from open_ctree.

Let's implemented proper error returning strategy for this function.



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

Perhaps return EUCLEAN i.e something is corrupted hence the checksum
didn't pan out as we expected.

> +
> +	return 0;
>  }
>  
>  /*
> 
