Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:33935 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752958Ab3LPJDQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 04:03:16 -0500
Message-ID: <52AEC221.70708@cn.fujitsu.com>
Date: Mon, 16 Dec 2013 17:04:33 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/3] Btrfs: avoid building inode cache repeatly
References: <1387178735-30832-1-git-send-email-bo.li.liu@oracle.com> <1387178735-30832-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1387178735-30832-2-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	mon, 16 Dec 2013 15:25:33 +0800, Liu Bo wrote:
> Inode cache is similar to free space cache and in fact shares the same
> code, however, we don't load inode cache unless we're about to allocate
> inode id, then there is a case where we only commit the transaction during
> other operations, such as snapshot creation, we now update fs roots' generation
> to the new transaction id, after that when we want to load the inode cache,
> we'll find that it's not valid thanks to the mismatch of generation, and we
> have to push btrfs-ino-cache thread to build inode cache from disk, and
> this operation is sometimes time-costing.
> 
> So to fix the above, we load inode cache into memory during reading fs root.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
> v2: fix race issue pointed by Miao.
> 
>  fs/btrfs/disk-io.c   | 3 +++
>  fs/btrfs/inode-map.c | 6 ++++++
>  fs/btrfs/inode-map.h | 1 +
>  fs/btrfs/root-tree.c | 3 +++
>  4 files changed, 13 insertions(+)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 8072cfa..59af2aa 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1630,6 +1630,9 @@ again:
>  		}
>  		goto fail;
>  	}
> +
> +	btrfs_start_ino_caching(root);
> +
>  	return root;
>  fail:
>  	free_fs_root(root);
> diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
> index ab485e5..f23b0df 100644
> --- a/fs/btrfs/inode-map.c
> +++ b/fs/btrfs/inode-map.c
> @@ -179,6 +179,12 @@ static void start_caching(struct btrfs_root *root)
>  	BUG_ON(IS_ERR(tsk)); /* -ENOMEM */
>  }
>  
> +void btrfs_start_ino_caching(struct btrfs_root *root)
> +{
> +	if (root)
> +		start_caching(root);
> +}

We are sure root is not NULL, so this check is unnecessary.

I dipped into the problem, I don't think loading inode cache during reading
fs root is a good way to fix this problem, because in some cases, we read
the fs/file root, but we don't want to allocate/free the inode id.

I think we can add a flag, which is used to mark if the fs/file root has inode
id cache. We can set the flag when we reading the fs/file root. If the flag is
set but we don't allocate/free the inode id from/to the inode id cache, we set
the generation in the space cache header to 0, which can avoid loading a invalid
inode cache, and then clear the flag. How about this idea?

Thanks
Miao

> +
>  int btrfs_find_free_ino(struct btrfs_root *root, u64 *objectid)
>  {
>  	if (!btrfs_test_opt(root, INODE_MAP_CACHE))
> diff --git a/fs/btrfs/inode-map.h b/fs/btrfs/inode-map.h
> index ddb347b..5acf943 100644
> --- a/fs/btrfs/inode-map.h
> +++ b/fs/btrfs/inode-map.h
> @@ -4,6 +4,7 @@
>  void btrfs_init_free_ino_ctl(struct btrfs_root *root);
>  void btrfs_unpin_free_ino(struct btrfs_root *root);
>  void btrfs_return_ino(struct btrfs_root *root, u64 objectid);
> +void btrfs_start_ino_caching(struct btrfs_root *root);
>  int btrfs_find_free_ino(struct btrfs_root *root, u64 *objectid);
>  int btrfs_save_ino_cache(struct btrfs_root *root,
>  			 struct btrfs_trans_handle *trans);
> diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
> index ec71ea4..d4b6cfc 100644
> --- a/fs/btrfs/root-tree.c
> +++ b/fs/btrfs/root-tree.c
> @@ -21,6 +21,7 @@
>  #include "transaction.h"
>  #include "disk-io.h"
>  #include "print-tree.h"
> +#include "inode-map.h"
>  
>  /*
>   * Read a root item from the tree. In case we detect a root item smaller then
> @@ -316,6 +317,8 @@ int btrfs_find_orphan_roots(struct btrfs_root *tree_root)
>  
>  		if (btrfs_root_refs(&root->root_item) == 0)
>  			btrfs_add_dead_root(root);
> +		else
> +			btrfs_start_ino_caching(root);
>  	}
>  
>  	btrfs_free_path(path);
> 

