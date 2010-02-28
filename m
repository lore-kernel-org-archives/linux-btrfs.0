From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] btrfs: use memparse
Date: Sun, 28 Feb 2010 19:59:11 +0900
Message-ID: <1267354751-6502-1-git-send-email-akinobu.mita@gmail.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Use memparse() instead of its own private implementation.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: linux-btrfs@vger.kernel.org
---
 fs/btrfs/ctree.h |    1 -
 fs/btrfs/ioctl.c |    2 +-
 fs/btrfs/super.c |   31 +++----------------------------
 3 files changed, 4 insertions(+), 30 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2aa8ec6..52af317 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2386,7 +2386,6 @@ void btrfs_sysfs_del_super(struct btrfs_fs_info *root);
 ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
 
 /* super.c */
-u64 btrfs_parse_size(char *str);
 int btrfs_parse_options(struct btrfs_root *root, char *options);
 int btrfs_sync_fs(struct super_block *sb, int wait);
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 645a179..c359efd 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -608,7 +608,7 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
 			mod = 1;
 			sizestr++;
 		}
-		new_size = btrfs_parse_size(sizestr);
+		new_size = memparse(sizestr, NULL);
 		if (new_size == 0) {
 			ret = -EINVAL;
 			goto out_unlock;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8a1ea6e..aa48c6b 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -95,31 +95,6 @@ static match_table_t tokens = {
 	{Opt_err, NULL},
 };
 
-u64 btrfs_parse_size(char *str)
-{
-	u64 res;
-	int mult = 1;
-	char *end;
-	char last;
-
-	res = simple_strtoul(str, &end, 10);
-
-	last = end[0];
-	if (isalpha(last)) {
-		last = tolower(last);
-		switch (last) {
-		case 'g':
-			mult *= 1024;
-		case 'm':
-			mult *= 1024;
-		case 'k':
-			mult *= 1024;
-		}
-		res = res * mult;
-	}
-	return res;
-}
-
 /*
  * Regular mount options parser.  Everything that is needed only when
  * reading in a new superblock is parsed here.
@@ -213,7 +188,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		case Opt_max_extent:
 			num = match_strdup(&args[0]);
 			if (num) {
-				info->max_extent = btrfs_parse_size(num);
+				info->max_extent = memparse(num, NULL);
 				kfree(num);
 
 				info->max_extent = max_t(u64,
@@ -225,7 +200,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		case Opt_max_inline:
 			num = match_strdup(&args[0]);
 			if (num) {
-				info->max_inline = btrfs_parse_size(num);
+				info->max_inline = memparse(num, NULL);
 				kfree(num);
 
 				if (info->max_inline) {
@@ -240,7 +215,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		case Opt_alloc_start:
 			num = match_strdup(&args[0]);
 			if (num) {
-				info->alloc_start = btrfs_parse_size(num);
+				info->alloc_start = memparse(num, NULL);
 				kfree(num);
 				printk(KERN_INFO
 					"btrfs: allocations start at %llu\n",
-- 
1.6.0.6

