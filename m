Return-Path: <SRS0=0sRS=P7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0C38C282C5
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 07:15:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 982C021019
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 07:15:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfAWHPj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 02:15:39 -0500
Received: from mx2.suse.de ([195.135.220.15]:47404 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726611AbfAWHPi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 02:15:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 449C5B088
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Jan 2019 07:15:36 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     dsterba@suse.cz
Subject: [Patch v5 4/7] btrfs: qgroup: Refactor btrfs_qgroup_trace_subtree_swap()
Date:   Wed, 23 Jan 2019 15:15:15 +0800
Message-Id: <20190123071518.2528-5-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190123071518.2528-1-wqu@suse.com>
References: <20190123071518.2528-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Refactor btrfs_qgroup_trace_subtree_swap() into
qgroup_trace_subtree_swap(), which only needs two extent buffer and some
other bool to control the behavior.

This provides the basis for later delayed subtree scan work.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 78 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 57 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index f214b490d80c..565bb661210f 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2023,6 +2023,60 @@ static int qgroup_trace_new_subtree_blocks(struct btrfs_trans_handle* trans,
 	return ret;
 }
 
+static int qgroup_trace_subtree_swap(struct btrfs_trans_handle *trans,
+				struct extent_buffer *src_eb,
+				struct extent_buffer *dst_eb,
+				u64 last_snapshot, bool trace_leaf)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_path *dst_path = NULL;
+	int level;
+	int ret;
+
+	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
+		return 0;
+
+	/* Wrong parameter order */
+	if (btrfs_header_generation(src_eb) > btrfs_header_generation(dst_eb)) {
+		btrfs_err_rl(fs_info,
+		"%s: bad parameter order, src_gen=%llu dst_gen=%llu", __func__,
+			     btrfs_header_generation(src_eb),
+			     btrfs_header_generation(dst_eb));
+		return -EUCLEAN;
+	}
+
+	if (!extent_buffer_uptodate(src_eb) ||
+	    !extent_buffer_uptodate(dst_eb)) {
+		ret = -EIO;
+		goto out;
+	}
+
+	level = btrfs_header_level(dst_eb);
+	dst_path = btrfs_alloc_path();
+	if (!dst_path) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	/* For dst_path */
+	extent_buffer_get(dst_eb);
+	dst_path->nodes[level] = dst_eb;
+	dst_path->slots[level] = 0;
+	dst_path->locks[level] = 0;
+
+	/* Do the generation aware breadth-first search */
+	ret = qgroup_trace_new_subtree_blocks(trans, src_eb, dst_path, level,
+					      level, last_snapshot, trace_leaf);
+	if (ret < 0)
+		goto out;
+	ret = 0;
+
+out:
+	btrfs_free_path(dst_path);
+	if (ret < 0)
+		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
+	return ret;
+}
+
 /*
  * Inform qgroup to trace subtree swap used in balance.
  *
@@ -2048,14 +2102,12 @@ int btrfs_qgroup_trace_subtree_swap(struct btrfs_trans_handle *trans,
 				u64 last_snapshot)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
-	struct btrfs_path *dst_path = NULL;
 	struct btrfs_key first_key;
 	struct extent_buffer *src_eb = NULL;
 	struct extent_buffer *dst_eb = NULL;
 	bool trace_leaf = false;
 	u64 child_gen;
 	u64 child_bytenr;
-	int level;
 	int ret;
 
 	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
@@ -2106,22 +2158,9 @@ int btrfs_qgroup_trace_subtree_swap(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	level = btrfs_header_level(dst_eb);
-	dst_path = btrfs_alloc_path();
-	if (!dst_path) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	/* For dst_path */
-	extent_buffer_get(dst_eb);
-	dst_path->nodes[level] = dst_eb;
-	dst_path->slots[level] = 0;
-	dst_path->locks[level] = 0;
-
-	/* Do the generation-aware breadth-first search */
-	ret = qgroup_trace_new_subtree_blocks(trans, src_eb, dst_path, level,
-					      level, last_snapshot, trace_leaf);
+	/* Do the generation aware breadth-first search */
+	ret = qgroup_trace_subtree_swap(trans, src_eb, dst_eb, last_snapshot,
+					trace_leaf);
 	if (ret < 0)
 		goto out;
 	ret = 0;
@@ -2129,9 +2168,6 @@ int btrfs_qgroup_trace_subtree_swap(struct btrfs_trans_handle *trans,
 out:
 	free_extent_buffer(src_eb);
 	free_extent_buffer(dst_eb);
-	btrfs_free_path(dst_path);
-	if (ret < 0)
-		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
 	return ret;
 }
 
-- 
2.20.1

