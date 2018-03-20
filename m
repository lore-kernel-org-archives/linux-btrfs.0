Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50005 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751552AbeCTLK5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Mar 2018 07:10:57 -0400
Subject: Re: [PATCH 3/3] btrfs: refactor btrfs_check_super_csum() for scan
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180320095310.6355-1-anand.jain@oracle.com>
 <20180320095310.6355-4-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <dd091687-5779-7200-d165-c8f6acf2935c@suse.com>
Date: Tue, 20 Mar 2018 13:10:54 +0200
MIME-Version: 1.0
In-Reply-To: <20180320095310.6355-4-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 20.03.2018 11:53, Anand Jain wrote:
> In preparation to use the function btrfs_check_super_csum() for
> the device scan context, make it nonstatic and pass the
> struct block_device instead of the struct fs_info.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/disk-io.c | 12 ++++++------
>  fs/btrfs/disk-io.h |  1 +
>  2 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index aafd836af61d..d2ace2dca9de 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -393,8 +393,7 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
>   * Return 0 if the superblock checksum type matches the checksum value of that
>   * algorithm. Pass the raw disk superblock data.
>   */
> -static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
> -				  char *raw_disk_sb)
> +int btrfs_check_super_csum(struct block_device *bdev, char *raw_disk_sb)
>  {

Since this has become a public function and you've changed the fs_info
parameter to taking a bdev, which is not used for anything else than
printing the error I think it's appropriate to document which block
device should be passed to this function.

Also passing the block device only for printing purposes seems a bit odd.

>  	struct btrfs_super_block *disk_sb =
>  		(struct btrfs_super_block *)raw_disk_sb;
> @@ -404,8 +403,8 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
>  
>  	/* We support csum type crc32 only as of now */
>  	if (csum_type != BTRFS_CSUM_TYPE_CRC32) {
> -		btrfs_err(fs_info, "unsupported checksum algorithm %u",
> -			  csum_type);
> +		pr_err("BTRFS error (device %pg): unsupported checksum algorithm %u",
> +			bdev, csum_type);
>  		return -EINVAL;
>  	}
>  
> @@ -419,7 +418,8 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
>  	btrfs_csum_final(crc, result);
>  
>  	if (memcmp(raw_disk_sb, result, sizeof(result))) {
> -		btrfs_err(fs_info, "superblock checksum mismatch");
> +		pr_err("BTRFS error (device %pg): superblock checksum mismatch",
> +			bdev);
>  		return -EINVAL;
>  	}
>  
> @@ -2573,7 +2573,7 @@ int open_ctree(struct super_block *sb,
>  	 * We want to check superblock checksum, the type is stored inside.
>  	 * Pass the whole disk block of size BTRFS_SUPER_INFO_SIZE (4k).
>  	 */
> -	err = btrfs_check_super_csum(fs_info, bh->b_data);
> +	err = btrfs_check_super_csum(fs_devices->latest_bdev, bh->b_data);
>  	if (err) {
>  		brelse(bh);
>  		goto fail_alloc;
> diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
> index 70a88d61b547..1427fa1181d4 100644
> --- a/fs/btrfs/disk-io.h
> +++ b/fs/btrfs/disk-io.h
> @@ -69,6 +69,7 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors);
>  struct buffer_head *btrfs_read_dev_super(struct block_device *bdev);
>  int btrfs_read_dev_one_super(struct block_device *bdev, int copy_num,
>  			struct buffer_head **bh_ret);
> +int btrfs_check_super_csum(struct block_device *bdev, char *raw_disk_sb);
>  int btrfs_commit_super(struct btrfs_fs_info *fs_info);
>  struct btrfs_root *btrfs_read_fs_root(struct btrfs_root *tree_root,
>  				      struct btrfs_key *location);
> 
