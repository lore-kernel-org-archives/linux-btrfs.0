Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57401 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752446AbdBOV2n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 16:28:43 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D9EBEAD9F
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Feb 2017 21:28:41 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 6/8] btrfs: btrfs_truncate_free_space_cache always allocates path
Date: Wed, 15 Feb 2017 16:28:32 -0500
Message-Id: <1487194114-12786-7-git-send-email-jeffm@suse.com>
In-Reply-To: <1487194114-12786-1-git-send-email-jeffm@suse.com>
References: <1487194114-12786-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

btrfs_truncate_free_space_cache always allocates a btrfs_path structure
but only uses it when the caller passes a block group.  Let's move the
allocation and free into the conditional.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/free-space-cache.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index a1e15f6..5240163 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -228,15 +228,14 @@ int btrfs_truncate_free_space_cache(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret = 0;
-	struct btrfs_path *path = btrfs_alloc_path();
 	bool locked = false;
 
-	if (!path) {
-		ret = -ENOMEM;
-		goto fail;
-	}
-
 	if (block_group) {
+		struct btrfs_path *path = btrfs_alloc_path();
+		if (!path) {
+			ret = -ENOMEM;
+			goto fail;
+		}
 		locked = true;
 		mutex_lock(&trans->transaction->cache_write_mutex);
 		if (!list_empty(&block_group->io_list)) {
@@ -253,8 +252,8 @@ int btrfs_truncate_free_space_cache(struct btrfs_trans_handle *trans,
 		spin_lock(&block_group->lock);
 		block_group->disk_cache_state = BTRFS_DC_CLEAR;
 		spin_unlock(&block_group->lock);
+		btrfs_free_path(path);
 	}
-	btrfs_free_path(path);
 
 	btrfs_i_size_write(inode, 0);
 	truncate_pagecache(inode, 0);
-- 
2.7.1

