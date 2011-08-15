From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch v2 1/9] btrfs: Add btrfs_panic()
Date: Mon, 15 Aug 2011 15:50:43 -0400
Message-ID: <20110815195232.022137466@suse.com>
References: <20110815195042.559654068@suse.com>
To: Btrfs Development List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 As part of the effort to eliminate BUG_ON as an error handling
 technique, we need to determine which errors are actual logic errors,
 which are on-disk corruption, and which are normal runtime errors
 e.g. -ENOMEM.

 Annotating these error cases is helpful to understand and report them.

 This patch adds a btrfs_panic() routine that will either panic
 or BUG depending on the new -ofatal_errors={panic,bug} mount option.
 Since there are still so many BUG_ONs, it defaults to BUG for now but I
 expect that to change once the error handling effort has made
 significant progress.


Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h |   11 +++++++++++
 fs/btrfs/super.c |   47 ++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 57 insertions(+), 1 deletion(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1363,6 +1363,7 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_MOUNT_ENOSPC_DEBUG	 (1 << 15)
 #define BTRFS_MOUNT_AUTO_DEFRAG		(1 << 16)
 #define BTRFS_MOUNT_INODE_MAP_CACHE	(1 << 17)
+#define BTRFS_MOUNT_PANIC_ON_FATAL_ERROR	(1 << 18)
 
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
@@ -2650,6 +2651,16 @@ do {								\
 		__btrfs_std_error((fs_info), __func__, __LINE__, (errno));\
 } while (0)
 
+void __btrfs_panic(struct btrfs_fs_info *fs_info, const char *function,
+		   unsigned int line, int errno, const char *fmt, ...);
+
+#define btrfs_panic(fs_info, errno, fmt, args...)			\
+do {									\
+	struct btrfs_fs_info *_i = (fs_info);				\
+	__btrfs_panic(_i, __func__, __LINE__, errno, fmt, ##args);	\
+	BUG_ON(!(_i->mount_opt & BTRFS_MOUNT_PANIC_ON_FATAL_ERROR));	\
+} while (0)
+
 /* acl.c */
 #ifdef CONFIG_BTRFS_FS_POSIX_ACL
 struct posix_acl *btrfs_get_acl(struct inode *inode, int type);
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -74,6 +74,9 @@ static const char *btrfs_decode_error(st
 	case -EROFS:
 		errstr = "Readonly filesystem";
 		break;
+	case -EEXIST:
+		errstr = "Object already exists";
+		break;
 	default:
 		if (nbuf) {
 			if (snprintf(nbuf, 16, "error %d", -errno) >= 0)
@@ -143,6 +146,33 @@ void __btrfs_std_error(struct btrfs_fs_i
 	btrfs_handle_error(fs_info);
 }
 
+/*
+ * __btrfs_panic decodes unexpected, fatal errors from the caller,
+ * issues an alert, and either panics or BUGs, depending on mount options.
+ */
+void __btrfs_panic(struct btrfs_fs_info *fs_info, const char *function,
+		   unsigned int line, int errno, const char *fmt, ...)
+{
+	struct super_block *sb = fs_info->sb;
+	char nbuf[16];
+	const char *errstr;
+	struct va_format vaf = { .fmt = fmt };
+	va_list args;
+
+	va_start(args, fmt);
+	vaf.va = &args;
+
+	errstr = btrfs_decode_error(fs_info, errno, nbuf);
+	if (fs_info->mount_opt & BTRFS_MOUNT_PANIC_ON_FATAL_ERROR)
+		panic(KERN_CRIT "BTRFS panic (device %s) in %s:%d: %pV (%s)\n",
+			sb->s_id, function, line, &vaf, errstr);
+
+	printk(KERN_CRIT "BTRFS panic (device %s) in %s:%d: %pV (%s)\n",
+	       sb->s_id, function, line, &vaf, errstr);
+	va_end(args);
+	/* Caller calls BUG() */
+}
+
 static void btrfs_put_super(struct super_block *sb)
 {
 	struct btrfs_root *root = btrfs_sb(sb);
@@ -162,7 +192,7 @@ enum {
 	Opt_notreelog, Opt_ratio, Opt_flushoncommit, Opt_discard,
 	Opt_space_cache, Opt_clear_cache, Opt_user_subvol_rm_allowed,
 	Opt_enospc_debug, Opt_subvolrootid, Opt_defrag,
-	Opt_inode_cache, Opt_err,
+	Opt_inode_cache, Opt_fatal_errors, Opt_err,
 };
 
 static match_table_t tokens = {
@@ -195,6 +225,7 @@ static match_table_t tokens = {
 	{Opt_subvolrootid, "subvolrootid=%d"},
 	{Opt_defrag, "autodefrag"},
 	{Opt_inode_cache, "inode_cache"},
+	{Opt_fatal_errors, "fatal_errors=%s"},
 	{Opt_err, NULL},
 };
 
@@ -381,6 +412,18 @@ int btrfs_parse_options(struct btrfs_roo
 			printk(KERN_INFO "btrfs: enabling auto defrag");
 			btrfs_set_opt(info->mount_opt, AUTO_DEFRAG);
 			break;
+		case Opt_fatal_errors:
+			if (strcmp(args[0].from, "panic") == 0)
+				btrfs_set_opt(info->mount_opt,
+					      PANIC_ON_FATAL_ERROR);
+			else if (strcmp(args[0].from, "bug") == 0)
+				btrfs_clear_opt(info->mount_opt,
+					      PANIC_ON_FATAL_ERROR);
+			else {
+				ret = -EINVAL;
+				goto out;
+			}
+			break;
 		case Opt_err:
 			printk(KERN_INFO "btrfs: unrecognized mount option "
 			       "'%s'\n", p);
@@ -729,6 +772,8 @@ static int btrfs_show_options(struct seq
 		seq_puts(seq, ",autodefrag");
 	if (btrfs_test_opt(root, INODE_MAP_CACHE))
 		seq_puts(seq, ",inode_cache");
+	if (btrfs_test_opt(root, PANIC_ON_FATAL_ERROR))
+		seq_puts(seq, ",fatal_errors=panic");
 	return 0;
 }
 


