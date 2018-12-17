Return-Path: <SRS0=1mW1=O2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90D80C43612
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 08:36:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6973A2086C
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 08:36:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731835AbeLQIgH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Dec 2018 03:36:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:56812 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731821AbeLQIgG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Dec 2018 03:36:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 18212AC66
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2018 08:36:05 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/4] btrfs: Rename found_type to extent_type
Date:   Mon, 17 Dec 2018 10:35:59 +0200
Message-Id: <20181217083602.10166-2-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20181217083602.10166-1-nborisov@suse.com>
References: <20181217083602.10166-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

found_type really holds the type of extent and is guaranteed to to have
a value between [0, 2]. The only time it can contain anything different
is if btrfs_lookup_file_extent returned a positive value and the
previous item is different than an extent. Avoid this situation by
simply checking found_key.type rather than assigning the item type to
found_type intermittently. Also make the variable an u8 to reduce stack
usage. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 73ae4428d0df..fe25f66a98d9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6746,7 +6746,7 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 	u64 extent_start = 0;
 	u64 extent_end = 0;
 	u64 objectid = btrfs_ino(inode);
-	u32 found_type;
+	u8 extent_type;
 	struct btrfs_path *path = NULL;
 	struct btrfs_root *root = inode->root;
 	struct btrfs_file_extent_item *item;
@@ -6812,11 +6812,9 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 	leaf = path->nodes[0];
 	item = btrfs_item_ptr(leaf, path->slots[0],
 			      struct btrfs_file_extent_item);
-	/* are we inside the extent that was found? */
 	btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
-	found_type = found_key.type;
 	if (found_key.objectid != objectid ||
-	    found_type != BTRFS_EXTENT_DATA_KEY) {
+	    found_key.type != BTRFS_EXTENT_DATA_KEY) {
 		/*
 		 * If we backup past the first extent we want to move forward
 		 * and see if there is an extent in front of us, otherwise we'll
@@ -6827,16 +6825,16 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 		goto next;
 	}
 
-	found_type = btrfs_file_extent_type(leaf, item);
+	extent_type = btrfs_file_extent_type(leaf, item);
 	extent_start = found_key.offset;
-	if (found_type == BTRFS_FILE_EXTENT_REG ||
-	    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
+	if (extent_type == BTRFS_FILE_EXTENT_REG ||
+	    extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
 		extent_end = extent_start +
 		       btrfs_file_extent_num_bytes(leaf, item);
 
 		trace_btrfs_get_extent_show_fi_regular(inode, leaf, item,
 						       extent_start);
-	} else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
+	} else if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
 		size_t size;
 
 		size = btrfs_file_extent_ram_bytes(leaf, item);
@@ -6877,10 +6875,10 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 	btrfs_extent_item_to_extent_map(inode, path, item,
 			new_inline, em);
 
-	if (found_type == BTRFS_FILE_EXTENT_REG ||
-	    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
+	if (extent_type == BTRFS_FILE_EXTENT_REG ||
+	    extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
 		goto insert;
-	} else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
+	} else if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
 		unsigned long ptr;
 		char *map;
 		size_t size;
-- 
2.17.1

