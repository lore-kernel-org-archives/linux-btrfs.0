From: liubo <liubo2009@cn.fujitsu.com>
Subject: [RFC PATCH 3/5 v3] Btrfs: add readonly support for error handle
Date: Fri, 03 Dec 2010 16:16:26 +0800
Message-ID: <4CF8A75A.5030503@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>,
	Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
	"Yan, Zheng " <yanzheng@21cn.com>,
	Wenyi Liu <qingshenlwy@gmail.com>,
	Mike Fedyk <mfedyk@mikefedyk.com>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch provide a new error handle interface for those errors that handled
by current BUG_ONs.

In order to protect btrfs from panic, when it comes to those BUG_ON errors, 
the interface forces btrfs readonly and saves the FS state to disk. And the 
filesystem can be umounted, although mabye with some warning in kernel dmesg.
Then btrfsck is helpful to recover btrfs.

v1->v2:
move write super stuff from error handle path to unmount in order to avoid
deadlock.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ctree.h |    8 +++++
 fs/btrfs/super.c |   88 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 96 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 92b5ca2..fc9b6a0 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2552,6 +2552,14 @@ ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
 /* super.c */
 int btrfs_parse_options(struct btrfs_root *root, char *options);
 int btrfs_sync_fs(struct super_block *sb, int wait);
+void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
+		     unsigned int line, int errno);
+
+#define btrfs_std_error(fs_info, errno)				\
+do {								\
+	if ((errno))						\
+		__btrfs_std_error((fs_info), __func__, __LINE__, (errno));\
+} while (0)
 
 /* acl.c */
 #ifdef CONFIG_BTRFS_FS_POSIX_ACL
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 718b10d..07c58f9 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -54,6 +54,94 @@
 
 static const struct super_operations btrfs_super_ops;
 
+static const char *btrfs_decode_error(struct btrfs_fs_info *fs_info, int errno,
+				      char nbuf[16])
+{
+	char *errstr = NULL;
+
+	switch (errno) {
+	case -EIO:
+		errstr = "IO failure";
+		break;
+	case -ENOMEM:
+		errstr = "Out of memory";
+		break;
+	case -EROFS:
+		errstr = "Readonly filesystem";
+		break;
+	default:
+		if (nbuf) {
+			if (snprintf(nbuf, 16, "error %d", -errno) >= 0)
+				errstr = nbuf;
+		}
+		break;
+	}
+
+	return errstr;
+}
+
+static void __save_error_info(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_super_block *disk_super = &fs_info->super_copy;
+
+	fs_info->fs_state = BTRFS_SUPER_FLAG_ERROR;
+	disk_super->flags |= cpu_to_le64(BTRFS_SUPER_FLAG_ERROR);
+
+	mutex_lock(&fs_info->trans_mutex);
+	memcpy(&fs_info->super_for_commit, disk_super,
+	       sizeof(fs_info->super_for_commit));
+	mutex_unlock(&fs_info->trans_mutex);
+}
+
+/* NOTE:
+ *	We move write_super stuff at umount in order to avoid deadlock
+ *	for umount hold all lock.
+ */
+static void save_error_info(struct btrfs_fs_info *fs_info)
+{
+	__save_error_info(fs_info);
+}
+
+/* btrfs handle error by forcing the filesystem readonly */
+static void btrfs_handle_error(struct btrfs_fs_info *fs_info)
+{
+	struct super_block *sb = fs_info->sb;
+
+	if (sb->s_flags & MS_RDONLY)
+		return;
+
+	if (fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
+		sb->s_flags |= MS_RDONLY;
+		printk(KERN_INFO "btrfs is forced readonly\n");
+	}
+}
+
+/*
+ * __btrfs_std_error decodes expected errors from the caller and
+ * invokes the approciate error response.
+ */
+void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
+		     unsigned int line, int errno)
+{
+	struct super_block *sb = fs_info->sb;
+	char nbuf[16];
+	const char *errstr;
+
+	/*
+	 * Special case: if the error is EROFS, and we're already
+	 * under MS_RDONLY, then it is safe here.
+	 */
+	if (errno == -EROFS && (sb->s_flags & MS_RDONLY))
+		return;
+
+	errstr = btrfs_decode_error(fs_info, errno, nbuf);
+	printk(KERN_CRIT "BTRFS error (device %s) in %s:%d: %s\n",
+		sb->s_id, function, line, errstr);
+	save_error_info(fs_info);
+
+	btrfs_handle_error(fs_info);
+}
+
 static void btrfs_put_super(struct super_block *sb)
 {
 	struct btrfs_root *root = btrfs_sb(sb);
-- 
1.7.1
