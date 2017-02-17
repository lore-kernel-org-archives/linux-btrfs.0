Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:33765 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934558AbdBQOoX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:44:23 -0500
Received: by mail-wr0-f194.google.com with SMTP id i10so5521093wrb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:44:23 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 36/38] btrfs: Make check_extent_to_block take btrfs_inode
Date: Fri, 17 Feb 2017 16:43:27 +0200
Message-Id: <1487342609-20652-37-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/scrub.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index bdf58b0eaef8..9a747ed9116d 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -4236,7 +4236,7 @@ static void copy_nocow_pages_worker(struct btrfs_work *work)
 	scrub_pending_trans_workers_dec(sctx);
 }
 
-static int check_extent_to_block(struct inode *inode, u64 start, u64 len,
+static int check_extent_to_block(struct btrfs_inode *inode, u64 start, u64 len,
 				 u64 logical)
 {
 	struct extent_state *cached_state = NULL;
@@ -4246,10 +4246,10 @@ static int check_extent_to_block(struct inode *inode, u64 start, u64 len,
 	u64 lockstart = start, lockend = start + len - 1;
 	int ret = 0;
 
-	io_tree = &BTRFS_I(inode)->io_tree;
+	io_tree = &inode->io_tree;
 
 	lock_extent_bits(io_tree, lockstart, lockend, &cached_state);
-	ordered = btrfs_lookup_ordered_range(BTRFS_I(inode), lockstart, len);
+	ordered = btrfs_lookup_ordered_range(inode, lockstart, len);
 	if (ordered) {
 		btrfs_put_ordered_extent(ordered);
 		ret = 1;
@@ -4325,7 +4325,7 @@ static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root,
 	io_tree = &BTRFS_I(inode)->io_tree;
 	nocow_ctx_logical = nocow_ctx->logical;
 
-	ret = check_extent_to_block(inode, offset, len, nocow_ctx_logical);
+	ret = check_extent_to_block(BTRFS_I(inode), offset, len, nocow_ctx_logical);
 	if (ret) {
 		ret = ret > 0 ? 0 : ret;
 		goto out;
@@ -4372,7 +4372,7 @@ static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root,
 			}
 		}
 
-		ret = check_extent_to_block(inode, offset, len,
+		ret = check_extent_to_block(BTRFS_I(inode), offset, len,
 					    nocow_ctx_logical);
 		if (ret) {
 			ret = ret > 0 ? 0 : ret;
-- 
2.7.4

