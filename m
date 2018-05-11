Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:41661 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752191AbeEKH4Y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 03:56:24 -0400
Received: by mail-pl0-f67.google.com with SMTP id az12-v6so2837382plb.8
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 00:56:23 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v3 03/11] Btrfs: don't BUG_ON() in btrfs_truncate_inode_items()
Date: Fri, 11 May 2018 00:56:08 -0700
Message-Id: <e25636f289e24efd153f7b353321c387b5317e96.1526025007.git.osandov@fb.com>
In-Reply-To: <cover.1526025007.git.osandov@fb.com>
References: <cover.1526025007.git.osandov@fb.com>
In-Reply-To: <cover.1526025007.git.osandov@fb.com>
References: <cover.1526025007.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

btrfs_free_extent() can fail because of ENOMEM. There's no reason to
panic here, we can just abort the transaction.

Fixes: f4b9aa8d3b87 ("btrfs_truncate")
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/inode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 79d1da01a90d..bd4975476f0e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4655,7 +4655,10 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 						extent_num_bytes, 0,
 						btrfs_header_owner(leaf),
 						ino, extent_offset);
-			BUG_ON(ret);
+			if (ret) {
+				btrfs_abort_transaction(trans, ret);
+				break;
+			}
 			if (btrfs_should_throttle_delayed_refs(trans, fs_info))
 				btrfs_async_run_delayed_refs(fs_info,
 					trans->delayed_ref_updates * 2,
-- 
2.17.0

