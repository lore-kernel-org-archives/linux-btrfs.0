Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:10864 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751528AbdKVIjw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Nov 2017 03:39:52 -0500
Subject: Re: [PATCH 2/6] btrfs-progs: check: change traversal way of lowmem
 mode
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        <linux-btrfs@vger.kernel.org>
References: <20170823023350.2940-1-lufq.fnst@cn.fujitsu.com>
 <20170823023350.2940-3-lufq.fnst@cn.fujitsu.com>
 <87d8b608-afe0-2b5d-4d76-8f038e2605bf@gmx.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <3349739d-1377-811a-5798-85b184f5470f@cn.fujitsu.com>
Date: Wed, 22 Nov 2017 16:43:34 +0800
MIME-Version: 1.0
In-Reply-To: <87d8b608-afe0-2b5d-4d76-8f038e2605bf@gmx.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/22/2017 04:15 PM, Qu Wenruo wrote:
> Well, David changed the title so it takes me some time to locate the patch.
> 
> Although it's too late to point out problems in this patch after being
> merged.
> But I still think it's worth mention some problems in this patch,
> especially considering how it's causing problems.
> 
Thanks, it indeed has many problems.
Since it was merged, I'll try to fix bugs which it brings.

> On 2017年08月23日 10:33, Lu Fengqi wrote:
>> From: Su Yue <suy.fnst@cn.fujitsu.com>
>>
>> This patch is a preparation for extent-tree repair in lowmem mode.
>> In the lowmem mode, checking tree blocks of various tree is in
>> recursive way.
>> But if during repair, add or delete of item(s) may modify upper nodes
>> which will cause the repair to be complicated and dangerous.
>>
>> Before this patch:
>> One problem of lowmem check is that it only checks the lowest node's
>> backref in check_tree_block_ref.
>> This way ensures checked tree blocks are legal and avoids to traverse
>> all trees for consideration about speed.
>> However, there is one shortcoming that it can not detect backref mistake
>> if one extent whose owner == offset but lacks of other backref(s).
>>
>> In check, correctness is more important than speed.
>> If errors can not be detected, repair is impossible.
>>
>> Change of the patch:
>> check_chunks_and_extents now has to check *ALL* trees so lowmem check
>> will behave like original mode.
>> Changing the way of traversal to be same as fs tree which calls
>> walk_down_tree_v2() and walk_up_tree_v2() is easy for further
>> repair.
>>
>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>> ---
>>   cmds-check.c | 695 +++++++++++++++++++++++++++++++++++++----------------------
>>   1 file changed, 443 insertions(+), 252 deletions(-)
>>
>> diff --git a/cmds-check.c b/cmds-check.c
>> index 829f7c5..7c9036c 100644
>> --- a/cmds-check.c
>> +++ b/cmds-check.c
>> @@ -1878,10 +1878,15 @@ struct node_refs {
>>   	u64 bytenr[BTRFS_MAX_LEVEL];
>>   	u64 refs[BTRFS_MAX_LEVEL];
>>   	int need_check[BTRFS_MAX_LEVEL];
>> +	/* field for check all trees*/
>> +	int checked[BTRFS_MAX_LEVEL];
>> +	/* the correspond extent should mark as full backref or not */
>> +	int full_backref[BTRFS_MAX_LEVEL];
>>   };
>>   
>>   static int update_nodes_refs(struct btrfs_root *root, u64 bytenr,
>> -			     struct node_refs *nrefs, u64 level);
>> +			     struct extent_buffer *eb, struct node_refs *nrefs,
>> +			     u64 level, int check_all);
>>   static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path,
>>   			    unsigned int ext_ref);
>>   
>> @@ -1943,7 +1948,7 @@ again:
>>   
>>   		ret = update_nodes_refs(root,
>>   				path->nodes[i]->start,
>> -				nrefs, i);
>> +				path->nodes[i], nrefs, i, 0);
>>   		if (ret)
>>   			goto out;
>>   
>> @@ -2062,25 +2067,42 @@ static int need_check(struct btrfs_root *root, struct ulist *roots)
>>   	return 1;
>>   }
>>   
>> +static int calc_extent_flag_v2(struct btrfs_root *root,
>> +			       struct extent_buffer *eb,
>> +			       u64 *flags_ret);
>>   /*
>>    * for a tree node or leaf, we record its reference count, so later if we still
>>    * process this node or leaf, don't need to compute its reference count again.
>> + *
>> + * @bytenr  if @bytenr == (u64)-1, only update nrefs->full_backref[level]
>>    */
>>   static int update_nodes_refs(struct btrfs_root *root, u64 bytenr,
>> -			     struct node_refs *nrefs, u64 level)
>> +			     struct extent_buffer *eb, struct node_refs *nrefs,
>> +			     u64 level, int check_all)
>>   {
>> -	int check, ret;
>> -	u64 refs;
>>   	struct ulist *roots;
>> +	u64 refs = 0;
>> +	u64 flags = 0;
>> +	int root_level = btrfs_header_level(root->node);
>> +	int check;
>> +	int ret;
>>   
>> -	if (nrefs->bytenr[level] != bytenr) {
>> +	if (nrefs->bytenr[level] == bytenr)
>> +		return 0;
>> +
>> +	if (bytenr != (u64)-1) {
>> +		/* the return value of this function seems a mistake */
>>   		ret = btrfs_lookup_extent_info(NULL, root, bytenr,
>> -				       level, 1, &refs, NULL);
>> -		if (ret < 0)
>> +				       level, 1, &refs, &flags);
>> +		/* temporary fix */
>> +		if (ret < 0 && !check_all)
>>   			return ret;
>>   
>>   		nrefs->bytenr[level] = bytenr;
>>   		nrefs->refs[level] = refs;
>> +		nrefs->full_backref[level] = 0;
>> +		nrefs->checked[level] = 0;
>> +
>>   		if (refs > 1) {
>>   			ret = btrfs_find_all_roots(NULL, root->fs_info, bytenr,
>>   						   0, &roots);
>> @@ -2091,13 +2113,56 @@ static int update_nodes_refs(struct btrfs_root *root, u64 bytenr,
>>   			ulist_free(roots);
>>   			nrefs->need_check[level] = check;
>>   		} else {
>> -			nrefs->need_check[level] = 1;
>> +			if (!check_all) {
>> +				nrefs->need_check[level] = 1;
>> +			} else {
>> +				if (level == root_level)
>> +					nrefs->need_check[level] = 1;
>> +				else
>> +			/*
>> +			 * the node refs may have not been updated
>> +			 * if upper needs check(the lowest root_objetid)
>> +			 * the node can be checked.
>> +			 */
>> +					nrefs->need_check[level] =
>> +						nrefs->need_check[level + 1];
>> +			}
>>   		}
>>   	}
>>   
>> +	if (check_all && eb) {
>> +		calc_extent_flag_v2(root, eb, &flags);
>> +		if (flags & BTRFS_BLOCK_FLAG_FULL_BACKREF)
>> +			nrefs->full_backref[level] = 1;
>> +	}
>> +
>>   	return 0;
>>   }
>>   
>> +/*
>> + * @level           if @level == -1 means extent data item
>> + *                  else normal treeblocl.
>> + */
>> +static int should_check_extent_strictly(struct btrfs_root *root,
>> +					struct node_refs *nrefs, int level)
>> +{
>> +	int root_level = btrfs_header_level(root->node);
>> +
>> +	if (level > root_level || level < -1)
>> +		return 1;
>> +	if (level == root_level)
>> +		return 1;
>> +	/*
>> +	 * if the upper node is marked full backref, it should contain shared
>> +	 * backref of the parent (except owner == root->objectid).
>> +	 */
>> +	while (++level <= root_level)
>> +		if (nrefs->refs[level] > 1)
>> +			return 0;
>> +
>> +	return 1;
>> +}
>> +
>>   static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
>>   			  struct walk_control *wc, int *level,
>>   			  struct node_refs *nrefs)
>> @@ -2230,16 +2295,57 @@ out:
>>   	return err;
>>   }
>>   
>> +static int fs_root_objectid(u64 objectid);
>> +
>> +/*
>> + * Update global fs information.
>> + */
>> +static void account_bytes(struct btrfs_root *root, struct btrfs_path *path,
>> +			 int level)
>> +{
>> +	u32 free_nrs;
>> +	struct extent_buffer *eb = path->nodes[level];
>> +
>> +	total_btree_bytes += eb->len;
>> +	if (fs_root_objectid(root->objectid))
>> +		total_fs_tree_bytes += eb->len;
>> +	if (btrfs_header_owner(eb) == BTRFS_EXTENT_TREE_OBJECTID)
>> +		total_extent_tree_bytes += eb->len;
>> +
>> +	if (level == 0) {
>> +		btree_space_waste +=
>> +			btrfs_leaf_free_space(root, eb);
>> +	} else {
>> +		free_nrs = (BTRFS_NODEPTRS_PER_BLOCK(root) -
>> +			    btrfs_header_nritems(eb));
>> +		btree_space_waste += free_nrs *
>> +			sizeof(struct btrfs_key_ptr);
>> +	}
>> +}
>> +
>>   static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path,
>>   			    unsigned int ext_ref);
>> +static int check_tree_block_ref(struct btrfs_root *root,
>> +				struct extent_buffer *eb, u64 bytenr,
>> +				int level, u64 owner, struct node_refs *nrefs);
>> +static int check_leaf_items(struct btrfs_trans_handle *trans,
>> +			    struct btrfs_root *root, struct btrfs_path *path,
>> +			    struct node_refs *nrefs, int account_bytes);
>>   
>>   /*
>> + * @trans      just for lowmem repair mode
>> + * @check all  if not 0 then check all tree block backrefs and items
>> + *             0 then just check relationship of items in fs tree(s)
>> + *
>>    * Returns >0  Found error, should continue
>>    * Returns <0  Fatal error, must exit the whole check
>>    * Returns 0   No errors found
>>    */
>> -static int walk_down_tree_v2(struct btrfs_root *root, struct btrfs_path *path,
>> -			     int *level, struct node_refs *nrefs, int ext_ref)
>> +static int walk_down_tree_v2(struct btrfs_trans_handle *trans,
>> +			     struct btrfs_root *root, struct btrfs_path *path,
>> +			     int *level, struct node_refs *nrefs, int ext_ref,
>> +			     int check_all)
>> +
>>   {
>>   	enum btrfs_tree_block_status status;
>>   	u64 bytenr;
>> @@ -2249,12 +2355,15 @@ static int walk_down_tree_v2(struct btrfs_root *root, struct btrfs_path *path,
>>   	struct extent_buffer *cur;
>>   	u32 blocksize;
>>   	int ret;
>> +	int err = 0;
>> +	int check;
>> +	int account_file_data = 0;
>>   
>>   	WARN_ON(*level < 0);
>>   	WARN_ON(*level >= BTRFS_MAX_LEVEL);
>>   
>> -	ret = update_nodes_refs(root, path->nodes[*level]->start,
>> -				nrefs, *level);
>> +	ret = update_nodes_refs(root, btrfs_header_bytenr(path->nodes[*level]),
>> +				path->nodes[*level], nrefs, *level, check_all);
>>   	if (ret < 0)
>>   		return ret;
>>   
>> @@ -2262,42 +2371,83 @@ static int walk_down_tree_v2(struct btrfs_root *root, struct btrfs_path *path,
>>   		WARN_ON(*level < 0);
>>   		WARN_ON(*level >= BTRFS_MAX_LEVEL);
>>   		cur = path->nodes[*level];
>> +		bytenr = btrfs_header_bytenr(cur);
>> +		check = nrefs->need_check[*level];
>>   
>>   		if (btrfs_header_level(cur) != *level)
>>   			WARN_ON(1);
>> +	       /*
>> +		* Update bytes accounting and check tree block ref
>> +		* *NOTICE* Doing account and check before checking nritems
>> +		* is necessary because of empty node/leaf.
>> +		*/
>> +		if ((check_all && !nrefs->checked[*level]) ||
>> +		    (!check_all && nrefs->need_check[*level])) {
>> +			ret = check_tree_block_ref(root, cur,
>> +			   btrfs_header_bytenr(cur), btrfs_header_level(cur),
>> +			   btrfs_header_owner(cur), nrefs);
>> +			err |= ret;
>> +
>> +			if (check_all && nrefs->need_check[*level] &&
>> +				nrefs->refs[*level]) {
>> +				account_bytes(root, path, *level);
>> +				account_file_data = 1;
>> +			}
>> +			nrefs->checked[*level] = 1;
>> +		}
>>   
>>   		if (path->slots[*level] >= btrfs_header_nritems(cur))
>>   			break;
>> +
>>   		/* Don't forgot to check leaf/node validation */
>>   		if (*level == 0) {
>> -			ret = btrfs_check_leaf(root, NULL, cur);
>> -			if (ret != BTRFS_TREE_BLOCK_CLEAN) {
>> -				ret = -EIO;
>> -				break;
>> +			/* skip duplicate check */
>> +			if (check || !check_all) {
>> +				ret = btrfs_check_leaf(root, NULL, cur);
>> +				if (ret != BTRFS_TREE_BLOCK_CLEAN) {
>> +					err |= -EIO;
>> +					break;
>> +				}
>>   			}
>> -			ret = process_one_leaf_v2(root, path, nrefs,
>> -						  level, ext_ref);
>> +
>> +			ret = 0;
>> +			if (!check_all)
>> +				ret = process_one_leaf_v2(root, path, nrefs,
>> +							  level, ext_ref);
>> +			else
>> +				ret = check_leaf_items(trans, root, path,
>> +					       nrefs, account_file_data);
>> +			err |= ret;
>>   			break;
>>   		} else {
>> -			ret = btrfs_check_node(root, NULL, cur);
>> -			if (ret != BTRFS_TREE_BLOCK_CLEAN) {
>> -				ret = -EIO;
>> -				break;
>> +			if (check || !check_all) {
>> +				ret = btrfs_check_node(root, NULL, cur);
>> +				if (ret != BTRFS_TREE_BLOCK_CLEAN) {
>> +					err |= -EIO;
>> +					break;
>> +				}
>>   			}
>>   		}
>> +
>>   		bytenr = btrfs_node_blockptr(cur, path->slots[*level]);
>>   		ptr_gen = btrfs_node_ptr_generation(cur, path->slots[*level]);
>>   		blocksize = fs_info->nodesize;
>>   
>> -		ret = update_nodes_refs(root, bytenr, nrefs, *level - 1);
>> -		if (ret)
>> +		ret = update_nodes_refs(root, bytenr, NULL, nrefs, *level - 1,
>> +					check_all);
>> +		if (ret < 0)
>>   			break;
>> -		if (!nrefs->need_check[*level - 1]) {
>> +		/*
>> +		 * check all trees in check_chunks_and_extent_v2
>> +		 * check shared node once in check_fs_roots
>> +		 */
>> +		if (!check_all && !nrefs->need_check[*level - 1]) {
>>   			path->slots[*level]++;
>>   			continue;
>>   		}
>>   
>>   		next = btrfs_find_tree_block(fs_info, bytenr, blocksize);
>> +
>>   		if (!next || !btrfs_buffer_uptodate(next, ptr_gen)) {
>>   			free_extent_buffer(next);
>>   			reada_walk_down(root, cur, path->slots[*level]);
>> @@ -2310,16 +2460,15 @@ static int walk_down_tree_v2(struct btrfs_root *root, struct btrfs_path *path,
>>   						      &node_key,
>>   						      path->slots[*level]);
>>   				btrfs_add_corrupt_extent_record(fs_info,
>> -						&node_key,
>> -						path->nodes[*level]->start,
>> -						fs_info->nodesize,
>> -						*level);
>> -				ret = -EIO;
>> +					&node_key, path->nodes[*level]->start,
>> +					fs_info->nodesize, *level);
>> +				err |= -EIO;
>>   				break;
>>   			}
>>   		}
>>   
>>   		ret = check_child_node(cur, path->slots[*level], next);
>> +		err |= ret;
>>   		if (ret < 0)
>>   			break;
>>   
>> @@ -2329,7 +2478,7 @@ static int walk_down_tree_v2(struct btrfs_root *root, struct btrfs_path *path,
>>   			status = btrfs_check_node(root, NULL, next);
>>   		if (status != BTRFS_TREE_BLOCK_CLEAN) {
>>   			free_extent_buffer(next);
>> -			ret = -EIO;
>> +			err |= -EIO;
>>   			break;
>>   		}
>>   
>> @@ -2337,8 +2486,12 @@ static int walk_down_tree_v2(struct btrfs_root *root, struct btrfs_path *path,
>>   		free_extent_buffer(path->nodes[*level]);
>>   		path->nodes[*level] = next;
>>   		path->slots[*level] = 0;
>> +		account_file_data = 0;
>> +
>> +		update_nodes_refs(root, (u64)-1, next, nrefs, *level,
>> +				  check_all);
>>   	}
>> -	return ret;
>> +	return err;
>>   }
>>   
>>   static int walk_up_tree(struct btrfs_root *root, struct btrfs_path *path,
>> @@ -5061,15 +5214,21 @@ out:
>>   }
>>   
>>   /*
>> - * Iterate all item on the tree and call check_inode_item() to check.
>> + * This function calls walk_down_tree_v2 and walk_up_tree_v2 to check tree
>> + * blocks and integrity of fs tree items.
>>    *
>> - * @root:	the root of the tree to be checked.
>> - * @ext_ref:	the EXTENDED_IREF feature
>> - *
>> - * Return 0 if no error found.
>> - * Return <0 for error.
>> + * @root:         the root of the tree to be checked.
>> + * @ext_ref       feature EXTENDED_IREF is enable or not.
>> + * @account       if NOT 0 means check the tree(include tree)'s treeblocks.
>> + *                otherwise means check fs tree(s) items relationship and
>> + *		  @root *MUST* be a fs tree root.
>> + * Returns 0      represents OK.
>> + * Returns not 0  represents error.
>>    */
>> -static int check_fs_root_v2(struct btrfs_root *root, unsigned int ext_ref)
>> +static int check_btrfs_root(struct btrfs_trans_handle *trans,
>> +			    struct btrfs_root *root, unsigned int ext_ref,
>> +			    int check_all)
>> +
>>   {
>>   	struct btrfs_path path;
>>   	struct node_refs nrefs;
>> @@ -5078,17 +5237,20 @@ static int check_fs_root_v2(struct btrfs_root *root, unsigned int ext_ref)
>>   	int level;
>>   	int err = 0;
>>   
>> -	/*
>> -	 * We need to manually check the first inode item(256)
>> -	 * As the following traversal function will only start from
>> -	 * the first inode item in the leaf, if inode item(256) is missing
>> -	 * we will just skip it forever.
>> -	 */
>> -	ret = check_fs_first_inode(root, ext_ref);
>> -	if (ret < 0)
>> -		return ret;
>> -
>>   	memset(&nrefs, 0, sizeof(nrefs));
>> +	if (!check_all) {
>> +		/*
>> +		 * We need to manually check the first inode item(256)
>> +		 * As the following traversal function will only start from
>> +		 * the first inode item in the leaf, if inode item(256) is
>> +		 * missing we will just skip it forever.
>> +		 */
>> +		ret = check_fs_first_inode(root, ext_ref);
>> +		if (ret < 0)
>> +			return ret;
>> +	}
>> +
>> +
>>   	level = btrfs_header_level(root->node);
>>   	btrfs_init_path(&path);
>>   
>> @@ -5110,7 +5272,9 @@ static int check_fs_root_v2(struct btrfs_root *root, unsigned int ext_ref)
>>   	}
>>   
>>   	while (1) {
>> -		ret = walk_down_tree_v2(root, &path, &level, &nrefs, ext_ref);
>> +		ret = walk_down_tree_v2(trans, root, &path, &level, &nrefs,
>> +					ext_ref, check_all);
>> +
>>   		err |= !!ret;
>>   
>>   		/* if ret is negative, walk shall stop */
>> @@ -5133,6 +5297,20 @@ out:
>>   }
>>   
>>   /*
>> + * Iterate all item on the tree and call check_inode_item() to check.
>> + *
>> + * @root:	the root of the tree to be checked.
>> + * @ext_ref:	the EXTENDED_IREF feature
>> + *
>> + * Return 0 if no error found.
>> + * Return <0 for error.
>> + */
>> +static int check_fs_root_v2(struct btrfs_root *root, unsigned int ext_ref)
>> +{
>> +	return check_btrfs_root(NULL, root, ext_ref, 0);
>> +}
>> +
>> +/*
>>    * Find the relative ref for root_ref and root_backref.
>>    *
>>    * @root:	the root of the root tree.
>> @@ -7544,6 +7722,113 @@ full_backref:
>>   	return 0;
>>   }
>>   
>> +static int calc_extent_flag_v2(struct btrfs_root *root,
>> +			       struct extent_buffer *eb,
>> +			       u64 *flags_ret)
>> +{
>> +	struct btrfs_root *extent_root = root->fs_info->extent_root;
>> +	struct btrfs_root_item *ri = &root->root_item;
>> +	struct btrfs_extent_inline_ref *iref;
>> +	struct btrfs_extent_item *ei;
>> +	struct btrfs_key key;
>> +	struct btrfs_path *path = NULL;
>> +	unsigned long ptr;
>> +	unsigned long end;
>> +	u64 flags;
>> +	u64 owner = 0;
>> +	u64 offset;
>> +	int slot;
>> +	int type;
>> +	int ret = 0;
>> +
>> +	/*
>> +	 * Except file/reloc tree, we can not have
>> +	 * FULL BACKREF MODE
>> +	 */
>> +	if (root->objectid < BTRFS_FIRST_FREE_OBJECTID)
>> +		goto normal;
>> +	/*
>> +	 * root node
>> +	 */
>> +	if (eb->start == ri->bytenr)
>> +		goto normal;
>> +
>> +	if (btrfs_header_flag(eb, BTRFS_HEADER_FLAG_RELOC))
>> +		goto full_backref;
>> +
>> +	owner = btrfs_header_owner(eb);
>> +	if (owner == root->objectid)
>> +		goto normal;
>> +
>> +	path = btrfs_alloc_path();
>> +	if (!path)
>> +		return -ENOMEM;
>> +
>> +	key.objectid = btrfs_header_bytenr(eb);
>> +	key.type = (u8)-1;
>> +	key.offset = (u64)-1;
>> +
>> +	ret = btrfs_search_slot(NULL, extent_root, &key, path, 0, 0);
>> +	if (ret <= 0) {
>> +		ret = -EIO;
>> +		goto out;
>> +	}
>> +
>> +	if (ret > 0) {
>> +		ret = btrfs_previous_extent_item(extent_root, path,
>> +						 key.objectid);
>> +		if (ret)
>> +			goto full_backref;
>> +
>> +	}
>> +	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
>> +
>> +	eb = path->nodes[0];
>> +	slot = path->slots[0];
>> +	ei = btrfs_item_ptr(eb, slot, struct btrfs_extent_item);
>> +
>> +	flags = btrfs_extent_flags(eb, ei);
>> +	if (flags & BTRFS_BLOCK_FLAG_FULL_BACKREF)
>> +		goto full_backref;
>> +
>> +	ptr = (unsigned long)(ei + 1);
>> +	end = (unsigned long)ei + btrfs_item_size_nr(eb, slot);
>> +
>> +	if (key.type == BTRFS_EXTENT_ITEM_KEY)
>> +		ptr += sizeof(struct btrfs_tree_block_info);
>> +
>> +next:
>> +	/* Reached extent item end normally */
>> +	if (ptr == end)
>> +		goto full_backref;
>> +
>> +	/* Beyond extent item end, wrong item size */
>> +	if (ptr > end) {
>> +		error("extent item at bytenr %llu slot %d has wrong size",
>> +			eb->start, slot);
>> +		goto full_backref;
>> +	}
>> +
>> +	iref = (struct btrfs_extent_inline_ref *)ptr;
>> +	offset = btrfs_extent_inline_ref_offset(eb, iref);
>> +	type = btrfs_extent_inline_ref_type(eb, iref);
>> +
>> +	if (type == BTRFS_TREE_BLOCK_REF_KEY && offset == owner)
>> +		goto normal;
>> +	ptr += btrfs_extent_inline_ref_size(type);
>> +	goto next;
>> +
>> +normal:
>> +	*flags_ret &= ~BTRFS_BLOCK_FLAG_FULL_BACKREF;
>> +	goto out;
>> +full_backref:
>> +	*flags_ret |= BTRFS_BLOCK_FLAG_FULL_BACKREF;
>> +	goto out;
>> +out:
>> +	btrfs_free_path(path);
>> +	return ret;
>> +}
>> +
>>   static void report_mismatch_key_root(u8 key_type, u64 rootid)
>>   {
>>   	fprintf(stderr, "Invalid key type(");
>> @@ -10059,7 +10344,7 @@ loop:
>>    */
>>   static int check_tree_block_ref(struct btrfs_root *root,
>>   				struct extent_buffer *eb, u64 bytenr,
>> -				int level, u64 owner)
>> +				int level, u64 owner, struct node_refs *nrefs)
>>   {
>>   	struct btrfs_key key;
>>   	struct btrfs_root *extent_root = root->fs_info->extent_root;
>> @@ -10071,6 +10356,7 @@ static int check_tree_block_ref(struct btrfs_root *root,
>>   	unsigned long ptr;
>>   	int slot;
>>   	int skinny_level;
>> +	int root_level = btrfs_header_level(root->node);
>>   	int type;
>>   	u32 nodesize = root->fs_info->nodesize;
>>   	u32 item_size;
>> @@ -10079,11 +10365,12 @@ static int check_tree_block_ref(struct btrfs_root *root,
>>   	int found_ref = 0;
>>   	int err = 0;
>>   	int ret;
>> +	int strict = 1;
>> +	int parent = 0;
>>   
>>   	if (root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID &&
>>   	    btrfs_header_bytenr(root->node) == bytenr)
>>   		tree_reloc_root = 1;
>> -
>>   	btrfs_init_path(&path);
>>   	key.objectid = bytenr;
>>   	if (btrfs_fs_incompat(root->fs_info, SKINNY_METADATA))
>> @@ -10121,10 +10408,19 @@ static int check_tree_block_ref(struct btrfs_root *root,
>>   		iref = (struct btrfs_extent_inline_ref *)(info + 1);
>>   	}
>>   
>> +
>>   	if (eb) {
>>   		u64 header_gen;
>>   		u64 extent_gen;
>>   
>> +		/*
>> +		 * Due to the feature of shared tree block, if the
>> +		 * upper node is a fs root or shared node, the extent
>> +		 * of checked node may not be updated until next CoW.
>> +		 */
>> +		if (nrefs)
>> +			strict = should_check_extent_strictly(root, nrefs,
>> +							      level);
>>   		if (!(btrfs_extent_flags(leaf, ei) &
>>   		      BTRFS_EXTENT_FLAG_TREE_BLOCK)) {
>>   			error(
>> @@ -10147,6 +10443,7 @@ static int check_tree_block_ref(struct btrfs_root *root,
>>   			"extent[%llu %u] level mismatch, wanted: %u, have: %u",
>>   				key.objectid, nodesize, level, skinny_level);
>>   			err = BACKREF_MISMATCH;
>> +
>>   		}
>>   		if (!is_fstree(owner) && btrfs_extent_refs(leaf, ei) != 1) {
>>   			error(
>> @@ -10162,14 +10459,17 @@ static int check_tree_block_ref(struct btrfs_root *root,
>>   	item_size = btrfs_item_size_nr(leaf, slot);
>>   	ptr = (unsigned long)iref;
>>   	end = (unsigned long)ei + item_size;
>> +
>>   	while (ptr < end) {
>>   		iref = (struct btrfs_extent_inline_ref *)ptr;
>>   		type = btrfs_extent_inline_ref_type(leaf, iref);
>>   		offset = btrfs_extent_inline_ref_offset(leaf, iref);
>>   
>> -		if (type == BTRFS_TREE_BLOCK_REF_KEY &&
>> -			(offset == root->objectid || offset == owner)) {
>> -			found_ref = 1;
>> +		if (type == BTRFS_TREE_BLOCK_REF_KEY) {
>> +			if (offset == root->objectid)
>> +				found_ref = 1;
>> +			if (!strict && owner == offset)
>> +				found_ref = 1;
>>   		} else if (type == BTRFS_SHARED_BLOCK_REF_KEY) {
>>   			/*
>>   			 * Backref of tree reloc root points to itself, no need
>> @@ -10179,8 +10479,8 @@ static int check_tree_block_ref(struct btrfs_root *root,
>>   				found_ref = 1;
>>   			else
>>   			/* Check if the backref points to valid referencer */
>> -				found_ref = !check_tree_block_ref(root, NULL,
>> -						offset, level + 1, owner);
>> +				found_ref = !check_tree_block_ref(
>> +				  root, NULL, offset, level + 1, owner, NULL);
>>   		}
>>   
>>   		if (found_ref)
>> @@ -10206,9 +10506,14 @@ static int check_tree_block_ref(struct btrfs_root *root,
>>   		err |= BACKREF_MISSING;
>>   out:
>>   	btrfs_release_path(&path);
>> +	if (nrefs && strict &&
>> +	    level < root_level && nrefs->full_backref[level + 1])
>> +		parent = nrefs->bytenr[level + 1];
>>   	if (eb && (err & BACKREF_MISSING))
>> -		error("extent[%llu %u] backref lost (owner: %llu, level: %u)",
>> -			bytenr, nodesize, owner, level);
>> +		error("extent[%llu %u] backref lost (owner: %llu, level: %u) %s %llu",
>> +		      bytenr, nodesize, owner, level,
>> +		      parent ? "parent" : "root",
>> +		      parent ? parent : root->objectid);
>>   	return err;
>>   }
>>   
>> @@ -10219,9 +10524,11 @@ out:
>>    * Return 0 for no error found
>>    */
>>   static int check_extent_data_item(struct btrfs_root *root,
>> -				  struct extent_buffer *eb, int slot)
>> +				  struct btrfs_path *pathp,
>> +				  struct node_refs *nrefs,  int account_bytes)
>>   {
>>   	struct btrfs_file_extent_item *fi;
>> +	struct extent_buffer *eb = pathp->nodes[0];
>>   	struct btrfs_path path;
>>   	struct btrfs_root *extent_root = root->fs_info->extent_root;
>>   	struct btrfs_key fi_key;
>> @@ -10241,8 +10548,10 @@ static int check_extent_data_item(struct btrfs_root *root,
>>   	int type;
>>   	u64 ref_root;
>>   	int found_dbackref = 0;
>> +	int slot = pathp->slots[0];
>>   	int err = 0;
>>   	int ret;
>> +	int strict;
>>   
>>   	btrfs_item_key_to_cpu(eb, &fi_key, slot);
>>   	fi = btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
>> @@ -10253,6 +10562,7 @@ static int check_extent_data_item(struct btrfs_root *root,
>>   		return 0;
>>   
>>   	disk_bytenr = btrfs_file_extent_disk_bytenr(eb, fi);
>> +
>>   	disk_num_bytes = btrfs_file_extent_disk_num_bytes(eb, fi);
>>   	extent_num_bytes = btrfs_file_extent_num_bytes(eb, fi);
>>   
>> @@ -10263,7 +10573,7 @@ static int check_extent_data_item(struct btrfs_root *root,
>>   			fi_key.objectid, fi_key.offset, disk_num_bytes,
>>   			root->fs_info->sectorsize);
>>   		err |= BYTES_UNALIGNED;
>> -	} else {
>> +	} else if (account_bytes) {
>>   		data_bytes_allocated += disk_num_bytes;
>>   	}
>>   	if (!IS_ALIGNED(extent_num_bytes, root->fs_info->sectorsize)) {
>> @@ -10272,7 +10582,7 @@ static int check_extent_data_item(struct btrfs_root *root,
>>   			fi_key.objectid, fi_key.offset, extent_num_bytes,
>>   			root->fs_info->sectorsize);
>>   		err |= BYTES_UNALIGNED;
>> -	} else {
>> +	} else if (account_bytes) {
>>   		data_bytes_referenced += extent_num_bytes;
>>   	}
>>   	owner = btrfs_header_owner(eb);
>> @@ -10306,6 +10616,8 @@ static int check_extent_data_item(struct btrfs_root *root,
>>   	iref = (struct btrfs_extent_inline_ref *)(ei + 1);
>>   	ptr = (unsigned long)iref;
>>   	end = (unsigned long)ei + item_size;
>> +	strict = should_check_extent_strictly(root, nrefs, -1);
>> +
>>   	while (ptr < end) {
>>   		iref = (struct btrfs_extent_inline_ref *)ptr;
>>   		type = btrfs_extent_inline_ref_type(leaf, iref);
>> @@ -10313,12 +10625,14 @@ static int check_extent_data_item(struct btrfs_root *root,
>>   
>>   		if (type == BTRFS_EXTENT_DATA_REF_KEY) {
>>   			ref_root = btrfs_extent_data_ref_root(leaf, dref);
>> -			if (ref_root == owner || ref_root == root->objectid)
>> +			if (ref_root == root->objectid)
>> +				found_dbackref = 1;
>> +			else if (!strict && owner == ref_root)
>>   				found_dbackref = 1;
>>   		} else if (type == BTRFS_SHARED_DATA_REF_KEY) {
>>   			found_dbackref = !check_tree_block_ref(root, NULL,
>>   				btrfs_extent_inline_ref_offset(leaf, iref),
>> -				0, owner);
>> +							       0, owner, NULL);
>>   		}
>>   
>>   		if (found_dbackref)
>> @@ -11260,23 +11574,37 @@ out:
>>   /*
>>    * Main entry function to check known items and update related accounting info
>>    */
>> -static int check_leaf_items(struct btrfs_root *root, struct extent_buffer *eb)
>> +static int check_leaf_items(struct btrfs_trans_handle *trans,
>> +			    struct btrfs_root *root, struct btrfs_path *path,
>> +			    struct node_refs *nrefs, int account_bytes)
>>   {
>>   	struct btrfs_fs_info *fs_info = root->fs_info;
>>   	struct btrfs_key key;
>> -	int slot = 0;
>> +	struct extent_buffer *eb;
>> +	int slot;
>>   	int type;
>>   	struct btrfs_extent_data_ref *dref;
>> -	int ret;
>> +	int ret = 0;
>>   	int err = 0;
>>   
>> -next:
>> +again:
>> +	eb = path->nodes[0];
>> +	slot = path->slots[0];
>> +	if (slot >= btrfs_header_nritems(eb)) {
>> +		if (slot == 0) {
>> +			error("Empty leaf [%llu %u] root %llu",
>> +		      eb->start, root->fs_info->nodesize, root->objectid);
>> +			err |= EIO;
>> +		}
>> +		goto out;
>> +	}
>> +
>>   	btrfs_item_key_to_cpu(eb, &key, slot);
>>   	type = key.type;
>>   
>>   	switch (type) {
>>   	case BTRFS_EXTENT_DATA_KEY:
>> -		ret = check_extent_data_item(root, eb, slot);
>> +		ret = check_extent_data_item(root, path, nrefs, account_bytes);
>>   		err |= ret;
>>   		break;
>>   	case BTRFS_BLOCK_GROUP_ITEM_KEY:
>> @@ -11302,6 +11630,7 @@ next:
>>   		break;
>>   	case BTRFS_EXTENT_CSUM_KEY:
>>   		total_csum_bytes += btrfs_item_size_nr(eb, slot);
>> +		err |= ret;
>>   		break;
>>   	case BTRFS_TREE_BLOCK_REF_KEY:
>>   		ret = check_tree_block_backref(fs_info, key.offset,
>> @@ -11332,205 +11661,49 @@ next:
>>   		break;
>>   	}
>>   
>> -	if (++slot < btrfs_header_nritems(eb))
>> -		goto next;
>> -
>> +	++path->slots[0];
>> +	goto again;
>> +out:
>>   	return err;
>>   }
>>   
>> -/*
>> - * Helper function for later fs/subvol tree check.  To determine if a tree
>> - * block should be checked.
>> - * This function will ensure only the direct referencer with lowest rootid to
>> - * check a fs/subvolume tree block.
>> - *
>> - * Backref check at extent tree would detect errors like missing subvolume
>> - * tree, so we can do aggressive check to reduce duplicated checks.
>> - */
>> -static int should_check(struct btrfs_root *root, struct extent_buffer *eb)
>> -{
>> -	struct btrfs_root *extent_root = root->fs_info->extent_root;
>> -	struct btrfs_key key;
>> -	struct btrfs_path path;
>> -	struct extent_buffer *leaf;
>> -	int slot;
>> -	struct btrfs_extent_item *ei;
>> -	unsigned long ptr;
>> -	unsigned long end;
>> -	int type;
>> -	u32 item_size;
>> -	u64 offset;
>> -	struct btrfs_extent_inline_ref *iref;
>> -	int ret;
>> -
>> -	btrfs_init_path(&path);
>> -	key.objectid = btrfs_header_bytenr(eb);
>> -	key.type = BTRFS_METADATA_ITEM_KEY;
>> -	key.offset = (u64)-1;
>> -
>> -	/*
>> -	 * Any failure in backref resolving means we can't determine
>> -	 * whom the tree block belongs to.
>> -	 * So in that case, we need to check that tree block
>> -	 */
>> -	ret = btrfs_search_slot(NULL, extent_root, &key, &path, 0, 0);
>> -	if (ret < 0)
>> -		goto need_check;
>> -
>> -	ret = btrfs_previous_extent_item(extent_root, &path,
>> -					 btrfs_header_bytenr(eb));
>> -	if (ret)
>> -		goto need_check;
>> -
>> -	leaf = path.nodes[0];
>> -	slot = path.slots[0];
>> -	btrfs_item_key_to_cpu(leaf, &key, slot);
>> -	ei = btrfs_item_ptr(leaf, slot, struct btrfs_extent_item);
>> -
>> -	if (key.type == BTRFS_METADATA_ITEM_KEY) {
>> -		iref = (struct btrfs_extent_inline_ref *)(ei + 1);
>> -	} else {
>> -		struct btrfs_tree_block_info *info;
>> -
>> -		info = (struct btrfs_tree_block_info *)(ei + 1);
>> -		iref = (struct btrfs_extent_inline_ref *)(info + 1);
>> -	}
>> -
>> -	item_size = btrfs_item_size_nr(leaf, slot);
>> -	ptr = (unsigned long)iref;
>> -	end = (unsigned long)ei + item_size;
>> -	while (ptr < end) {
>> -		iref = (struct btrfs_extent_inline_ref *)ptr;
>> -		type = btrfs_extent_inline_ref_type(leaf, iref);
>> -		offset = btrfs_extent_inline_ref_offset(leaf, iref);
>> -
>> -		/*
>> -		 * We only check the tree block if current root is
>> -		 * the lowest referencer of it.
>> -		 */
>> -		if (type == BTRFS_TREE_BLOCK_REF_KEY &&
>> -		    offset < root->objectid) {
>> -			btrfs_release_path(&path);
>> -			return 0;
>> -		}
>> -
>> -		ptr += btrfs_extent_inline_ref_size(type);
>> -	}
>> -	/*
>> -	 * Normally we should also check keyed tree block ref, but that may be
>> -	 * very time consuming.  Inlined ref should already make us skip a lot
>> -	 * of refs now.  So skip search keyed tree block ref.
>> -	 */
>> -
>> -need_check:
>> -	btrfs_release_path(&path);
>> -	return 1;
>> -}
>> -
>> -/*
>> - * Traversal function for tree block. We will do:
>> - * 1) Skip shared fs/subvolume tree blocks
>> - * 2) Update related bytes accounting
>> - * 3) Pre-order traversal
>> - */
>> -static int traverse_tree_block(struct btrfs_root *root,
>> -				struct extent_buffer *node)
>> -{
>> -	struct extent_buffer *eb;
>> -	struct btrfs_key key;
>> -	struct btrfs_key drop_key;
>> -	int level;
>> -	u64 nr;
>> -	int i;
>> -	int err = 0;
>> -	int ret;
>> -
>> -	/*
>> -	 * Skip shared fs/subvolume tree block, in that case they will
>> -	 * be checked by referencer with lowest rootid
>> -	 */
>> -	if (is_fstree(root->objectid) && !should_check(root, node))
>> -		return 0;
>> -
>> -	/* Update bytes accounting */
>> -	total_btree_bytes += node->len;
>> -	if (fs_root_objectid(btrfs_header_owner(node)))
>> -		total_fs_tree_bytes += node->len;
>> -	if (btrfs_header_owner(node) == BTRFS_EXTENT_TREE_OBJECTID)
>> -		total_extent_tree_bytes += node->len;
>> -	if (!found_old_backref &&
>> -	    btrfs_header_owner(node) == BTRFS_TREE_RELOC_OBJECTID &&
>> -	    btrfs_header_backref_rev(node) == BTRFS_MIXED_BACKREF_REV &&
>> -	    !btrfs_header_flag(node, BTRFS_HEADER_FLAG_RELOC))
>> -		found_old_backref = 1;
>> -
>> -	/* pre-order tranversal, check itself first */
>> -	level = btrfs_header_level(node);
>> -	ret = check_tree_block_ref(root, node, btrfs_header_bytenr(node),
>> -				   btrfs_header_level(node),
>> -				   btrfs_header_owner(node));
>> -	err |= ret;
>> -	if (err)
>> -		error(
>> -	"check %s failed root %llu bytenr %llu level %d, force continue check",
>> -			level ? "node":"leaf", root->objectid,
>> -			btrfs_header_bytenr(node), btrfs_header_level(node));
>> -
>> -	if (!level) {
>> -		btree_space_waste += btrfs_leaf_free_space(root, node);
>> -		ret = check_leaf_items(root, node);
>> -		err |= ret;
>> -		return err;
>> -	}
>> -
>> -	nr = btrfs_header_nritems(node);
>> -	btrfs_disk_key_to_cpu(&drop_key, &root->root_item.drop_progress);
>> -	btree_space_waste += (BTRFS_NODEPTRS_PER_BLOCK(root) - nr) *
>> -		sizeof(struct btrfs_key_ptr);
>> -
>> -	/* Then check all its children */
>> -	for (i = 0; i < nr; i++) {
>> -		u64 blocknr = btrfs_node_blockptr(node, i);
>>   
>> -		btrfs_node_key_to_cpu(node, &key, i);
>> -		if (level == root->root_item.drop_level &&
>> -		    is_dropped_key(&key, &drop_key))
>> -			continue;
>> -
>> -		/*
>> -		 * As a btrfs tree has most 8 levels (0..7), so it's quite safe
>> -		 * to call the function itself.
>> -		 */
>> -		eb = read_tree_block(root->fs_info, blocknr,
>> -				root->fs_info->nodesize, 0);
>> -		if (extent_buffer_uptodate(eb)) {
>> -			ret = traverse_tree_block(root, eb);
>> -			err |= ret;
>> -		}
>> -		free_extent_buffer(eb);
>> -	}
>> -
>> -	return err;
>> -}
>> +static int pin_metadata_blocks(struct btrfs_fs_info *fs_info);
>>   
>>   /*
>>    * Low memory usage version check_chunks_and_extents.
>>    */
>>   static int check_chunks_and_extents_v2(struct btrfs_root *root)
>>   {
>> +	struct btrfs_trans_handle *trans = NULL;
>>   	struct btrfs_path path;
>> +	struct btrfs_key old_key;
>>   	struct btrfs_key key;
>>   	struct btrfs_root *root1;
>>   	struct btrfs_root *cur_root;
>>   	int err = 0;
>>   	int ret;
>>   
>> +	if (repair) {
>> +		/* pin every tree block avoid extent overwrite */
>> +		ret = pin_metadata_blocks(root->fs_info);
> 
> Why pin_metadata_blocks() here?
> Any special reason to validate this behavior?
>All patches was tested with option '--init-extent-tree', I saw
the function sets all extents dirty. So I used it.
Anyway, it is my mistake.

> It should be avoided especially if you're not doing extent tree reinit.
> 
Yes.
> Pinned block will be unpinned at transaction commit time, and will be
> marked as *free* for free_space_cache.
> 
> Causing later extent allocation to allocate space already used by
> existing tree blocks.
> 
I did not realize the problem.
I will go to remove the call of the function in lowmem repair and
fix in another way.

Thanks,
Su
> Thanks,
> Qu
> 
>> +		if (ret) {
>> +			error("fail to pin metadata blocks");
>> +			return ret;
>> +		}
>> +		trans = btrfs_start_transaction(root->fs_info->extent_root, 1);
>> +		if (IS_ERR(trans)) {
>> +			error("fail to start transaction before check");
>> +			return PTR_ERR(trans);
>> +		}
>> +	}
>> +
>>   	root1 = root->fs_info->chunk_root;
>> -	ret = traverse_tree_block(root1, root1->node);
>> +	ret = check_btrfs_root(trans, root1, 0, 1);
>>   	err |= ret;
>>   
>>   	root1 = root->fs_info->tree_root;
>> -	ret = traverse_tree_block(root1, root1->node);
>> +	ret = check_btrfs_root(trans, root1, 0, 1);
>>   	err |= ret;
>>   
>>   	btrfs_init_path(&path);
>> @@ -11540,7 +11713,7 @@ static int check_chunks_and_extents_v2(struct btrfs_root *root)
>>   
>>   	ret = btrfs_search_slot(NULL, root1, &key, &path, 0, 0);
>>   	if (ret) {
>> -		error("cannot find extent treet in tree_root");
>> +		error("cannot find extent tree in tree_root");
>>   		goto out;
>>   	}
>>   
>> @@ -11548,6 +11721,7 @@ static int check_chunks_and_extents_v2(struct btrfs_root *root)
>>   		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
>>   		if (key.type != BTRFS_ROOT_ITEM_KEY)
>>   			goto next;
>> +		old_key = key;
>>   		key.offset = (u64)-1;
>>   
>>   		if (key.objectid == BTRFS_TREE_RELOC_OBJECTID)
>> @@ -11559,20 +11733,37 @@ static int check_chunks_and_extents_v2(struct btrfs_root *root)
>>   			error("failed to read tree: %lld", key.objectid);
>>   			goto next;
>>   		}
>> -
>> -		ret = traverse_tree_block(cur_root, cur_root->node);
>> +		printf("Start check root %llu\n", cur_root->objectid);
>> +		ret = check_btrfs_root(trans, cur_root, 0, 1);
>>   		err |= ret;
>>   
>>   		if (key.objectid == BTRFS_TREE_RELOC_OBJECTID)
>>   			btrfs_free_fs_root(cur_root);
>> +
>> +		btrfs_release_path(&path);
>> +		ret = btrfs_search_slot(NULL, root->fs_info->tree_root,
>> +					&old_key, &path, 0, 0);
>> +		if (ret)
>> +			goto out;
>>   next:
>>   		ret = btrfs_next_item(root1, &path);
>>   		if (ret)
>>   			goto out;
>>   	}
>> -
>>   out:
>> +
>> +	/* if repair, update block accounting */
>> +	if (repair) {
>> +		ret = btrfs_fix_block_accounting(trans, root);
>> +		if (ret)
>> +			err |= ret;
>> +	}
>> +
>> +	if (trans)
>> +		btrfs_commit_transaction(trans, root->fs_info->extent_root);
>> +
>>   	btrfs_release_path(&path);
>> +
>>   	return err;
>>   }
>>   
>>
> 


