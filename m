Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:56244 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751231AbeD3DVb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Apr 2018 23:21:31 -0400
Subject: Re: [PATCH 1/3] btrfs-progs: Remove fs_info parameter from
 btrfs_leaf_free_space()
To: Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
References: <20180430031545.29891-1-wqu@suse.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <db4bdb86-eef7-22dc-c680-e17e1a17cf30@cn.fujitsu.com>
Date: Mon, 30 Apr 2018 11:27:21 +0800
MIME-Version: 1.0
In-Reply-To: <20180430031545.29891-1-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/30/2018 11:15 AM, Qu Wenruo wrote:
> For btrfs_leaf_free_space(), to get leaf data size, we have two way to
> get it:
> 
> 1) leaf->fs_info->nodesize
> 2) leaf->len
> 
> Anyway, we could get rid of @fs_info parameter for
> btrfs_leaf_free_space().
> And here we choose method 2), as it provides extra benefit to get leaf
> free space without initializing a real fs_info.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>

> ---
>   btrfs-corrupt-block.c |  2 +-
>   check/main.c          |  2 +-
>   check/mode-lowmem.c   |  2 +-
>   ctree.c               | 49 ++++++++++++++++++++++---------------------
>   ctree.h               |  3 +--
>   print-tree.c          |  2 +-
>   6 files changed, 30 insertions(+), 30 deletions(-)
> 
> diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
> index da0ec8c51e5a..fc06204b6481 100644
> --- a/btrfs-corrupt-block.c
> +++ b/btrfs-corrupt-block.c
> @@ -726,7 +726,7 @@ out:
>   static void shift_items(struct btrfs_root *root, struct extent_buffer *eb)
>   {
>   	int nritems = btrfs_header_nritems(eb);
> -	int shift_space = btrfs_leaf_free_space(root->fs_info, eb) / 2;
> +	int shift_space = btrfs_leaf_free_space(eb) / 2;
>   	int slot = nritems / 2;
>   	int i = 0;
>   	unsigned int data_end = btrfs_item_offset_nr(eb, nritems - 1);
> diff --git a/check/main.c b/check/main.c
> index c4a1801fb0ef..2030fe663e1b 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -5970,7 +5970,7 @@ static int run_next_block(struct btrfs_root *root,
>   		goto out;
>   
>   	if (btrfs_is_leaf(buf)) {
> -		btree_space_waste += btrfs_leaf_free_space(fs_info, buf);
> +		btree_space_waste += btrfs_leaf_free_space(buf);
>   		for (i = 0; i < nritems; i++) {
>   			struct btrfs_file_extent_item *fi;
>   
> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
> index bfe45abab6cc..227ecf87cf97 100644
> --- a/check/mode-lowmem.c
> +++ b/check/mode-lowmem.c
> @@ -390,7 +390,7 @@ static void account_bytes(struct btrfs_root *root, struct btrfs_path *path,
>   		total_extent_tree_bytes += eb->len;
>   
>   	if (level == 0) {
> -		btree_space_waste += btrfs_leaf_free_space(root->fs_info, eb);
> +		btree_space_waste += btrfs_leaf_free_space(eb);
>   	} else {
>   		free_nrs = (BTRFS_NODEPTRS_PER_BLOCK(root->fs_info) -
>   			    btrfs_header_nritems(eb));
> diff --git a/ctree.c b/ctree.c
> index d1c41925d71c..2c3ba70b000c 100644
> --- a/ctree.c
> +++ b/ctree.c
> @@ -480,11 +480,11 @@ btrfs_check_leaf(struct btrfs_root *root, struct btrfs_disk_key *parent_key,
>   		       (unsigned long long)btrfs_header_bytenr(buf));
>   		goto fail;
>   	}
> -	if (btrfs_leaf_free_space(root->fs_info, buf) < 0) {
> +	if (btrfs_leaf_free_space(buf) < 0) {
>   		ret = BTRFS_TREE_BLOCK_INVALID_FREE_SPACE;
>   		fprintf(stderr, "leaf free space incorrect %llu %d\n",
>   			(unsigned long long)btrfs_header_bytenr(buf),
> -			btrfs_leaf_free_space(root->fs_info, buf));
> +			btrfs_leaf_free_space(buf));
>   		goto fail;
>   	}
>   
> @@ -1193,7 +1193,7 @@ again:
>   		} else {
>   			p->slots[level] = slot;
>   			if (ins_len > 0 &&
> -			    ins_len > btrfs_leaf_free_space(root->fs_info, b)) {
> +			    ins_len > btrfs_leaf_free_space(b)) {
>   				int sret = split_leaf(trans, root, key,
>   						      p, ins_len, ret == 0);
>   				BUG_ON(sret > 0);
> @@ -1634,17 +1634,19 @@ static int leaf_space_used(struct extent_buffer *l, int start, int nr)
>    * the start of the leaf data.  IOW, how much room
>    * the leaf has left for both items and data
>    */
> -int btrfs_leaf_free_space(struct btrfs_fs_info *fs_info,
> -			  struct extent_buffer *leaf)
> +int btrfs_leaf_free_space(struct extent_buffer *leaf)
>   {
>   	int nritems = btrfs_header_nritems(leaf);
> +	u32 leaf_data_size;
>   	int ret;
>   
> -	ret = BTRFS_LEAF_DATA_SIZE(fs_info) - leaf_space_used(leaf, 0, nritems);
> +	BUG_ON(leaf->fs_info && leaf->fs_info->nodesize != leaf->len);
> +	leaf_data_size = __BTRFS_LEAF_DATA_SIZE(leaf->len);
> +	ret = leaf_data_size - leaf_space_used(leaf, 0 ,nritems);
>   	if (ret < 0) {
> -		printk("leaf free space ret %d, leaf data size %lu, used %d nritems %d\n",
> -		       ret, BTRFS_LEAF_DATA_SIZE(fs_info),
> -		       leaf_space_used(leaf, 0, nritems), nritems);
> +		printk("leaf free space ret %d, leaf data size %u, used %d nritems %d\n",
> +		       ret, leaf_data_size, leaf_space_used(leaf, 0, nritems),
> +		       nritems);
>   	}
>   	return ret;
>   }
> @@ -1692,7 +1694,7 @@ static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
>   			return PTR_ERR(right);
>   		return -EIO;
>   	}
> -	free_space = btrfs_leaf_free_space(fs_info, right);
> +	free_space = btrfs_leaf_free_space(right);
>   	if (free_space < data_size) {
>   		free_extent_buffer(right);
>   		return 1;
> @@ -1705,7 +1707,7 @@ static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
>   		free_extent_buffer(right);
>   		return 1;
>   	}
> -	free_space = btrfs_leaf_free_space(fs_info, right);
> +	free_space = btrfs_leaf_free_space(right);
>   	if (free_space < data_size) {
>   		free_extent_buffer(right);
>   		return 1;
> @@ -1844,7 +1846,7 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
>   	}
>   
>   	left = read_node_slot(fs_info, path->nodes[1], slot - 1);
> -	free_space = btrfs_leaf_free_space(fs_info, left);
> +	free_space = btrfs_leaf_free_space(left);
>   	if (free_space < data_size) {
>   		free_extent_buffer(left);
>   		return 1;
> @@ -1859,7 +1861,7 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
>   		return 1;
>   	}
>   
> -	free_space = btrfs_leaf_free_space(fs_info, left);
> +	free_space = btrfs_leaf_free_space(left);
>   	if (free_space < data_size) {
>   		free_extent_buffer(left);
>   		return 1;
> @@ -2083,7 +2085,7 @@ static noinline int split_leaf(struct btrfs_trans_handle *trans,
>   		l = path->nodes[0];
>   
>   		/* did the pushes work? */
> -		if (btrfs_leaf_free_space(root->fs_info, l) >= data_size)
> +		if (btrfs_leaf_free_space(l) >= data_size)
>   			return 0;
>   	}
>   
> @@ -2240,7 +2242,7 @@ int btrfs_split_item(struct btrfs_trans_handle *trans,
>   
>   	leaf = path->nodes[0];
>   	btrfs_item_key_to_cpu(leaf, &orig_key, path->slots[0]);
> -	if (btrfs_leaf_free_space(root->fs_info, leaf) >=
> +	if (btrfs_leaf_free_space(leaf) >=
>   	    sizeof(struct btrfs_item))
>   		goto split;
>   
> @@ -2261,8 +2263,7 @@ int btrfs_split_item(struct btrfs_trans_handle *trans,
>   	ret = split_leaf(trans, root, &orig_key, path, 0, 0);
>   	BUG_ON(ret);
>   
> -	BUG_ON(btrfs_leaf_free_space(root->fs_info, leaf) <
> -	       sizeof(struct btrfs_item));
> +	BUG_ON(btrfs_leaf_free_space(leaf) < sizeof(struct btrfs_item));
>   	leaf = path->nodes[0];
>   
>   split:
> @@ -2314,7 +2315,7 @@ split:
>   	btrfs_mark_buffer_dirty(leaf);
>   
>   	ret = 0;
> -	if (btrfs_leaf_free_space(root->fs_info, leaf) < 0) {
> +	if (btrfs_leaf_free_space(leaf) < 0) {
>   		btrfs_print_leaf(leaf);
>   		BUG();
>   	}
> @@ -2410,7 +2411,7 @@ int btrfs_truncate_item(struct btrfs_root *root, struct btrfs_path *path,
>   	btrfs_mark_buffer_dirty(leaf);
>   
>   	ret = 0;
> -	if (btrfs_leaf_free_space(root->fs_info, leaf) < 0) {
> +	if (btrfs_leaf_free_space(leaf) < 0) {
>   		btrfs_print_leaf(leaf);
>   		BUG();
>   	}
> @@ -2435,7 +2436,7 @@ int btrfs_extend_item(struct btrfs_root *root, struct btrfs_path *path,
>   	nritems = btrfs_header_nritems(leaf);
>   	data_end = leaf_data_end(root->fs_info, leaf);
>   
> -	if (btrfs_leaf_free_space(root->fs_info, leaf) < data_size) {
> +	if (btrfs_leaf_free_space(leaf) < data_size) {
>   		btrfs_print_leaf(leaf);
>   		BUG();
>   	}
> @@ -2472,7 +2473,7 @@ int btrfs_extend_item(struct btrfs_root *root, struct btrfs_path *path,
>   	btrfs_mark_buffer_dirty(leaf);
>   
>   	ret = 0;
> -	if (btrfs_leaf_free_space(root->fs_info, leaf) < 0) {
> +	if (btrfs_leaf_free_space(leaf) < 0) {
>   		btrfs_print_leaf(leaf);
>   		BUG();
>   	}
> @@ -2521,10 +2522,10 @@ int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
>   	nritems = btrfs_header_nritems(leaf);
>   	data_end = leaf_data_end(root->fs_info, leaf);
>   
> -	if (btrfs_leaf_free_space(root->fs_info, leaf) < total_size) {
> +	if (btrfs_leaf_free_space(leaf) < total_size) {
>   		btrfs_print_leaf(leaf);
>   		printk("not enough freespace need %u have %d\n",
> -		       total_size, btrfs_leaf_free_space(root->fs_info, leaf));
> +		       total_size, btrfs_leaf_free_space(leaf));
>   		BUG();
>   	}
>   
> @@ -2582,7 +2583,7 @@ int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
>   		btrfs_fixup_low_keys(root, path, &disk_key, 1);
>   	}
>   
> -	if (btrfs_leaf_free_space(root->fs_info, leaf) < 0) {
> +	if (btrfs_leaf_free_space(leaf) < 0) {
>   		btrfs_print_leaf(leaf);
>   		BUG();
>   	}
> diff --git a/ctree.h b/ctree.h
> index 1fef37c93485..e291a7d48d14 100644
> --- a/ctree.h
> +++ b/ctree.h
> @@ -2664,8 +2664,7 @@ static inline int btrfs_next_item(struct btrfs_root *root,
>   }
>   
>   int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path);
> -int btrfs_leaf_free_space(struct btrfs_fs_info *fs_info,
> -			  struct extent_buffer *leaf);
> +int btrfs_leaf_free_space(struct extent_buffer *leaf);
>   void btrfs_fixup_low_keys(struct btrfs_root *root, struct btrfs_path *path,
>   			  struct btrfs_disk_key *key, int level);
>   int btrfs_set_item_key_safe(struct btrfs_root *root, struct btrfs_path *path,
> diff --git a/print-tree.c b/print-tree.c
> index a1a7954abdae..34a724d5f7ef 100644
> --- a/print-tree.c
> +++ b/print-tree.c
> @@ -1191,7 +1191,7 @@ void btrfs_print_leaf(struct extent_buffer *eb)
>   
>   	printf("leaf %llu items %d free space %d generation %llu owner ",
>   		(unsigned long long)btrfs_header_bytenr(eb), nr,
> -		btrfs_leaf_free_space(fs_info, eb),
> +		btrfs_leaf_free_space(eb),
>   		(unsigned long long)btrfs_header_generation(eb));
>   	print_objectid(stdout, btrfs_header_owner(eb), 0);
>   	printf("\n");
> 


