Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:41208 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965050AbcIXTu7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 24 Sep 2016 15:50:59 -0400
Subject: Re: [PATCH v2 3/6] Btrfs: catch invalid free space trees
To: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org
References: <cover.1474580472.git.osandov@fb.com>
 <1381db7b5de30b8ea0d2e87aff26bfdb83b030e7.1474580472.git.osandov@fb.com>
Cc: kernel-team@fb.com, Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Anatoly Pugachev <matorola@gmail.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <32fd73be-8b59-7df0-177d-4a2900522f18@mendix.com>
Date: Sat, 24 Sep 2016 21:50:53 +0200
MIME-Version: 1.0
In-Reply-To: <1381db7b5de30b8ea0d2e87aff26bfdb83b030e7.1474580472.git.osandov@fb.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/23/2016 02:24 AM, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> There are two separate issues that can lead to corrupted free space
> trees.
> 
> 1. The free space tree bitmaps had an endianness issue on big-endian
>    systems which is fixed by an earlier patch in this series.
> 2. btrfs-progs before v4.7.3 modified filesystems without updating the
>    free space tree.
> 
> To catch both of these issues at once, we need to force the free space
> tree to be rebuilt. To do so, add a FREE_SPACE_TREE_VALID compat_ro bit.
> If the bit isn't set, we know that it was either produced by a broken
> big-endian kernel or may have been corrupted by btrfs-progs.

This tekst will be read by anyone git blaming the source to find out
what FREE_SPACE_TREE_VALID does, and maybe to find an answer to why
their filesystem just got corrupted after using progs < v4.7.3, even if
they run a new kernel which knows about this bit.

Since the above text suggests this situation can be dealt with, the text
is a bit misleading/incomplete. The construction with the bit requires
active cooperation from whatever external tool that is changing the fs,
to also flip this bit, to keep the filesystem from subsequently
corrupting itself.

So, starting to use this bit can only detect corruption by btrfs-progs
before v4.7.3 once, and only exactly once.

My suggestion is to just add a sentence like the following after "[...]
may have been corrupted by btrfs-progs.": "Caution: Since btrfs-progs
before v4.7.3 will not clear this bit after modifying the filesystem,
keeping to use these older versions will again result in an inconsistent
free space tree, without having an ability to detect this."

> This also provides us with a way to add rudimentary read-write support
> for the free space tree to btrfs-progs: it can just clear this bit and
> have the kernel rebuild the free space tree.
> 
> Cc: stable@vger.kernel.org # 4.5+
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  fs/btrfs/ctree.h           |  3 ++-
>  fs/btrfs/disk-io.c         |  9 +++++++++
>  fs/btrfs/free-space-tree.c |  2 ++
>  include/uapi/linux/btrfs.h | 10 +++++++++-
>  4 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 33fe035..791e47c 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -251,7 +251,8 @@ struct btrfs_super_block {
>  #define BTRFS_FEATURE_COMPAT_SAFE_CLEAR		0ULL
>  
>  #define BTRFS_FEATURE_COMPAT_RO_SUPP			\
> -	(BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE)
> +	(BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE |	\
> +	 BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID)
>  
>  #define BTRFS_FEATURE_COMPAT_RO_SAFE_SET	0ULL
>  #define BTRFS_FEATURE_COMPAT_RO_SAFE_CLEAR	0ULL
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index c0bfc6c..3dede6d 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2566,6 +2566,7 @@ int open_ctree(struct super_block *sb,
>  	int num_backups_tried = 0;
>  	int backup_index = 0;
>  	int max_active;
> +	int clear_free_space_tree = 0;
>  
>  	tree_root = fs_info->tree_root = btrfs_alloc_root(fs_info, GFP_KERNEL);
>  	chunk_root = fs_info->chunk_root = btrfs_alloc_root(fs_info, GFP_KERNEL);
> @@ -3131,6 +3132,14 @@ retry_root_backup:
>  
>  	if (btrfs_test_opt(fs_info, CLEAR_CACHE) &&
>  	    btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE)) {
> +		clear_free_space_tree = 1;
> +	} else if (btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE) &&
> +		   !btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE_VALID)) {
> +		btrfs_warn(fs_info, "free space tree is invalid");
> +		clear_free_space_tree = 1;
> +	}
> +
> +	if (clear_free_space_tree) {
>  		btrfs_info(fs_info, "clearing free space tree");
>  		ret = btrfs_clear_free_space_tree(fs_info);
>  		if (ret) {
> diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
> index 8fd85bf..ea605ff 100644
> --- a/fs/btrfs/free-space-tree.c
> +++ b/fs/btrfs/free-space-tree.c
> @@ -1182,6 +1182,7 @@ int btrfs_create_free_space_tree(struct btrfs_fs_info *fs_info)
>  	}
>  
>  	btrfs_set_fs_compat_ro(fs_info, FREE_SPACE_TREE);
> +	btrfs_set_fs_compat_ro(fs_info, FREE_SPACE_TREE_VALID);
>  	fs_info->creating_free_space_tree = 0;
>  
>  	ret = btrfs_commit_transaction(trans, tree_root);
> @@ -1250,6 +1251,7 @@ int btrfs_clear_free_space_tree(struct btrfs_fs_info *fs_info)
>  		return PTR_ERR(trans);
>  
>  	btrfs_clear_fs_compat_ro(fs_info, FREE_SPACE_TREE);
> +	btrfs_clear_fs_compat_ro(fs_info, FREE_SPACE_TREE_VALID);
>  	fs_info->free_space_root = NULL;
>  
>  	ret = clear_free_space_tree(trans, free_space_root);
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index ac5eacd..549ecf4 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -239,7 +239,15 @@ struct btrfs_ioctl_fs_info_args {
>   * Used by:
>   * struct btrfs_ioctl_feature_flags
>   */
> -#define BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE	(1ULL << 0)
> +#define BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE		(1ULL << 0)
> +/*
> + * Older kernels on big-endian systems produced broken free space tree bitmaps,
> + * and btrfs-progs also used to corrupt the free space tree. If this bit is
> + * clear, then the free space tree cannot be trusted. btrfs-progs can also
> + * intentionally clear this bit to ask the kernel to rebuild the free space
> + * tree.
> + */
> +#define BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID	(1ULL << 1)
>  
>  #define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF	(1ULL << 0)
>  #define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
> 


-- 
Hans van Kranenburg
