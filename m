Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:42151 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750798AbeEKUNx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 16:13:53 -0400
Received: by mail-pl0-f68.google.com with SMTP id u6-v6so3862672pls.9
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 13:13:53 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH v4 03/12] Btrfs: don't BUG_ON() in btrfs_truncate_inode_items()
Date: Fri, 11 May 2018 13:13:31 -0700
Message-Id: <2970473d6aaaec84714be7c9d8d0750cd6bc5ec2.1526069051.git.osandov@fb.com>
In-Reply-To: <cover.1526069051.git.osandov@fb.com>
References: <cover.1526069051.git.osandov@fb.com>
In-Reply-To: <cover.1526069051.git.osandov@fb.com>
References: <cover.1526069051.git.osandov@fb.com>
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
index bfa0e094a60e..fa1da1991001 100644
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

