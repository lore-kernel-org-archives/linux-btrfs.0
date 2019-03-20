Return-Path: <SRS0=xnYl=RX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92A6EC10F05
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 06:37:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63B422186A
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 06:37:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbfCTGha (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Mar 2019 02:37:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:40866 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727716AbfCTGh3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Mar 2019 02:37:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DD39FAC69
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Mar 2019 06:37:27 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCh v2 4/9] btrfs: tree-checker: Check chunk item at tree block read time
Date:   Wed, 20 Mar 2019 14:37:12 +0800
Message-Id: <20190320063717.31770-5-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190320063717.31770-1-wqu@suse.com>
References: <20190320063717.31770-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Since we have btrfs_check_chunk_valid() in tree-checker, let's do
chunk item verification in tree-checker too.

Since the tree-checker is run at endio time, if one chunk leaf fails
chunk verification, we can still retry the other copy, making btrfs more
robust to fuzzed image as we may still get a good chunk item.

Also since we have done chunk verification in tree block read time, skip
the btrfs_check_chunk_valid() call in read_one_chunk() if we're reading
chunk items from leaf.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tree-checker.c |  6 ++++++
 fs/btrfs/volumes.c      | 12 +++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 63fbe0b5ae8e..86dee12d7917 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -610,6 +610,7 @@ static int check_leaf_item(struct btrfs_fs_info *fs_info,
 			   struct btrfs_key *key, int slot)
 {
 	int ret = 0;
+	struct btrfs_chunk *chunk;
 
 	switch (key->type) {
 	case BTRFS_EXTENT_DATA_KEY:
@@ -626,6 +627,11 @@ static int check_leaf_item(struct btrfs_fs_info *fs_info,
 	case BTRFS_BLOCK_GROUP_ITEM_KEY:
 		ret = check_block_group_item(fs_info, leaf, key, slot);
 		break;
+	case BTRFS_CHUNK_ITEM_KEY:
+		chunk = btrfs_item_ptr(leaf, slot, struct btrfs_chunk);
+		ret = btrfs_check_chunk_valid(fs_info, leaf, chunk,
+					      key->offset);
+		break;
 	}
 	return ret;
 }
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2a4ac5aa2a16..645ffc9c47b0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6745,9 +6745,15 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
 	length = btrfs_chunk_length(leaf, chunk);
 	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
 
-	ret = btrfs_check_chunk_valid(fs_info, leaf, chunk, logical);
-	if (ret)
-		return ret;
+	/*
+	 * Only need to verify chunk item if we're reading from sys chunk array,
+	 * as chunk item in tree block is already verified by tree-checker.
+	 */
+	if (leaf->start == BTRFS_SUPER_INFO_OFFSET) {
+		ret = btrfs_check_chunk_valid(fs_info, leaf, chunk, logical);
+		if (ret)
+			return ret;
+	}
 
 	read_lock(&map_tree->map_tree.lock);
 	em = lookup_extent_mapping(&map_tree->map_tree, logical, 1);
-- 
2.21.0

