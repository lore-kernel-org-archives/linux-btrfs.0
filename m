Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36002 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752611AbcHITI6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Aug 2016 15:08:58 -0400
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>, <jack@suse.com>, <viro@zeniv.linux.org.uk>,
        <dchinner@redhat.com>, <hch@lst.de>
Subject: [PATCH 2/2] writeback: allow for dirty metadata accounting
Date: Tue, 9 Aug 2016 15:08:27 -0400
Message-ID: <1470769707-26079-3-git-send-email-jbacik@fb.com>
In-Reply-To: <1470769707-26079-1-git-send-email-jbacik@fb.com>
References: <1470769707-26079-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Provide a mechanism for file systems to indicate how much dirty metadata they
are holding.  This introduces a few things

1) Zone stats for dirty metadata, which is the same as the NR_FILE_DIRTY.
2) WB stat for dirty metadata.  This way we know if we need to try and call into
the file system to write out metadata.  This could potentially be used in the
future to make balancing of dirty pages smarter.
3) A super callback to handle writing back dirty metadata.

A future patch will take advantage of this work in btrfs.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/fs-writeback.c                | 57 +++++++++++++++++++++++++++--
 fs/super.c                       |  1 +
 include/linux/backing-dev-defs.h |  3 ++
 include/linux/fs.h               |  4 +++
 include/linux/mm.h               |  4 +++
 include/linux/mmzone.h           |  1 +
 mm/backing-dev.c                 |  3 ++
 mm/page-writeback.c              | 78 ++++++++++++++++++++++++++++++++++++++--
 8 files changed, 145 insertions(+), 6 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 56c8fda..c670d45 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1615,11 +1615,36 @@ static long writeback_sb_inodes(struct super_block *sb,
 	return wrote;
 }
 
+static long writeback_sb_metadata(struct super_block *sb,
+				  struct bdi_writeback *wb,
+				  struct wb_writeback_work *work)
+{
+	struct writeback_control wbc = {
+		.sync_mode		= work->sync_mode,
+		.tagged_writepages	= work->tagged_writepages,
+		.for_kupdate		= work->for_kupdate,
+		.for_background		= work->for_background,
+		.for_sync		= work->for_sync,
+		.range_cyclic		= work->range_cyclic,
+		.range_start		= 0,
+		.range_end		= LLONG_MAX,
+	};
+	long write_chunk;
+
+	write_chunk = writeback_chunk_size(wb, work);
+	wbc.nr_to_write = write_chunk;
+	sb->s_op->write_metadata(sb, &wbc);
+	work->nr_pages -= write_chunk - wbc.nr_to_write;
+
+	return write_chunk - wbc.nr_to_write;
+}
+
 static long __writeback_inodes_wb(struct bdi_writeback *wb,
 				  struct wb_writeback_work *work)
 {
 	unsigned long start_time = jiffies;
 	long wrote = 0;
+	bool done = false;
 
 	while (!list_empty(&wb->b_io)) {
 		struct inode *inode = wb_inode(wb->b_io.prev);
@@ -1639,11 +1664,37 @@ static long __writeback_inodes_wb(struct bdi_writeback *wb,
 
 		/* refer to the same tests at the end of writeback_sb_inodes */
 		if (wrote) {
-			if (time_is_before_jiffies(start_time + HZ / 10UL))
-				break;
-			if (work->nr_pages <= 0)
+			if (time_is_before_jiffies(start_time + HZ / 10UL) ||
+			    work->nr_pages <= 0) {
+				done = true;
 				break;
+			}
+		}
+	}
+
+	if (!done && wb_stat(wb, WB_METADATA_DIRTY)) {
+		struct list_head list;
+
+		spin_unlock(&wb->list_lock);
+		spin_lock(&wb->bdi->sb_list_lock);
+		list_splice_init(&wb->bdi->sb_list, &list);
+		while (!list_empty(&list)) {
+			struct super_block *sb;
+
+			sb = list_first_entry(&list, struct super_block,
+					      s_bdi_list);
+			list_move_tail(&wb->bdi->sb_list, &sb->s_bdi_list);
+			if (!sb->s_op->write_metadata)
+				continue;
+			if (!trylock_super(sb))
+				continue;
+			spin_unlock(&wb->bdi->sb_list_lock);
+			wrote += writeback_sb_metadata(sb, wb, work);
+			spin_lock(&wb->bdi->sb_list_lock);
+			up_read(&sb->s_umount);
 		}
+		spin_unlock(&wb->bdi->sb_list_lock);
+		spin_lock(&wb->list_lock);
 	}
 	/* Leave any unwritten inodes on b_io */
 	return wrote;
diff --git a/fs/super.c b/fs/super.c
index c2ff475..940696d 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -215,6 +215,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags,
 	spin_lock_init(&s->s_inode_list_lock);
 	INIT_LIST_HEAD(&s->s_inodes_wb);
 	spin_lock_init(&s->s_inode_wblist_lock);
+	INIT_LIST_HEAD(&s->s_bdi_list);
 
 	if (list_lru_init_memcg(&s->s_dentry_lru))
 		goto fail;
diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index 3f10307..0e731a3 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -34,6 +34,7 @@ typedef int (congested_fn)(void *, int);
 enum wb_stat_item {
 	WB_RECLAIMABLE,
 	WB_WRITEBACK,
+	WB_METADATA_DIRTY,
 	WB_DIRTIED,
 	WB_WRITTEN,
 	NR_WB_STAT_ITEMS
@@ -166,6 +167,8 @@ struct backing_dev_info {
 
 	struct timer_list laptop_mode_wb_timer;
 
+	spinlock_t sb_list_lock;
+	struct list_head sb_list;
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *debug_dir;
 	struct dentry *debug_stats;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f3f0b4c8..015b06d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1430,6 +1430,8 @@ struct super_block {
 
 	spinlock_t		s_inode_wblist_lock;
 	struct list_head	s_inodes_wb;	/* writeback inodes */
+
+	struct list_head	s_bdi_list;
 };
 
 /* Helper functions so that in most cases filesystems will
@@ -1805,6 +1807,8 @@ struct super_operations {
 				  struct shrink_control *);
 	long (*free_cached_objects)(struct super_block *,
 				    struct shrink_control *);
+	long (*write_metadata)(struct super_block *sb,
+			       struct writeback_control *wbc);
 };
 
 /*
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 08ed53e..0e90fde 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -31,6 +31,7 @@ struct file_ra_state;
 struct user_struct;
 struct writeback_control;
 struct bdi_writeback;
+struct backing_dev_info;
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES	/* Don't use mapnrs, do it properly */
 extern unsigned long max_mapnr;
@@ -1363,6 +1364,9 @@ int redirty_page_for_writepage(struct writeback_control *wbc,
 void account_page_dirtied(struct page *page, struct address_space *mapping);
 void account_page_cleaned(struct page *page, struct address_space *mapping,
 			  struct bdi_writeback *wb);
+void account_metadata_dirtied(struct page *page, struct backing_dev_info *bdi);
+void account_metadata_cleaned(struct page *page, struct backing_dev_info *bdi);
+void account_metadata_writeback(struct page *page, struct backing_dev_info *bdi);
 int set_page_dirty(struct page *page);
 int set_page_dirty_lock(struct page *page);
 void cancel_dirty_page(struct page *page);
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index f2e4e90..c4177ef 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -167,6 +167,7 @@ enum node_stat_item {
 	NR_VMSCAN_IMMEDIATE,	/* Prioritise for reclaim when writeback ends */
 	NR_DIRTIED,		/* page dirtyings since bootup */
 	NR_WRITTEN,		/* page writings since bootup */
+	NR_METADATA_DIRTY,	/* Metadata dirty pages */
 	NR_VM_NODE_STAT_ITEMS
 };
 
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index efe2377..0f1692c 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -78,6 +78,7 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
 		   "BackgroundThresh:   %10lu kB\n"
 		   "BdiDirtied:         %10lu kB\n"
 		   "BdiWritten:         %10lu kB\n"
+		   "BdiMetadataDirty:	%10lu kB\n"
 		   "BdiWriteBandwidth:  %10lu kBps\n"
 		   "b_dirty:            %10lu\n"
 		   "b_io:               %10lu\n"
@@ -92,6 +93,7 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
 		   K(background_thresh),
 		   (unsigned long) K(wb_stat(wb, WB_DIRTIED)),
 		   (unsigned long) K(wb_stat(wb, WB_WRITTEN)),
+		   (unsigned long) K(wb_stat(wb, WB_METADATA_DIRTY)),
 		   (unsigned long) K(wb->write_bandwidth),
 		   nr_dirty,
 		   nr_io,
@@ -780,6 +782,7 @@ int bdi_init(struct backing_dev_info *bdi)
 	bdi->max_prop_frac = FPROP_FRAC_BASE;
 	INIT_LIST_HEAD(&bdi->bdi_list);
 	INIT_LIST_HEAD(&bdi->wb_list);
+	INIT_LIST_HEAD(&bdi->sb_list);
 	init_waitqueue_head(&bdi->wb_waitq);
 
 	ret = cgwb_bdi_init(bdi);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 121a6e3..c6492de1a 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -506,6 +506,7 @@ bool node_dirty_ok(struct pglist_data *pgdat)
 	nr_pages += node_page_state(pgdat, NR_FILE_DIRTY);
 	nr_pages += node_page_state(pgdat, NR_UNSTABLE_NFS);
 	nr_pages += node_page_state(pgdat, NR_WRITEBACK);
+	nr_pages += node_page_state(pgdat, NR_METADATA_DIRTY);
 
 	return nr_pages <= limit;
 }
@@ -1595,7 +1596,8 @@ static void balance_dirty_pages(struct bdi_writeback *wb,
 		 * been flushed to permanent storage.
 		 */
 		nr_reclaimable = global_node_page_state(NR_FILE_DIRTY) +
-					global_node_page_state(NR_UNSTABLE_NFS);
+				global_node_page_state(NR_UNSTABLE_NFS) +
+				global_node_page_state(NR_METADATA_DIRTY);
 		gdtc->avail = global_dirtyable_memory();
 		gdtc->dirty = nr_reclaimable + global_node_page_state(NR_WRITEBACK);
 
@@ -1935,7 +1937,8 @@ bool wb_over_bg_thresh(struct bdi_writeback *wb)
 	 */
 	gdtc->avail = global_dirtyable_memory();
 	gdtc->dirty = global_node_page_state(NR_FILE_DIRTY) +
-		      global_node_page_state(NR_UNSTABLE_NFS);
+		      global_node_page_state(NR_UNSTABLE_NFS) +
+		      global_node_page_state(NR_METADATA_DIRTY);
 	domain_dirty_limits(gdtc);
 
 	if (gdtc->dirty > gdtc->bg_thresh)
@@ -2009,7 +2012,8 @@ void laptop_mode_timer_fn(unsigned long data)
 {
 	struct request_queue *q = (struct request_queue *)data;
 	int nr_pages = global_node_page_state(NR_FILE_DIRTY) +
-		global_node_page_state(NR_UNSTABLE_NFS);
+		global_node_page_state(NR_UNSTABLE_NFS) +
+		global_node_page_state(NR_METADATA_DIRTY);
 	struct bdi_writeback *wb;
 
 	/*
@@ -2473,6 +2477,74 @@ void account_page_dirtied(struct page *page, struct address_space *mapping)
 EXPORT_SYMBOL(account_page_dirtied);
 
 /*
+ * account_metadata_dirtied
+ * @page - the page being dirited
+ * @bdi - the bdi that owns this page
+ *
+ * Do the dirty page accounting for metadata pages that aren't backed by an
+ * address_space.
+ */
+void account_metadata_dirtied(struct page *page, struct backing_dev_info *bdi)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__inc_node_page_state(page, NR_METADATA_DIRTY);
+	__inc_node_page_state(page, NR_FILE_DIRTY);
+	__inc_zone_page_state(page, NR_ZONE_WRITE_PENDING);
+	__inc_node_page_state(page, NR_DIRTIED);
+	__inc_wb_stat(&bdi->wb, WB_RECLAIMABLE);
+	__inc_wb_stat(&bdi->wb, WB_DIRTIED);
+	__inc_wb_stat(&bdi->wb, WB_METADATA_DIRTY);
+	current->nr_dirtied++;
+	task_io_account_write(PAGE_SIZE);
+	this_cpu_inc(bdp_ratelimits);
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL(account_metadata_dirtied);
+
+/*
+ * account_metadata_cleaned
+ * @page - the page being cleaned
+ * @bdi - the bdi that owns this page
+ *
+ * Called on a no longer dirty metadata page.
+ */
+void account_metadata_cleaned(struct page *page, struct backing_dev_info *bdi)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__dec_node_page_state(page, NR_METADATA_DIRTY);
+	__dec_zone_page_state(page, NR_ZONE_WRITE_PENDING);
+	__dec_wb_stat(&bdi->wb, WB_RECLAIMABLE);
+	__dec_wb_stat(&bdi->wb, WB_METADATA_DIRTY);
+	task_io_account_cancelled_write(PAGE_SIZE);
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL(account_metadata_cleaned);
+
+/*
+ * account_metadata_writeback
+ * @page - the page being marked as writeback
+ * @bdi - the bdi that owns this page
+ *
+ * Called on a metadata page that has been marked writeback.
+ */
+void account_metadata_writeback(struct page *page, struct backing_dev_info *bdi)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__inc_wb_stat(&bdi->wb, WB_WRITEBACK);
+	__dec_wb_stat(&bdi->wb, WB_METADATA_DIRTY);
+	__inc_node_page_state(page, NR_WRITEBACK);
+	__dec_node_page_state(page, NR_METADATA_DIRTY);
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL(account_metadata_writeback);
+
+/*
  * Helper function for deaccounting dirty page without writeback.
  *
  * Caller must hold lock_page_memcg().
-- 
1.8.3.1

