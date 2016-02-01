Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:36701 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806AbcBALyB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Feb 2016 06:54:01 -0500
Received: by mail-lb0-f170.google.com with SMTP id dx2so73214990lbd.3
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Feb 2016 03:54:00 -0800 (PST)
Date: Mon, 1 Feb 2016 12:53:57 +0100
From: Ben Marsh <bmarsh94@gmail.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] fs: btrfs: fixes a pass by reference issue in send.c
Message-ID: <20160201115350.GA9678@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch fixes a pointer issue from passing a struct as a parameter
to the function btrfs_root_dec_send_in_progress.

Signed-off-by: Ben Marsh <bmarsh94@gmail.com>
---
 fs/btrfs/send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 63a6152..47ee63e 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -5911,7 +5911,7 @@ commit_trans:
 	return btrfs_commit_transaction(trans, sctx->send_root);
 }
 
-static void btrfs_root_dec_send_in_progress(struct btrfs_root* root)
+static void btrfs_root_dec_send_in_progress(struct btrfs_root *root)
 {
 	spin_lock(&root->root_item_lock);
 	root->send_in_progress--;
-- 
1.9.1

