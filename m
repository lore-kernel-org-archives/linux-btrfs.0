Return-Path: <SRS0=UUkT=6P=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14839C4724C
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 May 2020 05:30:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E54412073E
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 May 2020 05:30:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgEAFaC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 1 May 2020 01:30:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:51578 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbgEAFaC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 May 2020 01:30:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id ABF08AEFD
        for <linux-btrfs@vger.kernel.org>; Fri,  1 May 2020 05:30:00 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Don't abuse READA_* for extent tree search
Date:   Fri,  1 May 2020 13:29:56 +0800
Message-Id: <20200501052956.29354-1-wqu@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

For extent tree search, we are only search two things: either
EXTENT_ITEM/METADATA_ITEM (inlined) or SHARED_BLOCK_REF/SHARED_DATA_REF
(keyed).

Except certain situation like cache_block_group(), we never read tree
blocks in a forward or backward sequence.

So remove those reada abuse.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 extent-tree.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index 4af8f4ba8a47..732f90207b25 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1247,8 +1247,6 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
-	path->reada = READA_BACK;
-
 	ret = insert_inline_extent_backref(trans, root->fs_info->extent_root,
 					   path, bytenr, num_bytes, parent,
 					   root_objectid, owner, offset, 1);
@@ -1268,8 +1266,6 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_release_path(path);
 
-	path->reada = READA_BACK;
-
 	/* now insert the actual backref */
 	ret = insert_extent_backref(trans, root->fs_info->extent_root,
 				    path, bytenr, parent, root_objectid,
@@ -1303,7 +1299,6 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-	path->reada = READA_BACK;
 
 	key.objectid = bytenr;
 	key.offset = offset;
@@ -1383,7 +1378,6 @@ int btrfs_set_block_flags(struct btrfs_trans_handle *trans, u64 bytenr,
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-	path->reada = READA_BACK;
 
 	key.objectid = bytenr;
 	if (skinny_metadata) {
@@ -1928,8 +1922,6 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
-	path->reada = READA_BACK;
-
 	is_data = owner_objectid >= BTRFS_FIRST_FREE_OBJECTID;
 	if (is_data)
 		skinny_metadata = 0;
-- 
2.26.2

