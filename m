Return-Path: <SRS0=zwEw=BD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07DC2C433E4
	for <linux-btrfs@archiver.kernel.org>; Fri, 24 Jul 2020 06:46:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3C992070B
	for <linux-btrfs@archiver.kernel.org>; Fri, 24 Jul 2020 06:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgGXGqP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 02:46:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:50238 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725942AbgGXGqP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Jul 2020 02:46:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1BD25AC20
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jul 2020 06:46:23 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: qgroup: fix wrong qgroup metadata reserve for delayed inode
Date:   Fri, 24 Jul 2020 14:46:09 +0800
Message-Id: <20200724064610.69442-1-wqu@suse.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

For delayed inode facility, qgroup metadata is reserved for it, and
later freed.

However we're freeing more bytes than we reserved.
In btrfs_delayed_inode_reserve_metadata():

	num_bytes = btrfs_calc_metadata_size(fs_info, 1);
	...
		ret = btrfs_qgroup_reserve_meta_prealloc(root,
				fs_info->nodesize, true);
		...
		if (!ret) {
			node->bytes_reserved = num_bytes;

But in btrfs_delayed_inode_release_metadata():

	if (qgroup_free)
		btrfs_qgroup_free_meta_prealloc(node->root,
				node->bytes_reserved);
	else
		btrfs_qgroup_convert_reserved_meta(node->root,
				node->bytes_reserved);

This means, we're always releasing more qgroup metadata rsv than we have
reserved.

This won't trigger selftest warning, as btrfs qgroup metadata rsv has
extra protection against cases like quota enabled half-way.

But we still need to fix this problem any way.

This patch will use the same num_bytes for qgroup metadata rsv so we
could handle it correctly.

Fixes: f218ea6c4792 ("btrfs: delayed-inode: Remove wrong qgroup meta reservation calls")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/delayed-inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index bf1595a42a98..0727b10a9a89 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -627,8 +627,7 @@ static int btrfs_delayed_inode_reserve_metadata(
 	 */
 	if (!src_rsv || (!trans->bytes_reserved &&
 			 src_rsv->type != BTRFS_BLOCK_RSV_DELALLOC)) {
-		ret = btrfs_qgroup_reserve_meta_prealloc(root,
-				fs_info->nodesize, true);
+		ret = btrfs_qgroup_reserve_meta_prealloc(root, num_bytes, true);
 		if (ret < 0)
 			return ret;
 		ret = btrfs_block_rsv_add(root, dst_rsv, num_bytes,
-- 
2.27.0

