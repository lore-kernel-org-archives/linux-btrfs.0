Return-Path: <SRS0=Lj+K=TK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88403C04A6B
	for <linux-btrfs@archiver.kernel.org>; Fri, 10 May 2019 04:45:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5752B217F9
	for <linux-btrfs@archiver.kernel.org>; Fri, 10 May 2019 04:45:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbfEJEpO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 10 May 2019 00:45:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:38704 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725904AbfEJEpO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 May 2019 00:45:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DB81CAE4E;
        Fri, 10 May 2019 04:45:12 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     kernel test robot <rong.a.chen@intel.com>
Subject: [PATCH] btrfs: extent-tree: Fix a bug that btrfs is unable to add pinned bytes
Date:   Fri, 10 May 2019 12:45:05 +0800
Message-Id: <20190510044505.17422-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Commit ddf30cf03fb5 ("btrfs: extent-tree: Use btrfs_ref to refactor
add_pinned_bytes()") refactored add_pinned_bytes(), but during that
refactor, there are two callers which add the pinned bytes instead
of subtracting.

That refactor misses those two caller, causing incorrect pinned bytes
calculation and resulting unexpected ENOSPC error.

Fix it by adding a new parameter @sign to restore the original behavior.

Reported-by: kernel test robot <rong.a.chen@intel.com>
Fixes: ddf30cf03fb5 ("btrfs: extent-tree: Use btrfs_ref to refactor add_pinned_bytes()")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent-tree.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f79e477a378e..8592d31e321c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -757,12 +757,14 @@ static struct btrfs_space_info *__find_space_info(struct btrfs_fs_info *info,
 }
 
 static void add_pinned_bytes(struct btrfs_fs_info *fs_info,
-			     struct btrfs_ref *ref)
+			     struct btrfs_ref *ref, int sign)
 {
 	struct btrfs_space_info *space_info;
-	s64 num_bytes = -ref->len;
+	s64 num_bytes;
 	u64 flags;
 
+	ASSERT(sign == 1 || sign == -1);
+	num_bytes = sign * ref->len;
 	if (ref->type == BTRFS_REF_METADATA) {
 		if (ref->tree_ref.root == BTRFS_CHUNK_TREE_OBJECTID)
 			flags = BTRFS_BLOCK_GROUP_SYSTEM;
@@ -2063,7 +2065,7 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	btrfs_ref_tree_mod(fs_info, generic_ref);
 
 	if (ret == 0 && old_ref_mod < 0 && new_ref_mod >= 0)
-		add_pinned_bytes(fs_info, generic_ref);
+		add_pinned_bytes(fs_info, generic_ref, -1);
 
 	return ret;
 }
@@ -7190,7 +7192,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 	}
 out:
 	if (pin)
-		add_pinned_bytes(fs_info, &generic_ref);
+		add_pinned_bytes(fs_info, &generic_ref, 1);
 
 	if (last_ref) {
 		/*
@@ -7238,7 +7240,7 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans, struct btrfs_ref *ref)
 		btrfs_ref_tree_mod(fs_info, ref);
 
 	if (ret == 0 && old_ref_mod >= 0 && new_ref_mod < 0)
-		add_pinned_bytes(fs_info, ref);
+		add_pinned_bytes(fs_info, ref, 1);
 
 	return ret;
 }
-- 
2.21.0

