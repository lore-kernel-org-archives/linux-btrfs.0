Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79603C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5651320700
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730071AbfCYSpM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:45:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:38896 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728991AbfCYSpL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 14:45:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C730FAFBD
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 18:45:09 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D1500DA98F; Mon, 25 Mar 2019 19:46:22 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 04/30] btrfs: get fs_info from eb in leaf_data_end
Date:   Mon, 25 Mar 2019 19:46:22 +0100
Message-Id: <d7dfb558e7536c002a941bf92a46911524b5af28.1553539114.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1553539114.git.dsterba@suse.com>
References: <cover.1553539114.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We can read fs_info from extent buffer and can drop it from the
parameters.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.c     | 24 ++++++++++++------------
 fs/btrfs/ctree.h     |  5 ++---
 fs/btrfs/extent_io.c |  2 +-
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 7b1bc25f10cb..5be2beef18be 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3665,10 +3665,10 @@ static noinline int __push_leaf_right(struct btrfs_fs_info *fs_info,
 	right_nritems = btrfs_header_nritems(right);
 
 	push_space = btrfs_item_end_nr(left, left_nritems - push_items);
-	push_space -= leaf_data_end(fs_info, left);
+	push_space -= leaf_data_end(left);
 
 	/* make room in the right data area */
-	data_end = leaf_data_end(fs_info, right);
+	data_end = leaf_data_end(right);
 	memmove_extent_buffer(right,
 			      BTRFS_LEAF_DATA_OFFSET + data_end - push_space,
 			      BTRFS_LEAF_DATA_OFFSET + data_end,
@@ -3677,7 +3677,7 @@ static noinline int __push_leaf_right(struct btrfs_fs_info *fs_info,
 	/* copy from the left data area */
 	copy_extent_buffer(right, left, BTRFS_LEAF_DATA_OFFSET +
 		     BTRFS_LEAF_DATA_SIZE(fs_info) - push_space,
-		     BTRFS_LEAF_DATA_OFFSET + leaf_data_end(fs_info, left),
+		     BTRFS_LEAF_DATA_OFFSET + leaf_data_end(left),
 		     push_space);
 
 	memmove_extent_buffer(right, btrfs_item_nr_offset(push_items),
@@ -3892,7 +3892,7 @@ static noinline int __push_leaf_left(struct btrfs_fs_info *fs_info,
 		     btrfs_item_offset_nr(right, push_items - 1);
 
 	copy_extent_buffer(left, right, BTRFS_LEAF_DATA_OFFSET +
-		     leaf_data_end(fs_info, left) - push_space,
+		     leaf_data_end(left) - push_space,
 		     BTRFS_LEAF_DATA_OFFSET +
 		     btrfs_item_offset_nr(right, push_items - 1),
 		     push_space);
@@ -3919,11 +3919,11 @@ static noinline int __push_leaf_left(struct btrfs_fs_info *fs_info,
 
 	if (push_items < right_nritems) {
 		push_space = btrfs_item_offset_nr(right, push_items - 1) -
-						  leaf_data_end(fs_info, right);
+						  leaf_data_end(right);
 		memmove_extent_buffer(right, BTRFS_LEAF_DATA_OFFSET +
 				      BTRFS_LEAF_DATA_SIZE(fs_info) - push_space,
 				      BTRFS_LEAF_DATA_OFFSET +
-				      leaf_data_end(fs_info, right), push_space);
+				      leaf_data_end(right), push_space);
 
 		memmove_extent_buffer(right, btrfs_item_nr_offset(0),
 			      btrfs_item_nr_offset(push_items),
@@ -4065,7 +4065,7 @@ static noinline void copy_for_split(struct btrfs_trans_handle *trans,
 
 	nritems = nritems - mid;
 	btrfs_set_header_nritems(right, nritems);
-	data_copy_size = btrfs_item_end_nr(l, mid) - leaf_data_end(fs_info, l);
+	data_copy_size = btrfs_item_end_nr(l, mid) - leaf_data_end(l);
 
 	copy_extent_buffer(right, l, btrfs_item_nr_offset(0),
 			   btrfs_item_nr_offset(mid),
@@ -4074,7 +4074,7 @@ static noinline void copy_for_split(struct btrfs_trans_handle *trans,
 	copy_extent_buffer(right, l,
 		     BTRFS_LEAF_DATA_OFFSET + BTRFS_LEAF_DATA_SIZE(fs_info) -
 		     data_copy_size, BTRFS_LEAF_DATA_OFFSET +
-		     leaf_data_end(fs_info, l), data_copy_size);
+		     leaf_data_end(l), data_copy_size);
 
 	rt_data_off = BTRFS_LEAF_DATA_SIZE(fs_info) - btrfs_item_end_nr(l, mid);
 
@@ -4577,7 +4577,7 @@ void btrfs_truncate_item(struct btrfs_fs_info *fs_info,
 		return;
 
 	nritems = btrfs_header_nritems(leaf);
-	data_end = leaf_data_end(fs_info, leaf);
+	data_end = leaf_data_end(leaf);
 
 	old_data_start = btrfs_item_offset_nr(leaf, slot);
 
@@ -4670,7 +4670,7 @@ void btrfs_extend_item(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 	leaf = path->nodes[0];
 
 	nritems = btrfs_header_nritems(leaf);
-	data_end = leaf_data_end(fs_info, leaf);
+	data_end = leaf_data_end(leaf);
 
 	if (btrfs_leaf_free_space(fs_info, leaf) < data_size) {
 		btrfs_print_leaf(leaf);
@@ -4748,7 +4748,7 @@ void setup_items_for_insert(struct btrfs_root *root, struct btrfs_path *path,
 	slot = path->slots[0];
 
 	nritems = btrfs_header_nritems(leaf);
-	data_end = leaf_data_end(fs_info, leaf);
+	data_end = leaf_data_end(leaf);
 
 	if (btrfs_leaf_free_space(fs_info, leaf) < total_size) {
 		btrfs_print_leaf(leaf);
@@ -4976,7 +4976,7 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	nritems = btrfs_header_nritems(leaf);
 
 	if (slot + nr != nritems) {
-		int data_end = leaf_data_end(fs_info, leaf);
+		int data_end = leaf_data_end(leaf);
 
 		memmove_extent_buffer(leaf, BTRFS_LEAF_DATA_OFFSET +
 			      data_end + dsize,
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 880b5abd8ecc..78b20567253e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2443,13 +2443,12 @@ static inline int btrfs_super_csum_size(const struct btrfs_super_block *s)
  * this returns the address of the start of the last item,
  * which is the stop of the leaf data stack
  */
-static inline unsigned int leaf_data_end(const struct btrfs_fs_info *fs_info,
-					 const struct extent_buffer *leaf)
+static inline unsigned int leaf_data_end(const struct extent_buffer *leaf)
 {
 	u32 nr = btrfs_header_nritems(leaf);
 
 	if (nr == 0)
-		return BTRFS_LEAF_DATA_SIZE(fs_info);
+		return BTRFS_LEAF_DATA_SIZE(leaf->fs_info);
 	return btrfs_item_offset_nr(leaf, nr - 1);
 }
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index ae3746829e41..4d58075e6cec 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3706,7 +3706,7 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 		 * header 0 1 2 .. N ... data_N .. data_2 data_1 data_0
 		 */
 		start = btrfs_item_nr_offset(nritems);
-		end = BTRFS_LEAF_DATA_OFFSET + leaf_data_end(fs_info, eb);
+		end = BTRFS_LEAF_DATA_OFFSET + leaf_data_end(eb);
 		memzero_extent_buffer(eb, start, end - start);
 	}
 
-- 
2.21.0

