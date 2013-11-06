Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56128 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889Ab3KFXP6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Nov 2013 18:15:58 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 12/16] btrfs-progs: remove more dead code from check_extent_refs
Date: Wed,  6 Nov 2013 17:15:51 -0600
Message-Id: <1383779755-18228-13-git-send-email-sandeen@redhat.com>
In-Reply-To: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
References: <1383779755-18228-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

e0a04278 removed a bunch of dead code but left one little
bit; reinit is always 0, so btrfs_read_block_groups is
never called from here.

Resolves-Coverity-CID: 1125926
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 cmds-check.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 668af15..263b4ef 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -5040,7 +5040,6 @@ static int check_extent_refs(struct btrfs_trans_handle *trans,
 	int err = 0;
 	int ret = 0;
 	int fixed = 0;
-	int reinit = 0;
 	int had_dups = 0;
 
 	if (repair) {
@@ -5066,8 +5065,6 @@ static int check_extent_refs(struct btrfs_trans_handle *trans,
 			cache = next_cache_extent(cache);
 		}
 		prune_corrupt_blocks(trans, root->fs_info);
-		if (reinit)
-			btrfs_read_block_groups(root->fs_info->extent_root);
 		reset_cached_block_groups(root->fs_info);
 	}
 
-- 
1.7.1

