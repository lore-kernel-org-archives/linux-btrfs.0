Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5956DC04E87
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 02:04:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2730721733
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 02:04:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2730721733
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbeI1I0O (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 04:26:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:58262 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726118AbeI1I0O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 04:26:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EE862ABB1
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 02:04:52 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/6] btrfs-progs: Replace root parameter using fs_info for reada_for_search()
Date:   Fri, 28 Sep 2018 10:04:42 +0800
Message-Id: <20180928020446.21467-3-wqu@suse.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180928020446.21467-1-wqu@suse.com>
References: <20180928020446.21467-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

As the @root parameter is only used to get @fs_info, use fs_info
directly instead.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds-restore.c |  4 ++--
 ctree.c        | 11 +++++------
 ctree.h        |  4 ++--
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index d12c1a924059..30ea8a7e93d1 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -259,7 +259,7 @@ again:
 		}
 
 		if (path->reada)
-			reada_for_search(root, path, level, slot, 0);
+			reada_for_search(fs_info, path, level, slot, 0);
 
 		next = read_node_slot(fs_info, c, slot);
 		if (extent_buffer_uptodate(next))
@@ -276,7 +276,7 @@ again:
 		if (!level)
 			break;
 		if (path->reada)
-			reada_for_search(root, path, level, 0, 0);
+			reada_for_search(fs_info, path, level, 0, 0);
 		next = read_node_slot(fs_info, next, 0);
 		if (!extent_buffer_uptodate(next))
 			goto again;
diff --git a/ctree.c b/ctree.c
index d8a6883aa85f..042fae19344d 100644
--- a/ctree.c
+++ b/ctree.c
@@ -1000,10 +1000,9 @@ static int noinline push_nodes_for_insert(struct btrfs_trans_handle *trans,
 /*
  * readahead one full node of leaves
  */
-void reada_for_search(struct btrfs_root *root, struct btrfs_path *path,
-			     int level, int slot, u64 objectid)
+void reada_for_search(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
+		      int level, int slot, u64 objectid)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct extent_buffer *node;
 	struct btrfs_disk_key disk_key;
 	u32 nritems;
@@ -1203,7 +1202,7 @@ again:
 				break;
 
 			if (should_reada)
-				reada_for_search(root, p, level, slot,
+				reada_for_search(fs_info, p, level, slot,
 						 key->objectid);
 
 			b = read_node_slot(fs_info, b, slot);
@@ -2902,7 +2901,7 @@ int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path)
 		}
 
 		if (path->reada)
-			reada_for_search(root, path, level, slot, 0);
+			reada_for_search(fs_info, path, level, slot, 0);
 
 		next = read_node_slot(fs_info, c, slot);
 		if (!extent_buffer_uptodate(next))
@@ -2919,7 +2918,7 @@ int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path)
 		if (!level)
 			break;
 		if (path->reada)
-			reada_for_search(root, path, level, 0, 0);
+			reada_for_search(fs_info, path, level, 0, 0);
 		next = read_node_slot(fs_info, next, 0);
 		if (!extent_buffer_uptodate(next))
 			return -EIO;
diff --git a/ctree.h b/ctree.h
index 4719962df67d..6df6075865c2 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2562,8 +2562,8 @@ btrfs_check_node(struct btrfs_root *root, struct btrfs_disk_key *parent_key,
 enum btrfs_tree_block_status
 btrfs_check_leaf(struct btrfs_root *root, struct btrfs_disk_key *parent_key,
 		 struct extent_buffer *buf);
-void reada_for_search(struct btrfs_root *root, struct btrfs_path *path,
-			     int level, int slot, u64 objectid);
+void reada_for_search(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
+		      int level, int slot, u64 objectid);
 struct extent_buffer *read_node_slot(struct btrfs_fs_info *fs_info,
 				   struct extent_buffer *parent, int slot);
 int btrfs_previous_item(struct btrfs_root *root,
-- 
2.19.0

