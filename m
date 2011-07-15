From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: Re: [PATCH 1/7] btrfs: don't BUG_ON btrfs_alloc_path() errors
Date: Fri, 15 Jul 2011 09:44:19 +0900
Message-ID: <4E1F8D63.4070907@jp.fujitsu.com>
References: <1310681702-13922-1-git-send-email-mfasheh@suse.com> <1310681702-13922-2-git-send-email-mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Mark Fasheh <mfasheh@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1310681702-13922-2-git-send-email-mfasheh@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

(2011/07/15 7:14), Mark Fasheh wrote:
> This patch fixes many callers of btrfs_alloc_path() which BUG_ON allocation
> failure. All the sites that are fixed in this patch were checked by me to
> be fairly trivial to fix because of at least one of two criteria:
> 
>  - Callers of the function catch errors from it already so bubbling the
>    error up will be handled.
>  - Callers of the function might BUG_ON any nonzero return code in which
>    case there is no behavior changed (but we still got to remove a BUG_ON)
> 
> The following functions were updated:
> 
> btrfs_lookup_extent, alloc_reserved_tree_block, btrfs_remove_block_group,
> btrfs_lookup_csums_range, btrfs_csum_file_blocks, btrfs_mark_extent_written,
> btrfs_inode_by_name, btrfs_new_inode, btrfs_symlink,
> insert_reserved_file_extent, and run_delalloc_nocow

Some patches have already been posted.
Please refer: http://marc.info/?l=linux-btrfs&m=131003114917755&w=2

Thanks,
Tsutomu

> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.com>
> ---
>  fs/btrfs/extent-tree.c |   12 +++++++++---
>  fs/btrfs/file-item.c   |    7 +++++--
>  fs/btrfs/file.c        |    3 ++-
>  fs/btrfs/inode.c       |   18 +++++++++++++-----
>  4 files changed, 29 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 71cd456..aa91773 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -667,7 +667,9 @@ int btrfs_lookup_extent(struct btrfs_root *root, u64 start, u64 len)
>  	struct btrfs_path *path;
>  
>  	path = btrfs_alloc_path();
> -	BUG_ON(!path);
> +	if (!path)
> +		return -ENOMEM;
> +
>  	key.objectid = start;
>  	key.offset = len;
>  	btrfs_set_key_type(&key, BTRFS_EXTENT_ITEM_KEY);
> @@ -5494,7 +5496,8 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
>  	u32 size = sizeof(*extent_item) + sizeof(*block_info) + sizeof(*iref);
>  
>  	path = btrfs_alloc_path();
> -	BUG_ON(!path);
> +	if (!path)
> +		return -ENOMEM;
>  
>  	path->leave_spinning = 1;
>  	ret = btrfs_insert_empty_item(trans, fs_info->extent_root, path,
> @@ -7162,7 +7165,10 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
>  	spin_unlock(&cluster->refill_lock);
>  
>  	path = btrfs_alloc_path();
> -	BUG_ON(!path);
> +	if (!path) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
>  
>  	inode = lookup_free_space_inode(root, block_group, path);
>  	if (!IS_ERR(inode)) {
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index 90d4ee5..f92ff0e 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -282,7 +282,8 @@ int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
>  	u16 csum_size = btrfs_super_csum_size(&root->fs_info->super_copy);
>  
>  	path = btrfs_alloc_path();
> -	BUG_ON(!path);
> +	if (!path)
> +		return -ENOMEM;
>  
>  	if (search_commit) {
>  		path->skip_locking = 1;
> @@ -672,7 +673,9 @@ int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
>  		btrfs_super_csum_size(&root->fs_info->super_copy);
>  
>  	path = btrfs_alloc_path();
> -	BUG_ON(!path);
> +	if (!path)
> +		return -ENOMEM;
> +
>  	sector_sum = sums->sums;
>  again:
>  	next_offset = (u64)-1;
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index fa4ef18..23d1d81 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -855,7 +855,8 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
>  	btrfs_drop_extent_cache(inode, start, end - 1, 0);
>  
>  	path = btrfs_alloc_path();
> -	BUG_ON(!path);
> +	if (!path)
> +		return -ENOMEM;
>  again:
>  	recow = 0;
>  	split = start;
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 3601f0a..8be7d7a 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1070,7 +1070,8 @@ static noinline int run_delalloc_nocow(struct inode *inode,
>  	u64 ino = btrfs_ino(inode);
>  
>  	path = btrfs_alloc_path();
> -	BUG_ON(!path);
> +	if (!path)
> +		return -ENOMEM;
>  
>  	nolock = is_free_space_inode(root, inode);
>  
> @@ -1644,7 +1645,8 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
>  	int ret;
>  
>  	path = btrfs_alloc_path();
> -	BUG_ON(!path);
> +	if (!path)
> +		return -ENOMEM;
>  
>  	path->leave_spinning = 1;
>  
> @@ -3713,7 +3715,8 @@ static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
>  	int ret = 0;
>  
>  	path = btrfs_alloc_path();
> -	BUG_ON(!path);
> +	if (!path)
> +		return -ENOMEM;
>  
>  	di = btrfs_lookup_dir_item(NULL, root, path, btrfs_ino(dir), name,
>  				    namelen, 0);
> @@ -4438,7 +4441,8 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
>  	int owner;
>  
>  	path = btrfs_alloc_path();
> -	BUG_ON(!path);
> +	if (!path)
> +		return ERR_PTR(-ENOMEM);
>  
>  	inode = new_inode(root->fs_info->sb);
>  	if (!inode) {
> @@ -7194,7 +7198,11 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
>  		goto out_unlock;
>  
>  	path = btrfs_alloc_path();
> -	BUG_ON(!path);
> +	if (!path) {
> +		err = -ENOMEM;
> +		drop_inode = 1;
> +		goto out_unlock;
> +	}
>  	key.objectid = btrfs_ino(inode);
>  	key.offset = 0;
>  	btrfs_set_key_type(&key, BTRFS_EXTENT_DATA_KEY);


