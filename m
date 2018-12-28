Return-Path: <SRS0=VlvV=PF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4820EC43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Dec 2018 08:38:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17DAC20866
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Dec 2018 08:38:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731668AbeL1IiW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Dec 2018 03:38:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:34530 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731664AbeL1IiV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Dec 2018 03:38:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 28E22AD54
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Dec 2018 08:38:20 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 6/6] btrfs-progs: check: Introduce support for bg-tree feature
Date:   Fri, 28 Dec 2018 16:38:06 +0800
Message-Id: <20181228083806.3204-7-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20181228083806.3204-1-wqu@suse.com>
References: <20181228083806.3204-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

For original mode BLOCK_GROUP_ITEM can occur in bg tree.

For lowmem mode just check BLOCK_GROUP_ITEM in bg tree if the that
feature is set.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c        | 3 ++-
 check/mode-lowmem.c | 9 +++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/check/main.c b/check/main.c
index 54ab146d0d13..255f762db3c3 100644
--- a/check/main.c
+++ b/check/main.c
@@ -6013,7 +6013,8 @@ static int check_type_with_root(u64 rootid, u8 key_type)
 	case BTRFS_EXTENT_ITEM_KEY:
 	case BTRFS_METADATA_ITEM_KEY:
 	case BTRFS_BLOCK_GROUP_ITEM_KEY:
-		if (rootid != BTRFS_EXTENT_TREE_OBJECTID)
+		if (rootid != BTRFS_EXTENT_TREE_OBJECTID &&
+		    rootid != BTRFS_BLOCK_GROUP_TREE_OBJECTID)
 			goto err;
 		break;
 	case BTRFS_ROOT_ITEM_KEY:
diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 7bb079a98ea9..acfffe1fef87 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -4229,7 +4229,7 @@ next:
 static int check_chunk_item(struct btrfs_fs_info *fs_info,
 			    struct extent_buffer *eb, int slot)
 {
-	struct btrfs_root *extent_root = fs_info->extent_root;
+	struct btrfs_root *root;
 	struct btrfs_root *dev_root = fs_info->dev_root;
 	struct btrfs_path path;
 	struct btrfs_key chunk_key;
@@ -4251,6 +4251,11 @@ static int check_chunk_item(struct btrfs_fs_info *fs_info,
 	int ret;
 	int err = 0;
 
+	if (btrfs_fs_incompat(fs_info, BG_TREE))
+		root = fs_info->bg_root;
+	else
+		root = fs_info->extent_root;
+
 	btrfs_item_key_to_cpu(eb, &chunk_key, slot);
 	chunk = btrfs_item_ptr(eb, slot, struct btrfs_chunk);
 	length = btrfs_chunk_length(eb, chunk);
@@ -4270,7 +4275,7 @@ static int check_chunk_item(struct btrfs_fs_info *fs_info,
 	bg_key.offset = length;
 
 	btrfs_init_path(&path);
-	ret = btrfs_search_slot(NULL, extent_root, &bg_key, &path, 0, 0);
+	ret = btrfs_search_slot(NULL, root, &bg_key, &path, 0, 0);
 	if (ret) {
 		error(
 		"chunk[%llu %llu) did not find the related block group item",
-- 
2.20.1

