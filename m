Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11FEAC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4AA020700
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730180AbfCYSpS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:45:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:38934 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728991AbfCYSpR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 14:45:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 67331AF94
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 18:45:16 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CFFF5DA98F; Mon, 25 Mar 2019 19:46:29 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 07/30] btrfs: get fs_info from eb in tree_mod_log_eb_copy
Date:   Mon, 25 Mar 2019 19:46:29 +0100
Message-Id: <afb83a1db90eeb91545bb5e49f31bcd83e258bde.1553539114.git.dsterba@suse.com>
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
 fs/btrfs/ctree.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 5be2beef18be..b83627a372b1 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -726,11 +726,11 @@ tree_mod_log_search(struct btrfs_fs_info *fs_info, u64 start, u64 min_seq)
 	return __tree_mod_log_search(fs_info, start, min_seq, 0);
 }
 
-static noinline int
-tree_mod_log_eb_copy(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
+static noinline int tree_mod_log_eb_copy(struct extent_buffer *dst,
 		     struct extent_buffer *src, unsigned long dst_offset,
 		     unsigned long src_offset, int nr_items)
 {
+	struct btrfs_fs_info *fs_info = dst->fs_info;
 	int ret = 0;
 	struct tree_mod_elem **tm_list = NULL;
 	struct tree_mod_elem **tm_list_add, **tm_list_rem;
@@ -3249,8 +3249,7 @@ static int push_node_left(struct btrfs_trans_handle *trans,
 	} else
 		push_items = min(src_nritems - 8, push_items);
 
-	ret = tree_mod_log_eb_copy(fs_info, dst, src, dst_nritems, 0,
-				   push_items);
+	ret = tree_mod_log_eb_copy(dst, src, dst_nritems, 0, push_items);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		return ret;
@@ -3325,8 +3324,8 @@ static int balance_node_right(struct btrfs_trans_handle *trans,
 				      (dst_nritems) *
 				      sizeof(struct btrfs_key_ptr));
 
-	ret = tree_mod_log_eb_copy(fs_info, dst, src, 0,
-				   src_nritems - push_items, push_items);
+	ret = tree_mod_log_eb_copy(dst, src, 0, src_nritems - push_items,
+				   push_items);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		return ret;
@@ -3511,7 +3510,7 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
 	root_add_used(root, fs_info->nodesize);
 	ASSERT(btrfs_header_level(c) == level);
 
-	ret = tree_mod_log_eb_copy(fs_info, split, c, 0, mid, c_nritems - mid);
+	ret = tree_mod_log_eb_copy(split, c, 0, mid, c_nritems - mid);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		return ret;
-- 
2.21.0

