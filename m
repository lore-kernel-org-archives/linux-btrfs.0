Return-Path: <SRS0=AHcI=SS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA554C10F14
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 07:15:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4D8D2073F
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 07:15:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbfDPHPi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Apr 2019 03:15:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:46240 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725865AbfDPHPi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Apr 2019 03:15:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 891B0ADD4
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2019 07:15:36 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs-progs: Handle error properly in btrfs_commit_transaction()
Date:   Tue, 16 Apr 2019 15:15:26 +0800
Message-Id: <20190416071526.3576-4-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190416071526.3576-1-wqu@suse.com>
References: <20190416071526.3576-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[BUG]
When running fuzz-tests/003 and fuzz-tests/009, btrfs-progs will crash
due to BUG_ON().

[CAUSE]
We abused BUG_ON() in btrfs_commit_transaction(), which is one of the
most error prone function for fuzzed images.

Currently to cleanup the aborted transaction, we only need to clean up
the only per-transaction data: delayed refs.

This patch will introduce a new function, btrfs_destroy_delayed_refs()
to cleanup delayed refs when we failed to commit transaction.

With that function, we will gently destroy per-trans delayed ref, and
remove the BUG_ON()s in btrfs_commit_transaction().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 delayed-ref.c | 24 ++++++++++++++++++++++++
 delayed-ref.h |  5 +++++
 extent-tree.c |  6 +++---
 transaction.c | 20 ++++++++++++++------
 4 files changed, 46 insertions(+), 9 deletions(-)

diff --git a/delayed-ref.c b/delayed-ref.c
index 9974dbbd4c6b..69f8be34fe18 100644
--- a/delayed-ref.c
+++ b/delayed-ref.c
@@ -605,3 +605,27 @@ free_ref:
 
 	return -ENOMEM;
 }
+
+void btrfs_destroy_delayed_refs(struct btrfs_trans_handle *trans)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct rb_node *node;
+	struct btrfs_delayed_ref_root *delayed_refs;
+
+	delayed_refs = &trans->delayed_refs;
+	if (RB_EMPTY_ROOT(&delayed_refs->href_root))
+		return;
+	while ((node = rb_first(&delayed_refs->href_root)) != NULL) {
+		struct btrfs_delayed_ref_head *head;
+		struct btrfs_delayed_ref_node *ref;
+		struct rb_node *n;
+
+		head = rb_entry(node, struct btrfs_delayed_ref_head, href_node);
+		while ((n = rb_first(&head->ref_tree)) != NULL) {
+			ref = rb_entry(n, struct btrfs_delayed_ref_node,
+				       ref_node);
+			drop_delayed_ref(trans, delayed_refs, head, ref);
+		}
+		ASSERT(cleanup_ref_head(trans, fs_info, head) == 0);
+	}
+}
diff --git a/delayed-ref.h b/delayed-ref.h
index 30a68b2a278c..4ff3eaa929ba 100644
--- a/delayed-ref.h
+++ b/delayed-ref.h
@@ -205,4 +205,9 @@ btrfs_delayed_node_to_tree_ref(struct btrfs_delayed_ref_node *node)
 {
 	return container_of(node, struct btrfs_delayed_tree_ref, node);
 }
+
+int cleanup_ref_head(struct btrfs_trans_handle *trans,
+		     struct btrfs_fs_info *fs_info,
+		     struct btrfs_delayed_ref_head *head);
+void btrfs_destroy_delayed_refs(struct btrfs_trans_handle *trans);
 #endif
diff --git a/extent-tree.c b/extent-tree.c
index 1140ebfc61ff..e62ee8c2ba13 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -4085,9 +4085,9 @@ static void unselect_delayed_ref_head(struct btrfs_delayed_ref_root *delayed_ref
 	delayed_refs->num_heads_ready++;
 }
 
-static int cleanup_ref_head(struct btrfs_trans_handle *trans,
-			    struct btrfs_fs_info *fs_info,
-			    struct btrfs_delayed_ref_head *head)
+int cleanup_ref_head(struct btrfs_trans_handle *trans,
+		     struct btrfs_fs_info *fs_info,
+		     struct btrfs_delayed_ref_head *head)
 {
 	struct btrfs_delayed_ref_root *delayed_refs;
 
diff --git a/transaction.c b/transaction.c
index 8d15eb11c7b5..138e10f0d6cc 100644
--- a/transaction.c
+++ b/transaction.c
@@ -17,6 +17,7 @@
 #include "kerncompat.h"
 #include "disk-io.h"
 #include "transaction.h"
+#include "delayed-ref.h"
 
 #include "messages.h"
 
@@ -165,7 +166,8 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	 * consistent
 	 */
 	ret = btrfs_run_delayed_refs(trans, -1);
-	BUG_ON(ret);
+	if (ret < 0)
+		goto error;
 
 	if (root->commit_root == root->node)
 		goto commit_tree;
@@ -182,21 +184,24 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	root->root_item.level = btrfs_header_level(root->node);
 	ret = btrfs_update_root(trans, root->fs_info->tree_root,
 				&root->root_key, &root->root_item);
-	BUG_ON(ret);
+	if (ret < 0)
+		goto error;
 
 commit_tree:
 	ret = commit_tree_roots(trans, fs_info);
-	BUG_ON(ret);
+	if (ret < 0)
+		goto error;
 	/*
 	 * Ensure that all committed roots are properly accounted in the
 	 * extent tree
 	 */
 	ret = btrfs_run_delayed_refs(trans, -1);
-	BUG_ON(ret);
+	if (ret < 0)
+		goto error;
 	btrfs_write_dirty_block_groups(trans);
 	__commit_transaction(trans, root);
 	if (ret < 0)
-		goto out;
+		goto error;
 	ret = write_ctree_super(trans);
 	btrfs_finish_extent_commit(trans);
 	kfree(trans);
@@ -204,7 +209,10 @@ commit_tree:
 	root->commit_root = NULL;
 	fs_info->running_transaction = NULL;
 	fs_info->last_trans_committed = transid;
-out:
+	return ret;
+error:
+	btrfs_destroy_delayed_refs(trans);
+	free(trans);
 	return ret;
 }
 
-- 
2.21.0

