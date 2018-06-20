Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48966 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754089AbeFTMt0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:49:26 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9F10AADBD
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 12:49:25 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 21/34] btrfs: Remove fs_info from cleanup_ref_head
Date: Wed, 20 Jun 2018 15:49:03 +0300
Message-Id: <1529498956-4241-22-git-send-email-nborisov@suse.com>
In-Reply-To: <1529498956-4241-1-git-send-email-nborisov@suse.com>
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fs_info can be refenreced from the transaction handle, since it's always
valid. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index da0c222c013d..95361d4195bc 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2531,9 +2531,10 @@ static int cleanup_extent_op(struct btrfs_trans_handle *trans,
 }
 
 static int cleanup_ref_head(struct btrfs_trans_handle *trans,
-			    struct btrfs_fs_info *fs_info,
 			    struct btrfs_delayed_ref_head *head)
 {
+
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	int ret;
 
@@ -2688,7 +2689,7 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 		 * up and move on to the next ref_head.
 		 */
 		if (!ref) {
-			ret = cleanup_ref_head(trans, fs_info, locked_ref);
+			ret = cleanup_ref_head(trans, locked_ref);
 			if (ret > 0 ) {
 				/* We dropped our lock, we need to loop. */
 				ret = 0;
-- 
2.7.4

