Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42349 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1163108AbcG1HI4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 03:08:56 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
	by cn.fujitsu.com (Postfix) with ESMTP id 8A3BD42984F5
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Jul 2016 15:08:44 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH 01/13] btrfs-progs: move btrfs_extref_hash() to hash.h
Date: Thu, 28 Jul 2016 15:08:13 +0800
Message-ID: <1469689705-26836-2-git-send-email-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <1469689705-26836-1-git-send-email-lufq.fnst@cn.fujitsu.com>
References: <1469689705-26836-1-git-send-email-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Move btrfs_extref_hash() from inode-item.c to hash.h,
so that the function can be called elsewhere.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 hash.h       | 10 ++++++++++
 inode-item.c |  8 +-------
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/hash.h b/hash.h
index ac4c411..9ff6761 100644
--- a/hash.h
+++ b/hash.h
@@ -25,4 +25,14 @@ static inline u64 btrfs_name_hash(const char *name, int len)
 {
 	return crc32c((u32)~1, name, len);
 }
+
+/*
+ * Figure the key offset of an extended inode ref
+ */
+static inline u64 btrfs_extref_hash(u64 parent_objectid, const char *name,
+				    int len)
+{
+	return (u64)btrfs_crc32c(parent_objectid, name, len);
+}
+
 #endif
diff --git a/inode-item.c b/inode-item.c
index 522d25a..df5011e 100644
--- a/inode-item.c
+++ b/inode-item.c
@@ -19,7 +19,7 @@
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
-#include "crc32c.h"
+#include "hash.h"
 
 static int find_name_in_backref(struct btrfs_path *path, const char * name,
 			 int name_len, struct btrfs_inode_ref **ref_ret)
@@ -184,12 +184,6 @@ out:
 		return ret_inode_ref;
 }
 
-static inline u64 btrfs_extref_hash(u64 parent_ino, const char *name,
-				    int namelen)
-{
-	return (u64)btrfs_crc32c(parent_ino, name, namelen);
-}
-
 static int btrfs_find_name_in_ext_backref(struct btrfs_path *path,
 		u64 parent_ino, const char *name, int namelen,
 		struct btrfs_inode_extref **extref_ret)
-- 
2.7.4



