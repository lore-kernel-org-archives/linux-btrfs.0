Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:3275 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1753219AbcIUDQd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 23:16:33 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [PATCH v2 01/14] btrfs-progs: move btrfs_extref_hash() to hash.h
Date: Wed, 21 Sep 2016 11:15:51 +0800
Message-Id: <20160921031604.23334-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160921031604.23334-1-quwenruo@cn.fujitsu.com>
References: <20160921031604.23334-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

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
index 913b81a..f7b6ead 100644
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
2.10.0



