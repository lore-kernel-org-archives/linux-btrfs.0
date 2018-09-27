Return-Path: <SRS0=Zypw=MJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BBF1C43382
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 06:42:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACE292156D
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 06:42:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ACE292156D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727204AbeI0M7h (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Sep 2018 08:59:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:38056 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727149AbeI0M7h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 08:59:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E74E3B124
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Sep 2018 06:42:54 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v4 7/7] btrfs: qgroup: Only trace data extents in leaves if we're relocating data block group
Date:   Thu, 27 Sep 2018 14:42:35 +0800
Message-Id: <20180927064235.7432-8-wqu@suse.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180927064235.7432-1-wqu@suse.com>
References: <20180927064235.7432-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

For qgroup_trace_extent_swap(), if we find one leaf needs to be traced,
btrfs will also iterate all file extents and trace them.

This is OK if we're relocating data block groups, but if we're
relocating metadata block groups, balance code itself has ensured that
both subtree of file tree and reloc tree contain the same contents.

That's to say, if we're relocating metadata block groups, all file
extents in reloc and file tree should match, thus no need to trace them.
This should reduce the total number of dirty extents processed in metadata
block group balance.

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
relocated extents    | 22929        | 22851          | -0.3%
qgroup dirty extents | 227757       | 140886         | -38.1%
time (sys)           | 65.253s      | 37.464s        | -42.6%
time (real)          | 74.032s      | 44.722s        | -39.6%

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c     | 21 +++++++++++++++------
 fs/btrfs/qgroup.h     |  1 +
 fs/btrfs/relocation.c | 10 +++++-----
 3 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 64251e9ee1d1..678e07c11bc6 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1725,7 +1725,8 @@ static int adjust_slots_upwards(struct btrfs_path *path, int root_level)
 static int qgroup_trace_extent_swap(struct btrfs_trans_handle* trans,
 				    struct extent_buffer *src_eb,
 				    struct btrfs_path *dst_path,
-				    int dst_level, int root_level)
+				    int dst_level, int root_level,
+				    bool trace_leaf)
 {
 	struct btrfs_key key;
 	struct btrfs_path *src_path;
@@ -1828,7 +1829,7 @@ static int qgroup_trace_extent_swap(struct btrfs_trans_handle* trans,
 		goto out;
 
 	/* Record leaf file extents */
-	if (dst_level == 0) {
+	if (dst_level == 0 && trace_leaf) {
 		ret = btrfs_qgroup_trace_leaf_items(trans, src_path->nodes[0]);
 		if (ret < 0)
 			goto out;
@@ -1865,7 +1866,7 @@ static int qgroup_trace_new_subtree_blocks(struct btrfs_trans_handle* trans,
 					   struct extent_buffer *src_eb,
 					   struct btrfs_path *dst_path,
 					   int cur_level, int root_level,
-					   u64 last_snapshot)
+					   u64 last_snapshot, bool trace_leaf)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct extent_buffer *eb;
@@ -1937,7 +1938,7 @@ static int qgroup_trace_new_subtree_blocks(struct btrfs_trans_handle* trans,
 
 	/* Now record this tree block and its counter part for qgroups */
 	ret = qgroup_trace_extent_swap(trans, src_eb, dst_path, cur_level,
-				       root_level);
+				       root_level, trace_leaf);
 	if (ret < 0)
 		goto cleanup;
 
@@ -1954,7 +1955,7 @@ static int qgroup_trace_new_subtree_blocks(struct btrfs_trans_handle* trans,
 			/* Recursive call (at most 7 times) */
 			ret = qgroup_trace_new_subtree_blocks(trans, src_eb,
 					dst_path, cur_level - 1, root_level,
-					last_snapshot);
+					last_snapshot, trace_leaf);
 			if (ret < 0)
 				goto cleanup;
 		}
@@ -1993,6 +1994,7 @@ static int qgroup_trace_new_subtree_blocks(struct btrfs_trans_handle* trans,
  * @dst_parent, @dst_slot: pointer to dst (tree reloc tree) eb.
  */
 int btrfs_qgroup_trace_subtree_swap(struct btrfs_trans_handle *trans,
+				struct btrfs_block_group_cache *bg_cache,
 				struct extent_buffer *src_parent, int src_slot,
 				struct extent_buffer *dst_parent, int dst_slot,
 				u64 last_snapshot)
@@ -2002,6 +2004,7 @@ int btrfs_qgroup_trace_subtree_swap(struct btrfs_trans_handle *trans,
 	struct btrfs_key first_key;
 	struct extent_buffer *src_eb = NULL;
 	struct extent_buffer *dst_eb = NULL;
+	bool trace_leaf = false;
 	u64 child_gen;
 	u64 child_bytenr;
 	int level;
@@ -2020,6 +2023,12 @@ int btrfs_qgroup_trace_subtree_swap(struct btrfs_trans_handle *trans,
 		return -EUCLEAN;
 	}
 
+	/*
+	 * Only trace leaf if we're relocating data block groups, this could
+	 * reduce tons of data extents tracing for meta/sys bg relocation.
+	 */
+	if (bg_cache->flags & BTRFS_BLOCK_GROUP_DATA)
+		trace_leaf = true;
 	/* Read out real @src_eb, pointed by @src_parent and @src_slot */
 	child_bytenr = btrfs_node_blockptr(src_parent, src_slot);
 	child_gen = btrfs_node_ptr_generation(src_parent, src_slot);
@@ -2063,7 +2072,7 @@ int btrfs_qgroup_trace_subtree_swap(struct btrfs_trans_handle *trans,
 
 	/* Do the generation aware breadth-first search */
 	ret = qgroup_trace_new_subtree_blocks(trans, src_eb, dst_path, level,
-					      level, last_snapshot);
+					      level, last_snapshot, trace_leaf);
 	if (ret < 0)
 		goto out;
 	ret = 0;
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 1aaf4c276900..80ebeb3ab5ba 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -238,6 +238,7 @@ int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
 			       u64 root_gen, int root_level);
 
 int btrfs_qgroup_trace_subtree_swap(struct btrfs_trans_handle *trans,
+				struct btrfs_block_group_cache *bg_cache,
 				struct extent_buffer *src_parent, int src_slot,
 				struct extent_buffer *dst_parent, int dst_slot,
 				u64 last_snapshot);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 07ab61a740ae..44efde9886fc 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1735,7 +1735,7 @@ int memcmp_node_keys(struct extent_buffer *eb, int slot,
  * errors, a negative error number is returned.
  */
 static noinline_for_stack
-int replace_path(struct btrfs_trans_handle *trans,
+int replace_path(struct btrfs_trans_handle *trans, struct reloc_control *rc,
 		 struct btrfs_root *dest, struct btrfs_root *src,
 		 struct btrfs_path *path, struct btrfs_key *next_key,
 		 int lowest_level, int max_level)
@@ -1879,9 +1879,9 @@ int replace_path(struct btrfs_trans_handle *trans,
 		 *    and tree block numbers, if current trans doesn't free
 		 *    data reloc tree inode.
 		 */
-		ret = btrfs_qgroup_trace_subtree_swap(trans, parent, slot,
-				path->nodes[level], path->slots[level],
-				last_snapshot);
+		ret = btrfs_qgroup_trace_subtree_swap(trans, rc->block_group,
+				parent, slot, path->nodes[level],
+				path->slots[level], last_snapshot);
 		if (ret < 0)
 			break;
 
@@ -2200,7 +2200,7 @@ static noinline_for_stack int merge_reloc_root(struct reloc_control *rc,
 		    btrfs_comp_cpu_keys(&next_key, &key) >= 0) {
 			ret = 0;
 		} else {
-			ret = replace_path(trans, root, reloc_root, path,
+			ret = replace_path(trans, rc, root, reloc_root, path,
 					   &next_key, level, max_level);
 		}
 		if (ret < 0) {
-- 
2.19.0

