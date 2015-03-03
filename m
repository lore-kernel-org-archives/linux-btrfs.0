Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:32030 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756189AbbCCLWK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Mar 2015 06:22:10 -0500
Message-ID: <54F5988C.4020905@cn.fujitsu.com>
Date: Tue, 3 Mar 2015 19:18:36 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, <mfasheh@suse.de>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/3] btrfs: qgroup: fix a wrong parameter of no_quota.
References: <1423563845-9103-1-git-send-email-yangds.fnst@cn.fujitsu.com> <1423563845-9103-4-git-send-email-yangds.fnst@cn.fujitsu.com> <54DDC62D.4070206@cn.fujitsu.com> <54EEB798.1070105@cn.fujitsu.com>
In-Reply-To: <54EEB798.1070105@cn.fujitsu.com>
Content-Type: multipart/mixed;
	boundary="------------040503020909030802000301"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--------------040503020909030802000301
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit

On 02/26/2015 02:05 PM, Dongsheng Yang wrote:
> Wait a minute, this patch seems not working well in accounting quota 
> number when
> deleting data shared by different subvolumes.
>
> I will investigate more about it and send a V2 out.
I have sent a fstest
  [PATCH] fstest: btrfs: add a test for quota number when deleting a subvol.
for this problem I was trying to solve in this patch.

Please consider reverting the two commits introduced the problem:

e339a6b0 (Btrfs: __btrfs_mod_ref should always use no_quota)
1152651a (btrfs: qgroup: account shared subtrees during snapshot delete)

as what I attached.

Thanx
>
> Thanx
> Yang
>
> On 02/13/2015 05:38 PM, Dongsheng Yang wrote:hen
>> Hi Josef and Mark,
>>
>> I saw the commit message of 1152651a:
>>
>> [btrfs: qgroup: account shared subtrees during snapshot delete]
>>
>> that SUBTREE operation was introduced to account the quota number
>> in subvolume deleting.
>>
>> But, I found it does not work well currently：
>>
>> Create subvolume '/mnt/sub'
>> + btrfs qgroup show -prce /mnt
>> qgroupid rfer excl max_rfer max_excl parent child
>> -------- ---- ---- -------- -------- ------ -----
>> 0/5 16.00KiB 16.00KiB 0.00B 0.00B --- ---
>> 0/257 16.00KiB 16.00KiB 0.00B 0.00B --- ---
>> + dd if=/dev/zero of=/mnt/sub/data bs=1024 count=100
>> 100+0 records in
>> 100+0 records out
>> 102400 bytes (102 kB) copied, 0.000876526 s, 117 MB/s
>> + sync
>> + btrfs qgroup show -prce --raw /mnt
>> qgroupid rfer excl max_rfer max_excl parent child
>> -------- ---- ---- -------- -------- ------ -----
>> 0/5 16384 16384 0 0 --- ---
>> 0/257 118784 118784 0 0 --- ---
>> + btrfs sub snap /mnt/sub /mnt/snap
>> Create a snapshot of '/mnt/sub' in '/mnt/snap'
>> + sync
>> + btrfs qgroup show -prce --raw /mnt
>> qgroupid rfer excl max_rfer max_excl parent child
>> -------- ---- ---- -------- -------- ------ -----
>> 0/5 16384 16384 0 0 --- ---
>> 0/257 118784 16384 0 0 --- ---
>> 0/258 118784 16384 0 0 --- ---
>> + btrfs sub delete /mnt/sub
>> Delete subvolume (no-commit): '/mnt/sub'
>> + sync
>> + btrfs qgroup show -prce --raw /mnt
>> qgroupid rfer excl max_rfer max_excl parent child
>> -------- ---- ---- -------- -------- ------ -----
>> 0/5 16384 16384 0 0 --- ---
>> 0/257 118784 16384 0 0 --- ---
>> 0/258 118784 16384 0 0 --- ---
>>
>> --------------------------------------------------------------------------- 
>> <------- WAIT for cleaner
>> [root@atest-guest linux_btrfs]# btrfs qgroup show -prce /mnt
>> qgroupid rfer excl max_rfer max_excl parent child
>> -------- ---- ---- -------- -------- ------ -----
>> 0/5 16.00KiB 16.00KiB 0.00B 0.00B --- ---
>> 0/257 100.00KiB 0.00B 0.00B 0.00B --- --- <------- the data size was 
>> not cleaned from qgroup.
>> 0/258 116.00KiB 116.00KiB 0.00B 0.00B --- --- <------- but the excl 
>> in the snapshot qgroup is increased to 116KB by SUBTREE operation
>>
>> My question is:
>> (1), SUBTREE is not working well.
>> (2), why we need a rule-breaker in qgroup operations SUBTREE to do 
>> this work?
>> We can do it via the delayed-ref routine like the other qgroup 
>> operations.
>>
>> with my patch here applied and 1152651a reverted, I got the result:
>> qgroupid rfer excl max_rfer max_excl parent child
>> -------- ---- ---- -------- -------- ------ -----
>> 0/5 16.00KiB 16.00KiB 0.00B 0.00B --- ---
>> 0/257 0.00B 0.00B 0.00B 0.00B --- --- <----------- data and tree 
>> block both are cleaned
>> 0/258 116.00KiB 116.00KiB 0.00B 0.00B --- --- <------ quota numbers 
>> in snapshot qgroup is correct.
>>
>> (1), quota is working well now in subvolume deleting.
>> (2), all operations are inserted by delayed-ref.
>>
>> So, the conclusion seems like that:
>> (1), commit 1152651a was introducing a SUBTREE operation to account 
>> the number in subvolume deleted.
>> (2). SUBTREE is not working well.
>> (3). we can solve the same problem in a better way without 
>> introducing a new operation of SUBTREE.
>>
>> To be honest, I am suspecting myself *very much*. I trust you guys 
>> and believe there must be something I am missing.
>>
>> Then I send this mail to ask your help.
>>
>> Thanx in advance.
>> Yang
>>
>>
>> On 02/10/2015 06:24 PM, Dongsheng Yang wrote:
>>> In function of __btrfs_mod_ref(), we are passing the no_quota=1
>>> to process_func() anyway. It will make the numbers in qgroup be
>>> wrong when deleting a subvolume. The data size in a deleted subvolume
>>> will never be decressed from all related qgroups.
>>>
>>> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
>>> ---
>>>   fs/btrfs/extent-tree.c | 8 ++++++--
>>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>> index 652be74..f59809c 100644
>>> --- a/fs/btrfs/extent-tree.c
>>> +++ b/fs/btrfs/extent-tree.c
>>> @@ -3056,6 +3056,7 @@ static int __btrfs_mod_ref(struct 
>>> btrfs_trans_handle *trans,
>>>       int i;
>>>       int level;
>>>       int ret = 0;
>>> +    int no_quota = 0;
>>>       int (*process_func)(struct btrfs_trans_handle *, struct 
>>> btrfs_root *,
>>>                   u64, u64, u64, u64, u64, u64, int);
>>>   @@ -3080,6 +3081,9 @@ static int __btrfs_mod_ref(struct 
>>> btrfs_trans_handle *trans,
>>>       else
>>>           parent = 0;
>>>   +    if (!root->fs_info->quota_enabled || !is_fstree(ref_root))
>>> +        no_quota = 1;
>>> +
>>>       for (i = 0; i < nritems; i++) {
>>>           if (level == 0) {
>>>               btrfs_item_key_to_cpu(buf, &key, i);
>>> @@ -3098,7 +3102,7 @@ static int __btrfs_mod_ref(struct 
>>> btrfs_trans_handle *trans,
>>>               key.offset -= btrfs_file_extent_offset(buf, fi);
>>>               ret = process_func(trans, root, bytenr, num_bytes,
>>>                          parent, ref_root, key.objectid,
>>> -                       key.offset, 1);
>>> +                       key.offset, no_quota);
>>>               if (ret)
>>>                   goto fail;
>>>           } else {
>>> @@ -3106,7 +3110,7 @@ static int __btrfs_mod_ref(struct 
>>> btrfs_trans_handle *trans,
>>>               num_bytes = root->nodesize;
>>>               ret = process_func(trans, root, bytenr, num_bytes,
>>>                          parent, ref_root, level - 1, 0,
>>> -                       1);
>>> +                       no_quota);
>>>               if (ret)
>>>                   goto fail;
>>>           }
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>> .
>>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
>


--------------040503020909030802000301
Content-Type: text/x-patch;
	name="0001-Revert-btrfs-qgroup-account-shared-subtrees-during-s.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0001-Revert-btrfs-qgroup-account-shared-subtrees-during-s.pa";
	filename*1="tch"

>From c71244a6017d6917e0281c5390817fcf901b8ca1 Mon Sep 17 00:00:00 2001
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Date: Tue, 3 Mar 2015 04:31:43 -0500
Subject: [PATCH 1/2] Revert "btrfs: qgroup: account shared subtrees during
 snapshot delete"

This reverts commit 1152651a081720ef6a8c76bb7da676e8c900ac30.

Conflicts:
	fs/btrfs/extent-tree.c
	fs/btrfs/qgroup.c
---
 fs/btrfs/extent-tree.c | 260 -------------------------------------------------
 fs/btrfs/qgroup.c      | 176 ---------------------------------
 fs/btrfs/qgroup.h      |   1 -
 3 files changed, 437 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4d9f6c5..ae305fa 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7499,219 +7499,6 @@ reada:
 	wc->reada_slot = slot;
 }
 
-static int account_leaf_items(struct btrfs_trans_handle *trans,
-			      struct btrfs_root *root,
-			      struct extent_buffer *eb)
-{
-	int nr = btrfs_header_nritems(eb);
-	int i, extent_type, ret;
-	struct btrfs_key key;
-	struct btrfs_file_extent_item *fi;
-	u64 bytenr, num_bytes;
-
-	for (i = 0; i < nr; i++) {
-		btrfs_item_key_to_cpu(eb, &key, i);
-
-		if (key.type != BTRFS_EXTENT_DATA_KEY)
-			continue;
-
-		fi = btrfs_item_ptr(eb, i, struct btrfs_file_extent_item);
-		/* filter out non qgroup-accountable extents  */
-		extent_type = btrfs_file_extent_type(eb, fi);
-
-		if (extent_type == BTRFS_FILE_EXTENT_INLINE)
-			continue;
-
-		bytenr = btrfs_file_extent_disk_bytenr(eb, fi);
-		if (!bytenr)
-			continue;
-
-		num_bytes = btrfs_file_extent_disk_num_bytes(eb, fi);
-
-		ret = btrfs_qgroup_record_ref(trans, root->fs_info,
-					      root->objectid,
-					      bytenr, num_bytes,
-					      BTRFS_QGROUP_OPER_SUB_SUBTREE,
-					      BTRFS_QGROUP_TYPE_METADATA, 0);
-		if (ret)
-			return ret;
-	}
-	return 0;
-}
-
-/*
- * Walk up the tree from the bottom, freeing leaves and any interior
- * nodes which have had all slots visited. If a node (leaf or
- * interior) is freed, the node above it will have it's slot
- * incremented. The root node will never be freed.
- *
- * At the end of this function, we should have a path which has all
- * slots incremented to the next position for a search. If we need to
- * read a new node it will be NULL and the node above it will have the
- * correct slot selected for a later read.
- *
- * If we increment the root nodes slot counter past the number of
- * elements, 1 is returned to signal completion of the search.
- */
-static int adjust_slots_upwards(struct btrfs_root *root,
-				struct btrfs_path *path, int root_level)
-{
-	int level = 0;
-	int nr, slot;
-	struct extent_buffer *eb;
-
-	if (root_level == 0)
-		return 1;
-
-	while (level <= root_level) {
-		eb = path->nodes[level];
-		nr = btrfs_header_nritems(eb);
-		path->slots[level]++;
-		slot = path->slots[level];
-		if (slot >= nr || level == 0) {
-			/*
-			 * Don't free the root -  we will detect this
-			 * condition after our loop and return a
-			 * positive value for caller to stop walking the tree.
-			 */
-			if (level != root_level) {
-				btrfs_tree_unlock_rw(eb, path->locks[level]);
-				path->locks[level] = 0;
-
-				free_extent_buffer(eb);
-				path->nodes[level] = NULL;
-				path->slots[level] = 0;
-			}
-		} else {
-			/*
-			 * We have a valid slot to walk back down
-			 * from. Stop here so caller can process these
-			 * new nodes.
-			 */
-			break;
-		}
-
-		level++;
-	}
-
-	eb = path->nodes[root_level];
-	if (path->slots[root_level] >= btrfs_header_nritems(eb))
-		return 1;
-
-	return 0;
-}
-
-/*
- * root_eb is the subtree root and is locked before this function is called.
- */
-static int account_shared_subtree(struct btrfs_trans_handle *trans,
-				  struct btrfs_root *root,
-				  struct extent_buffer *root_eb,
-				  u64 root_gen,
-				  int root_level)
-{
-	int ret = 0;
-	int level;
-	struct extent_buffer *eb = root_eb;
-	struct btrfs_path *path = NULL;
-
-	BUG_ON(root_level < 0 || root_level > BTRFS_MAX_LEVEL);
-	BUG_ON(root_eb == NULL);
-
-	if (!root->fs_info->quota_enabled)
-		return 0;
-
-	if (!extent_buffer_uptodate(root_eb)) {
-		ret = btrfs_read_buffer(root_eb, root_gen);
-		if (ret)
-			goto out;
-	}
-
-	if (root_level == 0) {
-		ret = account_leaf_items(trans, root, root_eb);
-		goto out;
-	}
-
-	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
-
-	/*
-	 * Walk down the tree.  Missing extent blocks are filled in as
-	 * we go. Metadata is accounted every time we read a new
-	 * extent block.
-	 *
-	 * When we reach a leaf, we account for file extent items in it,
-	 * walk back up the tree (adjusting slot pointers as we go)
-	 * and restart the search process.
-	 */
-	extent_buffer_get(root_eb); /* For path */
-	path->nodes[root_level] = root_eb;
-	path->slots[root_level] = 0;
-	path->locks[root_level] = 0; /* so release_path doesn't try to unlock */
-walk_down:
-	level = root_level;
-	while (level >= 0) {
-		if (path->nodes[level] == NULL) {
-			int parent_slot;
-			u64 child_gen;
-			u64 child_bytenr;
-
-			/* We need to get child blockptr/gen from
-			 * parent before we can read it. */
-			eb = path->nodes[level + 1];
-			parent_slot = path->slots[level + 1];
-			child_bytenr = btrfs_node_blockptr(eb, parent_slot);
-			child_gen = btrfs_node_ptr_generation(eb, parent_slot);
-
-			eb = read_tree_block(root, child_bytenr, child_gen);
-			if (!eb || !extent_buffer_uptodate(eb)) {
-				ret = -EIO;
-				goto out;
-			}
-
-			path->nodes[level] = eb;
-			path->slots[level] = 0;
-
-			btrfs_tree_read_lock(eb);
-			btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
-			path->locks[level] = BTRFS_READ_LOCK_BLOCKING;
-
-			ret = btrfs_qgroup_record_ref(trans, root->fs_info,
-						root->objectid,
-						child_bytenr,
-						root->nodesize,
-						BTRFS_QGROUP_OPER_SUB_SUBTREE,
-						BTRFS_QGROUP_TYPE_METADATA, 0);
-			if (ret)
-				goto out;
-
-		}
-
-		if (level == 0) {
-			ret = account_leaf_items(trans, root, path->nodes[level]);
-			if (ret)
-				goto out;
-
-			/* Nonzero return here means we completed our search */
-			ret = adjust_slots_upwards(root, path, root_level);
-			if (ret)
-				break;
-
-			/* Restart search with new slots */
-			goto walk_down;
-		}
-
-		level--;
-	}
-
-	ret = 0;
-out:
-	btrfs_free_path(path);
-
-	return ret;
-}
-
 /*
  * helper to process tree block while walking down the tree.
  *
@@ -7815,7 +7602,6 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 	int level = wc->level;
 	int reada = 0;
 	int ret = 0;
-	bool need_account = false;
 
 	generation = btrfs_node_ptr_generation(path->nodes[level],
 					       path->slots[level]);
@@ -7861,7 +7647,6 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 
 	if (wc->stage == DROP_REFERENCE) {
 		if (wc->refs[level - 1] > 1) {
-			need_account = true;
 			if (level == 1 &&
 			    (wc->flags[0] & BTRFS_BLOCK_FLAG_FULL_BACKREF))
 				goto skip;
@@ -7925,16 +7710,6 @@ skip:
 			parent = 0;
 		}
 
-		if (need_account) {
-			ret = account_shared_subtree(trans, root, next,
-						     generation, level - 1);
-			if (ret) {
-				printk_ratelimited(KERN_ERR "BTRFS: %s Error "
-					"%d accounting shared subtree. Quota "
-					"is out of sync, rescan required.\n",
-					root->fs_info->sb->s_id, ret);
-			}
-		}
 		ret = btrfs_free_extent(trans, root, bytenr, blocksize, parent,
 				root->root_key.objectid, level - 1, 0, 0);
 		BUG_ON(ret); /* -ENOMEM */
@@ -8019,13 +7794,6 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 			else
 				ret = btrfs_dec_ref(trans, root, eb, 0);
 			BUG_ON(ret); /* -ENOMEM */
-			ret = account_leaf_items(trans, root, eb);
-			if (ret) {
-				printk_ratelimited(KERN_ERR "BTRFS: %s Error "
-					"%d accounting leaf items. Quota "
-					"is out of sync, rescan required.\n",
-					root->fs_info->sb->s_id, ret);
-			}
 		}
 		/* make block locked assertion in clean_tree_block happy */
 		if (!path->locks[level] &&
@@ -8151,8 +7919,6 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 	int level;
 	bool root_dropped = false;
 
-	btrfs_debug(root->fs_info, "Drop subvolume %llu", root->objectid);
-
 	path = btrfs_alloc_path();
 	if (!path) {
 		err = -ENOMEM;
@@ -8278,24 +8044,6 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 				goto out_end_trans;
 			}
 
-			/*
-			 * Qgroup update accounting is run from
-			 * delayed ref handling. This usually works
-			 * out because delayed refs are normally the
-			 * only way qgroup updates are added. However,
-			 * we may have added updates during our tree
-			 * walk so run qgroups here to make sure we
-			 * don't lose any updates.
-			 */
-			ret = btrfs_delayed_qgroup_accounting(trans,
-							      root->fs_info);
-			if (ret)
-				printk_ratelimited(KERN_ERR "BTRFS: Failure %d "
-						   "running qgroup updates "
-						   "during snapshot delete. "
-						   "Quota is out of sync, "
-						   "rescan required.\n", ret);
-
 			btrfs_end_transaction_throttle(trans, tree_root);
 			if (!for_reloc && btrfs_need_cleaner_sleep(root)) {
 				pr_debug("BTRFS: drop snapshot early exit\n");
@@ -8349,14 +8097,6 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 	}
 	root_dropped = true;
 out_end_trans:
-	ret = btrfs_delayed_qgroup_accounting(trans, tree_root->fs_info);
-	if (ret)
-		printk_ratelimited(KERN_ERR "BTRFS: Failure %d "
-				   "running qgroup updates "
-				   "during snapshot delete. "
-				   "Quota is out of sync, "
-				   "rescan required.\n", ret);
-
 	btrfs_end_transaction_throttle(trans, tree_root);
 out_free:
 	kfree(wc);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 103a908..2acf059 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1262,50 +1262,6 @@ out:
 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 	return ret;
 }
-
-static int comp_oper_exist(struct btrfs_qgroup_operation *oper1,
-			   struct btrfs_qgroup_operation *oper2)
-{
-	/*
-	 * Ignore seq and type here, we're looking for any operation
-	 * at all related to this extent on that root.
-	 */
-	if (oper1->bytenr < oper2->bytenr)
-		return -1;
-	if (oper1->bytenr > oper2->bytenr)
-		return 1;
-	if (oper1->ref_root < oper2->ref_root)
-		return -1;
-	if (oper1->ref_root > oper2->ref_root)
-		return 1;
-	return 0;
-}
-
-static int qgroup_oper_exists(struct btrfs_fs_info *fs_info,
-			      struct btrfs_qgroup_operation *oper)
-{
-	struct rb_node *n;
-	struct btrfs_qgroup_operation *cur;
-	int cmp;
-
-	spin_lock(&fs_info->qgroup_op_lock);
-	n = fs_info->qgroup_op_tree.rb_node;
-	while (n) {
-		cur = rb_entry(n, struct btrfs_qgroup_operation, n);
-		cmp = comp_oper_exist(cur, oper);
-		if (cmp < 0) {
-			n = n->rb_right;
-		} else if (cmp) {
-			n = n->rb_left;
-		} else {
-			spin_unlock(&fs_info->qgroup_op_lock);
-			return -EEXIST;
-		}
-	}
-	spin_unlock(&fs_info->qgroup_op_lock);
-	return 0;
-}
-
 static int comp_oper(struct btrfs_qgroup_operation *oper1,
 		     struct btrfs_qgroup_operation *oper2)
 {
@@ -1397,25 +1353,6 @@ int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
 	oper->seq = atomic_inc_return(&fs_info->qgroup_op_seq);
 	INIT_LIST_HEAD(&oper->elem.list);
 	oper->elem.seq = 0;
-
-	trace_btrfs_qgroup_record_ref(oper);
-
-	if (type == BTRFS_QGROUP_OPER_SUB_SUBTREE) {
-		/*
-		 * If any operation for this bytenr/ref_root combo
-		 * exists, then we know it's not exclusively owned and
-		 * shouldn't be queued up.
-		 *
-		 * This also catches the case where we have a cloned
-		 * extent that gets queued up multiple times during
-		 * drop snapshot.
-		 */
-		if (qgroup_oper_exists(fs_info, oper)) {
-			kfree(oper);
-			return 0;
-		}
-	}
-
 	ret = insert_qgroup_oper(fs_info, oper);
 	if (ret) {
 		/* Shouldn't happen so have an assert for developers */
@@ -2025,116 +1962,6 @@ out:
 }
 
 /*
- * Process a reference to a shared subtree. This type of operation is
- * queued during snapshot removal when we encounter extents which are
- * shared between more than one root.
- */
-static int qgroup_subtree_accounting(struct btrfs_trans_handle *trans,
-				     struct btrfs_fs_info *fs_info,
-				     struct btrfs_qgroup_operation *oper)
-{
-	struct ulist *roots = NULL;
-	struct ulist_node *unode;
-	struct ulist_iterator uiter;
-	struct btrfs_qgroup_list *glist;
-	struct ulist *parents;
-	int ret = 0;
-	int err;
-	struct btrfs_qgroup *qg;
-	u64 root_obj = 0;
-	struct seq_list elem = {};
-
-	parents = ulist_alloc(GFP_NOFS);
-	if (!parents)
-		return -ENOMEM;
-
-	btrfs_get_tree_mod_seq(fs_info, &elem);
-	ret = btrfs_find_all_roots(trans, fs_info, oper->bytenr,
-				   elem.seq, &roots);
-	btrfs_put_tree_mod_seq(fs_info, &elem);
-	if (ret < 0)
-		goto out;
-
-	if (roots->nnodes != 1)
-		goto out;
-
-	ULIST_ITER_INIT(&uiter);
-	unode = ulist_next(roots, &uiter); /* Only want 1 so no need to loop */
-	/*
-	 * If we find our ref root then that means all refs
-	 * this extent has to the root have not yet been
-	 * deleted. In that case, we do nothing and let the
-	 * last ref for this bytenr drive our update.
-	 *
-	 * This can happen for example if an extent is
-	 * referenced multiple times in a snapshot (clone,
-	 * etc). If we are in the middle of snapshot removal,
-	 * queued updates for such an extent will find the
-	 * root if we have not yet finished removing the
-	 * snapshot.
-	 */
-	if (unode->val == oper->ref_root)
-		goto out;
-
-	root_obj = unode->val;
-	BUG_ON(!root_obj);
-
-	spin_lock(&fs_info->qgroup_lock);
-	qg = find_qgroup_rb(fs_info, root_obj);
-	if (!qg)
-		goto out_unlock;
-
-	if ((qg->type & oper->quota_type)) {
-		qg->excl += oper->num_bytes;
-		qg->excl_cmpr += oper->num_bytes;
-		qgroup_dirty(fs_info, qg);
-	}
-
-	/*
-	 * Adjust counts for parent groups. First we find all
-	 * parents, then in the 2nd loop we do the adjustment
-	 * while adding parents of the parents to our ulist.
-	 */
-	list_for_each_entry(glist, &qg->groups, next_group) {
-		err = ulist_add(parents, glist->group->qgroupid,
-				ptr_to_u64(glist->group), GFP_ATOMIC);
-		if (err < 0) {
-			ret = err;
-			goto out_unlock;
-		}
-	}
-
-	ULIST_ITER_INIT(&uiter);
-	while ((unode = ulist_next(parents, &uiter))) {
-		qg = u64_to_ptr(unode->aux);
-
-		if ((qg->type & oper->quota_type)) {
-			qg->excl += oper->num_bytes;
-			qg->excl_cmpr += oper->num_bytes;
-			qgroup_dirty(fs_info, qg);
-		}
-
-		/* Add any parents of the parents */
-		list_for_each_entry(glist, &qg->groups, next_group) {
-			err = ulist_add(parents, glist->group->qgroupid,
-					ptr_to_u64(glist->group), GFP_ATOMIC);
-			if (err < 0) {
-				ret = err;
-				goto out_unlock;
-			}
-		}
-	}
-
-out_unlock:
-	spin_unlock(&fs_info->qgroup_lock);
-
-out:
-	ulist_free(roots);
-	ulist_free(parents);
-	return ret;
-}
-
-/*
  * btrfs_qgroup_account_ref is called for every ref that is added to or deleted
  * from the fs. First, all roots referencing the extent are searched, and
  * then the space is accounted accordingly to the different roots. The
@@ -2173,9 +2000,6 @@ static int btrfs_qgroup_account(struct btrfs_trans_handle *trans,
 	case BTRFS_QGROUP_OPER_SUB_SHARED:
 		ret = qgroup_shared_accounting(trans, fs_info, oper);
 		break;
-	case BTRFS_QGROUP_OPER_SUB_SUBTREE:
-		ret = qgroup_subtree_accounting(trans, fs_info, oper);
-		break;
 	default:
 		ASSERT(0);
 	}
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 52cfdc2..9722888 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -60,7 +60,6 @@ enum btrfs_qgroup_operation_type {
 	BTRFS_QGROUP_OPER_ADD_SHARED,
 	BTRFS_QGROUP_OPER_SUB_EXCL,
 	BTRFS_QGROUP_OPER_SUB_SHARED,
-	BTRFS_QGROUP_OPER_SUB_SUBTREE,
 };
 
 struct btrfs_qgroup_operation {
-- 
1.8.4.2


--------------040503020909030802000301
Content-Type: text/x-patch;
	name="0002-Revert-Btrfs-__btrfs_mod_ref-should-always-use-no_qu.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0002-Revert-Btrfs-__btrfs_mod_ref-should-always-use-no_qu.pa";
	filename*1="tch"

>From 21b2e636b1beb005d39188608030793c41c1e4fc Mon Sep 17 00:00:00 2001
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Date: Tue, 3 Mar 2015 06:59:19 -0500
Subject: [PATCH 2/2] Revert "Btrfs: __btrfs_mod_ref should always use
 no_quota"

This reverts commit e339a6b097c515a31ce230d498c44ff2e89f1cf4.
---
 fs/btrfs/ctree.c       | 20 ++++++++++----------
 fs/btrfs/ctree.h       |  4 ++--
 fs/btrfs/extent-tree.c | 24 +++++++++++++-----------
 3 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 14a72ed..a06cd4a 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -269,9 +269,9 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 
 	WARN_ON(btrfs_header_generation(buf) > trans->transid);
 	if (new_root_objectid == BTRFS_TREE_RELOC_OBJECTID)
-		ret = btrfs_inc_ref(trans, root, cow, 1);
+		ret = btrfs_inc_ref(trans, root, cow, 1, 1);
 	else
-		ret = btrfs_inc_ref(trans, root, cow, 0);
+		ret = btrfs_inc_ref(trans, root, cow, 0, 1);
 
 	if (ret)
 		return ret;
@@ -1024,14 +1024,14 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 		if ((owner == root->root_key.objectid ||
 		     root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID) &&
 		    !(flags & BTRFS_BLOCK_FLAG_FULL_BACKREF)) {
-			ret = btrfs_inc_ref(trans, root, buf, 1);
+			ret = btrfs_inc_ref(trans, root, buf, 1, 1);
 			BUG_ON(ret); /* -ENOMEM */
 
 			if (root->root_key.objectid ==
 			    BTRFS_TREE_RELOC_OBJECTID) {
-				ret = btrfs_dec_ref(trans, root, buf, 0);
+				ret = btrfs_dec_ref(trans, root, buf, 0, 1);
 				BUG_ON(ret); /* -ENOMEM */
-				ret = btrfs_inc_ref(trans, root, cow, 1);
+				ret = btrfs_inc_ref(trans, root, cow, 1, 1);
 				BUG_ON(ret); /* -ENOMEM */
 			}
 			new_flags |= BTRFS_BLOCK_FLAG_FULL_BACKREF;
@@ -1039,9 +1039,9 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 
 			if (root->root_key.objectid ==
 			    BTRFS_TREE_RELOC_OBJECTID)
-				ret = btrfs_inc_ref(trans, root, cow, 1);
+				ret = btrfs_inc_ref(trans, root, cow, 1, 1);
 			else
-				ret = btrfs_inc_ref(trans, root, cow, 0);
+				ret = btrfs_inc_ref(trans, root, cow, 0, 1);
 			BUG_ON(ret); /* -ENOMEM */
 		}
 		if (new_flags != 0) {
@@ -1058,11 +1058,11 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 		if (flags & BTRFS_BLOCK_FLAG_FULL_BACKREF) {
 			if (root->root_key.objectid ==
 			    BTRFS_TREE_RELOC_OBJECTID)
-				ret = btrfs_inc_ref(trans, root, cow, 1);
+				ret = btrfs_inc_ref(trans, root, cow, 1, 1);
 			else
-				ret = btrfs_inc_ref(trans, root, cow, 0);
+				ret = btrfs_inc_ref(trans, root, cow, 0, 1);
 			BUG_ON(ret); /* -ENOMEM */
-			ret = btrfs_dec_ref(trans, root, buf, 1);
+			ret = btrfs_dec_ref(trans, root, buf, 1, 1);
 			BUG_ON(ret); /* -ENOMEM */
 		}
 		clean_tree_block(trans, root, buf);
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8034d07..d58a6d3 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3387,9 +3387,9 @@ int btrfs_reserve_extent(struct btrfs_root *root, u64 num_bytes,
 			 u64 min_alloc_size, u64 empty_size, u64 hint_byte,
 			 struct btrfs_key *ins, int is_data, int delalloc);
 int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		  struct extent_buffer *buf, int full_backref);
+		  struct extent_buffer *buf, int full_backref, int no_quota);
 int btrfs_dec_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		  struct extent_buffer *buf, int full_backref);
+		  struct extent_buffer *buf, int full_backref, int no_quota);
 int btrfs_set_disk_extent_flags(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				u64 bytenr, u64 num_bytes, u64 flags,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ae305fa..313aff9 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3049,7 +3049,7 @@ out:
 static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   struct extent_buffer *buf,
-			   int full_backref, int inc)
+			   int full_backref, int inc, int no_quota)
 {
 	u64 bytenr;
 	u64 num_bytes;
@@ -3103,7 +3103,7 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 			key.offset -= btrfs_file_extent_offset(buf, fi);
 			ret = process_func(trans, root, bytenr, num_bytes,
 					   parent, ref_root, key.objectid,
-					   key.offset, 1);
+					   key.offset, no_quota);
 			if (ret)
 				goto fail;
 		} else {
@@ -3111,7 +3111,7 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 			num_bytes = root->nodesize;
 			ret = process_func(trans, root, bytenr, num_bytes,
 					   parent, ref_root, level - 1, 0,
-					   1);
+					   no_quota);
 			if (ret)
 				goto fail;
 		}
@@ -3122,15 +3122,15 @@ fail:
 }
 
 int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		  struct extent_buffer *buf, int full_backref)
+		  struct extent_buffer *buf, int full_backref, int no_quota)
 {
-	return __btrfs_mod_ref(trans, root, buf, full_backref, 1);
+	return __btrfs_mod_ref(trans, root, buf, full_backref, 1, no_quota);
 }
 
 int btrfs_dec_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		  struct extent_buffer *buf, int full_backref)
+		  struct extent_buffer *buf, int full_backref, int no_quota)
 {
-	return __btrfs_mod_ref(trans, root, buf, full_backref, 0);
+	return __btrfs_mod_ref(trans, root, buf, full_backref, 0, no_quota);
 }
 
 static int write_one_cache_group(struct btrfs_trans_handle *trans,
@@ -7553,9 +7553,9 @@ static noinline int walk_down_proc(struct btrfs_trans_handle *trans,
 	/* wc->stage == UPDATE_BACKREF */
 	if (!(wc->flags[level] & flag)) {
 		BUG_ON(!path->locks[level]);
-		ret = btrfs_inc_ref(trans, root, eb, 1);
+		ret = btrfs_inc_ref(trans, root, eb, 1, wc->for_reloc);
 		BUG_ON(ret); /* -ENOMEM */
-		ret = btrfs_dec_ref(trans, root, eb, 0);
+		ret = btrfs_dec_ref(trans, root, eb, 0, wc->for_reloc);
 		BUG_ON(ret); /* -ENOMEM */
 		ret = btrfs_set_disk_extent_flags(trans, root, eb->start,
 						  eb->len, flag,
@@ -7790,9 +7790,11 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 	if (wc->refs[level] == 1) {
 		if (level == 0) {
 			if (wc->flags[level] & BTRFS_BLOCK_FLAG_FULL_BACKREF)
-				ret = btrfs_dec_ref(trans, root, eb, 1);
+				ret = btrfs_dec_ref(trans, root, eb, 1,
+						    wc->for_reloc);
 			else
-				ret = btrfs_dec_ref(trans, root, eb, 0);
+				ret = btrfs_dec_ref(trans, root, eb, 0,
+						    wc->for_reloc);
 			BUG_ON(ret); /* -ENOMEM */
 		}
 		/* make block locked assertion in clean_tree_block happy */
-- 
1.8.4.2


--------------040503020909030802000301--
