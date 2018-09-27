Return-Path: <SRS0=Zypw=MJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73C56C43382
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 06:42:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 394E52156D
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 06:42:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 394E52156D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbeI0M7e (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Sep 2018 08:59:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:38050 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727149AbeI0M7d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 08:59:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7C220B124
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Sep 2018 06:42:52 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v4 6/7] btrfs: delayed-ref: Introduce new parameter for btrfs_add_delayed_tree_ref() to reduce unnecessary qgroup tracing
Date:   Thu, 27 Sep 2018 14:42:34 +0800
Message-Id: <20180927064235.7432-7-wqu@suse.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180927064235.7432-1-wqu@suse.com>
References: <20180927064235.7432-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

For btrfs_add_delayed_tree_ref(), its ref_root parameter can be
different from its real root.
This is pretty common for reloc tree, in that case @ref_root is passed
as the original tree owner (source file tree).

However btrfs_add_delayed_tree_ref() uses @ref_root to determine whether
we should do heavy qgroup tracing for it, so for balance this could
cause a lot of unnecessary extent tracing.

This patch will introduce a parameter, @root for qgroup code to
determine whether we really need to do the heavy-lifting tracing work.

This patch would reduce the qgroup dirty extent number from 'number of
extents being relocated' to 0 for the transaction before real tree swap.

[[Benchmark]] (with all previous enhancement)
Hardware:
	VM 4G vRAM, 8 vCPUs,
	disk is using 'unsafe' cache mode,
	backing device is SAMSUNG 850 evo SSD.
	Host has 16G ram.

Mkfs parameter:
	--nodesize 4K (To bump up tree size)

Initial subvolume contents:
	4G data copied from /usr and /lib.
	(With enough regular small files)

Snapshots:
	16 snapshots of the original subvolume.
	each snapshot has 3 random files modified.

balance parameter:
	-m

So the content should be pretty similar to a real world root fs layout.

                     | v4.19-rc1    | w/ patchset    | diff (*)
---------------------------------------------------------------
relocated extents    | 22929        | 22975          | +0.0%
qgroup dirty extents | 227757       | 141239         | -38.0%
time (sys)           | 65.253s      | 37.466s        | -42.6%
time (real)          | 74.032s      | 44.585s        | -39.8%

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/delayed-ref.c | 3 ++-
 fs/btrfs/delayed-ref.h | 1 +
 fs/btrfs/extent-tree.c | 8 ++++----
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 62ff545ba1f7..a2a5c777d8c2 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -710,6 +710,7 @@ static void init_delayed_ref_common(struct btrfs_fs_info *fs_info,
  * transaction commits.
  */
 int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root,
 			       u64 bytenr, u64 num_bytes, u64 parent,
 			       u64 ref_root,  int level, int action,
 			       struct btrfs_delayed_extent_op *extent_op,
@@ -737,7 +738,7 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	}
 
 	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) &&
-	    is_fstree(ref_root)) {
+	    is_fstree(root->root_key.objectid)) {
 		record = kmalloc(sizeof(*record), GFP_NOFS);
 		if (!record) {
 			kmem_cache_free(btrfs_delayed_tree_ref_cachep, ref);
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index d9f2a4ebd5db..a51560a3cb66 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -235,6 +235,7 @@ static inline void btrfs_put_delayed_ref_head(struct btrfs_delayed_ref_head *hea
 }
 
 int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root,
 			       u64 bytenr, u64 num_bytes, u64 parent,
 			       u64 ref_root, int level, int action,
 			       struct btrfs_delayed_extent_op *extent_op,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 028d1a80d36f..d8a0746498ac 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2040,7 +2040,7 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 			   owner, offset, BTRFS_ADD_DELAYED_REF);
 
 	if (owner < BTRFS_FIRST_FREE_OBJECTID) {
-		ret = btrfs_add_delayed_tree_ref(trans, bytenr,
+		ret = btrfs_add_delayed_tree_ref(trans, root, bytenr,
 						 num_bytes, parent,
 						 root_objectid, (int)owner,
 						 BTRFS_ADD_DELAYED_REF, NULL,
@@ -6993,7 +6993,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 				   root->root_key.objectid,
 				   btrfs_header_level(buf), 0,
 				   BTRFS_DROP_DELAYED_REF);
-		ret = btrfs_add_delayed_tree_ref(trans, buf->start,
+		ret = btrfs_add_delayed_tree_ref(trans, root, buf->start,
 						 buf->len, parent,
 						 root->root_key.objectid,
 						 btrfs_header_level(buf),
@@ -7072,7 +7072,7 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 		old_ref_mod = new_ref_mod = 0;
 		ret = 0;
 	} else if (owner < BTRFS_FIRST_FREE_OBJECTID) {
-		ret = btrfs_add_delayed_tree_ref(trans, bytenr,
+		ret = btrfs_add_delayed_tree_ref(trans, root, bytenr,
 						 num_bytes, parent,
 						 root_objectid, (int)owner,
 						 BTRFS_DROP_DELAYED_REF, NULL,
@@ -8293,7 +8293,7 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 		btrfs_ref_tree_mod(root, ins.objectid, ins.offset, parent,
 				   root_objectid, level, 0,
 				   BTRFS_ADD_DELAYED_EXTENT);
-		ret = btrfs_add_delayed_tree_ref(trans, ins.objectid,
+		ret = btrfs_add_delayed_tree_ref(trans, root, ins.objectid,
 						 ins.offset, parent,
 						 root_objectid, level,
 						 BTRFS_ADD_DELAYED_EXTENT,
-- 
2.19.0

