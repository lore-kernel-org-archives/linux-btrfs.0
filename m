Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-eopbgr80059.outbound.protection.outlook.com ([40.107.8.59]:62392
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728103AbeHOB4q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Aug 2018 21:56:46 -0400
Subject: Re: [PATCH] Btrfs: correctly caculate item size used when item key
 collision happends
To: ethanwu <ethanwu@synology.com>, linux-btrfs@vger.kernel.org
References: <1534237532-1310-1-git-send-email-ethanwu@synology.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <d949e51d-0122-12ff-6aa2-083a7e5628b1@mendix.com>
Date: Wed, 15 Aug 2018 01:07:12 +0200
MIME-Version: 1.0
In-Reply-To: <1534237532-1310-1-git-send-email-ethanwu@synology.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/14/2018 11:05 AM, ethanwu wrote:
> Item key collision is allowed for some item types, like dir item and
> inode refs, but the overall item size is limited by the leafsize.
> 
> item size(ins_len) passed from btrfs_insert_empty_items to
> btrfs_search_slot already contains size of btrfs_item.
> 
> When btrfs_search_slot reaches leaf, we'll see if we need to split leaf,
> since the ins_len includes one struct btrfs_item, the check might
> fail even though new item we try to insert could merge into the existing
> one without adding new btrfs_item.
> And split_leaf return -EOVERFLOW from following code:
> if (extend && data_size + btrfs_item_size_nr(l, slot) +
>     sizeof(struct btrfs_item) > BTRFS_LEAF_DATA_SIZE(fs_info))
>     return -EOVERFLOW;
> 
> In most cases, when callers receive -EOVERFLOW, they either return
> this error or handle in different ways. For example, in normal dir item
> insertion the userspace will get errno EOVERFLOW; in inode ref case
> INODE_EXTREF is used instead if INODE_REF is full.
> 
> However, this is not the case for rename. To avoid the unrecoverable
> situation in rename, btrfs_check_dir_item_collision is called in
> early phase of rename. In this function, when item key collision is
> detected leaf space is checked:
> 
> data_size = sizeof(*di) + name_len;
> if (data_size + btrfs_item_size_nr(leaf, slot) +
>     sizeof(struct btrfs_item) > BTRFS_LEAF_DATA_SIZE(root->fs_info))
> 
> the sizeof(struct btrfs_item) + btrfs_item_size_nr(leaf, slot) here
> refers to existing item size.
> 
> The check condition here is not consistent with the btrfs_search_slot
> when item key collision happens. We might pass check here but fail
> at btrfs_search_slot.
> 
> in the rename call path
> btrfs_add_link
>   btrfs_insert_dir_item
>     insert_with_overflow
>       btrfs_insert_empty_items (btrfs item is counted)
>         btrfs_search_slot
> 
> if (ins_len > 0 &&
>     btrfs_leaf_free_space(fs_info, b) < ins_len) {
> 
> The ins_len here contains btrfs_item and the item data, but this
> btrfs_item is already in leaf used space, two btrfs_item is counted and
> we only need one when this is item key collision cases.
> Therfore, rename fails, and abort transaction is triggered with
> following error messages:
> BTRFS: error (device loop0) in btrfs_rename:9870: errno=-75 unknown
> 
> There are two ways to fix rename issue, one is to revert the patch
> 878f2d2cb355 Btrfs: fix max dir item size calculation
> to make the condition consistent.
> 
> The other way is to handle the leaf space check correctly when
> collision happens. I prefer the second one since it correct leaf
> space check in collision case. This fix needs unify the usage of ins_len
> in btrfs_search_slot to contain btrfs_item anyway and
> adjust all callers of btrfs_search_slot that intentionally pass ins_len
> without btrfs_item size to add size of btrfs_item from now.
> 
> dir item hash collision is not easy to reproduce.

I used this when testing dir_item related things:

http://crypto.junod.info/2012/12/13/hash-dos-and-btrfs/

> The following is a leaf sample filled with inode ref.
> 
> Before applying the patch, when item data reaches 16200
> and we want to add another link with namelen 26(inode ref size 36)
> It will not pass the leafspace check
> 10(inode ref item) + 26(name len) + 25(btrfs item) >
>     leaf free space 58
> and use BTRFS_INODE_EXTREF_KEY instead.
> Nevertheless, The 25 bytes btrfs_item is not needed because the
> newly inserted item could be merged with the existing one.
> 
> before patch:
> leaf 31571968 items 1 free space 58 generation 178 owner 262
> fs uuid 1abc143e-54af-491f-bff8-e58e21ad26e5
> chunk uuid 688bc1b5-5407-4f2d-9986-3dc3bf3019d3
>     item 0 key (261 INODE_REF 257) itemoff 83 itemsize 16200
>         inode ref index 504 namelen 26 name: abcdefghijklmnopqrstuv0001
>         inode ref index 505 namelen 26 name: abcdefghijklmnopqrstuv0002
>         inode ref index 506 namelen 26 name: abcdefghijklmnopqrstuv0003
>         ...
>         inode ref index 953 namelen 26 name: abcdefghijklmnopqrstuv0450
> 
> after patch:
> leaf 31899648 items 1 free space 22 generation 180 owner 262
> fs uuid 1abc143e-54af-491f-bff8-e58e21ad26e5
> chunk uuid 688bc1b5-5407-4f2d-9986-3dc3bf3019d3
>     item 0 key (263 INODE_REF 262) itemoff 47 itemsize 16236
>         inode ref index 504 namelen 26 name: abcdefghijklmnopqrstuv0001
>         inode ref index 505 namelen 26 name: abcdefghijklmnopqrstuv0002
>         inode ref index 506 namelen 26 name: abcdefghijklmnopqrstuv0003
>         ...
>         inode ref index 953 namelen 26 name: abcdefghijklmnopqrstuv0450
>         inode ref index 452 namelen 26 name: abcdefghijklmnopqrstuv0451
> 
> Signed-off-by: ethanwu <ethanwu@synology.com>
> ---
>  fs/btrfs/ctree.c       | 15 +++++++++++++--
>  fs/btrfs/extent-tree.c |  5 +++--
>  fs/btrfs/file-item.c   |  2 +-
>  3 files changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 4bc326d..3614dd9 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -2678,8 +2678,8 @@ static struct extent_buffer *btrfs_search_slot_get_root(struct btrfs_root *root,
>   * @p:		Holds all btree nodes along the search path
>   * @root:	The root node of the tree
>   * @key:	The key we are looking for
> - * @ins_len:	Indicates purpose of search, for inserts it is 1, for
> - *		deletions it's -1. 0 for plain searches
> + * @ins_len:	Indicates purpose of search, for inserts it is item size
> + *		including btrfs_item, for deletions it's -1. 0 for plain searches
>   * @cow:	boolean should CoW operations be performed. Must always be 1
>   *		when modifying the tree.
>   *
> @@ -2893,6 +2893,17 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>  			}
>  		} else {
>  			p->slots[level] = slot;
> +			/*
> +			 * item key collision happens. In this case, if we are allow
> +			 * to insert the item(for example, in dir_item case, item key
> +			 * collision is allowed), it will be merged with the original
> +			 * item. Only the item size grows, no new btrfs item will be
> +			 * added. Since the ins_len already accounts the size btrfs_item,
> +			 * this value is counted twice. Duduct this value here so the
> +			 * leaf space check will be correct.
> +			 */
> +			if (ret == 0 && ins_len > 0)
> +				ins_len -= sizeof(struct btrfs_item);
>  			if (ins_len > 0 &&
>  			    btrfs_leaf_free_space(fs_info, b) < ins_len) {
>  				if (write_lock_level < 1) {
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 3d9fe58..4e3aa09 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -1094,7 +1094,7 @@ static int convert_extent_item_v0(struct btrfs_trans_handle *trans,
>  
>  	new_size -= sizeof(*ei0);
>  	ret = btrfs_search_slot(trans, root, &key, path,
> -				new_size + extra_size, 1);
> +				new_size + extra_size + sizeof(struct btrfs_item), 1);
>  	if (ret < 0)
>  		return ret;
>  	BUG_ON(ret); /* Corruption */
> @@ -1644,7 +1644,8 @@ int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
>  	}
>  
>  again:
> -	ret = btrfs_search_slot(trans, root, &key, path, extra_size, 1);
> +	ret = btrfs_search_slot(trans, root, &key, path,
> +			    extra_size + sizeof(struct btrfs_item), 1);
>  	if (ret < 0) {
>  		err = ret;
>  		goto out;
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index f9dd6d1..0b6c581 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -804,7 +804,7 @@ int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
>  	 */
>  	btrfs_release_path(path);
>  	ret = btrfs_search_slot(trans, root, &file_key, path,
> -				csum_size, 1);
> +				csum_size + sizeof(struct btrfs_item), 1);
>  	if (ret < 0)
>  		goto fail_unlock;
>  
> 


-- 
Hans van Kranenburg
