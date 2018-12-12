Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14F0BC04EB8
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 07:31:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C52302084E
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 07:31:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C52302084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbeLLHbt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 02:31:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:39718 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726317AbeLLHbt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 02:31:49 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EC4A5AE1F
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2018 07:31:47 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 6/8] btrfs: extent-tree: Use btrfs_ref to refactor add_pinned_bytes()
Date:   Wed, 12 Dec 2018 15:31:00 +0800
Message-Id: <20181212073102.7736-7-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181212073102.7736-1-wqu@suse.com>
References: <20181212073102.7736-1-wqu@suse.com>
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
index 6e0706195279..83662e9bde0f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -738,14 +738,15 @@ static struct btrfs_space_info *__find_space_info(struct btrfs_fs_info *info,
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
@@ -2052,11 +2053,8 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 
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
@@ -7054,8 +7052,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 	}
 out:
 	if (pin)
-		add_pinned_bytes(fs_info, buf->len, true,
-				 root->root_key.objectid);
+		add_pinned_bytes(fs_info, &generic_ref);
 
 	if (last_ref) {
 		/*
@@ -7106,11 +7103,8 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
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
2.19.2

