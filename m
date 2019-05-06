Return-Path: <SRS0=0mr7=TG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	T_DKIMWL_WL_HIGH,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84EBCC04A6B
	for <linux-btrfs@archiver.kernel.org>; Mon,  6 May 2019 15:44:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56EA0205C9
	for <linux-btrfs@archiver.kernel.org>; Mon,  6 May 2019 15:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557157457;
	bh=jLNe08s8mvmSWPPtamMjqkRgYqq4x1YdmhgBQyrDJ7w=;
	h=From:To:Subject:Date:List-ID:From;
	b=WqdP4PG4QboBJnGNoXHUxEtLC5ls9IDrUHPOgGOdyCoSokBujbFxYDBn6nVyqi87T
	 ZoAk6ZWZdjPtT7JU7vWVu+GcN7JcK1ZKpyFWAW9i1+lAds/9P9dkIYi68Oiivw+Mli
	 XqzjGtGQ2WM0arQlPt1ylAYuh0ng8+OfW/amlPj8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfEFPoQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 6 May 2019 11:44:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:56766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726571AbfEFPoQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 May 2019 11:44:16 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99F0C205C9
        for <linux-btrfs@vger.kernel.org>; Mon,  6 May 2019 15:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557157455;
        bh=jLNe08s8mvmSWPPtamMjqkRgYqq4x1YdmhgBQyrDJ7w=;
        h=From:To:Subject:Date:From;
        b=Juzfpxd8NEIDY0y+yUEBpnIl4ZB2qDa7zx70BhoRB6iV6gqjBQKqAeoqnA1FdWy1k
         Ui1oa3EuGbgQxXyrV5dmYM1kwCYqE4XqeM3VHcizcyerIHDjvdv3SH7AzUyLW2NSkZ
         zTPOO3OgvlMhcbpHjxag8nTMaby1zOAKOQBa0gKE=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs: teach tree-checker to detect file extent items with overlapping ranges
Date:   Mon,  6 May 2019 16:44:12 +0100
Message-Id: <20190506154412.20147-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Having file extent items with ranges that overlap each other is a serious
issue that leads to all sorts of corruptions and crashes (like a BUG_ON()
during the course of __btrfs_drop_extents() when it traims file extent
items). Therefore teach the tree checker to detect such cases. This is
motivated by a recently fixed bug (race between ranged full fsync and
writeback or adjacent ranges).

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-checker.c | 51 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 47 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index a62e1e837a89..093cef702a4b 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -104,9 +104,27 @@ static void file_extent_err(const struct btrfs_fs_info *fs_info,
 	(!IS_ALIGNED(btrfs_file_extent_##name((leaf), (fi)), (alignment)));   \
 })
 
+static u64 file_extent_end(struct extent_buffer *leaf,
+			   struct btrfs_key *key,
+			   struct btrfs_file_extent_item *extent)
+{
+	u64 end;
+	u64 len;
+
+	if (btrfs_file_extent_type(leaf, extent) == BTRFS_FILE_EXTENT_INLINE) {
+		len = btrfs_file_extent_ram_bytes(leaf, extent);
+		end = ALIGN(key->offset + len, leaf->fs_info->sectorsize);
+	} else {
+		len = btrfs_file_extent_num_bytes(leaf, extent);
+		end = key->offset + len;
+	}
+	return end;
+}
+
 static int check_extent_data_item(struct btrfs_fs_info *fs_info,
 				  struct extent_buffer *leaf,
-				  struct btrfs_key *key, int slot)
+				  struct btrfs_key *key, int slot,
+				  struct btrfs_key *prev_key)
 {
 	struct btrfs_file_extent_item *fi;
 	u32 sectorsize = fs_info->sectorsize;
@@ -185,6 +203,28 @@ static int check_extent_data_item(struct btrfs_fs_info *fs_info,
 	    CHECK_FE_ALIGNED(fs_info, leaf, slot, fi, offset, sectorsize) ||
 	    CHECK_FE_ALIGNED(fs_info, leaf, slot, fi, num_bytes, sectorsize))
 		return -EUCLEAN;
+
+	/*
+	 * Check that no two consecutive file extent items, in the same leaf,
+	 * present ranges that overlap each other.
+	 */
+	if (slot > 0 &&
+	    prev_key->objectid == key->objectid &&
+	    prev_key->type == BTRFS_EXTENT_DATA_KEY) {
+		struct btrfs_file_extent_item *prev_fi;
+		u64 prev_end;
+
+		prev_fi = btrfs_item_ptr(leaf, slot - 1,
+					 struct btrfs_file_extent_item);
+		prev_end = file_extent_end(leaf, prev_key, prev_fi);
+		if (prev_end > key->offset) {
+			file_extent_err(fs_info, leaf, slot - 1,
+"file extent end range (%llu) goes beyond start offset (%llu) of the next file extent",
+					prev_end, key->offset);
+			return -EUCLEAN;
+		}
+	}
+
 	return 0;
 }
 
@@ -453,13 +493,15 @@ static int check_block_group_item(struct btrfs_fs_info *fs_info,
  */
 static int check_leaf_item(struct btrfs_fs_info *fs_info,
 			   struct extent_buffer *leaf,
-			   struct btrfs_key *key, int slot)
+			   struct btrfs_key *key, int slot,
+			   struct btrfs_key *prev_key)
 {
 	int ret = 0;
 
 	switch (key->type) {
 	case BTRFS_EXTENT_DATA_KEY:
-		ret = check_extent_data_item(fs_info, leaf, key, slot);
+		ret = check_extent_data_item(fs_info, leaf, key, slot,
+					     prev_key);
 		break;
 	case BTRFS_EXTENT_CSUM_KEY:
 		ret = check_csum_item(fs_info, leaf, key, slot);
@@ -620,7 +662,8 @@ static int check_leaf(struct btrfs_fs_info *fs_info, struct extent_buffer *leaf,
 			 * Check if the item size and content meet other
 			 * criteria
 			 */
-			ret = check_leaf_item(fs_info, leaf, &key, slot);
+			ret = check_leaf_item(fs_info, leaf, &key, slot,
+					      &prev_key);
 			if (ret < 0)
 				return ret;
 		}
-- 
2.11.0

