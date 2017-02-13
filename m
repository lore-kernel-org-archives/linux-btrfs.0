Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41796 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752355AbdBMJey (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 04:34:54 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 95A93ABD9
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 09:34:48 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 19/29] btrfs: remove unused parameter from __btrfs_alloc_chunk
Date: Mon, 13 Feb 2017 10:34:19 +0100
Message-Id: <d14782aff5d269a5875faf845938f3cf2d122295.1486977712.git.dsterba@suse.com>
In-Reply-To: <cover.1486977711.git.dsterba@suse.com>
References: <cover.1486977711.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We grab fs_info from other parameters.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3c3c69c0eee4..d234625e4e02 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4584,8 +4584,7 @@ static void check_raid56_incompat_flag(struct btrfs_fs_info *info, u64 type)
 				/ sizeof(struct btrfs_stripe) + 1)
 
 static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
-			       struct btrfs_fs_info *fs_info, u64 start,
-			       u64 type)
+			       u64 start, u64 type)
 {
 	struct btrfs_fs_info *info = trans->fs_info;
 	struct btrfs_fs_devices *fs_devices = info->fs_devices;
@@ -5009,7 +5008,7 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 
 	ASSERT(mutex_is_locked(&fs_info->chunk_mutex));
 	chunk_offset = find_next_chunk(fs_info);
-	return __btrfs_alloc_chunk(trans, fs_info, chunk_offset, type);
+	return __btrfs_alloc_chunk(trans, chunk_offset, type);
 }
 
 static noinline int init_first_rw_device(struct btrfs_trans_handle *trans,
@@ -5024,14 +5023,13 @@ static noinline int init_first_rw_device(struct btrfs_trans_handle *trans,
 
 	chunk_offset = find_next_chunk(fs_info);
 	alloc_profile = btrfs_get_alloc_profile(extent_root, 0);
-	ret = __btrfs_alloc_chunk(trans, fs_info, chunk_offset, alloc_profile);
+	ret = __btrfs_alloc_chunk(trans, chunk_offset, alloc_profile);
 	if (ret)
 		return ret;
 
 	sys_chunk_offset = find_next_chunk(fs_info);
 	alloc_profile = btrfs_get_alloc_profile(fs_info->chunk_root, 0);
-	ret = __btrfs_alloc_chunk(trans, fs_info, sys_chunk_offset,
-				  alloc_profile);
+	ret = __btrfs_alloc_chunk(trans, sys_chunk_offset, alloc_profile);
 	return ret;
 }
 
-- 
2.10.1

