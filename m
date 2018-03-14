Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42421 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752354AbeCNPvO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 11:51:14 -0400
Date: Wed, 14 Mar 2018 16:48:50 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] btrfs: check for SB checksum when scanned
Message-ID: <20180314154850.GM32007@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180313150637.3913-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180313150637.3913-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 13, 2018 at 11:06:37PM +0800, Anand Jain wrote:
> We aren't checking the SB csum when the device scanned,
> instead we do that when mounting the device, and if the
> csum fails we fail the mount. How if we check the csum
> when the device is scanned, I can't see any reason for
> why not? any idea?
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/disk-io.c | 9 +++++----
>  fs/btrfs/disk-io.h | 2 ++
>  fs/btrfs/volumes.c | 4 ++++
>  3 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 156116655a32..28e71e2aaa92 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -393,8 +393,8 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
>   * Return 0 if the superblock checksum type matches the checksum value of that
>   * algorithm. Pass the raw disk superblock data.
>   */
> -static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
> -				  char *raw_disk_sb)
> +int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
> +			   char *raw_disk_sb)
>  {
>  	struct btrfs_super_block *disk_sb =
>  		(struct btrfs_super_block *)raw_disk_sb;
> @@ -420,8 +420,9 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
>  	}
>  
>  	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
> -		btrfs_err(fs_info, "unsupported checksum algorithm %u",
> -				csum_type);
> +		if (fs_info)
> +			btrfs_err(fs_info, "unsupported checksum algorithm %u",
> +				  csum_type);
>  		ret = 1;
>  	}
>  
> diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
> index 70a88d61b547..683e4b0c4e24 100644
> --- a/fs/btrfs/disk-io.h
> +++ b/fs/btrfs/disk-io.h
> @@ -70,6 +70,8 @@ struct buffer_head *btrfs_read_dev_super(struct block_device *bdev);
>  int btrfs_read_dev_one_super(struct block_device *bdev, int copy_num,
>  			struct buffer_head **bh_ret);
>  int btrfs_commit_super(struct btrfs_fs_info *fs_info);
> +int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
> +			   char *raw_disk_sb);
>  struct btrfs_root *btrfs_read_fs_root(struct btrfs_root *tree_root,
>  				      struct btrfs_key *location);
>  int btrfs_init_fs_root(struct btrfs_root *root);
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 1e72357bdfa8..af34b8a611a0 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -677,6 +677,10 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
>  	if (ret)
>  		return ret;
>  
> +	if (btrfs_check_super_csum(NULL, bh->b_data)) {

I think the error reports during scan should be minimized, in this case
each time the scan will be run on that device, the checksum mismatch
will be reported.

I don't really like to see the NULL passed to btrfs_check_super_csum but
it's still better than adding an extra parameter to set the verbosity.
Documenting that at btrfs_check_super_csum would be good, mentioning
that the function can be called from mount or scan.
