Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49944 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387921AbeGTR1B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 13:27:01 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 21BC7AD3E
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Jul 2018 16:37:57 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 6/7] btrfs: Remove fs_info form btrfs_free_chunk
Date: Fri, 20 Jul 2018 19:37:52 +0300
Message-Id: <1532104673-28311-7-git-send-email-nborisov@suse.com>
In-Reply-To: <1532104673-28311-1-git-send-email-nborisov@suse.com>
References: <1532104673-28311-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be referenced from the passed transaction handle.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 241875277a7e..7376c83708e4 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2597,9 +2597,9 @@ int btrfs_grow_device(struct btrfs_trans_handle *trans,
 	return btrfs_update_device(trans, device);
 }
 
-static int btrfs_free_chunk(struct btrfs_trans_handle *trans,
-			    struct btrfs_fs_info *fs_info, u64 chunk_offset)
+static int btrfs_free_chunk(struct btrfs_trans_handle *trans, u64 chunk_offset)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_root *root = fs_info->chunk_root;
 	int ret;
 	struct btrfs_path *path;
@@ -2769,7 +2769,7 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
 	}
 	mutex_unlock(&fs_devices->device_list_mutex);
 
-	ret = btrfs_free_chunk(trans, fs_info, chunk_offset);
+	ret = btrfs_free_chunk(trans, chunk_offset);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		goto out;
-- 
2.7.4

