Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:33117 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751168AbdFBSOU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Jun 2017 14:14:20 -0400
Received: by mail-pf0-f175.google.com with SMTP id e193so54511928pfh.0
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Jun 2017 11:14:20 -0700 (PDT)
Date: Fri, 2 Jun 2017 11:14:13 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: skip commit transaction if we don't have enough
 pinned bytes
Message-ID: <20170602181413.GA20531@vader.DHCP.thefacebook.com>
References: <20170519173915.29846-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170519173915.29846-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 19, 2017 at 11:39:15AM -0600, Liu Bo wrote:
> We commit transaction in order to reclaim space from pinned bytes because
> it could process delayed refs, and in may_commit_transaction(), we check
> first if pinned bytes are enough for the required space, we then check if
> that plus bytes reserved for delayed insert are enough for the required
> space.
> 
> This changes the code to the above logic.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/extent-tree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index e390451c72e6..bded1ddd1bb6 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4837,7 +4837,7 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
>  
>  	spin_lock(&delayed_rsv->lock);
>  	if (percpu_counter_compare(&space_info->total_bytes_pinned,
> -				   bytes - delayed_rsv->size) >= 0) {
> +				   bytes - delayed_rsv->size) < 0) {
>  		spin_unlock(&delayed_rsv->lock);
>  		return -ENOSPC;
>  	}

I found this bug in my latest enospc investigation, too. However, the
total_bytes_pinned counter is pretty broken. E.g., on my laptop:

$ sync; grep -H '' /sys/fs/btrfs/*/allocation/*/total_bytes_pinned
/sys/fs/btrfs/f31cc926-37d3-442d-b50a-10c62d47badc/allocation/data/total_bytes_pinned:48693501952
/sys/fs/btrfs/f31cc926-37d3-442d-b50a-10c62d47badc/allocation/metadata/total_bytes_pinned:-258146304
/sys/fs/btrfs/f31cc926-37d3-442d-b50a-10c62d47badc/allocation/system/total_bytes_pinned:0

I have a patch to fix it that I haven't cleaned up yet, below. Without
it, Bo's fix will probably cause early ENOSPCs. Dave, should we pull
Bo's patch out of for-next? In any case, I'll get my fix sent out.

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index be70d90dfee5..93ffa898df6d 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -470,7 +470,8 @@ add_delayed_ref_tail_merge(struct btrfs_trans_handle *trans,
 static noinline void
 update_existing_head_ref(struct btrfs_delayed_ref_root *delayed_refs,
 			 struct btrfs_delayed_ref_node *existing,
-			 struct btrfs_delayed_ref_node *update)
+			 struct btrfs_delayed_ref_node *update,
+			 int *old_ref_mod_ret)
 {
 	struct btrfs_delayed_ref_head *existing_ref;
 	struct btrfs_delayed_ref_head *ref;
@@ -523,6 +524,8 @@ update_existing_head_ref(struct btrfs_delayed_ref_root *delayed_refs,
 	 * currently, for refs we just added we know we're a-ok.
 	 */
 	old_ref_mod = existing_ref->total_ref_mod;
+	if (old_ref_mod_ret)
+		*old_ref_mod_ret = old_ref_mod;
 	existing->ref_mod += update->ref_mod;
 	existing_ref->total_ref_mod += update->ref_mod;
 
@@ -550,7 +553,8 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 		     struct btrfs_delayed_ref_node *ref,
 		     struct btrfs_qgroup_extent_record *qrecord,
 		     u64 bytenr, u64 num_bytes, u64 ref_root, u64 reserved,
-		     int action, int is_data, int *qrecord_inserted_ret)
+		     int action, int is_data, int *qrecord_inserted_ret,
+		     int *old_ref_mod, int *new_ref_mod)
 {
 	struct btrfs_delayed_ref_head *existing;
 	struct btrfs_delayed_ref_head *head_ref = NULL;
@@ -638,7 +642,8 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 	if (existing) {
 		WARN_ON(ref_root && reserved && existing->qgroup_ref_root
 			&& existing->qgroup_reserved);
-		update_existing_head_ref(delayed_refs, &existing->node, ref);
+		update_existing_head_ref(delayed_refs, &existing->node, ref,
+					 old_ref_mod);
 		/*
 		 * we've updated the existing ref, free the newly
 		 * allocated ref
@@ -646,6 +651,8 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 		kmem_cache_free(btrfs_delayed_ref_head_cachep, head_ref);
 		head_ref = existing;
 	} else {
+		if (old_ref_mod)
+			*old_ref_mod = 0;
 		if (is_data && count_mod < 0)
 			delayed_refs->pending_csums += num_bytes;
 		delayed_refs->num_heads++;
@@ -655,6 +662,8 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 	}
 	if (qrecord_inserted_ret)
 		*qrecord_inserted_ret = qrecord_inserted;
+	if (new_ref_mod)
+		*new_ref_mod = head_ref->total_ref_mod;
 	return head_ref;
 }
 
@@ -778,7 +787,8 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 			       struct btrfs_trans_handle *trans,
 			       u64 bytenr, u64 num_bytes, u64 parent,
 			       u64 ref_root,  int level, int action,
-			       struct btrfs_delayed_extent_op *extent_op)
+			       struct btrfs_delayed_extent_op *extent_op,
+			       int *old_ref_mod, int *new_ref_mod)
 {
 	struct btrfs_delayed_tree_ref *ref;
 	struct btrfs_delayed_ref_head *head_ref;
@@ -813,7 +823,8 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	 */
 	head_ref = add_delayed_ref_head(fs_info, trans, &head_ref->node, record,
 					bytenr, num_bytes, 0, 0, action, 0,
-					&qrecord_inserted);
+					&qrecord_inserted, old_ref_mod,
+					new_ref_mod);
 
 	add_delayed_tree_ref(fs_info, trans, head_ref, &ref->node, bytenr,
 			     num_bytes, parent, ref_root, level, action);
@@ -838,7 +849,8 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 			       struct btrfs_trans_handle *trans,
 			       u64 bytenr, u64 num_bytes,
 			       u64 parent, u64 ref_root,
-			       u64 owner, u64 offset, u64 reserved, int action)
+			       u64 owner, u64 offset, u64 reserved, int action,
+			       int *old_ref_mod, int *new_ref_mod)
 {
 	struct btrfs_delayed_data_ref *ref;
 	struct btrfs_delayed_ref_head *head_ref;
@@ -878,7 +890,8 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	 */
 	head_ref = add_delayed_ref_head(fs_info, trans, &head_ref->node, record,
 					bytenr, num_bytes, ref_root, reserved,
-					action, 1, &qrecord_inserted);
+					action, 1, &qrecord_inserted,
+					old_ref_mod, new_ref_mod);
 
 	add_delayed_data_ref(fs_info, trans, head_ref, &ref->node, bytenr,
 				   num_bytes, parent, ref_root, owner, offset,
@@ -909,7 +922,7 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 
 	add_delayed_ref_head(fs_info, trans, &head_ref->node, NULL, bytenr,
 			     num_bytes, 0, 0, BTRFS_UPDATE_DELAYED_HEAD,
-			     extent_op->is_data, NULL);
+			     extent_op->is_data, NULL, NULL, NULL);
 
 	spin_unlock(&delayed_refs->lock);
 	return 0;
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index c0264ff01b53..ce88e4ac5276 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -247,12 +247,14 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 			       struct btrfs_trans_handle *trans,
 			       u64 bytenr, u64 num_bytes, u64 parent,
 			       u64 ref_root, int level, int action,
-			       struct btrfs_delayed_extent_op *extent_op);
+			       struct btrfs_delayed_extent_op *extent_op,
+			       int *old_ref_mod, int *new_ref_mod);
 int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 			       struct btrfs_trans_handle *trans,
 			       u64 bytenr, u64 num_bytes,
 			       u64 parent, u64 ref_root,
-			       u64 owner, u64 offset, u64 reserved, int action);
+			       u64 owner, u64 offset, u64 reserved, int action,
+			       int *old_ref_mod, int *new_ref_mod);
 int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 				struct btrfs_trans_handle *trans,
 				u64 bytenr, u64 num_bytes,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e390451c72e6..78cde661997b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -107,6 +107,8 @@ static void space_info_add_new_bytes(struct btrfs_fs_info *fs_info,
 static void space_info_add_old_bytes(struct btrfs_fs_info *fs_info,
 				     struct btrfs_space_info *space_info,
 				     u64 num_bytes);
+static void add_pinned_bytes(struct btrfs_fs_info *fs_info, s64 num_bytes,
+			     u64 owner, u64 root_objectid);
 
 static noinline int
 block_group_cache_done(struct btrfs_block_group_cache *cache)
@@ -2092,6 +2094,7 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 			 u64 bytenr, u64 num_bytes, u64 parent,
 			 u64 root_objectid, u64 owner, u64 offset)
 {
+	int old_ref_mod, new_ref_mod;
 	int ret;
 
 	BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID &&
@@ -2099,15 +2102,21 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 
 	if (owner < BTRFS_FIRST_FREE_OBJECTID) {
 		ret = btrfs_add_delayed_tree_ref(fs_info, trans, bytenr,
-					num_bytes,
-					parent, root_objectid, (int)owner,
-					BTRFS_ADD_DELAYED_REF, NULL);
+						 num_bytes, parent,
+						 root_objectid, (int)owner,
+						 BTRFS_ADD_DELAYED_REF, NULL,
+						 &old_ref_mod, &new_ref_mod);
 	} else {
 		ret = btrfs_add_delayed_data_ref(fs_info, trans, bytenr,
-					num_bytes, parent, root_objectid,
-					owner, offset, 0,
-					BTRFS_ADD_DELAYED_REF);
+						 num_bytes, parent,
+						 root_objectid, owner, offset,
+						 0, BTRFS_ADD_DELAYED_REF,
+						 &old_ref_mod, &new_ref_mod);
 	}
+
+	if (ret == 0 && old_ref_mod < 0 && new_ref_mod >= 0)
+		add_pinned_bytes(fs_info, -num_bytes, owner, root_objectid);
+
 	return ret;
 }
 
@@ -2401,6 +2410,7 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 
 	if (btrfs_delayed_ref_is_head(node)) {
 		struct btrfs_delayed_ref_head *head;
+
 		/*
 		 * we've hit the end of the chain and we were supposed
 		 * to insert this extent into the tree.  But, it got
@@ -2411,6 +2421,17 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 		head = btrfs_delayed_node_to_head(node);
 		trace_run_delayed_ref_head(fs_info, node, head, node->action);
 
+		if (head->total_ref_mod < 0) {
+			struct btrfs_block_group_cache *cache;
+
+			cache = btrfs_lookup_block_group(fs_info, node->bytenr);
+			percpu_counter_add(&cache->space_info->total_bytes_pinned,
+					   -node->num_bytes);
+			BUG_ON(!cache); /* Logic error */
+
+			btrfs_put_block_group(cache);
+		}
+
 		if (insert_reserved) {
 			btrfs_pin_extent(fs_info, node->bytenr,
 					 node->num_bytes, 1);
@@ -6247,6 +6268,8 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 			trace_btrfs_space_reservation(info, "pinned",
 						      cache->space_info->flags,
 						      num_bytes, 1);
+			percpu_counter_add(&cache->space_info->total_bytes_pinned,
+					   num_bytes);
 			set_extent_dirty(info->pinned_extents,
 					 bytenr, bytenr + num_bytes - 1,
 					 GFP_NOFS | __GFP_NOFAIL);
@@ -6323,6 +6346,7 @@ static int pin_down_extent(struct btrfs_fs_info *fs_info,
 
 	trace_btrfs_space_reservation(fs_info, "pinned",
 				      cache->space_info->flags, num_bytes, 1);
+	percpu_counter_add(&cache->space_info->total_bytes_pinned, num_bytes);
 	set_extent_dirty(fs_info->pinned_extents, bytenr,
 			 bytenr + num_bytes - 1, GFP_NOFS | __GFP_NOFAIL);
 	return 0;
@@ -6793,7 +6817,7 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-static void add_pinned_bytes(struct btrfs_fs_info *fs_info, u64 num_bytes,
+static void add_pinned_bytes(struct btrfs_fs_info *fs_info, s64 num_bytes,
 			     u64 owner, u64 root_objectid)
 {
 	struct btrfs_space_info *space_info;
@@ -7036,8 +7060,6 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 				goto out;
 			}
 		}
-		add_pinned_bytes(info, -num_bytes, owner_objectid,
-				 root_objectid);
 	} else {
 		if (found_extent) {
 			BUG_ON(is_data && refs_to_drop !=
@@ -7169,19 +7191,19 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 	int ret;
 
 	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID) {
-		ret = btrfs_add_delayed_tree_ref(fs_info, trans,
-						 buf->start, buf->len,
-						 parent,
+		int old_ref_mod, new_ref_mod;
+
+		ret = btrfs_add_delayed_tree_ref(fs_info, trans, buf->start,
+						 buf->len, parent,
 						 root->root_key.objectid,
 						 btrfs_header_level(buf),
-						 BTRFS_DROP_DELAYED_REF, NULL);
+						 BTRFS_DROP_DELAYED_REF, NULL,
+						 &old_ref_mod, &new_ref_mod);
 		BUG_ON(ret); /* -ENOMEM */
+		pin = old_ref_mod >= 0 && new_ref_mod < 0;
 	}
 
-	if (!last_ref)
-		return;
-
-	if (btrfs_header_generation(buf) == trans->transid) {
+	if (last_ref && btrfs_header_generation(buf) == trans->transid) {
 		struct btrfs_block_group_cache *cache;
 
 		if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID) {
@@ -7190,6 +7212,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 				goto out;
 		}
 
+		pin = 0;
 		cache = btrfs_lookup_block_group(fs_info, buf->start);
 
 		if (btrfs_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN)) {
@@ -7205,18 +7228,19 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 		btrfs_free_reserved_bytes(cache, buf->len, 0);
 		btrfs_put_block_group(cache);
 		trace_btrfs_reserved_extent_free(fs_info, buf->start, buf->len);
-		pin = 0;
 	}
 out:
 	if (pin)
 		add_pinned_bytes(fs_info, buf->len, btrfs_header_level(buf),
 				 root->root_key.objectid);
 
-	/*
-	 * Deleting the buffer, clear the corrupt flag since it doesn't matter
-	 * anymore.
-	 */
-	clear_bit(EXTENT_BUFFER_CORRUPT, &buf->bflags);
+	if (last_ref) {
+		/*
+		 * Deleting the buffer, clear the corrupt flag since it doesn't matter
+		 * anymore.
+		 */
+		clear_bit(EXTENT_BUFFER_CORRUPT, &buf->bflags);
+	}
 }
 
 /* Can return -ENOMEM */
@@ -7225,12 +7249,12 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 		      u64 bytenr, u64 num_bytes, u64 parent, u64 root_objectid,
 		      u64 owner, u64 offset)
 {
+	int old_ref_mod, new_ref_mod;
 	int ret;
 
 	if (btrfs_is_testing(fs_info))
 		return 0;
 
-	add_pinned_bytes(fs_info, num_bytes, owner, root_objectid);
 
 	/*
 	 * tree log blocks never actually go into the extent allocation
@@ -7240,19 +7264,25 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 		WARN_ON(owner >= BTRFS_FIRST_FREE_OBJECTID);
 		/* unlocks the pinned mutex */
 		btrfs_pin_extent(fs_info, bytenr, num_bytes, 1);
+		old_ref_mod = new_ref_mod = 0;
 		ret = 0;
 	} else if (owner < BTRFS_FIRST_FREE_OBJECTID) {
 		ret = btrfs_add_delayed_tree_ref(fs_info, trans, bytenr,
-					num_bytes,
-					parent, root_objectid, (int)owner,
-					BTRFS_DROP_DELAYED_REF, NULL);
+						 num_bytes, parent,
+						 root_objectid, (int)owner,
+						 BTRFS_DROP_DELAYED_REF, NULL,
+						 &old_ref_mod, &new_ref_mod);
 	} else {
 		ret = btrfs_add_delayed_data_ref(fs_info, trans, bytenr,
-						num_bytes,
-						parent, root_objectid, owner,
-						offset, 0,
-						BTRFS_DROP_DELAYED_REF);
+						 num_bytes, parent,
+						 root_objectid, owner, offset,
+						 0, BTRFS_DROP_DELAYED_REF,
+						 &old_ref_mod, &new_ref_mod);
 	}
+
+	if (ret == 0 && old_ref_mod >= 0 && new_ref_mod < 0)
+		add_pinned_bytes(fs_info, num_bytes, owner, root_objectid);
+
 	return ret;
 }
 
@@ -8199,9 +8229,9 @@ int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 	BUG_ON(root_objectid == BTRFS_TREE_LOG_OBJECTID);
 
 	ret = btrfs_add_delayed_data_ref(fs_info, trans, ins->objectid,
-					 ins->offset, 0,
-					 root_objectid, owner, offset,
-					 ram_bytes, BTRFS_ADD_DELAYED_EXTENT);
+					 ins->offset, 0, root_objectid, owner,
+					 offset, ram_bytes,
+					 BTRFS_ADD_DELAYED_EXTENT, NULL, NULL);
 	return ret;
 }
 
@@ -8421,11 +8451,11 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 		extent_op->is_data = false;
 		extent_op->level = level;
 
-		ret = btrfs_add_delayed_tree_ref(fs_info, trans,
-						 ins.objectid, ins.offset,
-						 parent, root_objectid, level,
+		ret = btrfs_add_delayed_tree_ref(fs_info, trans, ins.objectid,
+						 ins.offset, parent,
+						 root_objectid, level,
 						 BTRFS_ADD_DELAYED_EXTENT,
-						 extent_op);
+						 extent_op, NULL, NULL);
 		if (ret)
 			goto out_free_delayed;
 	}
