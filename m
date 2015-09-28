Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:34229 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbbI1Wcu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Sep 2015 18:32:50 -0400
Received: by wicfx3 with SMTP id fx3so125150464wic.1
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2015 15:32:48 -0700 (PDT)
From: =?UTF-8?q?Gabr=C3=ADel=20Arth=C3=BAr=20P=C3=A9tursson?=
	<gabriel@system.is>
To: linux-btrfs@vger.kernel.org
Cc: =?UTF-8?q?Gabr=C3=ADel=20Arth=C3=BAr=20P=C3=A9tursson?=
	<gabriel@system.is>
Subject: [PATCH] btrfs: add stripes filter
Date: Mon, 28 Sep 2015 22:32:41 +0000
Message-Id: <1443479561-785-1-git-send-email-gabriel@system.is>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <1443463025.16163.6.camel@system.is>

---
 fs/btrfs/ctree.h           |  6 +++++-
 fs/btrfs/volumes.c         | 18 ++++++++++++++++++
 fs/btrfs/volumes.h         |  1 +
 include/uapi/linux/btrfs.h |  6 +++++-
 4 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 938efe3..78573e5 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -849,7 +849,11 @@ struct btrfs_disk_balance_args {
 	/* BTRFS_BALANCE_ARGS_LIMIT value */
 	__le64 limit;
 
-	__le64 unused[7];
+	/* btrfs stripes filter */
+	__le64 sstart;
+	__le64 send;
+
+	__le64 unused[5];
 } __attribute__ ((__packed__));
 
 /*
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6fc73586..dc65fbb 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3170,6 +3170,18 @@ static int chunk_vrange_filter(struct extent_buffer *leaf,
 	return 1;
 }
 
+static int chunk_stripes_filter(struct extent_buffer *leaf,
+			       struct btrfs_chunk *chunk,
+			       struct btrfs_balance_args *bargs)
+{
+	int num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
+
+	if (bargs->sstart <= num_stripes && num_stripes <= bargs->send)
+		return 0;
+
+	return 1;
+}
+
 static int chunk_soft_convert_filter(u64 chunk_type,
 				     struct btrfs_balance_args *bargs)
 {
@@ -3236,6 +3248,12 @@ static int should_balance_chunk(struct btrfs_root *root,
 		return 0;
 	}
 
+	/* stripes filter */
+	if ((bargs->flags & BTRFS_BALANCE_ARGS_STRIPES) &&
+	    chunk_stripes_filter(leaf, chunk, bargs)) {
+		return 0;
+	}
+
 	/* soft profile changing mode */
 	if ((bargs->flags & BTRFS_BALANCE_ARGS_SOFT) &&
 	    chunk_soft_convert_filter(chunk_type, bargs)) {
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 2ca784a..fb6b89a 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -375,6 +375,7 @@ struct map_lookup {
 #define BTRFS_BALANCE_ARGS_DRANGE	(1ULL << 3)
 #define BTRFS_BALANCE_ARGS_VRANGE	(1ULL << 4)
 #define BTRFS_BALANCE_ARGS_LIMIT	(1ULL << 5)
+#define BTRFS_BALANCE_ARGS_STRIPES	(1ULL << 6)
 
 /*
  * Profile changing flags.  When SOFT is set we won't relocate chunk if
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index b6dec05..a7819d0 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -218,7 +218,11 @@ struct btrfs_balance_args {
 	__u64 flags;
 
 	__u64 limit;		/* limit number of processed chunks */
-	__u64 unused[7];
+
+	__u64 sstart;
+	__u64 send;
+
+	__u64 unused[5];
 } __attribute__ ((__packed__));
 
 /* report balance progress to userspace */
-- 
2.5.3

