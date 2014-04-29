Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57197 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757634AbaD2P5D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Apr 2014 11:57:03 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id C7E7FAC4F
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 15:57:02 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 01/14] btrfs-progs: read global reserve size from space infos
Date: Tue, 29 Apr 2014 17:57:01 +0200
Message-Id: <b0d096eacc220f6d523706c1685099a37070925d.1398786620.git.dsterba@suse.cz>
In-Reply-To: <cover.1398786620.git.dsterba@suse.cz>
References: <cover.1398786620.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kernels >= 3.15 export the global block reserve as a space info presented
by 'btrfs fi df' but would display 'unknown' instead of some meaningful
string.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 ctree.h | 6 ++++++
 utils.c | 7 ++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/ctree.h b/ctree.h
index 8ac17619b9dc..5c43fc5f5f6e 100644
--- a/ctree.h
+++ b/ctree.h
@@ -862,6 +862,12 @@ struct btrfs_csum_item {
 /* used in struct btrfs_balance_args fields */
 #define BTRFS_AVAIL_ALLOC_BIT_SINGLE	(1ULL << 48)
 
+/*
+ * GLOBAL_RSV does not exist as a on-disk block group type and is used
+ * internally for exporting info about global block reserve from space infos
+ */
+#define BTRFS_SPACE_INFO_GLOBAL_RSV    (1ULL << 49)
+
 #define BTRFS_QGROUP_STATUS_OFF			0
 #define BTRFS_QGROUP_STATUS_ON			1
 #define BTRFS_QGROUP_STATUS_SCANNING		2
diff --git a/utils.c b/utils.c
index f2ab416c28b2..ca150404ea6f 100644
--- a/utils.c
+++ b/utils.c
@@ -2240,7 +2240,10 @@ u64 get_partition_size(char *dev)
  */
 const char *group_type_str(u64 flag)
 {
-	switch (flag & BTRFS_BLOCK_GROUP_TYPE_MASK) {
+	u64 mask = BTRFS_BLOCK_GROUP_TYPE_MASK |
+		BTRFS_SPACE_INFO_GLOBAL_RSV;
+
+	switch (flag & mask) {
 	case BTRFS_BLOCK_GROUP_DATA:
 		return "Data";
 	case BTRFS_BLOCK_GROUP_SYSTEM:
@@ -2249,6 +2252,8 @@ const char *group_type_str(u64 flag)
 		return "Metadata";
 	case BTRFS_BLOCK_GROUP_DATA|BTRFS_BLOCK_GROUP_METADATA:
 		return "Data+Metadata";
+	case BTRFS_SPACE_INFO_GLOBAL_RSV:
+		return "GlobalReserve";
 	default:
 		return "unknown";
 	}
-- 
1.9.0

