Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF8F4C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 10:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B72F120878
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 10:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbfBVKRK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 05:17:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:44730 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726184AbfBVKRK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 05:17:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 99969B15A;
        Fri, 22 Feb 2019 10:17:08 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     dan.carpenter@oracle.com
Subject: [PATCH 5/5] btrfs: extent_io: Unify the return value of btrfs_clone_extent_buffer() with alloc_extent_buffer()
Date:   Fri, 22 Feb 2019 18:16:44 +0800
Message-Id: <20190222101645.4403-6-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190222101645.4403-1-wqu@suse.com>
References: <20190222101645.4403-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The direct callers are:
1) qgroup_rescan_leaf()
2) btrfs_compare_trees()
   These two call sites are stubs.

3) tree_mod_log_rewind()
4) get_old_root()
   These two doesn't follow the name pattern *_extent_buffer(), thus we
   don't need to unify their return value.
   However for get_old_root(), all its eb assignment can no longer be
   NULL, change its IS_ERR_OR_NULL() to IS_ERR().

5) btrfs_search_slot_get_root()
   This is a stub. The only caller has already handled the return value.

This patch should cover all the call sites of
btrfs_clone_extent_buffer().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/backref.c   |  8 ++++----
 fs/btrfs/ctree.c     | 14 ++++++++------
 fs/btrfs/extent_io.c |  4 ++--
 fs/btrfs/qgroup.c    |  5 +++--
 4 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 78556447e1d5..b6e469a12011 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -2016,8 +2016,8 @@ static int iterate_inode_refs(u64 inum, struct btrfs_root *fs_root,
 		parent = found_key.offset;
 		slot = path->slots[0];
 		eb = btrfs_clone_extent_buffer(path->nodes[0]);
-		if (!eb) {
-			ret = -ENOMEM;
+		if (IS_ERR(eb)) {
+			ret = PTR_ERR(eb);
 			break;
 		}
 		btrfs_release_path(path);
@@ -2075,8 +2075,8 @@ static int iterate_inode_extrefs(u64 inum, struct btrfs_root *fs_root,
 
 		slot = path->slots[0];
 		eb = btrfs_clone_extent_buffer(path->nodes[0]);
-		if (!eb) {
-			ret = -ENOMEM;
+		if (IS_ERR(eb)) {
+			ret = PTR_ERR(eb);
 			break;
 		}
 		btrfs_release_path(path);
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 3276b743f40a..ea7ff0012007 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1384,7 +1384,7 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 		free_extent_buffer(eb_root);
 	}
 
-	if (IS_ERR_OR_NULL(eb))
+	if (IS_ERR(eb))
 		return NULL;
 	btrfs_tree_read_lock(eb);
 	if (old_root) {
@@ -2624,8 +2624,8 @@ static struct extent_buffer *btrfs_search_slot_get_root(struct btrfs_root *root,
 			down_read(&fs_info->commit_root_sem);
 			b = btrfs_clone_extent_buffer(root->commit_root);
 			up_read(&fs_info->commit_root_sem);
-			if (!b)
-				return ERR_PTR(-ENOMEM);
+			if (IS_ERR(b))
+				return b;
 
 		} else {
 			b = root->commit_root;
@@ -5431,7 +5431,8 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
 			btrfs_clone_extent_buffer(left_root->commit_root);
 	if (!left_path->nodes[left_level]) {
 		up_read(&fs_info->commit_root_sem);
-		ret = -ENOMEM;
+		ret = PTR_ERR(left_path->nodes[left_level]);
+		left_path->nodes[left_level] = NULL;
 		goto out;
 	}
 
@@ -5439,9 +5440,10 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
 	right_root_level = right_level;
 	right_path->nodes[right_level] =
 			btrfs_clone_extent_buffer(right_root->commit_root);
-	if (!right_path->nodes[right_level]) {
+	if (IS_ERR(right_path->nodes[right_level])) {
 		up_read(&fs_info->commit_root_sem);
-		ret = -ENOMEM;
+		ret = PTR_ERR(right_path->nodes[right_level]);
+		right_path->nodes[right_level] = NULL;
 		goto out;
 	}
 	up_read(&fs_info->commit_root_sem);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a19bd8bc3b32..dbdb649f1957 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4713,13 +4713,13 @@ struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src)
 
 	new = __alloc_extent_buffer(src->fs_info, src->start, src->len);
 	if (IS_ERR(new))
-		return NULL;
+		return new;
 
 	for (i = 0; i < num_pages; i++) {
 		p = alloc_page(GFP_NOFS);
 		if (!p) {
 			btrfs_release_extent_buffer(new);
-			return NULL;
+			return ERR_PTR(-ENOMEM);
 		}
 		attach_extent_buffer_page(new, p);
 		WARN_ON(PageDirty(p));
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 4e473a998219..ccfa992a10bf 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3105,8 +3105,9 @@ static int qgroup_rescan_leaf(struct btrfs_trans_handle *trans,
 	fs_info->qgroup_rescan_progress.objectid = found.objectid + 1;
 
 	scratch_leaf = btrfs_clone_extent_buffer(path->nodes[0]);
-	if (!scratch_leaf) {
-		ret = -ENOMEM;
+	if (IS_ERR(scratch_leaf)) {
+		ret = PTR_ERR(scratch_leaf);
+		scratch_leaf = NULL;
 		mutex_unlock(&fs_info->qgroup_rescan_lock);
 		goto out;
 	}
-- 
2.20.1

