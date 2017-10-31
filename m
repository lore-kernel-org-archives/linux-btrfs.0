Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:21880 "EHLO
        mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752996AbdJaFki (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 01:40:38 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id D5E46AC00A4
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 14:40:32 +0900 (JST)
Received: from G01JPEXCHYT18.g01.fujitsu.local (G01JPEXCHYT18.g01.fujitsu.local [10.128.194.57])
        by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id 2A2CC46E55C
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 14:40:32 +0900 (JST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: ins: print c/o/s/r time of ROOT_ITEM
Message-ID: <8bccc1fc-c8bb-9999-dbb7-94185ba5d7e8@jp.fujitsu.com>
Date: Tue, 31 Oct 2017 14:40:24 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently c/o/s/r time of ROOT_ITEM is not printed in print_root_item().
Fix this and print them if the values are not zero. print_timespec()
is moved forward to reuse.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 ctree.h      | 32 ++++++++++++++++++++++++++++++++
 print-tree.c | 52 ++++++++++++++++++++++++++++++++--------------------
 2 files changed, 64 insertions(+), 20 deletions(-)

diff --git a/ctree.h b/ctree.h
index 2280659..54a85fd 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2072,6 +2072,38 @@ BTRFS_SETGET_STACK_FUNCS(root_stransid, struct btrfs_root_item,
 BTRFS_SETGET_STACK_FUNCS(root_rtransid, struct btrfs_root_item,
 			 rtransid, 64);
 
+static inline struct btrfs_timespec *
+btrfs_root_ctime(struct btrfs_root_item *root_item)
+{
+	unsigned long ptr = (unsigned long)root_item;
+	ptr += offsetof(struct btrfs_root_item, ctime);
+	return (struct btrfs_timespec *)ptr;
+}
+
+static inline struct btrfs_timespec *
+btrfs_root_otime(struct btrfs_root_item *root_item)
+{
+	unsigned long ptr = (unsigned long)root_item;
+	ptr += offsetof(struct btrfs_root_item, otime);
+	return (struct btrfs_timespec *)ptr;
+}
+
+static inline struct btrfs_timespec *
+btrfs_root_stime(struct btrfs_root_item *root_item)
+{
+	unsigned long ptr = (unsigned long)root_item;
+	ptr += offsetof(struct btrfs_root_item, stime);
+	return (struct btrfs_timespec *)ptr;
+}
+
+static inline struct btrfs_timespec *
+btrfs_root_rtime(struct btrfs_root_item *root_item)
+{
+	unsigned long ptr = (unsigned long)root_item;
+	ptr += offsetof(struct btrfs_root_item, rtime);
+	return (struct btrfs_timespec *)ptr;
+}
+
 /* struct btrfs_root_backup */
 BTRFS_SETGET_STACK_FUNCS(backup_tree_root, struct btrfs_root_backup,
 		   tree_root, 64);
diff --git a/print-tree.c b/print-tree.c
index 9d1b862..62f3163 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -551,6 +551,26 @@ static void root_flags_to_str(u64 flags, char *ret)
 		strcat(ret, "none");
 }
 
+static void print_timespec(struct extent_buffer *eb,
+		struct btrfs_timespec *timespec, const char *prefix,
+		const char *suffix)
+{
+	struct tm tm;
+	u64 tmp_u64;
+	u32 tmp_u32;
+	time_t tmp_time;
+	char timestamp[256];
+
+	tmp_u64 = btrfs_timespec_sec(eb, timespec);
+	tmp_u32 = btrfs_timespec_nsec(eb, timespec);
+	tmp_time = tmp_u64;
+	localtime_r(&tmp_time, &tm);
+	strftime(timestamp, sizeof(timestamp),
+			"%Y-%m-%d %H:%M:%S", &tm);
+	printf("%s%llu.%u (%s)%s", prefix, (unsigned long long)tmp_u64, tmp_u32,
+			timestamp, suffix);
+}
+
 static void print_root_item(struct extent_buffer *leaf, int slot)
 {
 	struct btrfs_root_item *ri;
@@ -600,6 +620,18 @@ static void print_root_item(struct extent_buffer *leaf, int slot)
 				btrfs_root_stransid(&root_item),
 				btrfs_root_rtransid(&root_item));
 		}
+		if (btrfs_timespec_sec(leaf, btrfs_root_ctime(ri)))
+			print_timespec(leaf, btrfs_root_ctime(ri),
+					"\t\tctime ", "\n");
+		if (btrfs_timespec_sec(leaf, btrfs_root_otime(ri)))
+			print_timespec(leaf, btrfs_root_otime(ri),
+					"\t\totime ", "\n");
+		if (btrfs_timespec_sec(leaf, btrfs_root_stime(ri)))
+			print_timespec(leaf, btrfs_root_stime(ri),
+					"\t\tstime ", "\n");
+		if (btrfs_timespec_sec(leaf, btrfs_root_rtime(ri)))
+			print_timespec(leaf, btrfs_root_rtime(ri),
+					"\t\trtime ", "\n");
 	}
 
 	btrfs_disk_key_to_cpu(&drop_key, &root_item.drop_progress);
@@ -858,26 +890,6 @@ static void inode_flags_to_str(u64 flags, char *ret)
 		strcat(ret, "none");
 }
 
-static void print_timespec(struct extent_buffer *eb,
-		struct btrfs_timespec *timespec, const char *prefix,
-		const char *suffix)
-{
-	struct tm tm;
-	u64 tmp_u64;
-	u32 tmp_u32;
-	time_t tmp_time;
-	char timestamp[256];
-
-	tmp_u64 = btrfs_timespec_sec(eb, timespec);
-	tmp_u32 = btrfs_timespec_nsec(eb, timespec);
-	tmp_time = tmp_u64;
-	localtime_r(&tmp_time, &tm);
-	strftime(timestamp, sizeof(timestamp),
-			"%Y-%m-%d %H:%M:%S", &tm);
-	printf("%s%llu.%u (%s)%s", prefix, (unsigned long long)tmp_u64, tmp_u32,
-			timestamp, suffix);
-}
-
 static void print_inode_item(struct extent_buffer *eb,
 		struct btrfs_inode_item *ii)
 {
-- 
2.9.5

