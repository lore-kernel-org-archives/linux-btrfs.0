From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 05/10] btrfs: Add BTRFS_UERROR for unhandled errors
Date: Wed, 04 Nov 2009 14:03:51 -0500
Message-ID: <20091104190433.477436095@suse.com>
References: <20091104190346.971762946@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 This patch adds a BTRFS_UERROR macro to indicate than an error is
 unhandled but should be. This is to differentiate between internal
 logic errors and runtime errors so that we can go through later
 more easily to locate and fix them. It currently BUGs after
 printing a message indicating where the failure occured and what
 the failure condition was.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

---

 fs/btrfs/ctree.h |    8 ++++++++
 fs/btrfs/super.c |    8 ++++++++
 2 files changed, 16 insertions(+)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1951,6 +1951,13 @@ static inline struct dentry *fdentry(str
 	return file->f_path.dentry;
 }
 
+#define BTRFS_UERROR(condition) \
+	do { \
+		if (condition) \
+			btrfs_unhandled_error(__FILE__, __LINE__, \
+					      #condition); \
+	} while(0);
+
 /* extent-tree.c */
 void btrfs_put_block_group(struct btrfs_block_group_cache *cache);
 int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
@@ -2373,6 +2380,7 @@ ssize_t btrfs_listxattr(struct dentry *d
 u64 btrfs_parse_size(char *str);
 int btrfs_parse_options(struct btrfs_root *root, char *options);
 int btrfs_sync_fs(struct super_block *sb, int wait);
+void btrfs_unhandled_error(const char *file, int line, const char *condition);
 
 /* acl.c */
 #ifdef CONFIG_BTRFS_FS_POSIX_ACL
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -51,6 +51,14 @@
 #include "export.h"
 #include "compression.h"
 
+void btrfs_unhandled_error(const char *file, int line, const char *msg)
+{
+	printk(KERN_CRIT "btrfs: Unhandled error at %s:%d: %s\n",
+	       file, line, msg);
+
+	BUG();
+}
+
 static struct super_operations btrfs_super_ops;
 
 static void btrfs_put_super(struct super_block *sb)

