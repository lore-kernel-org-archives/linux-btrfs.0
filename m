Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8128AC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CD0120700
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730376AbfCYSpo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:45:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:39060 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730369AbfCYSpn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 14:45:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0FD42AFBD
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 18:45:42 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7971BDA98F; Mon, 25 Mar 2019 19:46:55 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 18/30] btrfs: tree-checker: get fs_info from eb in block_group_err
Date:   Mon, 25 Mar 2019 19:46:55 +0100
Message-Id: <8988075d09fc3f4a9846dff4a9dcdd03d519f4b8.1553539114.git.dsterba@suse.com>
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
 fs/btrfs/tree-checker.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index d6822c0390af..1bf8b67dbf57 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -354,12 +354,12 @@ static int check_dir_item(struct extent_buffer *leaf,
 	return 0;
 }
 
-__printf(4, 5)
+__printf(3, 4)
 __cold
-static void block_group_err(const struct btrfs_fs_info *fs_info,
-			    const struct extent_buffer *eb, int slot,
+static void block_group_err(const struct extent_buffer *eb, int slot,
 			    const char *fmt, ...)
 {
+	const struct btrfs_fs_info *fs_info = eb->fs_info;
 	struct btrfs_key key;
 	struct va_format vaf;
 	va_list args;
@@ -392,13 +392,13 @@ static int check_block_group_item(struct btrfs_fs_info *fs_info,
 	 * handle it.  We care more about the size.
 	 */
 	if (key->offset == 0) {
-		block_group_err(fs_info, leaf, slot,
+		block_group_err(leaf, slot,
 				"invalid block group size 0");
 		return -EUCLEAN;
 	}
 
 	if (item_size != sizeof(bgi)) {
-		block_group_err(fs_info, leaf, slot,
+		block_group_err(leaf, slot,
 			"invalid item size, have %u expect %zu",
 				item_size, sizeof(bgi));
 		return -EUCLEAN;
@@ -408,7 +408,7 @@ static int check_block_group_item(struct btrfs_fs_info *fs_info,
 			   sizeof(bgi));
 	if (btrfs_block_group_chunk_objectid(&bgi) !=
 	    BTRFS_FIRST_CHUNK_TREE_OBJECTID) {
-		block_group_err(fs_info, leaf, slot,
+		block_group_err(leaf, slot,
 		"invalid block group chunk objectid, have %llu expect %llu",
 				btrfs_block_group_chunk_objectid(&bgi),
 				BTRFS_FIRST_CHUNK_TREE_OBJECTID);
@@ -416,7 +416,7 @@ static int check_block_group_item(struct btrfs_fs_info *fs_info,
 	}
 
 	if (btrfs_block_group_used(&bgi) > key->offset) {
-		block_group_err(fs_info, leaf, slot,
+		block_group_err(leaf, slot,
 			"invalid block group used, have %llu expect [0, %llu)",
 				btrfs_block_group_used(&bgi), key->offset);
 		return -EUCLEAN;
@@ -424,7 +424,7 @@ static int check_block_group_item(struct btrfs_fs_info *fs_info,
 
 	flags = btrfs_block_group_flags(&bgi);
 	if (hweight64(flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) > 1) {
-		block_group_err(fs_info, leaf, slot,
+		block_group_err(leaf, slot,
 "invalid profile flags, have 0x%llx (%lu bits set) expect no more than 1 bit set",
 			flags & BTRFS_BLOCK_GROUP_PROFILE_MASK,
 			hweight64(flags & BTRFS_BLOCK_GROUP_PROFILE_MASK));
@@ -437,7 +437,7 @@ static int check_block_group_item(struct btrfs_fs_info *fs_info,
 	    type != BTRFS_BLOCK_GROUP_SYSTEM &&
 	    type != (BTRFS_BLOCK_GROUP_METADATA |
 			   BTRFS_BLOCK_GROUP_DATA)) {
-		block_group_err(fs_info, leaf, slot,
+		block_group_err(leaf, slot,
 "invalid type, have 0x%llx (%lu bits set) expect either 0x%llx, 0x%llx, 0x%llx or 0x%llx",
 			type, hweight64(type),
 			BTRFS_BLOCK_GROUP_DATA, BTRFS_BLOCK_GROUP_METADATA,
-- 
2.21.0

