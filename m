Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63802 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755081AbaFYKJj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jun 2014 06:09:39 -0400
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <sandeen@redhat.com>, Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: replace BTRFS_NUM_MIRRORS with BTRFS_MAX_MIRRORS
Date: Wed, 25 Jun 2014 18:04:17 +0800
Message-ID: <1403690657-13521-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The chunk-recover.c/BTRFS_NUM_MIRRORS in the userspace means
the same thing as ctree.h/BTRFS_MAX_MIRRORS in the kernelspace,
so to stay consistent with the kernelspace, just make this movement
in the userspace:
	chunk-recover.c/BTRFS_NUM_MIRRORS
		===>
	ctree.h/BTRFS_MAX_MIRRORS

This provides convenience for future use.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 chunk-recover.c | 8 +++-----
 ctree.h         | 2 ++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index 8bc5bc3..b638ada 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -42,8 +42,6 @@
 #include "btrfsck.h"
 #include "commands.h"
 
-#define BTRFS_NUM_MIRRORS			3
-
 struct recover_control {
 	int verbose;
 	int yes;
@@ -71,8 +69,8 @@ struct extent_record {
 	struct cache_extent cache;
 	u64 generation;
 	u8 csum[BTRFS_CSUM_SIZE];
-	struct btrfs_device *devices[BTRFS_NUM_MIRRORS];
-	u64 offsets[BTRFS_NUM_MIRRORS];
+	struct btrfs_device *devices[BTRFS_MAX_MIRRORS];
+	u64 offsets[BTRFS_MAX_MIRRORS];
 	int nmirrors;
 };
 
@@ -128,7 +126,7 @@ again:
 			    memcmp(exist->csum, rec->csum, BTRFS_CSUM_SIZE)) {
 				ret = -EEXIST;
 			} else {
-				BUG_ON(exist->nmirrors >= BTRFS_NUM_MIRRORS);
+				BUG_ON(exist->nmirrors >= BTRFS_MAX_MIRRORS);
 				exist->devices[exist->nmirrors] = device;
 				exist->offsets[exist->nmirrors] = offset;
 				exist->nmirrors++;
diff --git a/ctree.h b/ctree.h
index 0690063..35d3633 100644
--- a/ctree.h
+++ b/ctree.h
@@ -40,6 +40,8 @@ struct btrfs_trans_handle;
 struct btrfs_free_space_ctl;
 #define BTRFS_MAGIC 0x4D5F53665248425FULL /* ascii _BHRfS_M, no null */
 
+#define BTRFS_MAX_MIRRORS 3
+
 #define BTRFS_MAX_LEVEL 8
 
 #define BTRFS_COMPAT_EXTENT_TREE_V0
-- 
1.8.1.4

