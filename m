Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:51856 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753536Ab2FEJrb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Jun 2012 05:47:31 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kay Sievers <kay@vrfy.org>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] btrfs: Use printk_get_level and printk_skip_level, add __printf, fix fallout
Date: Tue,  5 Jun 2012 02:46:33 -0700
Message-Id: <982bca290e82702d3b89c98022e16311fd6fa371.1338889066.git.joe@perches.com>
In-Reply-To: <cover.1338889066.git.joe@perches.com>
References: <cover.1338889066.git.joe@perches.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use the generic printk_get_level function to search a message
for a kern_level.  Add __printf to verify format and arguments.
Fix a few messages that had mismatches in format and arguments.
Add #ifdef CONFIG_PRINTK blocks to shrink the object size a bit
when not using printk.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/btrfs/ctree.h      |   13 +++++++++++++
 fs/btrfs/disk-io.c    |    2 +-
 fs/btrfs/relocation.c |    2 +-
 fs/btrfs/super.c      |   41 +++++++++++++++++++++++++++++++++++------
 4 files changed, 50 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0236d03..590b519 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3046,10 +3046,22 @@ ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
 /* super.c */
 int btrfs_parse_options(struct btrfs_root *root, char *options);
 int btrfs_sync_fs(struct super_block *sb, int wait);
+
+#ifdef CONFIG_PRINTK
+__printf(2, 3)
 void btrfs_printk(struct btrfs_fs_info *fs_info, const char *fmt, ...);
+#else
+static inline __printf(2, 3)
+void btrfs_printk(struct btrfs_fs_info *fs_info, const char *fmt, ...)
+{
+}
+#endif
+
+__printf(5, 6)
 void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 		     unsigned int line, int errno, const char *fmt, ...);
 
+
 void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root, const char *function,
 			       unsigned int line, int errno);
@@ -3073,6 +3085,7 @@ do {								\
 			  (errno), fmt, ##args);		\
 } while (0)
 
+__printf(5, 6)
 void __btrfs_panic(struct btrfs_fs_info *fs_info, const char *function,
 		   unsigned int line, int errno, const char *fmt, ...);
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7ae51de..f02bba5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1113,7 +1113,7 @@ void clean_tree_block(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 				spin_unlock(&root->fs_info->delalloc_lock);
 				btrfs_panic(root->fs_info, -EOVERFLOW,
 					  "Can't clear %lu bytes from "
-					  " dirty_mdatadata_bytes (%lu)",
+					  " dirty_mdatadata_bytes (%llu)",
 					  buf->len,
 					  root->fs_info->dirty_metadata_bytes);
 			}
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 646ee21..790f492 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1242,7 +1242,7 @@ static int __must_check __add_reloc_root(struct btrfs_root *root)
 		kfree(node);
 		btrfs_panic(root->fs_info, -EEXIST, "Duplicate root found "
 			    "for start=%llu while inserting into relocation "
-			    "tree\n");
+			    "tree\n", node->bytenr);
 	}
 
 	list_add_tail(&root->root_list, &rc->reloc_roots);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 96eb9fe..a84529d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -124,6 +124,7 @@ static void btrfs_handle_error(struct btrfs_fs_info *fs_info)
 	}
 }
 
+#ifdef CONFIG_PRINTK
 /*
  * __btrfs_std_error decodes expected errors from the caller and
  * invokes the approciate error response.
@@ -166,7 +167,7 @@ void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 	va_end(args);
 }
 
-const char *logtypes[] = {
+static const char *logtypes[] = {
 	"emergency",
 	"alert",
 	"critical",
@@ -184,22 +185,50 @@ void btrfs_printk(struct btrfs_fs_info *fs_info, const char *fmt, ...)
 	struct va_format vaf;
 	va_list args;
 	const char *type = logtypes[4];
+	int kern_level;
 
 	va_start(args, fmt);
 
-	if (fmt[0] == '<' && isdigit(fmt[1]) && fmt[2] == '>') {
-		memcpy(lvl, fmt, 3);
-		lvl[3] = '\0';
-		fmt += 3;
-		type = logtypes[fmt[1] - '0'];
+	kern_level = printk_get_level(fmt);
+	if (kern_level) {
+		size_t size = printk_skip_level(fmt)  - fmt;
+		memcpy(lvl, fmt,  size);
+		lvl[size] = '\0';
+		fmt += size;
+		type = logtypes[kern_level - '0'];
 	} else
 		*lvl = '\0';
 
 	vaf.fmt = fmt;
 	vaf.va = &args;
+
 	printk("%sBTRFS %s (device %s): %pV", lvl, type, sb->s_id, &vaf);
+
+	va_end(args);
 }
 
+#else
+
+void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
+		       unsigned int line, int errno, const char *fmt, ...)
+{
+	struct super_block *sb = fs_info->sb;
+
+	/*
+	 * Special case: if the error is EROFS, and we're already
+	 * under MS_RDONLY, then it is safe here.
+	 */
+	if (errno == -EROFS && (sb->s_flags & MS_RDONLY))
+		return;
+
+	/* Don't go through full error handling during mount */
+	if (sb->s_flags & MS_BORN) {
+		save_error_info(fs_info);
+		btrfs_handle_error(fs_info);
+	}
+}
+#endif
+
 /*
  * We only mark the transaction aborted and then set the file system read-only.
  * This will prevent new transactions from starting or trying to join this
-- 
1.7.8.111.gad25c.dirty

