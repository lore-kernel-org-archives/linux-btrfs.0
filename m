From: Eric Paris <eparis@redhat.com>
Subject: btrfs: introduce btrfs_show_options
Date: Tue, 24 Feb 2009 17:48:36 -0500
Message-ID: <1235515716.10158.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs options can change at times other than mount, yet /proc/mounts shows the
options string used when the fs was mounted (an example would be when btrfs
determines that barriers aren't useful and turns them off.)  This patch
instead outputs the actual options in use by btrfs.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/btrfs/super.c |   34 +++++++++++++++++++++++++++++++++-
 1 files changed, 33 insertions(+), 1 deletions(-)


diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 19a4daf..2ceb40b 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -24,6 +24,7 @@
 #include <linux/highmem.h>
 #include <linux/time.h>
 #include <linux/init.h>
+#include <linux/seq_file.h>
 #include <linux/string.h>
 #include <linux/smp_lock.h>
 #include <linux/backing-dev.h>
@@ -385,6 +386,37 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
 	return ret;
 }
 
+static int btrfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
+{
+	struct btrfs_root *root = btrfs_sb(vfs->mnt_sb);
+	struct btrfs_fs_info *info = root->fs_info;
+
+	if (btrfs_test_opt(root, DEGRADED))
+		seq_puts(seq, ",degraded");
+	if (btrfs_test_opt(root, NODATASUM))
+		seq_puts(seq, ",nodatasum");
+	if (btrfs_test_opt(root, NODATACOW))
+		seq_puts(seq, ",nodatacow");
+	if (btrfs_test_opt(root, NOBARRIER))
+		seq_puts(seq, ",nobarrier");
+	if (info->max_extent != (u64)-1)
+		seq_printf(seq, ",max_extent=%llu", info->max_extent);
+	if (info->max_inline != 8192 * 1024)
+		seq_printf(seq, ",max_inline=%llu", info->max_inline);
+	if (info->alloc_start != 0)
+		seq_printf(seq, ",alloc_start=%llu", info->alloc_start);
+	if (info->thread_pool_size !=  min_t(unsigned long,
+					     num_online_cpus() + 2, 8))
+		seq_printf(seq, ",thread_pool=%d", info->thread_pool_size);
+	if (btrfs_test_opt(root, COMPRESS))
+		seq_puts(seq, ",compress");
+	if (btrfs_test_opt(root, SSD))
+		seq_puts(seq, ",ssd");
+	if (!(root->fs_info->sb->s_flags & MS_POSIXACL))
+		seq_puts(seq, ",noacl");
+	return 0;
+}
+
 static void btrfs_write_super(struct super_block *sb)
 {
 	sb->s_dirt = 0;
@@ -630,7 +662,7 @@ static struct super_operations btrfs_super_ops = {
 	.put_super	= btrfs_put_super,
 	.write_super	= btrfs_write_super,
 	.sync_fs	= btrfs_sync_fs,
-	.show_options	= generic_show_options,
+	.show_options	= btrfs_show_options,
 	.write_inode	= btrfs_write_inode,
 	.dirty_inode	= btrfs_dirty_inode,
 	.alloc_inode	= btrfs_alloc_inode,


