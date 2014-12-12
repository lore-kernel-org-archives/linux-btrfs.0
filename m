Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967773AbaLLMgE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 07:36:04 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sBCCa3IP022450
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Dec 2014 07:36:04 -0500
From: Karel Zak <kzak@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Karel Zak <kzak@redhat.com>
Subject: [PATCH 03/10] btrfs-progs: use standard PACKAGE_* macros
Date: Fri, 12 Dec 2014 13:35:17 +0100
Message-Id: <1418387724-20188-4-git-send-email-kzak@redhat.com>
In-Reply-To: <1418387724-20188-1-git-send-email-kzak@redhat.com>
References: <1418387724-20188-1-git-send-email-kzak@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

- use standard PACKAGE_{NAME,VERSION,STRING,URL,...} autoconf macros
  rather than homemade BTRFS_BUILD_VERSION

- don't #include version.h, now the file is necessary for library API only

Note that "btrfs version" returns "btrfs-progs <version>" instead of
the original confusing "btrfs <version>".

Signed-off-by: Karel Zak <kzak@redhat.com>
---
 btrfs-calc-size.c     | 1 -
 btrfs-corrupt-block.c | 1 -
 btrfs-debug-tree.c    | 5 ++---
 btrfs-find-root.c     | 1 -
 btrfs-image.c         | 1 -
 btrfs-map-logical.c   | 1 -
 btrfs-select-super.c  | 3 +--
 btrfs-show-super.c    | 3 +--
 btrfs-zero-log.c      | 3 +--
 btrfs.c               | 3 +--
 btrfstune.c           | 1 -
 chunk-recover.c       | 1 -
 cmds-check.c          | 3 +--
 cmds-filesystem.c     | 5 ++---
 cmds-restore.c        | 1 -
 library-test.c        | 1 -
 mkfs.c                | 9 ++++-----
 17 files changed, 13 insertions(+), 30 deletions(-)

diff --git a/btrfs-calc-size.c b/btrfs-calc-size.c
index 3ec8230..2be0d64 100644
--- a/btrfs-calc-size.c
+++ b/btrfs-calc-size.c
@@ -32,7 +32,6 @@
 #include "print-tree.h"
 #include "transaction.h"
 #include "list.h"
-#include "version.h"
 #include "volumes.h"
 #include "utils.h"
 
diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index e993680..ba7358d 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -30,7 +30,6 @@
 #include "print-tree.h"
 #include "transaction.h"
 #include "list.h"
-#include "version.h"
 #include "utils.h"
 
 #define FIELD_BUF_LEN 80
diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index e46500d..4468297 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -26,7 +26,6 @@
 #include "disk-io.h"
 #include "print-tree.h"
 #include "transaction.h"
-#include "version.h"
 #include "utils.h"
 
 static int print_usage(void)
@@ -43,7 +42,7 @@ static int print_usage(void)
                     " only\n");
 	fprintf(stderr,
 		"\t-t tree_id : print only the tree with the given id\n");
-	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
+	fprintf(stderr, "%s\n", PACKAGE_STRING);
 	exit(1);
 }
 
@@ -406,7 +405,7 @@ no_node:
 	uuidbuf[BTRFS_UUID_UNPARSED_SIZE - 1] = '\0';
 	uuid_unparse(info->super_copy->fsid, uuidbuf);
 	printf("uuid %s\n", uuidbuf);
-	printf("%s\n", BTRFS_BUILD_VERSION);
+	printf("%s\n", PACKAGE_STRING);
 close_root:
 	return close_ctree(root);
 }
diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index b24dddf..571c86a 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -30,7 +30,6 @@
 #include "print-tree.h"
 #include "transaction.h"
 #include "list.h"
-#include "version.h"
 #include "volumes.h"
 #include "utils.h"
 #include "crc32c.h"
diff --git a/btrfs-image.c b/btrfs-image.c
index 1257966..74681ba 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -33,7 +33,6 @@
 #include "disk-io.h"
 #include "transaction.h"
 #include "utils.h"
-#include "version.h"
 #include "volumes.h"
 #include "extent_io.h"
 
diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index c34484f..fc4a29b 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -30,7 +30,6 @@
 #include "print-tree.h"
 #include "transaction.h"
 #include "list.h"
-#include "version.h"
 #include "utils.h"
 
 /* we write the mirror info to stdout unless they are dumping the data
diff --git a/btrfs-select-super.c b/btrfs-select-super.c
index 54ac436..492d38d 100644
--- a/btrfs-select-super.c
+++ b/btrfs-select-super.c
@@ -29,13 +29,12 @@
 #include "print-tree.h"
 #include "transaction.h"
 #include "list.h"
-#include "version.h"
 #include "utils.h"
 
 static void print_usage(void)
 {
 	fprintf(stderr, "usage: btrfs-select-super -s number dev\n");
-	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
+	fprintf(stderr, "%s\n", PACKAGE_STRING);
 	exit(1);
 }
 
diff --git a/btrfs-show-super.c b/btrfs-show-super.c
index 9702eb0..15b9e36 100644
--- a/btrfs-show-super.c
+++ b/btrfs-show-super.c
@@ -33,7 +33,6 @@
 #include "print-tree.h"
 #include "transaction.h"
 #include "list.h"
-#include "version.h"
 #include "utils.h"
 #include "crc32c.h"
 
@@ -51,7 +50,7 @@ static void print_usage(void)
 	fprintf(stderr, "\t-a : print information of all superblocks\n");
 	fprintf(stderr, "\t-i <super_mirror> : specify which mirror to print out\n");
 	fprintf(stderr, "\t-F : attempt to dump superblocks with bad magic\n");
-	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
+	fprintf(stderr, "%s\n", PACKAGE_STRING);
 }
 
 int main(int argc, char **argv)
diff --git a/btrfs-zero-log.c b/btrfs-zero-log.c
index 411fae3..0859fe2 100644
--- a/btrfs-zero-log.c
+++ b/btrfs-zero-log.c
@@ -29,14 +29,13 @@
 #include "print-tree.h"
 #include "transaction.h"
 #include "list.h"
-#include "version.h"
 #include "utils.h"
 
 static void print_usage(void) __attribute__((noreturn));
 static void print_usage(void)
 {
 	fprintf(stderr, "usage: btrfs-zero-log dev\n");
-	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
+	fprintf(stderr, "%s\n", PACKAGE_STRING);
 	exit(1);
 }
 
diff --git a/btrfs.c b/btrfs.c
index 2451885..f0fa848 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -20,7 +20,6 @@
 
 #include "crc32c.h"
 #include "commands.h"
-#include "version.h"
 #include "utils.h"
 
 static const char * const btrfs_cmd_group_usage[] = {
@@ -168,7 +167,7 @@ static const char * const cmd_version_usage[] = {
 
 static int cmd_version(int argc, char **argv)
 {
-	printf("%s\n", BTRFS_BUILD_VERSION);
+	printf("%s\n", PACKAGE_STRING);
 	return 0;
 }
 
diff --git a/btrfstune.c b/btrfstune.c
index 899a721..65513f6 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -30,7 +30,6 @@
 #include "disk-io.h"
 #include "transaction.h"
 #include "utils.h"
-#include "version.h"
 
 static char *device;
 
diff --git a/chunk-recover.c b/chunk-recover.c
index 688a7d7..c76b1b2 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -37,7 +37,6 @@
 #include "transaction.h"
 #include "crc32c.h"
 #include "utils.h"
-#include "version.h"
 #include "btrfsck.h"
 #include "commands.h"
 
diff --git a/cmds-check.c b/cmds-check.c
index 0894cf0..87cb6e2 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -33,7 +33,6 @@
 #include "disk-io.h"
 #include "print-tree.h"
 #include "transaction.h"
-#include "version.h"
 #include "utils.h"
 #include "commands.h"
 #include "free-space-cache.h"
@@ -7986,7 +7985,7 @@ out:
 	printf("file data blocks allocated: %llu\n referenced %llu\n",
 		(unsigned long long)data_bytes_allocated,
 		(unsigned long long)data_bytes_referenced);
-	printf("%s\n", BTRFS_BUILD_VERSION);
+	printf("%s\n", PACKAGE_STRING);
 
 	free_root_recs_tree(&root_cache);
 close_out:
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 253f105..85a3897 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -34,7 +34,6 @@
 #include "ioctl.h"
 #include "utils.h"
 #include "volumes.h"
-#include "version.h"
 #include "commands.h"
 #include "list_sort.h"
 #include "disk-io.h"
@@ -989,7 +988,7 @@ devs_only:
 		free_fs_devices(fs_devices);
 	}
 out:
-	printf("%s\n", BTRFS_BUILD_VERSION);
+	printf("%s\n", PACKAGE_STRING);
 	free_seen_fsid();
 	return ret;
 }
@@ -1245,7 +1244,7 @@ static int cmd_defrag(int argc, char **argv)
 		}
 	}
 	if (defrag_global_verbose)
-		printf("%s\n", BTRFS_BUILD_VERSION);
+		printf("%s\n", PACKAGE_STRING);
 	if (defrag_global_errors)
 		fprintf(stderr, "total %d failures\n", defrag_global_errors);
 
diff --git a/cmds-restore.c b/cmds-restore.c
index a5c99e8..27df3d8 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -40,7 +40,6 @@
 #include "print-tree.h"
 #include "transaction.h"
 #include "list.h"
-#include "version.h"
 #include "volumes.h"
 #include "utils.h"
 #include "commands.h"
diff --git a/library-test.c b/library-test.c
index 142188a..d23f4a7 100644
--- a/library-test.c
+++ b/library-test.c
@@ -17,7 +17,6 @@
  */
 
 #include "kerncompat.h"
-#include "version.h"
 #include "send-stream.h"
 
 /*
diff --git a/mkfs.c b/mkfs.c
index d5d03fc..dc87273 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -41,7 +41,6 @@
 #include "volumes.h"
 #include "transaction.h"
 #include "utils.h"
-#include "version.h"
 
 static u64 index_cnt = 2;
 
@@ -289,14 +288,14 @@ static void print_usage(void)
 	fprintf(stderr, "\t -O --features comma separated list of filesystem features\n");
 	fprintf(stderr, "\t -U --uuid specify the filesystem UUID\n");
 	fprintf(stderr, "\t -V --version print the mkfs.btrfs version and exit\n");
-	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
+	fprintf(stderr, "%s\n", PACKAGE_STRING);
 	exit(1);
 }
 
 static void print_version(void) __attribute__((noreturn));
 static void print_version(void)
 {
-	fprintf(stderr, "mkfs.btrfs, part of %s\n", BTRFS_BUILD_VERSION);
+	fprintf(stderr, "mkfs.btrfs, part of %s\n", PACKAGE_STRING);
 	exit(0);
 }
 
@@ -1488,8 +1487,8 @@ int main(int ac, char **av)
 	}
 
 	/* if we are here that means all devs are good to btrfsify */
-	printf("%s\n", BTRFS_BUILD_VERSION);
-	printf("See http://btrfs.wiki.kernel.org for more information.\n\n");
+	printf("%s\n", PACKAGE_STRING);
+	printf("See %s for more information.\n\n", PACKAGE_URL);
 
 	dev_cnt--;
 
-- 
1.9.3

