Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34123 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751120AbeC0Lab (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 07:30:31 -0400
Subject: Re: [PATCH 6/8] btrfs: verify checksum when superblock is read for
 scan
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180326082742.9235-1-anand.jain@oracle.com>
 <20180326082742.9235-7-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <d44f6480-016f-2f32-c823-013011d66788@suse.com>
Date: Tue, 27 Mar 2018 14:30:28 +0300
MIME-Version: 1.0
In-Reply-To: <20180326082742.9235-7-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 26.03.2018 11:27, Anand Jain wrote:
> During the scan context, we aren't verifying the superblock-
> checksum when read.
> This patch fixes it by adding the checksum verification function
> btrfs_check_super_csum() in the function btrfs_read_disk_super().
> And makes device scan to error fail if the primary superblock csum
> is wrong, whereas if the copy-superblock csum is wrong it will just
> just report missmatch and continue mount/scan as usual. When the
> mount is successful We anyway overwrite all superblocks upon unmount.
> 
> The context in which this will be called is - device scan, device ready,
> and mount -o device option.
> 
> Test script:
> 
>  Corrupt primary superblock and check if device scan and mount
>  fails:
>  mkfs.btrfs -fq /dev/sdc
>  dd if=/dev/urandom of=/dev/sdc ibs=1 obs=1 count=1 seek=64K
>  btrfs dev scan
>  mount /dev/sdb /btrfs
> 
>  Corrupt secondary superblock and check if device scan and mount
>  is succcessful, check for the dmesg for errors.
>  mkfs.btrfs -fq /dev/sdc
>  dd if=/dev/urandom of=/dev/sdc ibs=1 obs=1 count=1 seek=64K
>  btrfs dev scan
>  mount /dev/sdb /btrfs

Have you considered adding fstests, it will be very easy to test for
this behavior?

> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/volumes.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 45dd0674571b..384e503c83ff 100644
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
> @@ -1177,6 +1178,20 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
>  	/* align our pointer to the offset of the super block */
>  	*disk_super = p + (bytenr & ~PAGE_MASK);
>  
> +	err = btrfs_check_super_csum((char *) *disk_super);
> +	if (err) {
if (err < 0)
> +		if (err == -EINVAL)
> +			pr_err("BTRFS error (device %pg): "\
> +				"unsupported checksum type, bytenr=%llu",
> +				bdev, bytenr);

Same comment as before regarding string literals splitting across lines.

> +		else
> +			pr_err("BTRFS error (device %pg): "\
> +				"superblock checksum failed, bytenr=%llu",
> +				bdev, bytenr);
> +		btrfs_release_disk_super(*page);
> +		return err;
> +	}
> +
>  	if (btrfs_super_bytenr(*disk_super) != bytenr ||
>  	    btrfs_super_magic(*disk_super) != BTRFS_MAGIC) {
>  		btrfs_release_disk_super(*page);
> 
