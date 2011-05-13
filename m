From: Mark Fasheh <mfasheh@suse.com>
Subject: [RFC][PATCH 1/2] vfs: allow /proc/pid/maps to return a custom device
Date: Fri, 13 May 2011 16:18:48 -0700
Message-ID: <1305328729-9995-2-git-send-email-mfasheh@suse.com>
References: <1305328729-9995-1-git-send-email-mfasheh@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Mark Fasheh <mfasheh@suse.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1305328729-9995-1-git-send-email-mfasheh@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

This patch introduces a callback in the super_operations structure,
'get_maps_dev' which is then used by procfs to query which device to return
for reporting in /proc/[PID]/maps.

btrfs wants this so that it can return the same device as it uses from
stat(2) calls.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/proc/task_mmu.c   |    2 +-
 fs/proc/task_nommu.c |    2 +-
 include/linux/fs.h   |    8 ++++++++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 2e7addf..c0acc19 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -220,7 +220,7 @@ static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
 
 	if (file) {
 		struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
-		dev = inode->i_sb->s_dev;
+		dev = get_maps_dev(inode);
 		ino = inode->i_ino;
 		pgoff = ((loff_t)vma->vm_pgoff) << PAGE_SHIFT;
 	}
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 980de54..6769efe 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -148,7 +148,7 @@ static int nommu_vma_show(struct seq_file *m, struct vm_area_struct *vma)
 
 	if (file) {
 		struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
-		dev = inode->i_sb->s_dev;
+		dev = get_maps_dev(inode);
 		ino = inode->i_ino;
 		pgoff = (loff_t)vma->vm_pgoff << PAGE_SHIFT;
 	}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index dbd860a..ad683ad 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1637,8 +1637,16 @@ struct super_operations {
 	ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
 #endif
 	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
+	dev_t (*get_maps_dev)(struct inode *);
 };
 
+static inline dev_t get_maps_dev(struct inode *inode)
+{
+	if (inode->i_sb->s_op->get_maps_dev)
+		return inode->i_sb->s_op->get_maps_dev(inode);
+	return inode->i_sb->s_dev;
+}
+
 /*
  * Inode state bits.  Protected by inode->i_lock
  *
-- 
1.6.4.2

