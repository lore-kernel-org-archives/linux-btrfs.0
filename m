Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27875ECDE43
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 11:17:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC6052087A
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 11:17:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC6052087A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbeJRTSL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 15:18:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:42886 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727461AbeJRTSL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 15:18:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 15266AD18
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Oct 2018 11:17:37 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/6] btrfs: qgroup: Allow btrfs_qgroup_extent_record::old_roots unpopulated at insert time
Date:   Thu, 18 Oct 2018 19:17:24 +0800
Message-Id: <20181018111729.11128-2-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181018111729.11128-1-wqu@suse.com>
References: <20181018111729.11128-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Commit fb235dc06fac ("btrfs: qgroup: Move half of the qgroup accounting
time out of commit trans") makes btrfs_qgroup_extent_record::old_roots
populated at insert time.

It's OK for most cases as btrfs_qgroup_extent_record is inserted at
delayed ref head insert time, which has a less restrict lock context.

But later delayed subtree scan optimization will need to insert
btrfs_qgroup_extent_record with path write lock hold, where triggering a
backref walk can easily lead to dead lock.

So this patch introduces two new internal functions,
qgroup_trace_extent() and qgroup_trace_leaf_items(), with new @exec_post
parameter to info whether we need to initialize the backref walk right
now.

Also modifies btrfs_qgroup_account_extents() not to trigger kernel
warning.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 51 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 41 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 678e07c11bc6..aaa3657266b0 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1580,8 +1580,16 @@ int btrfs_qgroup_trace_extent_post(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
-int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans, u64 bytenr,
-			      u64 num_bytes, gfp_t gfp_flag)
+/*
+ * Insert qgroup extent record for extent at @bytenr, @num_bytes.
+ *
+ * @bytenr:	bytenr of the extent
+ * @num_bytes:	length of the extent
+ * @exec_post:	whether to exec the post insert work
+ * 		will init backref walk if set to true.
+ */
+static int qgroup_trace_extent(struct btrfs_trans_handle *trans, u64 bytenr,
+			       u64 num_bytes, gfp_t gfp_flag, bool exec_post)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_qgroup_extent_record *record;
@@ -1607,11 +1615,27 @@ int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans, u64 bytenr,
 		kfree(record);
 		return 0;
 	}
-	return btrfs_qgroup_trace_extent_post(fs_info, record);
+	if (exec_post)
+		return btrfs_qgroup_trace_extent_post(fs_info, record);
+	return 0;
 }
 
-int btrfs_qgroup_trace_leaf_items(struct btrfs_trans_handle *trans,
-				  struct extent_buffer *eb)
+int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans, u64 bytenr,
+			      u64 num_bytes, gfp_t gfp_flag)
+{
+	return qgroup_trace_extent(trans, bytenr, num_bytes, gfp_flag, true);
+}
+
+/*
+ * Insert qgroup extent record for leaf and all file extents in it
+ *
+ * @bytenr:	bytenr of the leaf
+ * @num_bytes:	length of the leaf
+ * @exec_post:	whether to exec the post insert work
+ * 		will init backref walk if set to true.
+ */
+static int qgroup_trace_leaf_items(struct btrfs_trans_handle *trans,
+				   struct extent_buffer *eb, bool exec_post)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	int nr = btrfs_header_nritems(eb);
@@ -1643,8 +1667,8 @@ int btrfs_qgroup_trace_leaf_items(struct btrfs_trans_handle *trans,
 
 		num_bytes = btrfs_file_extent_disk_num_bytes(eb, fi);
 
-		ret = btrfs_qgroup_trace_extent(trans, bytenr, num_bytes,
-						GFP_NOFS);
+		ret = qgroup_trace_extent(trans, bytenr, num_bytes, GFP_NOFS,
+					  exec_post);
 		if (ret)
 			return ret;
 	}
@@ -1652,6 +1676,12 @@ int btrfs_qgroup_trace_leaf_items(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+int btrfs_qgroup_trace_leaf_items(struct btrfs_trans_handle *trans,
+				  struct extent_buffer *eb)
+{
+	return qgroup_trace_leaf_items(trans, eb, true);
+}
+
 /*
  * Walk up the tree from the bottom, freeing leaves and any interior
  * nodes which have had all slots visited. If a node (leaf or
@@ -2521,10 +2551,11 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans)
 
 		if (!ret) {
 			/*
-			 * Old roots should be searched when inserting qgroup
-			 * extent record
+			 * Most record->old_roots should have been populated at
+			 * insert time. Although we still allow some records
+			 * without old_roots populated.
 			 */
-			if (WARN_ON(!record->old_roots)) {
+			if (!record->old_roots) {
 				/* Search commit root to find old_roots */
 				ret = btrfs_find_all_roots(NULL, fs_info,
 						record->bytenr, 0,
-- 
2.19.1

