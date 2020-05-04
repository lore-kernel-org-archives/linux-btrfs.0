Return-Path: <SRS0=eotd=6S=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C596AC47254
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 May 2020 23:58:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A126120675
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 May 2020 23:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbgEDX6g (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 May 2020 19:58:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:37908 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728278AbgEDX6g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 May 2020 19:58:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CC54CAEB9
        for <linux-btrfs@vger.kernel.org>; Mon,  4 May 2020 23:58:36 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v4 3/7] btrfs: block-group: Refactor how we delete one block group item
Date:   Tue,  5 May 2020 07:58:21 +0800
Message-Id: <20200504235825.4199-4-wqu@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504235825.4199-1-wqu@suse.com>
References: <20200504235825.4199-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When deleting a block group item, it's pretty straight forward, just
delete the item pointed by the key.

However it will not be that straight-forward for incoming skinny block
group item.

So refactor the block group item deletion into a new function,
remove_block_group_item(), also to make the already lengthy
btrfs_remove_block_group() a little shorter.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/block-group.c | 37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 57483ea07d51..914b1c2064ac 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -865,11 +865,34 @@ static void clear_incompat_bg_bits(struct btrfs_fs_info *fs_info, u64 flags)
 	}
 }
 
+static int remove_block_group_item(struct btrfs_trans_handle *trans,
+				   struct btrfs_path *path,
+				   struct btrfs_block_group *block_group)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_root *root;
+	struct btrfs_key key;
+	int ret;
+
+	root = fs_info->extent_root;
+	key.objectid = block_group->start;
+	key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
+	key.offset = block_group->length;
+
+	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	if (ret > 0)
+		ret = -ENOENT;
+	if (ret < 0)
+		return ret;
+
+	ret = btrfs_del_item(trans, root, path);
+	return ret;
+}
+
 int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 			     u64 group_start, struct extent_map *em)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
-	struct btrfs_root *root = fs_info->extent_root;
 	struct btrfs_path *path;
 	struct btrfs_block_group *block_group;
 	struct btrfs_free_cluster *cluster;
@@ -1067,10 +1090,6 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 
 	spin_unlock(&block_group->space_info->lock);
 
-	key.objectid = block_group->start;
-	key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
-	key.offset = block_group->length;
-
 	mutex_lock(&fs_info->chunk_mutex);
 	spin_lock(&block_group->lock);
 	block_group->removed = 1;
@@ -1109,16 +1128,10 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	/* Once for the block groups rbtree */
 	btrfs_put_block_group(block_group);
 
-	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
-	if (ret > 0)
-		ret = -EIO;
+	ret = remove_block_group_item(trans, path, block_group);
 	if (ret < 0)
 		goto out;
 
-	ret = btrfs_del_item(trans, root, path);
-	if (ret)
-		goto out;
-
 	if (remove_em) {
 		struct extent_map_tree *em_tree;
 
-- 
2.26.2

