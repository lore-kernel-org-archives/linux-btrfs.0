Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:48620 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755143Ab2KHJwZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Nov 2012 04:52:25 -0500
Message-ID: <509B80E9.7070703@cn.fujitsu.com>
Date: Thu, 08 Nov 2012 17:52:41 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Arne Jansen <sensille@gmx.net>, wangshilong <wangsl-fnst@cn.fujitsu.com>
Subject: [PATCH 2/3] Btrfs-progs: clean up reduplicate parse_qgroupid() and
 replace atoi with strtoull
References: <509B7B13.2030505@cn.fujitsu.com>
In-Reply-To: <509B7B13.2030505@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

1. parse_qgroupid() is implemented twice, clean up the reduplicate code.
2. atoi() can not detect errors, so use strtoull() instead of it.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 cmds-qgroup.c |   15 +--------------
 qgroup.c      |   22 ++++++++++++++++++----
 qgroup.h      |    2 ++
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
-- 1.7.7.6











