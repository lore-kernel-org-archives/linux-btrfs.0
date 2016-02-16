Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:34269 "EHLO
	mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953AbcBPIC6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Feb 2016 03:02:58 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] btrfs: fix build warning
Date: Tue, 16 Feb 2016 13:32:47 +0530
Message-Id: <1455609767-26992-1-git-send-email-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We were getting build warning about:
fs/btrfs/extent-tree.c:7021:34: warning: ‘used_bg’ may be used
	uninitialized in this function

It is not a valid warning as used_bg is never used uninitilized since
locked is initially false so we can never be in the section where
'used_bg' is used. But gcc is not able to understand that and we can
initialize it while declaring to silence the warning.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 fs/btrfs/extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e2287c7..f24e4c3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7018,7 +7018,7 @@ btrfs_lock_cluster(struct btrfs_block_group_cache *block_group,
 		   struct btrfs_free_cluster *cluster,
 		   int delalloc)
 {
-	struct btrfs_block_group_cache *used_bg;
+	struct btrfs_block_group_cache *used_bg = NULL;
 	bool locked = false;
 again:
 	spin_lock(&cluster->refill_lock);
-- 
1.9.1

