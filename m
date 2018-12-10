Return-Path: <SRS0=qyTl=OT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63CB9C04EB8
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Dec 2018 07:01:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BEEA2081C
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Dec 2018 07:01:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2BEEA2081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbeLJHBJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 10 Dec 2018 02:01:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:43324 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726292AbeLJHBJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Dec 2018 02:01:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 347CEAF68
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Dec 2018 07:01:08 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: extent-tree: cleanup one-shot usage of @blocksize in do_walk_down
Date:   Mon, 10 Dec 2018 15:01:03 +0800
Message-Id: <20181210070103.10073-1-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

@blocksize variable in do_walk_down() is only used once, really no need
to declare it.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent-tree.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 225698b588c4..6744f2fa2b03 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8577,7 +8577,6 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 	u64 bytenr;
 	u64 generation;
 	u64 parent;
-	u32 blocksize;
 	struct btrfs_key key;
 	struct btrfs_key first_key;
 	struct extent_buffer *next;
@@ -8602,7 +8601,6 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 	bytenr = btrfs_node_blockptr(path->nodes[level], path->slots[level]);
 	btrfs_node_key_to_cpu(path->nodes[level], &first_key,
 			      path->slots[level]);
-	blocksize = fs_info->nodesize;
 
 	next = find_extent_buffer(fs_info, bytenr);
 	if (!next) {
@@ -8726,7 +8724,7 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 					     ret);
 			}
 		}
-		ret = btrfs_free_extent(trans, root, bytenr, blocksize,
+		ret = btrfs_free_extent(trans, root, bytenr, fs_info->nodesize,
 					parent, root->root_key.objectid,
 					level - 1, 0, false);
 		if (ret)
-- 
2.19.2

