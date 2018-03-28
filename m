Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33953 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752227AbeC1HVx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Mar 2018 03:21:53 -0400
Subject: Re: [PATCH v2 6/8] btrfs: verify superblock checksum during scan
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180327234000.23656-1-anand.jain@oracle.com>
 <20180327234000.23656-7-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <13c339bb-1beb-45e0-6504-dde4d2e806b5@suse.com>
Date: Wed, 28 Mar 2018 10:21:50 +0300
MIME-Version: 1.0
In-Reply-To: <20180327234000.23656-7-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 28.03.2018 02:39, Anand Jain wrote:
> During the scan context, we aren't verifying the superblock-
> checksum when read.
> This patch fixes it by adding the checksum verification function
> btrfs_check_super_csum() in the function btrfs_read_disk_super().
> And makes device scan to error fail if the primary superblock csum
> is wrong, whereas if the copy-superblock csum is wrong it will just
> just report mismatch and continue mount/scan as usual. When the

Where in this patch do you deal with the secondary sb.
btrfs_read_disk_super verifies only the primary sb which corresponds to
the first part of the sentence. But I'm confused about the second?

I also think that 4/8 should be merged into this one.

> mount is successful We anyway overwrite all superblocks upon unmount.
> 
> The context in which this will be called is - device scan, device ready,
> and mount -o device option.
> 
> Test script:
> 
>  Corrupt primary superblock and check if device scan and mount
>  fails:
>   mkfs.btrfs -fq /dev/sdc
>   dd if=/dev/urandom of=/dev/sdc ibs=1 obs=1 count=1 seek=64K
>   btrfs dev scan /dev/sdc
>   mount /dev/sdc /btrfs
> 
>  Corrupt secondary superblock and check if device scan and mount
>  is succcessful, check for the dmesg for errors.
>   mkfs.btrfs -fq /dev/sdc
>   dd if=/dev/urandom of=/dev/sdc ibs=1 obs=1 count=1 seek=67108864
>   btrfs dev scan /dev/sdc
>   mount /dev/sdc /btrfs
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v1->v2:
>  changed title.
>  use explicit (< 0) check for %errr.
>  Un-split pr_err() string.
>  Fix typo in the git commit log.
>  Move the csum check after bytenr and btrfs magic verified.
> 
>  fs/btrfs/volumes.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index b099823f60d1..eda86ba258fc 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1149,6 +1149,7 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
>  				 struct page **page,
>  				 struct btrfs_super_block **disk_super)
>  {
> +	int err;
>  	void *p;
>  	pgoff_t index;
>  
> @@ -1183,6 +1184,18 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
>  		return -EINVAL;
>  	}
>  
> +	err = btrfs_check_super_csum((char *) *disk_super);
> +	if (err < 0) {
> +		if (err == -EINVAL)
> +			pr_err("BTRFS error (device %pg): unsupported checksum type, bytenr=%llu",
> +				bdev, bytenr);
> +		else
> +			pr_err("BTRFS error (device %pg): superblock checksum failed, bytenr=%llu",
> +				bdev, bytenr);
> +		btrfs_release_disk_super(*page);
> +		return err;
> +	}
> +
>  	if ((*disk_super)->label[0] &&
>  		(*disk_super)->label[BTRFS_LABEL_SIZE - 1])
>  		(*disk_super)->label[BTRFS_LABEL_SIZE - 1] = '\0';
> 
