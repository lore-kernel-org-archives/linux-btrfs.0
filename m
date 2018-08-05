Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44184 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726509AbeHEVSp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 5 Aug 2018 17:18:45 -0400
Subject: Re: [PATCH 1/3] fs/btrfs/disk-io: Remove unneeded variable "err"
To: zhong jiang <zhongjiang@huawei.com>, clm@fb.com, jbacik@fb.com,
        dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1533481371-21349-1-git-send-email-zhongjiang@huawei.com>
 <1533481371-21349-2-git-send-email-zhongjiang@huawei.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <b999d05d-1f94-5f31-8b43-20e6bf4ebc3d@suse.com>
Date: Sun, 5 Aug 2018 22:13:07 +0300
MIME-Version: 1.0
In-Reply-To: <1533481371-21349-2-git-send-email-zhongjiang@huawei.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  5.08.2018 18:02, zhong jiang wrote:
> The err is not used after initalization, So remove it and make
> the function to be void function.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>

The ret value of this function is not checked by the sole caller
(btrfs_cleanup_one_transaction), however, this does not give you the
right to use a bulk commit message. If you want your future
contributions to be taken seriously please put actual effort in properly
describing your changes.


> ---
>  fs/btrfs/disk-io.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 468365d..34e4926 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -53,8 +53,8 @@
>  static const struct extent_io_ops btree_extent_io_ops;
>  static void end_workqueue_fn(struct btrfs_work *work);
>  static void btrfs_destroy_ordered_extents(struct btrfs_root *root);
> -static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
> -				      struct btrfs_fs_info *fs_info);
> +static void btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
> +				       struct btrfs_fs_info *fs_info);
>  static void btrfs_destroy_delalloc_inodes(struct btrfs_root *root);
>  static int btrfs_destroy_marked_extents(struct btrfs_fs_info *fs_info,
>  					struct extent_io_tree *dirty_pages,
> @@ -4179,13 +4179,12 @@ static void btrfs_destroy_all_ordered_extents(struct btrfs_fs_info *fs_info)
>  	spin_unlock(&fs_info->ordered_root_lock);
>  }
>  
> -static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
> -				      struct btrfs_fs_info *fs_info)
> +static void btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
> +				       struct btrfs_fs_info *fs_info)
>  {
>  	struct rb_node *node;
>  	struct btrfs_delayed_ref_root *delayed_refs;
>  	struct btrfs_delayed_ref_node *ref;
> -	int ret = 0;
>  
>  	delayed_refs = &trans->delayed_refs;
>  
> @@ -4193,7 +4192,6 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
>  	if (atomic_read(&delayed_refs->num_entries) == 0) {
>  		spin_unlock(&delayed_refs->lock);
>  		btrfs_info(fs_info, "delayed_refs has NO entry");
> -		return ret;
>  	}
>  
>  	while ((node = rb_first(&delayed_refs->href_root)) != NULL) {
> @@ -4247,8 +4245,6 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
>  	}
>  
>  	spin_unlock(&delayed_refs->lock);
> -
> -	return ret;
>  }
>  
>  static void btrfs_destroy_delalloc_inodes(struct btrfs_root *root)
> 
