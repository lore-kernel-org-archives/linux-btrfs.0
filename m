From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] Btrfs: fix readahead in file defrag
Date: Wed, 20 Jul 2011 11:46:35 +0800
Message-ID: <4E264F9B.3070706@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We passed the wrong value to btrfs_force_ra(). Fix this by changing
the argument of btrfs_force_ra() from last_index to nr_page.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ctree.h |   11 ++++++++---
 fs/btrfs/inode.c |   13 -------------
 2 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f30ac05..76f68e1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2513,6 +2513,14 @@ int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 #define PageChecked PageFsMisc
 #endif
 
+/* This forces readahead on a given range of bytes in an inode */
+static inline void btrfs_force_ra(struct address_space *mapping,
+				  struct file_ra_state *ra, struct file *file,
+				  pgoff_t offset, unsigned long req_size)
+{
+	page_cache_sync_readahead(mapping, ra, file, offset, req_size);
+}
+
 struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry);
 int btrfs_set_inode_index(struct inode *dir, u64 *index);
 int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
@@ -2541,9 +2549,6 @@ int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
 int btrfs_merge_bio_hook(struct page *page, unsigned long offset,
 			 size_t size, struct bio *bio, unsigned long bio_flags);
 
-unsigned long btrfs_force_ra(struct address_space *mapping,
-			      struct file_ra_state *ra, struct file *file,
-			      pgoff_t offset, pgoff_t last_index);
 int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
 int btrfs_readpage(struct file *file, struct page *page);
 void btrfs_evict_inode(struct inode *inode);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d340f63..5e5ae1c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6697,19 +6697,6 @@ int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-/* helper function for file defrag and space balancing.  This
- * forces readahead on a given range of bytes in an inode
- */
-unsigned long btrfs_force_ra(struct address_space *mapping,
-			      struct file_ra_state *ra, struct file *file,
-			      pgoff_t offset, pgoff_t last_index)
-{
-	pgoff_t req_size = last_index - offset + 1;
-
-	page_cache_sync_readahead(mapping, ra, file, offset, req_size);
-	return offset + req_size;
-}
-
 struct inode *btrfs_alloc_inode(struct super_block *sb)
 {
 	struct btrfs_inode *ei;
-- 1.7.3.1 
