Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:33095 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752585AbdI2Toi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 15:44:38 -0400
Received: by mail-qk0-f193.google.com with SMTP id b82so20860qkc.0
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Sep 2017 12:44:37 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 21/21] btrfs: add assertions for releasing trans handle reservations
Date: Fri, 29 Sep 2017 15:44:05 -0400
Message-Id: <1506714245-23072-22-git-send-email-jbacik@fb.com>
In-Reply-To: <1506714245-23072-1-git-send-email-jbacik@fb.com>
References: <1506714245-23072-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These are useful for debugging problems where we mess with
trans->block_rsv to make sure we're not screwing something up.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index dc966978ca7b..0bdc10b453b9 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5897,12 +5897,15 @@ static void release_global_block_rsv(struct btrfs_fs_info *fs_info)
 void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans,
 				  struct btrfs_fs_info *fs_info)
 {
-	if (!trans->block_rsv)
+	if (!trans->block_rsv) {
+		ASSERT(!trans->bytes_reserved);
 		return;
+	}
 
 	if (!trans->bytes_reserved)
 		return;
 
+	ASSERT(trans->block_rsv == &fs_info->trans_block_rsv);
 	trace_btrfs_space_reservation(fs_info, "transaction",
 				      trans->transid, trans->bytes_reserved, 0);
 	btrfs_block_rsv_release(fs_info, trans->block_rsv,
-- 
2.7.4

