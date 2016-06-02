Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22837 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751019AbcFBFqg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jun 2016 01:46:36 -0400
Subject: Re: [PATCH v2] btrfs: fix check_shared for fiemap ioctl
To: Mark Fasheh <mfasheh@suse.de>, <dsterba@suse.cz>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Message-ID: <42d1c7d3-0f0c-11c3-6029-cd7c1e201c4e@cn.fujitsu.com>
Date: Thu, 2 Jun 2016 13:46:27 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <20160601211522.GI7633@wotan.suse.de>


At 06/02/2016 05:15 AM, Mark Fasheh wrote:
> Thanks for trying to fix this problem, comments below.
>
> On Wed, Jun 01, 2016 at 01:48:05PM +0800, Lu Fengqi wrote:
>> Only in the case of different root_id or different object_id, check_shared
>> identified extent as the shared. However, If a extent was referred by
>> different offset of same file, it should also be identified as shared.
>> In addition, check_shared's loop scale is at least  n^3, so if a extent
>> has too many references,  even causes soft hang up.
>>
>> First, add all delayed_ref to the ref_tree and calculate the unqiue_refs,
>> if the unique_refs is greater than one, return BACKREF_FOUND_SHARED.
>> Then individually add the  on-disk reference(inline/keyed) to the ref_tree
>> and calculate the unique_refs of the ref_tree to check if the unique_refs
>> is greater than one.Because once there are two references to return
>> SHARED, so the time complexity is close to the constant.
> Constant time in the best case, but still n^3 in the worst case right? I'm
> not complaining btw, I just want to be sure we're not over promising  :)
Only in case of a large number of delayed_ref, the worst case time 
complexity will be n^2*logn. Otherwise, it will be constant even if 
there are many on-disk references.
>> @@ -34,6 +35,253 @@ struct extent_inode_elem {
>>   	struct extent_inode_elem *next;
>>   };
>>
>> +/*
>> + * ref_root is used as the root of the ref tree that hold a collection
>> + * of unique references.
>> + */
>> +struct ref_root {
>> +	struct rb_root rb_root;
>> +
>> +	/*
>> +	 * the unique_refs represents the number of ref_nodes with a positive
>> +	 * count stored in the tree. Even if a ref_node(the count is greater
>> +	 * than one) is added, the unique_refs will only increase one.
>> +	 */
>> +	unsigned int unique_refs;
>> +};
>> +
>> +/* ref_node is used to store a unique reference to the ref tree. */
>> +struct ref_node {
>> +	struct rb_node rb_node;
>> +
>> +	/* for NORMAL_REF, otherwise all these fields should be set to 0 */
>> +	u64 root_id;
>> +	u64 object_id;
>> +	u64 offset;
>> +
>> +	/* for SHARED_REF, otherwise parent field should be set to 0 */
>> +	u64 parent;
>> +
>> +	/* ref to the ref_mod of btrfs_delayed_ref_node(delayed-ref.h) */
>> +	int ref_mod;
>> +};
> Why are we mirroring so much of the backref structures here? It seems like
> we're just throwing layers on top of layers. Can't we modify the backref
> structures and code to handle whatever small amount of unique accounting you
> must do?
The original structure(struct __prelim_ref) store reference in list, and 
I have to perform many search operations that not suitable for list. 
However, if I modify the original structure, it would require a lot of 
rework. So I just want to fix fiemap with this patch. If necessary, we 
can use this structure to replace the original structure later.
>
>> +/* dynamically allocate and initialize a ref_root */
>> +static struct ref_root *ref_root_alloc(void)
>> +{
>> +	struct ref_root *ref_tree;
>> +
>> +	ref_tree = kmalloc(sizeof(*ref_tree), GFP_KERNEL);
> I'm pretty sure we want GFP_NOFS here.
Yes, perhaps you're right.
> Because there's no need to narrow the allocation constraints. GFP_NOFS
> is necessary when the caller is on a critical path that must not recurse
> back to the filesystem through the allocation (ie. if the allocator
> decides to free some memory and tries tro write dirty data). FIEMAP is
> called from an ioctl.
But David seems to have a different point of view with you, so I would 
like to ask for his advice again.
>> +
>> +/*
>> + * search ref_node with (root_id, object_id, offset, parent) in the tree
>> + *
>> + * if found, the pointer of the ref_node will be returned;
>> + * if not found, NULL will be returned and pos will point to the rb_node for
>> + * insert, pos_parent will point to pos'parent for insert;
>> +*/
>> +static struct ref_node *__ref_tree_search(struct ref_root *ref_tree,
>> +					  struct rb_node ***pos,
>> +					  struct rb_node **pos_parent,
>> +					  u64 root_id, u64 object_id,
>> +					  u64 offset, u64 parent)
>> +{
>> +	struct ref_node *cur = NULL;
>> +
>> +	*pos = &ref_tree->rb_root.rb_node;
>> +
>> +	while (**pos) {
>> +		*pos_parent = **pos;
>> +		cur = rb_entry(*pos_parent, struct ref_node, rb_node);
>> +
>> +		if (cur->root_id < root_id) {
>> +			*pos = &(**pos)->rb_right;
>> +			continue;
>> +		} else if (cur->root_id > root_id) {
>> +			*pos = &(**pos)->rb_left;
>> +			continue;
>> +		}
>> +
>> +		if (cur->object_id < object_id) {
>> +			*pos = &(**pos)->rb_right;
>> +			continue;
>> +		} else if (cur->object_id > object_id) {
>> +			*pos = &(**pos)->rb_left;
>> +			continue;
>> +		}
>> +
>> +		if (cur->offset < offset) {
>> +			*pos = &(**pos)->rb_right;
>> +			continue;
>> +		} else if (cur->offset > offset) {
>> +			*pos = &(**pos)->rb_left;
>> +			continue;
>> +		}
>> +
>> +		if (cur->parent < parent) {
>> +			*pos = &(**pos)->rb_right;
>> +			continue;
>> +		} else if (cur->parent > parent) {
>> +			*pos = &(**pos)->rb_left;
>> +			continue;
>> +		}
> These 4 comparisons need to be in their own cmp() function - we want to
> avoid open coded comparisons with an rbtree search. This is a pretty
> standard way to handle it.
>
Yes, you are right. I'll update rb_tree related function.
>> +
>> +		return cur;
>> +	}
>> +
>> +	return NULL;
>> +}
>> +
>> +/*
>> + * insert a ref_node to the ref tree
>> + * @pos used for specifiy the position to insert
>> + * @pos_parent for specifiy pos's parent
>> + *
>> + * success, return 0;
>> + * ref_node already exists, return -EEXIST;
>> +*/
>> +static int ref_tree_insert(struct ref_root *ref_tree, struct rb_node **pos,
>> +			   struct rb_node *pos_parent, struct ref_node *ins)
>> +{
>> +	struct rb_node **p = NULL;
>> +	struct rb_node *parent = NULL;
>> +	struct ref_node *cur = NULL;
>> +
>> +	if (!pos) {
>> +		cur = __ref_tree_search(ref_tree, &p, &parent, ins->root_id,
>> +					ins->object_id, ins->offset,
>> +					ins->parent);
>> +		if (cur)
>> +			return -EEXIST;
>> +	} else {
>> +		p = pos;
>> +		parent = pos_parent;
>> +	}
>> +
>> +	rb_link_node(&ins->rb_node, parent, p);
>> +	rb_insert_color(&ins->rb_node, &ref_tree->rb_root);
>> +
>> +	return 0;
>> +}
>> +
>> +/* erase and free ref_node, caller should update ref_root->unique_refs */
>> +static void ref_tree_remove(struct ref_root *ref_tree, struct ref_node *node)
>> +{
>> +	rb_erase(&node->rb_node, &ref_tree->rb_root);
>> +	kfree(node);
>> +}
>> +
>> +/*
>> + * update ref_root->unique_refs
>> + *
>> + * call __ref_tree_search
>> + *	1. if ref_node doesn't exist, ref_tree_insert this node, and update
>> + *	ref_root->unique_refs:
>> + *		if ref_node->ref_mod > 0, ref_root->unique_refs++;
>> + *		if ref_node->ref_mod < 0, do noting;
>> + *
>> + *	2. if ref_node is found, then get origin ref_node->ref_mod, and update
>> + *	ref_node->ref_mod.
>> + *		if ref_node->ref_mod is equal to 0,then call ref_tree_remove
>> + *
>> + *		according to origin_mod and new_mod, update ref_root->items
>> + *		+----------------+--------------+-------------+
>> + *		|		 |new_count <= 0|new_count > 0|
>> + *		+----------------+--------------+-------------+
>> + *		|origin_count < 0|       0      |      1      |
>> + *		+----------------+--------------+-------------+
>> + *		|origin_count > 0|      -1      |      0      |
>> + *		+----------------+--------------+-------------+
>> + *
>> + * In case of allocation failure, -ENOMEM is returned and the ref_tree stays
>> + * unaltered.
>> + * Success, return 0
>> + */
>> +static int ref_tree_add(struct ref_root *ref_tree, u64 root_id, u64 object_id,
>> +			u64 offset, u64 parent, int count)
>> +{
>> +	struct ref_node *node = NULL;
>> +	struct rb_node **pos = NULL;
>> +	struct rb_node *pos_parent = NULL;
>> +	int origin_count;
>> +	int ret;
>> +
>> +	if (!count)
>> +		return 0;
>> +
>> +	node = __ref_tree_search(ref_tree, &pos, &pos_parent, root_id,
>> +				 object_id, offset, parent);
>> +	if (node == NULL) {
>> +		node = kmalloc(sizeof(*node), GFP_KERNEL);
>> +		if (!node)
>> +			return -ENOMEM;
>> +
>> +		node->root_id = root_id;
>> +		node->object_id = object_id;
>> +		node->offset = offset;
>> +		node->parent = parent;
>> +		node->ref_mod = count;
>> +
>> +		ret = ref_tree_insert(ref_tree, pos, pos_parent, node);
>> +		ASSERT(!ret);
>> +		if (ret) {
>> +			kfree(node);
>> +			return ret;
>> +		}
> If you put the open coded comparisons into their own function, then it
> should be trivial to call that here and we can have a 'standard' looking
> rbtree insert instead of this custom version. See the rbtree.h header for an
> example.
>
> We really need to avoid open coded, 'custom' versions of standard linux
> kernel programming conventions. rbtree's are coded in a specific and
> standard way across the entire kernel that everyone can quickly understand
> and verify. There is no reason for an exception here.
>
> Also, __ref_tree_search() and ref_tree_insert() are both re-doing the same
> search so your custom rbtree() code is also slower than what we'd get if
> you used the usual methods.
ref_tree_insert() will use these parameters(pos and pos_parent) without 
same search.
Of course, you are right, we need to avoid open coded, I'll use standard 
methods.
>
> Please CC me on any revisions to this patch as I am very interested to see
> btrfs fiemap performance get back in line with other filesystems.
>
> Thanks,
> 	--Mark
>
> --
> Mark Fasheh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message tomajordomo@vger.kernel.org
> More majordomo info athttp://vger.kernel.org/majordomo-info.html
>
>
Thanks,
Lu




