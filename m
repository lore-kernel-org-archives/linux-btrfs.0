Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:19567 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751651Ab2HJFbg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Aug 2012 01:31:36 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q7A5VY0X026111
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2012 13:31:34 +0800
Message-ID: <50249C8A.5010902@cn.fujitsu.com>
Date: Fri, 10 Aug 2012 13:30:50 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] Btrfs: fix several compile warning
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch fixed the following warning:
cmds-send.c:464:6: warning: ‘ret' may be used uninitialized in this function [-Wuninitialized]
crc32c.c:121:1: warning: control reaches end of non-void function [-Wreturn-type]
send-utils.c:69:11: warning: ‘comp' may be used uninitialized in this function [-Wuninitialized]
send-utils.c:126:6: warning: ‘comp' may be used uninitialized in this function [-Wuninitialized]
send-utils.c:99:22: warning: ‘entry' may be used uninitialized in this function [-Wuninitialized]
btrfs.c:261:2: warning: implicit declaration of function ‘crc32c_optimization_init' [-Wimplicit-function-declaration]
btrfs.c:105:2: warning: ‘cmd' may be used uninitialized in this function [-Wuninitialized]
restore.c:435:12: warning: ignoring return value of ‘ftruncate', declared with attribute warn_unused_result [-Wunused-result]

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 btrfs.c      |    3 ++-
 cmds-send.c  |    2 ++
 crc32c.c     |    4 ++--
 crc32c.h     |    2 +-
 restore.c    |    8 +++++---
 send-utils.c |    4 ++++
 6 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index e9d54f8..ed99994 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -19,6 +19,7 @@
 #include <stdlib.h>
 #include <string.h>
 
+#include "crc32c.h"
 #include "commands.h"
 #include "version.h"
 
@@ -93,7 +94,7 @@ static int parse_one_token(const char *arg, const struct cmd_group *grp,
 static const struct cmd_struct *
 parse_command_token(const char *arg, const struct cmd_group *grp)
 {
-	const struct cmd_struct *cmd;
+	const struct cmd_struct *cmd = NULL;
 
 	switch(parse_one_token(arg, grp, &cmd)) {
 	case -1:
diff --git a/cmds-send.c b/cmds-send.c
index 8a0c110..3d15d26 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -541,6 +541,7 @@ int cmd_send_start(int argc, char **argv)
 
 	subvol = realpath(argv[optind], NULL);
 	if (!subvol) {
+		ret = -errno;
 		fprintf(stderr, "ERROR: unable to resolve %s\n", argv[optind]);
 		goto out;
 	}
@@ -565,6 +566,7 @@ int cmd_send_start(int argc, char **argv)
 	for (i = optind; i < argc; i++) {
 		subvol = realpath(argv[i], NULL);
 		if (!subvol) {
+			ret = -errno;
 			fprintf(stderr, "ERROR: unable to resolve %s\n", argv[i]);
 			goto out;
 		}
diff --git a/crc32c.c b/crc32c.c
index a761a1d..c285d6e 100644
--- a/crc32c.c
+++ b/crc32c.c
@@ -113,7 +113,7 @@ void crc32c_intel_probe(void)
 	}
 }
 
-int crc32c_optimization_init(void)
+void crc32c_optimization_init(void)
 {
 	crc32c_intel_probe();
 	if (crc32c_intel_available)
@@ -121,7 +121,7 @@ int crc32c_optimization_init(void)
 }
 #else
 
-int crc32c_optimization_init(void)
+void crc32c_optimization_init(void)
 {
 }
 
diff --git a/crc32c.h b/crc32c.h
index 27f298a..7f12e77 100644
--- a/crc32c.h
+++ b/crc32c.h
@@ -22,7 +22,7 @@
 #include "kerncompat.h"
 
 u32 crc32c_le(u32 seed, unsigned char const *data, size_t length);
-int crc32c_optimization_init(void);
+void crc32c_optimization_init(void);
 
 #define crc32c(seed, data, length) crc32c_le(seed, (unsigned char const *)data, length)
 #define btrfs_crc32c crc32c
diff --git a/restore.c b/restore.c
index d1ac542..b9e5381 100644
--- a/restore.c
+++ b/restore.c
@@ -385,7 +385,6 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 					/* No more leaves to search */
 					btrfs_free_path(path);
 					goto set_size;
-					return 0;
 				}
 				leaf = path->nodes[0];
 			} while (!leaf);
@@ -431,8 +430,11 @@ next:
 
 	btrfs_free_path(path);
 set_size:
-	if (found_size)
-		ftruncate(fd, (loff_t)found_size);
+	if (found_size) {
+		ret = ftruncate(fd, (loff_t)found_size);
+		if (ret)
+			return ret;
+	}
 	return 0;
 }
 
diff --git a/send-utils.c b/send-utils.c
index a43d47e..af495a0 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -62,6 +62,8 @@ static struct rb_node *tree_insert(struct rb_root *root,
 			entry = rb_entry(parent, struct subvol_info,
 					rb_path_node);
 			comp = strcmp(entry->path, si->path);
+		} else {
+			BUG();
 		}
 
 		if (comp < 0)
@@ -120,6 +122,8 @@ static struct subvol_info *tree_search(struct rb_root *root,
 		} else if (type == subvol_search_by_path) {
 			entry = rb_entry(n, struct subvol_info, rb_path_node);
 			comp = strcmp(entry->path, path);
+		} else {
+			BUG();
 		}
 		if (comp < 0)
 			n = n->rb_left;
-- 
1.7.6.5
