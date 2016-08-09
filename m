Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33062 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751919AbcHITIu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Aug 2016 15:08:50 -0400
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>, <jack@suse.com>, <viro@zeniv.linux.org.uk>,
        <dchinner@redhat.com>, <hch@lst.de>
Subject: [PATCH 1/2] remove mapping from balance_dirty_pages*()
Date: Tue, 9 Aug 2016 15:08:26 -0400
Message-ID: <1470769707-26079-2-git-send-email-jbacik@fb.com>
In-Reply-To: <1470769707-26079-1-git-send-email-jbacik@fb.com>
References: <1470769707-26079-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The only reason we pass in the mapping is to get the inode in order to see if
writeback cgroups is enabled, and even then it only checks the bdi and a super
block flag.  balance_dirty_pages() doesn't even use the mapping.  Since
balance_dirty_pages*() works on a bdi level, just pass in the bdi and super
block directly so we can avoid using mapping.  This will allow us to still use
balance_dirty_pages for dirty metadata pages that are not backed by an
address_mapping.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/disk-io.c          |  4 ++--
 fs/btrfs/file.c             |  3 ++-
 fs/btrfs/ioctl.c            |  3 ++-
 fs/btrfs/relocation.c       |  3 ++-
 fs/buffer.c                 |  3 ++-
 fs/iomap.c                  |  3 ++-
 include/linux/backing-dev.h | 23 +++++++++++++++++------
 include/linux/writeback.h   |  3 ++-
 mm/filemap.c                |  4 +++-
 mm/memory.c                 |  9 +++++++--
 mm/page-writeback.c         | 15 +++++++--------
 11 files changed, 48 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 17346f7..c1d951a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4024,8 +4024,8 @@ static void __btrfs_btree_balance_dirty(struct btrfs_root *root,
 	ret = percpu_counter_compare(&root->fs_info->dirty_metadata_bytes,
 				     BTRFS_DIRTY_METADATA_THRESH);
 	if (ret > 0) {
-		balance_dirty_pages_ratelimited(
-				   root->fs_info->btree_inode->i_mapping);
+		balance_dirty_pages_ratelimited(&root->fs_info->bdi,
+						root->fs_info->sb);
 	}
 }
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 9404121..f060b08 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1686,7 +1686,8 @@ again:
 
 		cond_resched();
 
-		balance_dirty_pages_ratelimited(inode->i_mapping);
+		balance_dirty_pages_ratelimited(inode_to_bdi(inode),
+						inode->i_sb);
 		if (dirty_pages < (root->nodesize >> PAGE_SHIFT) + 1)
 			btrfs_btree_balance_dirty(root);
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 14ed1e9..a222bad 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1410,7 +1410,8 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		}
 
 		defrag_count += ret;
-		balance_dirty_pages_ratelimited(inode->i_mapping);
+		balance_dirty_pages_ratelimited(inode_to_bdi(inode),
+						inode->i_sb);
 		inode_unlock(inode);
 
 		if (newer_than) {
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 4598e29..7fc6ea7 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3202,7 +3202,8 @@ static int relocate_file_extent_cluster(struct inode *inode,
 		put_page(page);
 
 		index++;
-		balance_dirty_pages_ratelimited(inode->i_mapping);
+		balance_dirty_pages_ratelimited(inode_to_bdi(inode),
+						inode->i_sb);
 		btrfs_throttle(BTRFS_I(inode)->root);
 	}
 	WARN_ON(nr != cluster->nr);
diff --git a/fs/buffer.c b/fs/buffer.c
index 9c8eb9b..9bbe30d 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2386,7 +2386,8 @@ static int cont_expand_zero(struct file *file, struct address_space *mapping,
 		BUG_ON(err != len);
 		err = 0;
 
-		balance_dirty_pages_ratelimited(mapping);
+		balance_dirty_pages_ratelimited(inode_to_bdi(inode),
+						inode->i_sb);
 
 		if (unlikely(fatal_signal_pending(current))) {
 			err = -EINTR;
diff --git a/fs/iomap.c b/fs/iomap.c
index 48141b8..937e266 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -226,7 +226,8 @@ again:
 		written += copied;
 		length -= copied;
 
-		balance_dirty_pages_ratelimited(inode->i_mapping);
+		balance_dirty_pages_ratelimited(inode_to_bdi(inode),
+						inode->i_sb);
 	} while (iov_iter_count(i) && length);
 
 	return written ? written : status;
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 491a917..3b76eeb 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -252,8 +252,9 @@ void wb_blkcg_offline(struct blkcg *blkcg);
 int inode_congested(struct inode *inode, int cong_bits);
 
 /**
- * inode_cgwb_enabled - test whether cgroup writeback is enabled on an inode
- * @inode: inode of interest
+ * bdi_cgwb_enabled - test wether cgroup writeback is enabled on a filesystem
+ * @bdi: the bdi we care about
+ * @sb: the super for the bdi
  *
  * cgroup writeback requires support from both the bdi and filesystem.
  * Also, both memcg and iocg have to be on the default hierarchy.  Test
@@ -262,15 +263,25 @@ int inode_congested(struct inode *inode, int cong_bits);
  * Note that the test result may change dynamically on the same inode
  * depending on how memcg and iocg are configured.
  */
-static inline bool inode_cgwb_enabled(struct inode *inode)
+static inline bool bdi_cgwb_enabled(struct backing_dev_info *bdi,
+				    struct super_block *sb)
 {
-	struct backing_dev_info *bdi = inode_to_bdi(inode);
-
 	return cgroup_subsys_on_dfl(memory_cgrp_subsys) &&
 		cgroup_subsys_on_dfl(io_cgrp_subsys) &&
 		bdi_cap_account_dirty(bdi) &&
 		(bdi->capabilities & BDI_CAP_CGROUP_WRITEBACK) &&
-		(inode->i_sb->s_iflags & SB_I_CGROUPWB);
+		(sb->s_iflags & SB_I_CGROUPWB);
+}
+
+/**
+ * inode_cgwb_enabled - test whether cgroup writeback is enabled on an inode
+ * @inode: inode of interest
+ *
+ * Does the inode have cgroup writeback support.
+ */
+static inline bool inode_cgwb_enabled(struct inode *inode)
+{
+	return bdi_cgwb_enabled(inode_to_bdi(inode), inode->i_sb);
 }
 
 /**
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index fc1e16c..256ffc3 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -364,7 +364,8 @@ unsigned long wb_calc_thresh(struct bdi_writeback *wb, unsigned long thresh);
 
 void wb_update_bandwidth(struct bdi_writeback *wb, unsigned long start_time);
 void page_writeback_init(void);
-void balance_dirty_pages_ratelimited(struct address_space *mapping);
+void balance_dirty_pages_ratelimited(struct backing_dev_info *bdi,
+				     struct super_block *sb);
 bool wb_over_bg_thresh(struct bdi_writeback *wb);
 
 typedef int (*writepage_t)(struct page *page, struct writeback_control *wbc,
diff --git a/mm/filemap.c b/mm/filemap.c
index 3083ded..abb0e98 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2667,6 +2667,7 @@ ssize_t generic_perform_write(struct file *file,
 				struct iov_iter *i, loff_t pos)
 {
 	struct address_space *mapping = file->f_mapping;
+	struct inode *inode = mapping->host;
 	const struct address_space_operations *a_ops = mapping->a_ops;
 	long status = 0;
 	ssize_t written = 0;
@@ -2746,7 +2747,8 @@ again:
 		pos += copied;
 		written += copied;
 
-		balance_dirty_pages_ratelimited(mapping);
+		balance_dirty_pages_ratelimited(inode_to_bdi(inode),
+						inode->i_sb);
 	} while (iov_iter_count(i));
 
 	return written ? written : status;
diff --git a/mm/memory.c b/mm/memory.c
index 83be99d..d43e73b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -64,6 +64,7 @@
 #include <linux/debugfs.h>
 #include <linux/userfaultfd_k.h>
 #include <linux/dax.h>
+#include <linux/backing-dev.h>
 
 #include <asm/io.h>
 #include <asm/mmu_context.h>
@@ -2105,11 +2106,13 @@ static inline int wp_page_reuse(struct fault_env *fe, pte_t orig_pte,
 		put_page(page);
 
 		if ((dirtied || page_mkwrite) && mapping) {
+			struct inode *inode = mapping->host;
 			/*
 			 * Some device drivers do not set page.mapping
 			 * but still dirty their pages
 			 */
-			balance_dirty_pages_ratelimited(mapping);
+			balance_dirty_pages_ratelimited(inode_to_bdi(inode),
+							inode->i_sb);
 		}
 
 		if (!page_mkwrite)
@@ -3291,11 +3294,13 @@ static int do_shared_fault(struct fault_env *fe, pgoff_t pgoff)
 	mapping = page_rmapping(fault_page);
 	unlock_page(fault_page);
 	if ((dirtied || vma->vm_ops->page_mkwrite) && mapping) {
+		struct inode *inode = mapping->host;
 		/*
 		 * Some device drivers do not set page.mapping but still
 		 * dirty their pages
 		 */
-		balance_dirty_pages_ratelimited(mapping);
+		balance_dirty_pages_ratelimited(inode_to_bdi(inode),
+						inode->i_sb);
 	}
 
 	if (!vma->vm_ops->page_mkwrite)
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index f4cd7d8..121a6e3 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1559,8 +1559,7 @@ static inline void wb_dirty_limits(struct dirty_throttle_control *dtc)
  * If we're over `background_thresh' then the writeback threads are woken to
  * perform some writeout.
  */
-static void balance_dirty_pages(struct address_space *mapping,
-				struct bdi_writeback *wb,
+static void balance_dirty_pages(struct bdi_writeback *wb,
 				unsigned long pages_dirtied)
 {
 	struct dirty_throttle_control gdtc_stor = { GDTC_INIT(wb) };
@@ -1849,7 +1848,8 @@ DEFINE_PER_CPU(int, dirty_throttle_leaks) = 0;
 
 /**
  * balance_dirty_pages_ratelimited - balance dirty memory state
- * @mapping: address_space which was dirtied
+ * @bdi: the bdi that was dirtied
+ * @sb: the super block that was dirtied
  *
  * Processes which are dirtying memory should call in here once for each page
  * which was newly dirtied.  The function will periodically check the system's
@@ -1860,10 +1860,9 @@ DEFINE_PER_CPU(int, dirty_throttle_leaks) = 0;
  * limit we decrease the ratelimiting by a lot, to prevent individual processes
  * from overshooting the limit by (ratelimit_pages) each.
  */
-void balance_dirty_pages_ratelimited(struct address_space *mapping)
+void balance_dirty_pages_ratelimited(struct backing_dev_info *bdi,
+				     struct super_block *sb)
 {
-	struct inode *inode = mapping->host;
-	struct backing_dev_info *bdi = inode_to_bdi(inode);
 	struct bdi_writeback *wb = NULL;
 	int ratelimit;
 	int *p;
@@ -1871,7 +1870,7 @@ void balance_dirty_pages_ratelimited(struct address_space *mapping)
 	if (!bdi_cap_account_dirty(bdi))
 		return;
 
-	if (inode_cgwb_enabled(inode))
+	if (bdi_cgwb_enabled(bdi, sb))
 		wb = wb_get_create_current(bdi, GFP_KERNEL);
 	if (!wb)
 		wb = &bdi->wb;
@@ -1909,7 +1908,7 @@ void balance_dirty_pages_ratelimited(struct address_space *mapping)
 	preempt_enable();
 
 	if (unlikely(current->nr_dirtied >= ratelimit))
-		balance_dirty_pages(mapping, wb, current->nr_dirtied);
+		balance_dirty_pages(wb, current->nr_dirtied);
 
 	wb_put(wb);
 }
-- 
1.8.3.1

