Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F8D6C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64CC120700
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730332AbfCYSpd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:45:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:39004 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729413AbfCYSpc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 14:45:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6218FAF94
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 18:45:30 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CA1F3DA98F; Mon, 25 Mar 2019 19:46:43 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 13/30] btrfs: tree-checker: get fs_info from eb in generic_err
Date:   Mon, 25 Mar 2019 19:46:43 +0100
Message-Id: <0a8c46c8e9840ecaee8a36a2340a13e272b395ca.1553539114.git.dsterba@suse.com>
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
 fs/btrfs/tree-checker.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index de8626234de4..dc157925a602 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -41,12 +41,12 @@
  * Append generic "corrupt leaf/node root=%llu block=%llu slot=%d: " to @fmt.
  * Allows callers to customize the output.
  */
-__printf(4, 5)
+__printf(3, 4)
 __cold
-static void generic_err(const struct btrfs_fs_info *fs_info,
-			const struct extent_buffer *eb, int slot,
+static void generic_err(const struct extent_buffer *eb, int slot,
 			const char *fmt, ...)
 {
+	const struct btrfs_fs_info *fs_info = eb->fs_info;
 	struct va_format vaf;
 	va_list args;
 
@@ -196,19 +196,19 @@ static int check_csum_item(struct btrfs_fs_info *fs_info,
 	u32 csumsize = btrfs_super_csum_size(fs_info->super_copy);
 
 	if (key->objectid != BTRFS_EXTENT_CSUM_OBJECTID) {
-		generic_err(fs_info, leaf, slot,
+		generic_err(leaf, slot,
 		"invalid key objectid for csum item, have %llu expect %llu",
 			key->objectid, BTRFS_EXTENT_CSUM_OBJECTID);
 		return -EUCLEAN;
 	}
 	if (!IS_ALIGNED(key->offset, sectorsize)) {
-		generic_err(fs_info, leaf, slot,
+		generic_err(leaf, slot,
 	"unaligned key offset for csum item, have %llu should be aligned to %u",
 			key->offset, sectorsize);
 		return -EUCLEAN;
 	}
 	if (!IS_ALIGNED(btrfs_item_size_nr(leaf, slot), csumsize)) {
-		generic_err(fs_info, leaf, slot,
+		generic_err(leaf, slot,
 	"unaligned item size for csum item, have %u should be aligned to %u",
 			btrfs_item_size_nr(leaf, slot), csumsize);
 		return -EUCLEAN;
@@ -486,7 +486,7 @@ static int check_leaf(struct btrfs_fs_info *fs_info, struct extent_buffer *leaf,
 	int slot;
 
 	if (btrfs_header_level(leaf) != 0) {
-		generic_err(fs_info, leaf, 0,
+		generic_err(leaf, 0,
 			"invalid level for leaf, have %d expect 0",
 			btrfs_header_level(leaf));
 		return -EUCLEAN;
@@ -511,7 +511,7 @@ static int check_leaf(struct btrfs_fs_info *fs_info, struct extent_buffer *leaf,
 		    owner == BTRFS_DEV_TREE_OBJECTID ||
 		    owner == BTRFS_FS_TREE_OBJECTID ||
 		    owner == BTRFS_DATA_RELOC_TREE_OBJECTID) {
-			generic_err(fs_info, leaf, 0,
+			generic_err(leaf, 0,
 			"invalid root, root %llu must never be empty",
 				    owner);
 			return -EUCLEAN;
@@ -540,7 +540,7 @@ static int check_leaf(struct btrfs_fs_info *fs_info, struct extent_buffer *leaf,
 			eb = btrfs_root_node(check_root);
 			/* if leaf is the root, then it's fine */
 			if (leaf != eb) {
-				generic_err(fs_info, leaf, 0,
+				generic_err(leaf, 0,
 		"invalid nritems, have %u should not be 0 for non-root leaf",
 					nritems);
 				free_extent_buffer(eb);
@@ -573,7 +573,7 @@ static int check_leaf(struct btrfs_fs_info *fs_info, struct extent_buffer *leaf,
 
 		/* Make sure the keys are in the right order */
 		if (btrfs_comp_cpu_keys(&prev_key, &key) >= 0) {
-			generic_err(fs_info, leaf, slot,
+			generic_err(leaf, slot,
 	"bad key order, prev (%llu %u %llu) current (%llu %u %llu)",
 				prev_key.objectid, prev_key.type,
 				prev_key.offset, key.objectid, key.type,
@@ -592,7 +592,7 @@ static int check_leaf(struct btrfs_fs_info *fs_info, struct extent_buffer *leaf,
 			item_end_expected = btrfs_item_offset_nr(leaf,
 								 slot - 1);
 		if (btrfs_item_end_nr(leaf, slot) != item_end_expected) {
-			generic_err(fs_info, leaf, slot,
+			generic_err(leaf, slot,
 				"unexpected item end, have %u expect %u",
 				btrfs_item_end_nr(leaf, slot),
 				item_end_expected);
@@ -606,7 +606,7 @@ static int check_leaf(struct btrfs_fs_info *fs_info, struct extent_buffer *leaf,
 		 */
 		if (btrfs_item_end_nr(leaf, slot) >
 		    BTRFS_LEAF_DATA_SIZE(fs_info)) {
-			generic_err(fs_info, leaf, slot,
+			generic_err(leaf, slot,
 			"slot end outside of leaf, have %u expect range [0, %u]",
 				btrfs_item_end_nr(leaf, slot),
 				BTRFS_LEAF_DATA_SIZE(fs_info));
@@ -616,7 +616,7 @@ static int check_leaf(struct btrfs_fs_info *fs_info, struct extent_buffer *leaf,
 		/* Also check if the item pointer overlaps with btrfs item. */
 		if (btrfs_item_nr_offset(slot) + sizeof(struct btrfs_item) >
 		    btrfs_item_ptr_offset(leaf, slot)) {
-			generic_err(fs_info, leaf, slot,
+			generic_err(leaf, slot,
 		"slot overlaps with its data, item end %lu data start %lu",
 				btrfs_item_nr_offset(slot) +
 				sizeof(struct btrfs_item),
@@ -675,7 +675,7 @@ int btrfs_check_node(struct btrfs_fs_info *fs_info, struct extent_buffer *node)
 	int ret = 0;
 
 	if (level <= 0 || level >= BTRFS_MAX_LEVEL) {
-		generic_err(fs_info, node, 0,
+		generic_err(node, 0,
 			"invalid level for node, have %d expect [1, %d]",
 			level, BTRFS_MAX_LEVEL - 1);
 		return -EUCLEAN;
@@ -695,13 +695,13 @@ int btrfs_check_node(struct btrfs_fs_info *fs_info, struct extent_buffer *node)
 		btrfs_node_key_to_cpu(node, &next_key, slot + 1);
 
 		if (!bytenr) {
-			generic_err(fs_info, node, slot,
+			generic_err(node, slot,
 				"invalid NULL node pointer");
 			ret = -EUCLEAN;
 			goto out;
 		}
 		if (!IS_ALIGNED(bytenr, fs_info->sectorsize)) {
-			generic_err(fs_info, node, slot,
+			generic_err(node, slot,
 			"unaligned pointer, have %llu should be aligned to %u",
 				bytenr, fs_info->sectorsize);
 			ret = -EUCLEAN;
@@ -709,7 +709,7 @@ int btrfs_check_node(struct btrfs_fs_info *fs_info, struct extent_buffer *node)
 		}
 
 		if (btrfs_comp_cpu_keys(&key, &next_key) >= 0) {
-			generic_err(fs_info, node, slot,
+			generic_err(node, slot,
 	"bad key order, current (%llu %u %llu) next (%llu %u %llu)",
 				key.objectid, key.type, key.offset,
 				next_key.objectid, next_key.type,
-- 
2.21.0

