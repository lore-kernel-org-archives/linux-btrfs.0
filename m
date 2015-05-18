Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:37666 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754044AbbERSMM (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Mon, 18 May 2015 14:12:12 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: fix racy system chunk allocation when setting block group ro
Date: Mon, 18 May 2015 19:11:40 +0100
Message-Id: <1431972715-16833-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If while setting a block group read-only we end up allocating a system
chunk, through check_system_chunk(), we were not doing it while holding
the chunk mutex which is a problem if a concurrent chunk allocation is
happening, through do_chunk_alloc(), as it means both block groups can
end up using the same logical addresses and physical regions in the
device(s). So make sure we hold the chunk mutex.

Cc: stable@vger.kernel.org  # 4.0+
Fixes: 2f0810880f08 ("btrfs: delete chunk allocation attemp when
                      setting block group ro")

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent-tree.c | 2 ++
 fs/btrfs/volumes.c     | 1 +
 2 files changed, 3 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4bf489b..1d757d8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8846,7 +8846,9 @@ again:
 out:
 	if (cache->flags & BTRFS_BLOCK_GROUP_SYSTEM) {
 		alloc_flags = update_block_group_flags(root, cache->flags);
+		lock_chunks(root->fs_info->chunk_root);
 		check_system_chunk(trans, root, alloc_flags);
+		unlock_chunks(root->fs_info->chunk_root);
 	}
 	mutex_unlock(&root->fs_info->ro_block_group_mutex);
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 56b91ed..d2b276c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4641,6 +4641,7 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 {
 	u64 chunk_offset;
 
+	ASSERT(mutex_is_locked(&extent_root->fs_info->chunk_mutex));
 	chunk_offset = find_next_chunk(extent_root->fs_info);
 	return __btrfs_alloc_chunk(trans, extent_root, chunk_offset, type);
 }
-- 
2.1.3

