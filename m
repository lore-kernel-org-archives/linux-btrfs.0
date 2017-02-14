Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42172 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751714AbdBNCNv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 21:13:51 -0500
Date: Mon, 13 Feb 2017 18:11:56 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 11/29] btrfs: remove unused parameter from
 btrfs_check_super_valid
Message-ID: <20170214021156.GC24037@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1486977711.git.dsterba@suse.com>
 <30b7866b2b154b6bbdf3959dfd4ecc754e78c208.1486977712.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <30b7866b2b154b6bbdf3959dfd4ecc754e78c208.1486977712.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2017 at 10:33:55AM +0100, David Sterba wrote:
> None of the checks need to know the RO/RW status.
>

OK...there was a readonly check, which lets us skip all checks,
it was removed by the below commit, should we add the check back?

commit 1104a8855109a4051d74977f819a13b4516aa11e
Author: David Sterba <dsterba@suse.cz>
Date:   Wed Mar 6 15:57:46 2013 +0100

btrfs: enhance superblock checks

The superblock checksum is not verified upon mount. <awkward silence>

Add that check and also reorder existing checks to a more logical
order.

Current mkfs.btrfs does not calculate the correct checksum of
super_block and thus a freshly created filesytem will fail to mount when
this patch is applied.

First transaction commit calculates correct superblock checksum and
saves it to disk.

Reproducer:
$ mfks.btrfs /dev/sda
$ mount /dev/sda /mnt
$ btrfs scrub start /mnt
$ sleep 5
$ btrfs scrub status /mnt
... super:2 ...

Signed-off-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Chris Mason <chris.mason@fusionio.com>

Thanks,

-liubo

> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/disk-io.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 441a62cd0351..2b06f557c176 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -64,8 +64,7 @@
>  static const struct extent_io_ops btree_extent_io_ops;
>  static void end_workqueue_fn(struct btrfs_work *work);
>  static void free_fs_root(struct btrfs_root *root);
> -static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
> -				    int read_only);
> +static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info);
>  static void btrfs_destroy_ordered_extents(struct btrfs_root *root);
>  static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
>  				      struct btrfs_fs_info *fs_info);
> @@ -2801,7 +2800,7 @@ int open_ctree(struct super_block *sb,
>  
>  	memcpy(fs_info->fsid, fs_info->super_copy->fsid, BTRFS_FSID_SIZE);
>  
> -	ret = btrfs_check_super_valid(fs_info, sb->s_flags & MS_RDONLY);
> +	ret = btrfs_check_super_valid(fs_info);
>  	if (ret) {
>  		btrfs_err(fs_info, "superblock contains fatal errors");
>  		err = -EINVAL;
> @@ -4115,8 +4114,7 @@ int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid)
>  	return btree_read_extent_buffer_pages(fs_info, buf, parent_transid);
>  }
>  
> -static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
> -			      int read_only)
> +static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
>  {
>  	struct btrfs_super_block *sb = fs_info->super_copy;
>  	u64 nodesize = btrfs_super_nodesize(sb);
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
