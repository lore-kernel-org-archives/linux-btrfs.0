Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:20355 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab3IRIaW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Sep 2013 04:30:22 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8I8UG7I030190
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Sep 2013 16:30:16 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/4] Btrfs-progs: move ask_user() to utils.c
Date: Wed, 18 Sep 2013 16:27:35 +0800
Message-Id: <1379492856-30639-4-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1379492856-30639-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1379492856-30639-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 chunk-recover.c | 18 ------------------
 utils.c         | 18 ++++++++++++++++++
 utils.h         |  1 +
 3 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index 9af4887..e44ca72 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1307,24 +1307,6 @@ fail_close_fd:
 	return ret;
 }
 
-/*
- * This reads a line from the stdin and only returns non-zero if the
- * first whitespace delimited token is a case insensitive match with yes
- * or y.
- */
-static int ask_user(char *question)
-{
-	char buf[30] = {0,};
-	char *saveptr = NULL;
-	char *answer;
-
-	printf("%s [y/N]: ", question);
-
-	return fgets(buf, sizeof(buf) - 1, stdin) &&
-	       (answer = strtok_r(buf, " \t\n\r", &saveptr)) &&
-	       (!strcasecmp(answer, "yes") || !strcasecmp(answer, "y"));
-}
-
 static int btrfs_get_device_extents(u64 chunk_object,
 				    struct list_head *orphan_devexts,
 				    struct list_head *ret_list)
diff --git a/utils.c b/utils.c
index e3738d3..2bfd59a 100644
--- a/utils.c
+++ b/utils.c
@@ -1955,3 +1955,21 @@ int is_vol_small(char *file)
 		return 0;
 	}
 }
+
+/*
+ * This reads a line from the stdin and only returns non-zero if the
+ * first whitespace delimited token is a case insensitive match with yes
+ * or y.
+ */
+int ask_user(char *question)
+{
+	char buf[30] = {0,};
+	char *saveptr = NULL;
+	char *answer;
+
+	printf("%s [y/N]: ", question);
+
+	return fgets(buf, sizeof(buf) - 1, stdin) &&
+	       (answer = strtok_r(buf, " \t\n\r", &saveptr)) &&
+	       (!strcasecmp(answer, "yes") || !strcasecmp(answer, "y"));
+}
diff --git a/utils.h b/utils.h
index 6c2553a..2cb9d9b 100644
--- a/utils.h
+++ b/utils.h
@@ -80,4 +80,5 @@ int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 int is_vol_small(char *file);
 int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 			   int verify);
+int ask_user(char *question);
 #endif
-- 
1.8.3.1

