Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30084 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751557AbcF0BuZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Jun 2016 21:50:25 -0400
Subject: Re: [PATCH 02/31] btrfs: prefix fsid to all trace events
To: <jeffm@suse.com>, <linux-btrfs@vger.kernel.org>
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
 <1466806524-27508-3-git-send-email-jeffm@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <8d17b46b-2b1b-146b-937c-860e8d86b8fc@cn.fujitsu.com>
Date: Mon, 27 Jun 2016 09:50:15 +0800
MIME-Version: 1.0
In-Reply-To: <1466806524-27508-3-git-send-email-jeffm@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 06/25/2016 06:14 AM, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
>
> When using trace events to debug a problem, it's impossible to determine
> which file system generated a particular event.  This patch adds a
> macro to prefix standard information to the head of a trace event.
>
> The extent_state alloc/free events are all that's left without an
> fs_info available.
>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/btrfs/delayed-ref.c       |   9 +-
>  fs/btrfs/extent-tree.c       |  10 +-
>  fs/btrfs/qgroup.c            |  19 +--
>  fs/btrfs/qgroup.h            |   9 +-
>  fs/btrfs/super.c             |   2 +-
>  include/trace/events/btrfs.h | 282 ++++++++++++++++++++++++-------------------
>  6 files changed, 182 insertions(+), 149 deletions(-)
>
> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> index 430b368..e7b1ec0 100644
> --- a/fs/btrfs/delayed-ref.c
> +++ b/fs/btrfs/delayed-ref.c
> @@ -606,7 +606,8 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
>  		qrecord->num_bytes = num_bytes;
>  		qrecord->old_roots = NULL;
>
> -		qexisting = btrfs_qgroup_insert_dirty_extent(delayed_refs,
> +		qexisting = btrfs_qgroup_insert_dirty_extent(fs_info,
> +							     delayed_refs,
>  							     qrecord);
>  		if (qexisting)
>  			kfree(qrecord);
> @@ -615,7 +616,7 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
>  	spin_lock_init(&head_ref->lock);
>  	mutex_init(&head_ref->mutex);
>
> -	trace_add_delayed_ref_head(ref, head_ref, action);
> +	trace_add_delayed_ref_head(fs_info, ref, head_ref, action);
>
>  	existing = htree_insert(&delayed_refs->href_root,
>  				&head_ref->href_node);
> @@ -682,7 +683,7 @@ add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
>  		ref->type = BTRFS_TREE_BLOCK_REF_KEY;
>  	full_ref->level = level;
>
> -	trace_add_delayed_tree_ref(ref, full_ref, action);
> +	trace_add_delayed_tree_ref(fs_info, ref, full_ref, action);
>
>  	ret = add_delayed_ref_tail_merge(trans, delayed_refs, head_ref, ref);
>
> @@ -739,7 +740,7 @@ add_delayed_data_ref(struct btrfs_fs_info *fs_info,
>  	full_ref->objectid = owner;
>  	full_ref->offset = offset;
>
> -	trace_add_delayed_data_ref(ref, full_ref, action);
> +	trace_add_delayed_data_ref(fs_info, ref, full_ref, action);
>
>  	ret = add_delayed_ref_tail_merge(trans, delayed_refs, head_ref, ref);
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 29e5d00..39308a8 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2194,7 +2194,7 @@ static int run_delayed_data_ref(struct btrfs_trans_handle *trans,
>  	ins.type = BTRFS_EXTENT_ITEM_KEY;
>
>  	ref = btrfs_delayed_node_to_data_ref(node);
> -	trace_run_delayed_data_ref(node, ref, node->action);
> +	trace_run_delayed_data_ref(root->fs_info, node, ref, node->action);
>
>  	if (node->type == BTRFS_SHARED_DATA_REF_KEY)
>  		parent = ref->parent;
> @@ -2349,7 +2349,7 @@ static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
>  						 SKINNY_METADATA);
>
>  	ref = btrfs_delayed_node_to_tree_ref(node);
> -	trace_run_delayed_tree_ref(node, ref, node->action);
> +	trace_run_delayed_tree_ref(root->fs_info, node, ref, node->action);
>
>  	if (node->type == BTRFS_SHARED_BLOCK_REF_KEY)
>  		parent = ref->parent;
> @@ -2413,7 +2413,8 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
>  		 */
>  		BUG_ON(extent_op);
>  		head = btrfs_delayed_node_to_head(node);
> -		trace_run_delayed_ref_head(node, head, node->action);
> +		trace_run_delayed_ref_head(root->fs_info, node, head,
> +					   node->action);
>
>  		if (insert_reserved) {
>  			btrfs_pin_extent(root, node->bytenr,
> @@ -8317,7 +8318,8 @@ static int record_one_subtree_extent(struct btrfs_trans_handle *trans,
>
>  	delayed_refs = &trans->transaction->delayed_refs;
>  	spin_lock(&delayed_refs->lock);
> -	if (btrfs_qgroup_insert_dirty_extent(delayed_refs, qrecord))
> +	if (btrfs_qgroup_insert_dirty_extent(trans->root->fs_info,
> +					     delayed_refs, qrecord))
>  		kfree(qrecord);
>  	spin_unlock(&delayed_refs->lock);
>
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 9d4c05b..13e28d8 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1453,9 +1453,10 @@ int btrfs_qgroup_prepare_account_extents(struct btrfs_trans_handle *trans,
>  	return ret;
>  }
>
> -struct btrfs_qgroup_extent_record
> -*btrfs_qgroup_insert_dirty_extent(struct btrfs_delayed_ref_root *delayed_refs,
> -				  struct btrfs_qgroup_extent_record *record)
> +struct btrfs_qgroup_extent_record *
> +btrfs_qgroup_insert_dirty_extent(struct btrfs_fs_info *fs_info,
> +				 struct btrfs_delayed_ref_root *delayed_refs,
> +				 struct btrfs_qgroup_extent_record *record)
>  {
>  	struct rb_node **p = &delayed_refs->dirty_extent_root.rb_node;
>  	struct rb_node *parent_node = NULL;
> @@ -1463,7 +1464,7 @@ struct btrfs_qgroup_extent_record
>  	u64 bytenr = record->bytenr;
>
>  	assert_spin_locked(&delayed_refs->lock);
> -	trace_btrfs_qgroup_insert_dirty_extent(record);
> +	trace_btrfs_qgroup_insert_dirty_extent(fs_info, record);
>
>  	while (*p) {
>  		parent_node = *p;
> @@ -1595,8 +1596,8 @@ static int qgroup_update_counters(struct btrfs_fs_info *fs_info,
>  		cur_old_count = btrfs_qgroup_get_old_refcnt(qg, seq);
>  		cur_new_count = btrfs_qgroup_get_new_refcnt(qg, seq);
>
> -		trace_qgroup_update_counters(qg->qgroupid, cur_old_count,
> -					     cur_new_count);
> +		trace_qgroup_update_counters(fs_info, qg->qgroupid,
> +					     cur_old_count, cur_new_count);
>
>  		/* Rfer update part */
>  		if (cur_old_count == 0 && cur_new_count > 0) {
> @@ -1687,8 +1688,8 @@ btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans,
>  		goto out_free;
>  	BUG_ON(!fs_info->quota_root);
>
> -	trace_btrfs_qgroup_account_extent(bytenr, num_bytes, nr_old_roots,
> -					  nr_new_roots);
> +	trace_btrfs_qgroup_account_extent(fs_info, bytenr, num_bytes,
> +					  nr_old_roots, nr_new_roots);
>
>  	qgroups = ulist_alloc(GFP_NOFS);
>  	if (!qgroups) {
> @@ -1759,7 +1760,7 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans,
>  		record = rb_entry(node, struct btrfs_qgroup_extent_record,
>  				  node);
>
> -		trace_btrfs_qgroup_account_extents(record);
> +		trace_btrfs_qgroup_account_extents(fs_info, record);
>
>  		if (!ret) {
>  			/*
> diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
> index ecb2c14..710887c 100644
> --- a/fs/btrfs/qgroup.h
> +++ b/fs/btrfs/qgroup.h
> @@ -63,9 +63,10 @@ void btrfs_free_qgroup_config(struct btrfs_fs_info *fs_info);
>  struct btrfs_delayed_extent_op;
>  int btrfs_qgroup_prepare_account_extents(struct btrfs_trans_handle *trans,
>  					 struct btrfs_fs_info *fs_info);
> -struct btrfs_qgroup_extent_record
> -*btrfs_qgroup_insert_dirty_extent(struct btrfs_delayed_ref_root *delayed_refs,
> -				  struct btrfs_qgroup_extent_record *record);
> +struct btrfs_qgroup_extent_record *
> +btrfs_qgroup_insert_dirty_extent(struct btrfs_fs_info *fs_info,
> +				 struct btrfs_delayed_ref_root *delayed_refs,
> +				 struct btrfs_qgroup_extent_record *record);
>  int
>  btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans,
>  			    struct btrfs_fs_info *fs_info,
> @@ -88,7 +89,7 @@ static inline void btrfs_qgroup_free_delayed_ref(struct btrfs_fs_info *fs_info,
>  						 u64 ref_root, u64 num_bytes)
>  {
>  	btrfs_qgroup_free_refroot(fs_info, ref_root, num_bytes);
> -	trace_btrfs_qgroup_free_delayed_ref(ref_root, num_bytes);
> +	trace_btrfs_qgroup_free_delayed_ref(fs_info, ref_root, num_bytes);
>  }
>  void assert_qgroups_uptodate(struct btrfs_trans_handle *trans);
>
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 60e7179..ee56b0e 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1149,7 +1149,7 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
>  	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
>  	struct btrfs_root *root = fs_info->tree_root;
>
> -	trace_btrfs_sync_fs(wait);
> +	trace_btrfs_sync_fs(fs_info, wait);
>
>  	if (!wait) {
>  		filemap_flush(fs_info->btree_inode->i_mapping);
> diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
> index e90e82a..eba0c65 100644
> --- a/include/trace/events/btrfs.h
> +++ b/include/trace/events/btrfs.h
> @@ -66,6 +66,21 @@ struct btrfs_qgroup_extent_record;
>  	{ BTRFS_BLOCK_GROUP_RAID6,	"RAID6"}
>
>  #define BTRFS_UUID_SIZE 16
> +#define TP_STRUCT__entry_fsid __array(u8, fsid, BTRFS_UUID_SIZE)
> +
> +#define TP_fast_assign_fsid(fs_info)					\
> +	memcpy(__entry->fsid, fs_info->fsid, BTRFS_UUID_SIZE)
> +
> +#define TP_STRUCT__entry_btrfs(args...)					\
> +	TP_STRUCT__entry(						\
> +		TP_STRUCT__entry_fsid					\
> +		args)
> +#define TP_fast_assign_btrfs(fs_info, args...)				\
> +	TP_fast_assign(							\
> +		TP_fast_assign_fsid(fs_info);				\
> +		args)
> +#define TP_printk_btrfs(fmt, args...) \
> +	TP_printk("%pU: " fmt, __entry->fsid, args)

Although it would be much better if we can shorten the uuid length, but 
that would need to modify printk parameter to support non-standard uuid 
size.

Or we need to manual output chars as hex.

Either way, I'm not sure if it's worthy just to shorten the uuid length.

Otherwise it looks good for me.

Thanks,
Qu

>
>  TRACE_EVENT(btrfs_transaction_commit,
>
> @@ -73,17 +88,17 @@ TRACE_EVENT(btrfs_transaction_commit,
>
>  	TP_ARGS(root),
>
> -	TP_STRUCT__entry(
> +	TP_STRUCT__entry_btrfs(
>  		__field(	u64,  generation		)
>  		__field(	u64,  root_objectid		)
>  	),
>
> -	TP_fast_assign(
> +	TP_fast_assign_btrfs(root->fs_info,
>  		__entry->generation	= root->fs_info->generation;
>  		__entry->root_objectid	= root->root_key.objectid;
>  	),
>
> -	TP_printk("root = %llu(%s), gen = %llu",
> +	TP_printk_btrfs("root = %llu(%s), gen = %llu",
>  		  show_root_type(__entry->root_objectid),
>  		  (unsigned long long)__entry->generation)
>  );
> @@ -94,7 +109,7 @@ DECLARE_EVENT_CLASS(btrfs__inode,
>
>  	TP_ARGS(inode),
>
> -	TP_STRUCT__entry(
> +	TP_STRUCT__entry_btrfs(
>  		__field(	ino_t,  ino			)
>  		__field(	blkcnt_t,  blocks		)
>  		__field(	u64,  disk_i_size		)
> @@ -104,7 +119,7 @@ DECLARE_EVENT_CLASS(btrfs__inode,
>  		__field(	u64,  root_objectid		)
>  	),
>
> -	TP_fast_assign(
> +	TP_fast_assign_btrfs(btrfs_sb(inode->i_sb),
>  		__entry->ino	= inode->i_ino;
>  		__entry->blocks	= inode->i_blocks;
>  		__entry->disk_i_size  = BTRFS_I(inode)->disk_i_size;
> @@ -115,7 +130,7 @@ DECLARE_EVENT_CLASS(btrfs__inode,
>  				BTRFS_I(inode)->root->root_key.objectid;
>  	),
>
> -	TP_printk("root = %llu(%s), gen = %llu, ino = %lu, blocks = %llu, "
> +	TP_printk_btrfs("root = %llu(%s), gen = %llu, ino = %lu, blocks = %llu, "
>  		  "disk_i_size = %llu, last_trans = %llu, logged_trans = %llu",
>  		  show_root_type(__entry->root_objectid),
>  		  (unsigned long long)__entry->generation,
> @@ -175,7 +190,7 @@ TRACE_EVENT_CONDITION(btrfs_get_extent,
>
>  	TP_CONDITION(map),
>
> -	TP_STRUCT__entry(
> +	TP_STRUCT__entry_btrfs(
>  		__field(	u64,  root_objectid	)
>  		__field(	u64,  start		)
>  		__field(	u64,  len		)
> @@ -187,7 +202,7 @@ TRACE_EVENT_CONDITION(btrfs_get_extent,
>  		__field(	unsigned int,  compress_type	)
>  	),
>
> -	TP_fast_assign(
> +	TP_fast_assign_btrfs(root->fs_info,
>  		__entry->root_objectid	= root->root_key.objectid;
>  		__entry->start 		= map->start;
>  		__entry->len		= map->len;
> @@ -199,7 +214,7 @@ TRACE_EVENT_CONDITION(btrfs_get_extent,
>  		__entry->compress_type	= map->compress_type;
>  	),
>
> -	TP_printk("root = %llu(%s), start = %llu, len = %llu, "
> +	TP_printk_btrfs("root = %llu(%s), start = %llu, len = %llu, "
>  		  "orig_start = %llu, block_start = %llu(%s), "
>  		  "block_len = %llu, flags = %s, refs = %u, "
>  		  "compress_type = %u",
> @@ -233,7 +248,7 @@ DECLARE_EVENT_CLASS(btrfs__ordered_extent,
>
>  	TP_ARGS(inode, ordered),
>
> -	TP_STRUCT__entry(
> +	TP_STRUCT__entry_btrfs(
>  		__field(	ino_t,  ino		)
>  		__field(	u64,  file_offset	)
>  		__field(	u64,  start		)
> @@ -246,7 +261,7 @@ DECLARE_EVENT_CLASS(btrfs__ordered_extent,
>  		__field(	u64,  root_objectid	)
>  	),
>
> -	TP_fast_assign(
> +	TP_fast_assign_btrfs(btrfs_sb(inode->i_sb),
>  		__entry->ino 		= inode->i_ino;
>  		__entry->file_offset	= ordered->file_offset;
>  		__entry->start		= ordered->start;
> @@ -260,7 +275,7 @@ DECLARE_EVENT_CLASS(btrfs__ordered_extent,
>  				BTRFS_I(inode)->root->root_key.objectid;
>  	),
>
> -	TP_printk("root = %llu(%s), ino = %llu, file_offset = %llu, "
> +	TP_printk_btrfs("root = %llu(%s), ino = %llu, file_offset = %llu, "
>  		  "start = %llu, len = %llu, disk_len = %llu, "
>  		  "bytes_left = %llu, flags = %s, compress_type = %d, "
>  		  "refs = %d",
> @@ -310,7 +325,7 @@ DECLARE_EVENT_CLASS(btrfs__writepage,
>
>  	TP_ARGS(page, inode, wbc),
>
> -	TP_STRUCT__entry(
> +	TP_STRUCT__entry_btrfs(
>  		__field(	ino_t,  ino			)
>  		__field(	pgoff_t,  index			)
>  		__field(	long,   nr_to_write		)
> @@ -324,7 +339,7 @@ DECLARE_EVENT_CLASS(btrfs__writepage,
>  		__field(	u64,    root_objectid		)
>  	),
>
> -	TP_fast_assign(
> +	TP_fast_assign_btrfs(btrfs_sb(inode->i_sb),
>  		__entry->ino		= inode->i_ino;
>  		__entry->index		= page->index;
>  		__entry->nr_to_write	= wbc->nr_to_write;
> @@ -339,7 +354,7 @@ DECLARE_EVENT_CLASS(btrfs__writepage,
>  				 BTRFS_I(inode)->root->root_key.objectid;
>  	),
>
> -	TP_printk("root = %llu(%s), ino = %lu, page_index = %lu, "
> +	TP_printk_btrfs("root = %llu(%s), ino = %lu, page_index = %lu, "
>  		  "nr_to_write = %ld, pages_skipped = %ld, range_start = %llu, "
>  		  "range_end = %llu, for_kupdate = %d, "
>  		  "for_reclaim = %d, range_cyclic = %d, writeback_index = %lu",
> @@ -366,7 +381,7 @@ TRACE_EVENT(btrfs_writepage_end_io_hook,
>
>  	TP_ARGS(page, start, end, uptodate),
>
> -	TP_STRUCT__entry(
> +	TP_STRUCT__entry_btrfs(
>  		__field(	ino_t,	 ino		)
>  		__field(	pgoff_t, index		)
>  		__field(	u64,	 start		)
> @@ -375,7 +390,7 @@ TRACE_EVENT(btrfs_writepage_end_io_hook,
>  		__field(	u64,    root_objectid	)
>  	),
>
> -	TP_fast_assign(
> +	TP_fast_assign_btrfs(btrfs_sb(page->mapping->host->i_sb),
>  		__entry->ino	= page->mapping->host->i_ino;
>  		__entry->index	= page->index;
>  		__entry->start	= start;
> @@ -385,7 +400,7 @@ TRACE_EVENT(btrfs_writepage_end_io_hook,
>  			 BTRFS_I(page->mapping->host)->root->root_key.objectid;
>  	),
>
> -	TP_printk("root = %llu(%s), ino = %lu, page_index = %lu, start = %llu, "
> +	TP_printk_btrfs("root = %llu(%s), ino = %lu, page_index = %lu, start = %llu, "
>  		  "end = %llu, uptodate = %d",
>  		  show_root_type(__entry->root_objectid),
>  		  (unsigned long)__entry->ino, (unsigned long)__entry->index,
> @@ -399,7 +414,7 @@ TRACE_EVENT(btrfs_sync_file,
>
>  	TP_ARGS(file, datasync),
>
> -	TP_STRUCT__entry(
> +	TP_STRUCT__entry_btrfs(
>  		__field(	ino_t,  ino		)
>  		__field(	ino_t,  parent		)
>  		__field(	int,    datasync	)
> @@ -410,6 +425,7 @@ TRACE_EVENT(btrfs_sync_file,
>  		struct dentry *dentry = file->f_path.dentry;
>  		struct inode *inode = d_inode(dentry);
>
> +		TP_fast_assign_fsid(btrfs_sb(file->f_path.dentry->d_sb));
>  		__entry->ino		= inode->i_ino;
>  		__entry->parent		= d_inode(dentry->d_parent)->i_ino;
>  		__entry->datasync	= datasync;
> @@ -417,7 +433,7 @@ TRACE_EVENT(btrfs_sync_file,
>  				 BTRFS_I(inode)->root->root_key.objectid;
>  	),
>
> -	TP_printk("root = %llu(%s), ino = %ld, parent = %ld, datasync = %d",
> +	TP_printk_btrfs("root = %llu(%s), ino = %ld, parent = %ld, datasync = %d",
>  		  show_root_type(__entry->root_objectid),
>  		  (unsigned long)__entry->ino, (unsigned long)__entry->parent,
>  		  __entry->datasync)
> @@ -425,19 +441,19 @@ TRACE_EVENT(btrfs_sync_file,
>
>  TRACE_EVENT(btrfs_sync_fs,
>
> -	TP_PROTO(int wait),
> +	TP_PROTO(struct btrfs_fs_info *fs_info, int wait),
>
> -	TP_ARGS(wait),
> +	TP_ARGS(fs_info, wait),
>
> -	TP_STRUCT__entry(
> +	TP_STRUCT__entry_btrfs(
>  		__field(	int,  wait		)
>  	),
>
> -	TP_fast_assign(
> +	TP_fast_assign_btrfs(fs_info,
>  		__entry->wait	= wait;
>  	),
>
> -	TP_printk("wait = %d", __entry->wait)
> +	TP_printk_btrfs("wait = %d", __entry->wait)
>  );
>
>  #define show_ref_action(action)						\
> @@ -450,13 +466,14 @@ TRACE_EVENT(btrfs_sync_fs,
>
>  DECLARE_EVENT_CLASS(btrfs_delayed_tree_ref,
>
> -	TP_PROTO(struct btrfs_delayed_ref_node *ref,
> +	TP_PROTO(struct btrfs_fs_info *fs_info,
> +		 struct btrfs_delayed_ref_node *ref,
>  		 struct btrfs_delayed_tree_ref *full_ref,
>  		 int action),
>
> -	TP_ARGS(ref, full_ref, action),
> +	TP_ARGS(fs_info, ref, full_ref, action),
>
> -	TP_STRUCT__entry(
> +	TP_STRUCT__entry_btrfs(
>  		__field(	u64,  bytenr		)
>  		__field(	u64,  num_bytes		)
>  		__field(	int,  action		)
> @@ -467,7 +484,7 @@ DECLARE_EVENT_CLASS(btrfs_delayed_tree_ref,
>  		__field(	u64,  seq		)
>  	),
>
> -	TP_fast_assign(
> +	TP_fast_assign_btrfs(fs_info,
>  		__entry->bytenr		= ref->bytenr;
>  		__entry->num_bytes	= ref->num_bytes;
>  		__entry->action		= action;
> @@ -478,7 +495,7 @@ DECLARE_EVENT_CLASS(btrfs_delayed_tree_ref,
>  		__entry->seq		= ref->seq;
>  	),
>
> -	TP_printk("bytenr = %llu, num_bytes = %llu, action = %s, "
> +	TP_printk_btrfs("bytenr = %llu, num_bytes = %llu, action = %s, "
>  		  "parent = %llu(%s), ref_root = %llu(%s), level = %d, "
>  		  "type = %s, seq = %llu",
>  		  (unsigned long long)__entry->bytenr,
> @@ -492,31 +509,34 @@ DECLARE_EVENT_CLASS(btrfs_delayed_tree_ref,
>
>  DEFINE_EVENT(btrfs_delayed_tree_ref,  add_delayed_tree_ref,
>
> -	TP_PROTO(struct btrfs_delayed_ref_node *ref,
> +	TP_PROTO(struct btrfs_fs_info *fs_info,
> +		 struct btrfs_delayed_ref_node *ref,
>  		 struct btrfs_delayed_tree_ref *full_ref,
>  		 int action),
>
> -	TP_ARGS(ref, full_ref, action)
> +	TP_ARGS(fs_info, ref, full_ref, action)
>  );
>
>  DEFINE_EVENT(btrfs_delayed_tree_ref,  run_delayed_tree_ref,
>
> -	TP_PROTO(struct btrfs_delayed_ref_node *ref,
> +	TP_PROTO(struct btrfs_fs_info *fs_info,
> +		 struct btrfs_delayed_ref_node *ref,
>  		 struct btrfs_delayed_tree_ref *full_ref,
>  		 int action),
>
> -	TP_ARGS(ref, full_ref, action)
> +	TP_ARGS(fs_info, ref, full_ref, action)
>  );
>
>  DECLARE_EVENT_CLASS(btrfs_delayed_data_ref,
>
> -	TP_PROTO(struct btrfs_delayed_ref_node *ref,
> +	TP_PROTO(struct btrfs_fs_info *fs_info,
> +		 struct btrfs_delayed_ref_node *ref,
>  		 struct btrfs_delayed_data_ref *full_ref,
>  		 int action),
>
> -	TP_ARGS(ref, full_ref, action),
> +	TP_ARGS(fs_info, ref, full_ref, action),
>
> -	TP_STRUCT__entry(
> +	TP_STRUCT__entry_btrfs(
>  		__field(	u64,  bytenr		)
>  		__field(	u64,  num_bytes		)
>  		__field(	int,  action		)
> @@ -528,7 +548,7 @@ DECLARE_EVENT_CLASS(btrfs_delayed_data_ref,
>  		__field(	u64,  seq		)
>  	),
>
> -	TP_fast_assign(
> +	TP_fast_assign_btrfs(fs_info,
>  		__entry->bytenr		= ref->bytenr;
>  		__entry->num_bytes	= ref->num_bytes;
>  		__entry->action		= action;
> @@ -540,7 +560,7 @@ DECLARE_EVENT_CLASS(btrfs_delayed_data_ref,
>  		__entry->seq		= ref->seq;
>  	),
>
> -	TP_printk("bytenr = %llu, num_bytes = %llu, action = %s, "
> +	TP_printk_btrfs("bytenr = %llu, num_bytes = %llu, action = %s, "
>  		  "parent = %llu(%s), ref_root = %llu(%s), owner = %llu, "
>  		  "offset = %llu, type = %s, seq = %llu",
>  		  (unsigned long long)__entry->bytenr,
> @@ -556,45 +576,48 @@ DECLARE_EVENT_CLASS(btrfs_delayed_data_ref,
>
>  DEFINE_EVENT(btrfs_delayed_data_ref,  add_delayed_data_ref,
>
> -	TP_PROTO(struct btrfs_delayed_ref_node *ref,
> +	TP_PROTO(struct btrfs_fs_info *fs_info,
> +		 struct btrfs_delayed_ref_node *ref,
>  		 struct btrfs_delayed_data_ref *full_ref,
>  		 int action),
>
> -	TP_ARGS(ref, full_ref, action)
> +	TP_ARGS(fs_info, ref, full_ref, action)
>  );
>
>  DEFINE_EVENT(btrfs_delayed_data_ref,  run_delayed_data_ref,
>
> -	TP_PROTO(struct btrfs_delayed_ref_node *ref,
> +	TP_PROTO(struct btrfs_fs_info *fs_info,
> +		 struct btrfs_delayed_ref_node *ref,
>  		 struct btrfs_delayed_data_ref *full_ref,
>  		 int action),
>
> -	TP_ARGS(ref, full_ref, action)
> +	TP_ARGS(fs_info, ref, full_ref, action)
>  );
>
>  DECLARE_EVENT_CLASS(btrfs_delayed_ref_head,
>
> -	TP_PROTO(struct btrfs_delayed_ref_node *ref,
> +	TP_PROTO(struct btrfs_fs_info *fs_info,
> +		 struct btrfs_delayed_ref_node *ref,
>  		 struct btrfs_delayed_ref_head *head_ref,
>  		 int action),
>
> -	TP_ARGS(ref, head_ref, action),
> +	TP_ARGS(fs_info, ref, head_ref, action),
>
> -	TP_STRUCT__entry(
> +	TP_STRUCT__entry_btrfs(
>  		__field(	u64,  bytenr		)
>  		__field(	u64,  num_bytes		)
>  		__field(	int,  action		)
>  		__field(	int,  is_data		)
>  	),
>
> -	TP_fast_assign(
> +	TP_fast_assign_btrfs(fs_info,
>  		__entry->bytenr		= ref->bytenr;
>  		__entry->num_bytes	= ref->num_bytes;
>  		__entry->action		= action;
>  		__entry->is_data	= head_ref->is_data;
>  	),
>
> -	TP_printk("bytenr = %llu, num_bytes = %llu, action = %s, is_data = %d",
> +	TP_printk_btrfs("bytenr = %llu, num_bytes = %llu, action = %s, is_data = %d",
>  		  (unsigned long long)__entry->bytenr,
>  		  (unsigned long long)__entry->num_bytes,
>  		  show_ref_action(__entry->action),
> @@ -603,20 +626,22 @@ DECLARE_EVENT_CLASS(btrfs_delayed_ref_head,
>
>  DEFINE_EVENT(btrfs_delayed_ref_head,  add_delayed_ref_head,
>
> -	TP_PROTO(struct btrfs_delayed_ref_node *ref,
> +	TP_PROTO(struct btrfs_fs_info *fs_info,
> +		 struct btrfs_delayed_ref_node *ref,
>  		 struct btrfs_delayed_ref_head *head_ref,
>  		 int action),
>
> -	TP_ARGS(ref, head_ref, action)
> +	TP_ARGS(fs_info, ref, head_ref, action)
>  );
>
>  DEFINE_EVENT(btrfs_delayed_ref_head,  run_delayed_ref_head,
>
> -	TP_PROTO(struct btrfs_delayed_ref_node *ref,
> +	TP_PROTO(struct btrfs_fs_info *fs_info,
> +		 struct btrfs_delayed_ref_node *ref,
>  		 struct btrfs_delayed_ref_head *head_ref,
>  		 int action),
>
> -	TP_ARGS(ref, head_ref, action)
> +	TP_ARGS(fs_info, ref, head_ref, action)
>  );
>
>  #define show_chunk_type(type)					\
> @@ -638,7 +663,7 @@ DECLARE_EVENT_CLASS(btrfs__chunk,
>
>  	TP_ARGS(root, map, offset, size),
>
> -	TP_STRUCT__entry(
> +	TP_STRUCT__entry_btrfs(
>  		__field(	int,  num_stripes		)
>  		__field(	u64,  type			)
>  		__field(	int,  sub_stripes		)
> @@ -647,7 +672,7 @@ DECLARE_EVENT_CLASS(btrfs__chunk,
>  		__field(	u64,  root_objectid		)
>  	),
>
> -	TP_fast_assign(
> +	TP_fast_assign_btrfs(root->fs_info,
>  		__entry->num_stripes	= map->num_stripes;
>  		__entry->type		= map->type;
>  		__entry->sub_stripes	= map->sub_stripes;
> @@ -656,7 +681,7 @@ DECLARE_EVENT_CLASS(btrfs__chunk,
>  		__entry->root_objectid	= root->root_key.objectid;
>  	),
>
> -	TP_printk("root = %llu(%s), offset = %llu, size = %llu, "
> +	TP_printk_btrfs("root = %llu(%s), offset = %llu, size = %llu, "
>  		  "num_stripes = %d, sub_stripes = %d, type = %s",
>  		  show_root_type(__entry->root_objectid),
>  		  (unsigned long long)__entry->offset,
> @@ -688,7 +713,7 @@ TRACE_EVENT(btrfs_cow_block,
>
>  	TP_ARGS(root, buf, cow),
>
> -	TP_STRUCT__entry(
> +	TP_STRUCT__entry_btrfs(
>  		__field(	u64,  root_objectid		)
>  		__field(	u64,  buf_start			)
>  		__field(	int,  refs			)
> @@ -697,7 +722,7 @@ TRACE_EVENT(btrfs_cow_block,
>  		__field(	int,  cow_level			)
>  	),
>
> -	TP_fast_assign(
> +	TP_fast_assign_btrfs(root->fs_info,
>  		__entry->root_objectid	= root->root_key.objectid;
>  		__entry->buf_start	= buf->start;
>  		__entry->refs		= atomic_read(&buf->refs);
> @@ -706,7 +731,7 @@ TRACE_EVENT(btrfs_cow_block,
>  		__entry->cow_level	= btrfs_header_level(cow);
>  	),
>
> -	TP_printk("root = %llu(%s), refs = %d, orig_buf = %llu "
> +	TP_printk_btrfs("root = %llu(%s), refs = %d, orig_buf = %llu "
>  		  "(orig_level = %d), cow_buf = %llu (cow_level = %d)",
>  		  show_root_type(__entry->root_objectid),
>  		  __entry->refs,
> @@ -723,25 +748,23 @@ TRACE_EVENT(btrfs_space_reservation,
>
>  	TP_ARGS(fs_info, type, val, bytes, reserve),
>
> -	TP_STRUCT__entry(
> -		__array(	u8,	fsid,	BTRFS_UUID_SIZE	)
> +	TP_STRUCT__entry_btrfs(
>  		__string(	type,	type			)
>  		__field(	u64,	val			)
>  		__field(	u64,	bytes			)
>  		__field(	int,	reserve			)
>  	),
>
> -	TP_fast_assign(
> -		memcpy(__entry->fsid, fs_info->fsid, BTRFS_UUID_SIZE);
> +	TP_fast_assign_btrfs(fs_info,
>  		__assign_str(type, type);
>  		__entry->val		= val;
>  		__entry->bytes		= bytes;
>  		__entry->reserve	= reserve;
>  	),
>
> -	TP_printk("%pU: %s: %Lu %s %Lu", __entry->fsid, __get_str(type),
> -		  __entry->val, __entry->reserve ? "reserve" : "release",
> -		  __entry->bytes)
> +	TP_printk_btrfs("%s: %Lu %s %Lu", __get_str(type), __entry->val,
> +			__entry->reserve ? "reserve" : "release",
> +			__entry->bytes)
>  );
>
>  DECLARE_EVENT_CLASS(btrfs__reserved_extent,
> @@ -750,19 +773,19 @@ DECLARE_EVENT_CLASS(btrfs__reserved_extent,
>
>  	TP_ARGS(root, start, len),
>
> -	TP_STRUCT__entry(
> +	TP_STRUCT__entry_btrfs(
>  		__field(	u64,  root_objectid		)
>  		__field(	u64,  start			)
>  		__field(	u64,  len			)
>  	),
>
> -	TP_fast_assign(
> +	TP_fast_assign_btrfs(root->fs_info,
>  		__entry->root_objectid	= root->root_key.objectid;
>  		__entry->start		= start;
>  		__entry->len		= len;
>  	),
>
> -	TP_printk("root = %llu(%s), start = %llu, len = %llu",
> +	TP_printk_btrfs("root = %llu(%s), start = %llu, len = %llu",
>  		  show_root_type(__entry->root_objectid),
>  		  (unsigned long long)__entry->start,
>  		  (unsigned long long)__entry->len)
> @@ -789,21 +812,21 @@ TRACE_EVENT(find_free_extent,
>
>  	TP_ARGS(root, num_bytes, empty_size, data),
>
> -	TP_STRUCT__entry(
> +	TP_STRUCT__entry_btrfs(
>  		__field(	u64,	root_objectid		)
>  		__field(	u64,	num_bytes		)
>  		__field(	u64,	empty_size		)
>  		__field(	u64,	data			)
>  	),
>
> -	TP_fast_assign(
> +	TP_fast_assign_btrfs(root->fs_info,
>  		__entry->root_objectid	= root->root_key.objectid;
>  		__entry->num_bytes	= num_bytes;
>  		__entry->empty_size	= empty_size;
>  		__entry->data		= data;
>  	),
>
> -	TP_printk("root = %Lu(%s), len = %Lu, empty_size = %Lu, "
> +	TP_printk_btrfs("root = %Lu(%s), len = %Lu, empty_size = %Lu, "
>  		  "flags = %Lu(%s)", show_root_type(__entry->root_objectid),
>  		  __entry->num_bytes, __entry->empty_size, __entry->data,
>  		  __print_flags((unsigned long)__entry->data, "|",
> @@ -818,7 +841,7 @@ DECLARE_EVENT_CLASS(btrfs__reserve_extent,
>
>  	TP_ARGS(root, block_group, start, len),
>
> -	TP_STRUCT__entry(
> +	TP_STRUCT__entry_btrfs(
>  		__field(	u64,	root_objectid		)
>  		__field(	u64,	bg_objectid		)
>  		__field(	u64,	flags			)
> @@ -826,7 +849,7 @@ DECLARE_EVENT_CLASS(btrfs__reserve_extent,
>  		__field(	u64,	len			)
>  	),
>
> -	TP_fast_assign(
> +	TP_fast_assign_btrfs(root->fs_info,
>  		__entry->root_objectid	= root->root_key.objectid;
>  		__entry->bg_objectid	= block_group->key.objectid;
>  		__entry->flags		= block_group->flags;
> @@ -834,7 +857,7 @@ DECLARE_EVENT_CLASS(btrfs__reserve_extent,
>  		__entry->len		= len;
>  	),
>
> -	TP_printk("root = %Lu(%s), block_group = %Lu, flags = %Lu(%s), "
> +	TP_printk_btrfs("root = %Lu(%s), block_group = %Lu, flags = %Lu(%s), "
>  		  "start = %Lu, len = %Lu",
>  		  show_root_type(__entry->root_objectid), __entry->bg_objectid,
>  		  __entry->flags, __print_flags((unsigned long)__entry->flags,
> @@ -867,7 +890,7 @@ TRACE_EVENT(btrfs_find_cluster,
>
>  	TP_ARGS(block_group, start, bytes, empty_size, min_bytes),
>
> -	TP_STRUCT__entry(
> +	TP_STRUCT__entry_btrfs(
>  		__field(	u64,	bg_objectid		)
>  		__field(	u64,	flags			)
>  		__field(	u64,	start			)
> @@ -876,7 +899,7 @@ TRACE_EVENT(btrfs_find_cluster,
>  		__field(	u64,	min_bytes		)
>  	),
>
> -	TP_fast_assign(
> +	TP_fast_assign_btrfs(block_group->fs_info,
>  		__entry->bg_objectid	= block_group->key.objectid;
>  		__entry->flags		= block_group->flags;
>  		__entry->start		= start;
> @@ -885,7 +908,7 @@ TRACE_EVENT(btrfs_find_cluster,
>  		__entry->min_bytes	= min_bytes;
>  	),
>
> -	TP_printk("block_group = %Lu, flags = %Lu(%s), start = %Lu, len = %Lu,"
> +	TP_printk_btrfs("block_group = %Lu, flags = %Lu(%s), start = %Lu, len = %Lu,"
>  		  " empty_size = %Lu, min_bytes = %Lu", __entry->bg_objectid,
>  		  __entry->flags,
>  		  __print_flags((unsigned long)__entry->flags, "|",
> @@ -899,15 +922,15 @@ TRACE_EVENT(btrfs_failed_cluster_setup,
>
>  	TP_ARGS(block_group),
>
> -	TP_STRUCT__entry(
> +	TP_STRUCT__entry_btrfs(
>  		__field(	u64,	bg_objectid		)
>  	),
>
> -	TP_fast_assign(
> +	TP_fast_assign_btrfs(block_group->fs_info,
>  		__entry->bg_objectid	= block_group->key.objectid;
>  	),
>
> -	TP_printk("block_group = %Lu", __entry->bg_objectid)
> +	TP_printk_btrfs("block_group = %Lu", __entry->bg_objectid)
>  );
>
>  TRACE_EVENT(btrfs_setup_cluster,
> @@ -917,7 +940,7 @@ TRACE_EVENT(btrfs_setup_cluster,
>
>  	TP_ARGS(block_group, cluster, size, bitmap),
>
> -	TP_STRUCT__entry(
> +	TP_STRUCT__entry_btrfs(
>  		__field(	u64,	bg_objectid		)
>  		__field(	u64,	flags			)
>  		__field(	u64,	start			)
> @@ -926,7 +949,7 @@ TRACE_EVENT(btrfs_setup_cluster,
>  		__field(	int,	bitmap			)
>  	),
>
> -	TP_fast_assign(
> +	TP_fast_assign_btrfs(block_group->fs_info,
>  		__entry->bg_objectid	= block_group->key.objectid;
>  		__entry->flags		= block_group->flags;
>  		__entry->start		= cluster->window_start;
> @@ -935,7 +958,7 @@ TRACE_EVENT(btrfs_setup_cluster,
>  		__entry->bitmap		= bitmap;
>  	),
>
> -	TP_printk("block_group = %Lu, flags = %Lu(%s), window_start = %Lu, "
> +	TP_printk_btrfs("block_group = %Lu, flags = %Lu(%s), window_start = %Lu, "
>  		  "size = %Lu, max_size = %Lu, bitmap = %d",
>  		  __entry->bg_objectid,
>  		  __entry->flags,
> @@ -993,7 +1016,7 @@ DECLARE_EVENT_CLASS(btrfs__work,
>
>  	TP_ARGS(work),
>
> -	TP_STRUCT__entry(
> +	TP_STRUCT__entry_btrfs(
>  		__field(	void *,	work			)
>  		__field(	void *, wq			)
>  		__field(	void *,	func			)
> @@ -1002,7 +1025,7 @@ DECLARE_EVENT_CLASS(btrfs__work,
>  		__field(	void *,	normal_work		)
>  	),
>
> -	TP_fast_assign(
> +	TP_fast_assign_btrfs(btrfs_work_owner(work),
>  		__entry->work		= work;
>  		__entry->wq		= work->wq;
>  		__entry->func		= work->func;
> @@ -1011,7 +1034,7 @@ DECLARE_EVENT_CLASS(btrfs__work,
>  		__entry->normal_work	= &work->normal_work;
>  	),
>
> -	TP_printk("work=%p (normal_work=%p), wq=%p, func=%pf, ordered_func=%p,"
> +	TP_printk_btrfs("work=%p (normal_work=%p), wq=%p, func=%pf, ordered_func=%p,"
>  		  " ordered_free=%p",
>  		  __entry->work, __entry->normal_work, __entry->wq,
>  		   __entry->func, __entry->ordered_func, __entry->ordered_free)
> @@ -1024,15 +1047,15 @@ DECLARE_EVENT_CLASS(btrfs__work__done,
>
>  	TP_ARGS(work),
>
> -	TP_STRUCT__entry(
> +	TP_STRUCT__entry_btrfs(
>  		__field(	void *,	work			)
>  	),
>
> -	TP_fast_assign(
> +	TP_fast_assign_btrfs(btrfs_work_owner(work),
>  		__entry->work		= work;
>  	),
>
> -	TP_printk("work->%p", __entry->work)
> +	TP_printk_btrfs("work->%p", __entry->work)
>  );
>
>  DEFINE_EVENT(btrfs__work, btrfs_work_queued,
> @@ -1069,19 +1092,19 @@ DECLARE_EVENT_CLASS(btrfs__workqueue,
>
>  	TP_ARGS(wq, name, high),
>
> -	TP_STRUCT__entry(
> +	TP_STRUCT__entry_btrfs(
>  		__field(	void *,	wq			)
>  		__string(	name,	name			)
>  		__field(	int ,	high			)
>  	),
>
> -	TP_fast_assign(
> +	TP_fast_assign_btrfs(btrfs_workqueue_owner(wq),
>  		__entry->wq		= wq;
>  		__assign_str(name, name);
>  		__entry->high		= high;
>  	),
>
> -	TP_printk("name=%s%s, wq=%p", __get_str(name),
> +	TP_printk_btrfs("name=%s%s, wq=%p", __get_str(name),
>  		  __print_flags(__entry->high, "",
>  				{(WQ_HIGHPRI),	"-high"}),
>  		  __entry->wq)
> @@ -1100,15 +1123,15 @@ DECLARE_EVENT_CLASS(btrfs__workqueue_done,
>
>  	TP_ARGS(wq),
>
> -	TP_STRUCT__entry(
> +	TP_STRUCT__entry_btrfs(
>  		__field(	void *,	wq			)
>  	),
>
> -	TP_fast_assign(
> +	TP_fast_assign_btrfs(btrfs_workqueue_owner(wq),
>  		__entry->wq		= wq;
>  	),
>
> -	TP_printk("wq=%p", __entry->wq)
> +	TP_printk_btrfs("wq=%p", __entry->wq)
>  );
>
>  DEFINE_EVENT(btrfs__workqueue_done, btrfs_workqueue_destroy,
> @@ -1124,19 +1147,19 @@ DECLARE_EVENT_CLASS(btrfs__qgroup_data_map,
>
>  	TP_ARGS(inode, free_reserved),
>
> -	TP_STRUCT__entry(
> +	TP_STRUCT__entry_btrfs(
>  		__field(	u64,		rootid		)
>  		__field(	unsigned long,	ino		)
>  		__field(	u64,		free_reserved	)
>  	),
>
> -	TP_fast_assign(
> +	TP_fast_assign_btrfs(btrfs_sb(inode->i_sb),
>  		__entry->rootid		=	BTRFS_I(inode)->root->objectid;
>  		__entry->ino		=	inode->i_ino;
>  		__entry->free_reserved	=	free_reserved;
>  	),
>
> -	TP_printk("rootid=%llu, ino=%lu, free_reserved=%llu",
> +	TP_printk_btrfs("rootid=%llu, ino=%lu, free_reserved=%llu",
>  		  __entry->rootid, __entry->ino, __entry->free_reserved)
>  );
>
> @@ -1165,7 +1188,7 @@ DECLARE_EVENT_CLASS(btrfs__qgroup_rsv_data,
>
>  	TP_ARGS(inode, start, len, reserved, op),
>
> -	TP_STRUCT__entry(
> +	TP_STRUCT__entry_btrfs(
>  		__field(	u64,		rootid		)
>  		__field(	unsigned long,	ino		)
>  		__field(	u64,		start		)
> @@ -1174,7 +1197,7 @@ DECLARE_EVENT_CLASS(btrfs__qgroup_rsv_data,
>  		__field(	int,		op		)
>  	),
>
> -	TP_fast_assign(
> +	TP_fast_assign_btrfs(btrfs_sb(inode->i_sb),
>  		__entry->rootid		= BTRFS_I(inode)->root->objectid;
>  		__entry->ino		= inode->i_ino;
>  		__entry->start		= start;
> @@ -1183,7 +1206,7 @@ DECLARE_EVENT_CLASS(btrfs__qgroup_rsv_data,
>  		__entry->op		= op;
>  	),
>
> -	TP_printk("root=%llu, ino=%lu, start=%llu, len=%llu, reserved=%llu, op=%s",
> +	TP_printk_btrfs("root=%llu, ino=%lu, start=%llu, len=%llu, reserved=%llu, op=%s",
>  		  __entry->rootid, __entry->ino, __entry->start, __entry->len,
>  		  __entry->reserved,
>  		  __print_flags((unsigned long)__entry->op, "",
> @@ -1207,86 +1230,90 @@ DEFINE_EVENT(btrfs__qgroup_rsv_data, btrfs_qgroup_release_data,
>
>  DECLARE_EVENT_CLASS(btrfs__qgroup_delayed_ref,
>
> -	TP_PROTO(u64 ref_root, u64 reserved),
> +	TP_PROTO(struct btrfs_fs_info *fs_info, u64 ref_root, u64 reserved),
>
> -	TP_ARGS(ref_root, reserved),
> +	TP_ARGS(fs_info, ref_root, reserved),
>
> -	TP_STRUCT__entry(
> +	TP_STRUCT__entry_btrfs(
>  		__field(	u64,		ref_root	)
>  		__field(	u64,		reserved	)
>  	),
>
> -	TP_fast_assign(
> +	TP_fast_assign_btrfs(fs_info,
>  		__entry->ref_root	= ref_root;
>  		__entry->reserved	= reserved;
>  	),
>
> -	TP_printk("root=%llu, reserved=%llu, op=free",
> +	TP_printk_btrfs("root=%llu, reserved=%llu, op=free",
>  		  __entry->ref_root, __entry->reserved)
>  );
>
>  DEFINE_EVENT(btrfs__qgroup_delayed_ref, btrfs_qgroup_free_delayed_ref,
>
> -	TP_PROTO(u64 ref_root, u64 reserved),
> +	TP_PROTO(struct btrfs_fs_info *fs_info, u64 ref_root, u64 reserved),
>
> -	TP_ARGS(ref_root, reserved)
> +	TP_ARGS(fs_info, ref_root, reserved)
>  );
>
>  DECLARE_EVENT_CLASS(btrfs_qgroup_extent,
> -	TP_PROTO(struct btrfs_qgroup_extent_record *rec),
> +	TP_PROTO(struct btrfs_fs_info *fs_info,
> +		 struct btrfs_qgroup_extent_record *rec),
>
> -	TP_ARGS(rec),
> +	TP_ARGS(fs_info, rec),
>
> -	TP_STRUCT__entry(
> +	TP_STRUCT__entry_btrfs(
>  		__field(	u64,  bytenr		)
>  		__field(	u64,  num_bytes		)
>  	),
>
> -	TP_fast_assign(
> +	TP_fast_assign_btrfs(fs_info,
>  		__entry->bytenr		= rec->bytenr,
>  		__entry->num_bytes	= rec->num_bytes;
>  	),
>
> -	TP_printk("bytenr = %llu, num_bytes = %llu",
> +	TP_printk_btrfs("bytenr = %llu, num_bytes = %llu",
>  		  (unsigned long long)__entry->bytenr,
>  		  (unsigned long long)__entry->num_bytes)
>  );
>
>  DEFINE_EVENT(btrfs_qgroup_extent, btrfs_qgroup_account_extents,
>
> -	TP_PROTO(struct btrfs_qgroup_extent_record *rec),
> +	TP_PROTO(struct btrfs_fs_info *fs_info,
> +		 struct btrfs_qgroup_extent_record *rec),
>
> -	TP_ARGS(rec)
> +	TP_ARGS(fs_info, rec)
>  );
>
>  DEFINE_EVENT(btrfs_qgroup_extent, btrfs_qgroup_insert_dirty_extent,
>
> -	TP_PROTO(struct btrfs_qgroup_extent_record *rec),
> +	TP_PROTO(struct btrfs_fs_info *fs_info,
> +		 struct btrfs_qgroup_extent_record *rec),
>
> -	TP_ARGS(rec)
> +	TP_ARGS(fs_info, rec)
>  );
>
>  TRACE_EVENT(btrfs_qgroup_account_extent,
>
> -	TP_PROTO(u64 bytenr, u64 num_bytes, u64 nr_old_roots, u64 nr_new_roots),
> +	TP_PROTO(struct btrfs_fs_info *fs_info, u64 bytenr,
> +		 u64 num_bytes, u64 nr_old_roots, u64 nr_new_roots),
>
> -	TP_ARGS(bytenr, num_bytes, nr_old_roots, nr_new_roots),
> +	TP_ARGS(fs_info, bytenr, num_bytes, nr_old_roots, nr_new_roots),
>
> -	TP_STRUCT__entry(
> +	TP_STRUCT__entry_btrfs(
>  		__field(	u64,  bytenr			)
>  		__field(	u64,  num_bytes			)
>  		__field(	u64,  nr_old_roots		)
>  		__field(	u64,  nr_new_roots		)
>  	),
>
> -	TP_fast_assign(
> +	TP_fast_assign_btrfs(fs_info,
>  		__entry->bytenr		= bytenr;
>  		__entry->num_bytes	= num_bytes;
>  		__entry->nr_old_roots	= nr_old_roots;
>  		__entry->nr_new_roots	= nr_new_roots;
>  	),
>
> -	TP_printk("bytenr = %llu, num_bytes = %llu, nr_old_roots = %llu, "
> +	TP_printk_btrfs("bytenr = %llu, num_bytes = %llu, nr_old_roots = %llu, "
>  		  "nr_new_roots = %llu",
>  		  __entry->bytenr,
>  		  __entry->num_bytes,
> @@ -1296,23 +1323,24 @@ TRACE_EVENT(btrfs_qgroup_account_extent,
>
>  TRACE_EVENT(qgroup_update_counters,
>
> -	TP_PROTO(u64 qgid, u64 cur_old_count, u64 cur_new_count),
> +	TP_PROTO(struct btrfs_fs_info *fs_info, u64 qgid,
> +		 u64 cur_old_count, u64 cur_new_count),
>
> -	TP_ARGS(qgid, cur_old_count, cur_new_count),
> +	TP_ARGS(fs_info, qgid, cur_old_count, cur_new_count),
>
> -	TP_STRUCT__entry(
> +	TP_STRUCT__entry_btrfs(
>  		__field(	u64,  qgid			)
>  		__field(	u64,  cur_old_count		)
>  		__field(	u64,  cur_new_count		)
>  	),
>
> -	TP_fast_assign(
> +	TP_fast_assign_btrfs(fs_info,
>  		__entry->qgid		= qgid;
>  		__entry->cur_old_count	= cur_old_count;
>  		__entry->cur_new_count	= cur_new_count;
>  	),
>
> -	TP_printk("qgid = %llu, cur_old_count = %llu, cur_new_count = %llu",
> +	TP_printk_btrfs("qgid = %llu, cur_old_count = %llu, cur_new_count = %llu",
>  		  __entry->qgid,
>  		  __entry->cur_old_count,
>  		  __entry->cur_new_count)
>


