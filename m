Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40454 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728Ab3GJRpr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jul 2013 13:45:47 -0400
Date: Wed, 10 Jul 2013 10:45:45 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: dsterba@suse.cz, Andrew Vagin <avagin@gmail.com>,
        Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org,
        kzak@redhat.com, xemul@openvz.org
Subject: Re: btrfs: stat(2) and /proc/pid/maps returns different devices
Message-ID: <20130710174545.GS32502@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20130704095138.GB12359@gmail.com> <20130708215446.GH18204@twin.jikos.cz> <20130710163105.GR32502@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130710163105.GR32502@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 10, 2013 at 09:31:05AM -0700, Mark Fasheh wrote:
> As far as I can tell we'll be carrying this patch until a better
> solution is possible.
> 
> When that will happen, I don't know.
> 	--Mark

Well, what do I get when I pretend I don't care any more? The little voice
in my head says "keep plugging away". Here's another attempt at fixing this
problem in a sane manner. Basically, this time we're adding a flag to
s_flags which btrfs sets. Proc will see the flag and call ->getattr().

This compiles, but it needs testing (which I will get to soon). It still has
a bunch of problems in my honest opinion but maybe if we get something
acceptable upstream we can work from there.

Also, as Andrew pointed out there's more than one place which is return
different device than from stat(2) so I probably need to update more sites
to deal with this.

Does anyone see a problem with this approach?
	--Mark

--
Mark Fasheh

From: Mark Fasheh <mfasheh@suse.de>

vfs: allow /proc/PID/maps to get device from stat

stat(2) on btrfs returns a custom device, but proc uses s_dev from the super
block. This causes problems because software (and users) are not expecting
the kernel to return different devices from these calls.

This patch fixes the problem by adding a new superblock flag,
MS_PROC_USE_ST. When the proc code sees this flag, it will call the file
systems ->getattr() method to extract a device as opposed to getting it
directly from s_dev.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/super.c        |  1 +
 fs/proc/generic.c       | 30 ++++++++++++++++++++++++++++++
 fs/proc/internal.h      |  1 +
 fs/proc/task_mmu.c      |  2 +-
 fs/proc/task_nommu.c    |  2 +-
 include/uapi/linux/fs.h |  1 +
 6 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index f0857e0..67be4ef 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -822,6 +822,7 @@ static int btrfs_fill_super(struct super_block *sb,
 	sb->s_flags |= MS_POSIXACL;
 #endif
 	sb->s_flags |= MS_I_VERSION;
+	sb->s_flags |= MS_PROC_USE_ST;
 	err = open_ctree(sb, fs_devices, (char *)data);
 	if (err) {
 		printk("btrfs: open_ctree failed\n");
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index a2596af..eca8195 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -24,6 +24,8 @@
 #include <linux/spinlock.h>
 #include <linux/completion.h>
 #include <asm/uaccess.h>
+#include <linux/fs.h>
+#include <linux/dcache.h>
 
 #include "internal.h"
 
@@ -637,3 +639,31 @@ void *PDE_DATA(const struct inode *inode)
 	return __PDE_DATA(inode);
 }
 EXPORT_SYMBOL(PDE_DATA);
+
+static dev_t proc_get_dev_from_stat(struct inode *inode)
+{
+	struct dentry *dentry = d_find_any_alias(inode);
+	struct kstat kstat;
+
+	if (!dentry)
+		goto out_error;
+
+	if (inode->i_op->getattr(NULL, dentry, &kstat))
+		goto out_error_dput;
+
+	dput(dentry);
+	return kstat.dev;
+
+out_error_dput:
+	dput(dentry);
+out_error:
+	return inode->i_sb->s_dev;
+}
+
+dev_t proc_get_map_dev(struct inode *inode)
+{
+	if (inode->i_sb->s_flags & MS_PROC_USE_ST)
+		return proc_get_dev_from_stat(inode);
+	else
+		return inode->i_sb->s_dev;
+}
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index d600fb0..24808b0 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -192,6 +192,7 @@ static inline struct proc_dir_entry *pde_get(struct proc_dir_entry *pde)
 	return pde;
 }
 extern void pde_put(struct proc_dir_entry *);
+dev_t proc_get_map_dev(struct inode *inode);
 
 /*
  * inode.c
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 3e636d8..9226600 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -272,7 +272,7 @@ show_map_vma(struct seq_file *m, struct vm_area_struct *vma, int is_pid)
 
 	if (file) {
 		struct inode *inode = file_inode(vma->vm_file);
-		dev = inode->i_sb->s_dev;
+		dev = proc_get_map_dev(inode);
 		ino = inode->i_ino;
 		pgoff = ((loff_t)vma->vm_pgoff) << PAGE_SHIFT;
 	}
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 56123a6..892d84a 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -150,7 +150,7 @@ static int nommu_vma_show(struct seq_file *m, struct vm_area_struct *vma,
 
 	if (file) {
 		struct inode *inode = file_inode(vma->vm_file);
-		dev = inode->i_sb->s_dev;
+		dev = proc_get_map_dev(inode);
 		ino = inode->i_ino;
 		pgoff = (loff_t)vma->vm_pgoff << PAGE_SHIFT;
 	}
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index a4ed56c..b4173a3 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -88,6 +88,7 @@ struct inodes_stat_t {
 #define MS_STRICTATIME	(1<<24) /* Always perform atime updates */
 
 /* These sb flags are internal to the kernel */
+#define MS_PROC_USE_ST	(1<<27)
 #define MS_NOSEC	(1<<28)
 #define MS_BORN		(1<<29)
 #define MS_ACTIVE	(1<<30)
-- 
1.8.1.4

