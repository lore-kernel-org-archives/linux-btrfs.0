Return-Path: <SRS0=AHcI=SS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53552C10F14
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 10:21:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C7F1206BA
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 10:21:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729032AbfDPKVz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Apr 2019 06:21:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:50704 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726686AbfDPKVy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Apr 2019 06:21:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8C451AFFB
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2019 10:21:53 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: Do metadata preallocation for fs trees and csum tree
Date:   Tue, 16 Apr 2019 18:21:44 +0800
Message-Id: <20190416102144.12173-3-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190416102144.12173-1-wqu@suse.com>
References: <20190416102144.12173-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In github issues, one user reports unexpected ENOSPC error if enabling
datasum druing convert.  After some investigation, it looks like that
during ext2_saved/image creation, we could create large file extent
whose size can be 128M (max data extent size).

In that case, its csum block will be at least 128K. Under certain case
we need to allocate extra metadata chunks to fulfill such space
requirement.

However we only do metadata prealloc if we're reserving extents for fs
trees.  (we use btrfs_root::ref_cows to determine whether we should do
metadata prealloc, and that member is only set for fs trees).

There is no explaination on why we only do metadata prealloc for file
trees, but from my educated guess, it could be related to avoid nested
extent/chunk tree modication.

At least extent reservation for csum tree shouldn't be a problem with
metadata block group preallocation.

So adding new condition for metadata preallocate to avoid unexpected
ENOSPC problem.

Issue: #123
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 extent-tree.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/extent-tree.c b/extent-tree.c
index e25ddf02e5cc..cf2e29258dfb 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -2518,7 +2518,13 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 		profile = BTRFS_BLOCK_GROUP_METADATA | alloc_profile;
 	}
 
-	if (root->ref_cows) {
+	/*
+	 * Also preallocate metadata for csum tree and fs trees (root->ref_cows
+	 * already set), as they can consume a lot of metadata space.
+	 * Pre-allocate to avoid unexpected ENOSPC.
+	 */
+	if (root->ref_cows ||
+	    root->root_key.objectid == BTRFS_CSUM_TREE_OBJECTID) {
 		if (!(profile & BTRFS_BLOCK_GROUP_METADATA)) {
 			ret = do_chunk_alloc(trans, info,
 					     num_bytes,
-- 
2.21.0

