Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36826 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932264Ab3GVSHF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jul 2013 14:07:05 -0400
Date: Mon, 22 Jul 2013 11:07:00 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org, linux-fsdevel@vget.kernel.org
Cc: Chris Mason <chris.mason@oracle.com>, Andrew Vagin <avagin@gmail.com>,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH] vfs: allow /proc/PID/maps to get device from stat
Message-ID: <20130722180659.GO32502@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

stat(2) on btrfs returns a custom device, but proc uses s_dev from the super
block. This causes problems (abi breakage) because software (and users) are
not expecting the kernel to return different devices from these calls.

This patch fixes the problem by adding a new superblock flag,
MS_STAT_FOR_DEV. When the proc code sees this flag, it will call the file
systems ->getattr() method to extract a device as opposed to getting it
directly from s_dev.

This has been a problem for some time now, and this is not the first attempt
to fix this. More details can be found in this thread from 2011:

http://thr3ads.net/btrfs-devel/2011/05/2346176-RFC-PATCH-0-2-btrfs-vfs-Return-same-device-in-stat-2-and-proc-pid-maps

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/super.c        |  1 +
 fs/proc/generic.c       | 15 +++++++++++++++
 fs/proc/internal.h      |  1 +
 fs/proc/nommu.c         |  2 +-
 fs/proc/task_mmu.c      |  2 +-
 fs/proc/task_nommu.c    |  2 +-
 include/uapi/linux/fs.h |  1 +
 7 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index f0857e0..da7c5f5 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -822,6 +822,7 @@ static int btrfs_fill_super(struct super_block *sb,
 	sb->s_flags |= MS_POSIXACL;
 #endif
 	sb->s_flags |= MS_I_VERSION;
+	sb->s_flags |= MS_STAT_FOR_DEV;
 	err = open_ctree(sb, fs_devices, (char *)data);
 	if (err) {
 		printk("btrfs: open_ctree failed\n");
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index a2596af..ed9df4a 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -24,6 +24,8 @@
 #include <linux/spinlock.h>
 #include <linux/completion.h>
 #include <asm/uaccess.h>
+#include <linux/fs.h>
+#include <linux/dcache.h>
 
 #include "internal.h"
 
@@ -637,3 +639,16 @@ void *PDE_DATA(const struct inode *inode)
 	return __PDE_DATA(inode);
 }
 EXPORT_SYMBOL(PDE_DATA);
+
+dev_t proc_get_map_dev(struct dentry *dentry)
+{
+	struct inode *inode = dentry->d_inode;
+	struct kstat kstat;
+
+	if (inode->i_sb->s_flags & MS_STAT_FOR_DEV &&
+	    inode->i_op->getattr &&
+	    inode->i_op->getattr(NULL, dentry, &kstat) == 0)
+		return kstat.dev;
+
+	return inode->i_sb->s_dev;
+}
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index d600fb0..afc9424 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -192,6 +192,7 @@ static inline struct proc_dir_entry *pde_get(struct proc_dir_entry *pde)
 	return pde;
 }
 extern void pde_put(struct proc_dir_entry *);
+dev_t proc_get_map_dev(struct dentry *dentry);
 
 /*
  * inode.c
diff --git a/fs/proc/nommu.c b/fs/proc/nommu.c
index ccfd99b..fe22ff6 100644
--- a/fs/proc/nommu.c
+++ b/fs/proc/nommu.c
@@ -46,7 +46,7 @@ static int nommu_region_show(struct seq_file *m, struct vm_region *region)
 
 	if (file) {
 		struct inode *inode = file_inode(region->vm_file);
-		dev = inode->i_sb->s_dev;
+		dev = proc_get_map_dev(vma->vm_file->f_path->dentry);
 		ino = inode->i_ino;
 	}
 
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 3e636d8..4d9d1d9 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -272,7 +272,7 @@ show_map_vma(struct seq_file *m, struct vm_area_struct *vma, int is_pid)
 
 	if (file) {
 		struct inode *inode = file_inode(vma->vm_file);
-		dev = inode->i_sb->s_dev;
+		dev = proc_get_map_dev(vma->vm_file->f_path.dentry);
 		ino = inode->i_ino;
 		pgoff = ((loff_t)vma->vm_pgoff) << PAGE_SHIFT;
 	}
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 56123a6..0995249 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -150,7 +150,7 @@ static int nommu_vma_show(struct seq_file *m, struct vm_area_struct *vma,
 
 	if (file) {
 		struct inode *inode = file_inode(vma->vm_file);
-		dev = inode->i_sb->s_dev;
+		dev = proc_get_map_dev(vma->vm_file->f_path.dentry);
 		ino = inode->i_ino;
 		pgoff = (loff_t)vma->vm_pgoff << PAGE_SHIFT;
 	}
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index a4ed56c..918054d 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -88,6 +88,7 @@ struct inodes_stat_t {
 #define MS_STRICTATIME	(1<<24) /* Always perform atime updates */
 
 /* These sb flags are internal to the kernel */
+#define MS_STAT_FOR_DEV	(1<<27)
 #define MS_NOSEC	(1<<28)
 #define MS_BORN		(1<<29)
 #define MS_ACTIVE	(1<<30)
-- 
1.8.1.4

