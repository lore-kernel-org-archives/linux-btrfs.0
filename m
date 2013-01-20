Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo201.cox.net ([68.230.241.216]:46311 "EHLO
	eastrmfepo201.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab3ATVEm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jan 2013 16:04:42 -0500
Received: from eastrmimpo209 ([68.230.241.224]) by eastrmfepo201.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130120210441.LAEG17456.eastrmfepo201.cox.net@eastrmimpo209>
          for <linux-btrfs@vger.kernel.org>;
          Sun, 20 Jan 2013 16:04:41 -0500
From: Gene Czarcinski <gene@czarc.net>
To: linux-btrfs@vger.kernel.org
Cc: Wang Shilong <wangsl-fnst@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
        Gene Czarcinski <gene@czarc.net>
Subject: [PATCH 10/13] Btrfs-progs: clean up reduplicate parse_qgroupid() and replace atoi with strtoull
Date: Sun, 20 Jan 2013 16:04:15 -0500
Message-Id: <1358715858-4469-11-git-send-email-gene@czarc.net>
In-Reply-To: <1358715858-4469-1-git-send-email-gene@czarc.net>
References: <1358715858-4469-1-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

1. parse_qgroupid() is implemented twice, clean up the reduplicate code.
2. atoi() can not detect errors, so use strtoull() instead of it.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Gene Czarcinski <gene@czarc.net>
---
 cmds-qgroup.c | 15 +--------------
 qgroup.c      | 22 ++++++++++++++++++----
 qgroup.h      |  2 ++
 3 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 129a4f0..c4122bf 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -24,26 +24,13 @@
 #include "ioctl.h"
 
 #include "commands.h"
+#include "qgroup.h"
 
 static const char * const qgroup_cmd_group_usage[] = {
 	"btrfs qgroup <command> [options] <path>",
 	NULL
 };
 
-static u64 parse_qgroupid(char *p)
-{
-	char *s = strchr(p, '/');
-	u64 level;
-	u64 id;
-
-	if (!s)
-		return atoll(p);
-	level = atoll(p);
-	id = atoll(s + 1);
-
-	return (level << 48) | id;
-}
-
 static int qgroup_assign(int assign, int argc, char **argv)
 {
 	int ret = 0;
diff --git a/qgroup.c b/qgroup.c
index 4083b57..dafde12 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -22,15 +22,29 @@
 u64 parse_qgroupid(char *p)
 {
 	char *s = strchr(p, '/');
+	char *ptr_src_end = p + strlen(p);
+	char *ptr_parse_end = NULL;
 	u64 level;
 	u64 id;
 
-	if (!s)
-		return atoll(p);
-	level = atoll(p);
-	id = atoll(s + 1);
+	if (!s) {
+		id = strtoull(p, &ptr_parse_end, 10);
+		if (ptr_parse_end != ptr_src_end)
+			goto err;
+		return id;
+	}
+	level = strtoull(p, &ptr_parse_end, 10);
+	if (ptr_parse_end != s)
+		goto err;
+
+	id = strtoull(s+1, &ptr_parse_end, 10);
+	if (ptr_parse_end != ptr_src_end)
+		goto  err;
 
 	return (level << 48) | id;
+err:
+	fprintf(stderr, "ERROR:invalid qgroupid\n");
+	exit(-1);
 }
 
 int qgroup_inherit_size(struct btrfs_qgroup_inherit *p)
diff --git a/qgroup.h b/qgroup.h
index f7af8c5..ad14c88 100644
--- a/qgroup.h
+++ b/qgroup.h
@@ -20,7 +20,9 @@
 #define _BTRFS_QGROUP_H
 
 #include "ioctl.h"
+#include "kerncompat.h"
 
+u64 parse_qgroupid(char *p);
 int qgroup_inherit_size(struct btrfs_qgroup_inherit *p);
 int qgroup_inherit_realloc(struct btrfs_qgroup_inherit **inherit,
 			   int incgroups, int inccopies);
-- 
1.8.1

