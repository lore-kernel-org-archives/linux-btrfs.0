Return-Path: <SRS0=iUkD=SG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2679C4360F
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 03:47:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C171A2147C
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 03:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbfDDDrR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Apr 2019 23:47:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:37294 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726833AbfDDDrR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Apr 2019 23:47:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6A763AE7A
        for <linux-btrfs@vger.kernel.org>; Thu,  4 Apr 2019 03:47:16 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: tree-checker: Remove comprehensive root owner check
Date:   Thu,  4 Apr 2019 11:47:07 +0800
Message-Id: <20190404034708.3399-2-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190404034708.3399-1-wqu@suse.com>
References: <20190404034708.3399-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Commit 1ba98d086fe3 ("Btrfs: detect corruption when non-root leaf has
zero item") introduced comprehensive root owner checker.

However it's pretty expensive tree search to locate the owner root,
especially when it get reused by mandatory read and write time
tree-checker.

This patch will remove that check, and completely rely on owner based
empty leaf check, which is much faster and still works fine for most
case.

And since we skip the old root owner check, now write time tree check
can be merged with btrfs_check_leaf_full().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tree-checker.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index d2c3c1f8870d..e325d4df5c23 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -838,7 +838,6 @@ static int check_leaf(struct extent_buffer *leaf, bool check_item_data)
 	 */
 	if (nritems == 0 && !btrfs_header_flag(leaf, BTRFS_HEADER_FLAG_RELOC)) {
 		u64 owner = btrfs_header_owner(leaf);
-		struct btrfs_root *check_root;
 
 		/* These trees must never be empty */
 		if (owner == BTRFS_ROOT_TREE_OBJECTID ||
@@ -852,29 +851,6 @@ static int check_leaf(struct extent_buffer *leaf, bool check_item_data)
 				    owner);
 			return -EUCLEAN;
 		}
-		key.objectid = owner;
-		key.type = BTRFS_ROOT_ITEM_KEY;
-		key.offset = (u64)-1;
-
-		check_root = btrfs_get_fs_root(fs_info, &key, false);
-		/*
-		 * The only reason we also check NULL here is that during
-		 * open_ctree() some roots has not yet been set up.
-		 */
-		if (!IS_ERR_OR_NULL(check_root)) {
-			struct extent_buffer *eb;
-
-			eb = btrfs_root_node(check_root);
-			/* if leaf is the root, then it's fine */
-			if (leaf != eb) {
-				generic_err(leaf, 0,
-		"invalid nritems, have %u should not be 0 for non-root leaf",
-					nritems);
-				free_extent_buffer(eb);
-				return -EUCLEAN;
-			}
-			free_extent_buffer(eb);
-		}
 		return 0;
 	}
 
-- 
2.21.0

