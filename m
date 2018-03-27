Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40839 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752123AbeC0MKf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 08:10:35 -0400
Subject: Re: [PATCH 4/8] btrfs: make btrfs_check_super_csum() non-static
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180326082742.9235-1-anand.jain@oracle.com>
 <20180326082742.9235-5-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <3337e0a0-432c-2f39-f084-10162431e0cb@suse.com>
Date: Tue, 27 Mar 2018 15:10:33 +0300
MIME-Version: 1.0
In-Reply-To: <20180326082742.9235-5-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 26.03.2018 11:27, Anand Jain wrote:
> In preparation to add the superblock csum verification for the
> scan context, make btrfs_check_super_csum() non-static.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/disk-io.c | 2 +-
>  fs/btrfs/disk-io.h | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 8b4e602ed60a..6299ab18da5f 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -395,7 +395,7 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
>   * Otherwise: -EINVAL  if csum type is not found
>   * 	      -EUCLEAN if csum does not match
>   */
> -static int btrfs_check_super_csum(char *raw_disk_sb)
> +int btrfs_check_super_csum(char *raw_disk_sb)
>  {
>  	struct btrfs_super_block *disk_sb =
>  		(struct btrfs_super_block *)raw_disk_sb;
> diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
> index 70a88d61b547..c400cc68f913 100644
> --- a/fs/btrfs/disk-io.h
> +++ b/fs/btrfs/disk-io.h
> @@ -69,6 +69,7 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors);
>  struct buffer_head *btrfs_read_dev_super(struct block_device *bdev);
>  int btrfs_read_dev_one_super(struct block_device *bdev, int copy_num,
>  			struct buffer_head **bh_ret);
> +int btrfs_check_super_csum(char *raw_disk_sb);
>  int btrfs_commit_super(struct btrfs_fs_info *fs_info);
>  struct btrfs_root *btrfs_read_fs_root(struct btrfs_root *tree_root,
>  				      struct btrfs_key *location);
> 
