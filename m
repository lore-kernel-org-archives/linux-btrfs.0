Return-Path: <SRS0=iUkD=SG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED2CC4360F
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 06:46:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D1EB206DF
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 06:46:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfDDGq1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Apr 2019 02:46:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:36492 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725904AbfDDGq1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Apr 2019 02:46:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7D9A2AE7D
        for <linux-btrfs@vger.kernel.org>; Thu,  4 Apr 2019 06:46:26 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v3.1 6/9] btrfs: extent-tree: Use btrfs_ref to refactor add_pinned_bytes()
Date:   Thu,  4 Apr 2019 14:45:34 +0800
Message-Id: <20190404064537.4031-7-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190404064537.4031-1-wqu@suse.com>
References: <20190404064537.4031-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Since add_pinned_bytes() only needs to know if the extent is metadata
and if it's a chunk tree extent, btrfs_ref is a perfect match for it, as
we don't need various owner/level trick to determine extent type.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 153cb7b9e41d..6f82dcf1528e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -756,14 +756,15 @@ static struct btrfs_space_info *__find_space_info(struct btrfs_fs_info *info,
 	return NULL;
 }
 
-static void add_pinned_bytes(struct btrfs_fs_info *fs_info, s64 num_bytes,
-			     bool metadata, u64 root_objectid)
+static void add_pinned_bytes(struct btrfs_fs_info *fs_info,
+			     struct btrfs_ref *ref)
 {
 	struct btrfs_space_info *space_info;
+	s64 num_bytes = -ref->len;
 	u64 flags;
 
-	if (metadata) {
-		if (root_objectid == BTRFS_CHUNK_TREE_OBJECTID)
+	if (ref->type == BTRFS_REF_METADATA) {
+		if (ref->tree_ref.root == BTRFS_CHUNK_TREE_OBJECTID)
 			flags = BTRFS_BLOCK_GROUP_SYSTEM;
 		else
 			flags = BTRFS_BLOCK_GROUP_METADATA;
@@ -2069,11 +2070,8 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 
 	btrfs_ref_tree_mod(fs_info, &generic_ref);
 
-	if (ret == 0 && old_ref_mod < 0 && new_ref_mod >= 0) {
-		bool metadata = owner < BTRFS_FIRST_FREE_OBJECTID;
-
-		add_pinned_bytes(fs_info, -num_bytes, metadata, root_objectid);
-	}
+	if (ret == 0 && old_ref_mod < 0 && new_ref_mod >= 0)
+		add_pinned_bytes(fs_info, &generic_ref);
 
 	return ret;
 }
@@ -7313,8 +7311,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 	}
 out:
 	if (pin)
-		add_pinned_bytes(fs_info, buf->len, true,
-				 root->root_key.objectid);
+		add_pinned_bytes(fs_info, &generic_ref);
 
 	if (last_ref) {
 		/*
@@ -7365,11 +7362,8 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 	if (root_objectid != BTRFS_TREE_LOG_OBJECTID)
 		btrfs_ref_tree_mod(fs_info, &generic_ref);
 
-	if (ret == 0 && old_ref_mod >= 0 && new_ref_mod < 0) {
-		bool metadata = owner < BTRFS_FIRST_FREE_OBJECTID;
-
-		add_pinned_bytes(fs_info, num_bytes, metadata, root_objectid);
-	}
+	if (ret == 0 && old_ref_mod >= 0 && new_ref_mod < 0)
+		add_pinned_bytes(fs_info, &generic_ref);
 
 	return ret;
 }
-- 
2.21.0

