Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49782 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754514AbdGKKr5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Jul 2017 06:47:57 -0400
From: Nikolay Borisov <nborisov@suse.com>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Remove redundant checks from btrfs_alloc_data_chunk_ondemand
Date: Tue, 11 Jul 2017 13:47:50 +0300
Message-Id: <1499770070-28334-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Many commits ago the data space_info in alloc_data_chunk_ondemand used to be
acquired from the inode. At that point commit
33b4d47f5e24 ("Btrfs: deal with NULL space info") got introduced to deal with
spurios cases where the space info could be null, following a rebalance.
Nowadays, however, the space info is referenced directly from the btrfs_fs_info
struct which is initialised at filesystem mount time. This makes the null
checks redundant, so remove them.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 375f8c728d91..f8aa512e9de5 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4199,9 +4199,9 @@ static u64 btrfs_space_info_used(struct btrfs_space_info *s_info,
 
 int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes)
 {
-	struct btrfs_space_info *data_sinfo;
 	struct btrfs_root *root = inode->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_space_info *data_sinfo = fs_info->data_sinfo;
 	u64 used;
 	int ret = 0;
 	int need_commit = 2;
@@ -4215,10 +4215,6 @@ int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes)
 		ASSERT(current->journal_info);
 	}
 
-	data_sinfo = fs_info->data_sinfo;
-	if (!data_sinfo)
-		goto alloc;
-
 again:
 	/* make sure we have enough space to handle the data first */
 	spin_lock(&data_sinfo->lock);
@@ -4236,7 +4232,7 @@ int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes)
 
 			data_sinfo->force_alloc = CHUNK_ALLOC_FORCE;
 			spin_unlock(&data_sinfo->lock);
-alloc:
+
 			alloc_target = btrfs_data_alloc_profile(fs_info);
 			/*
 			 * It is ugly that we don't call nolock join
@@ -4264,9 +4260,6 @@ int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes)
 				}
 			}
 
-			if (!data_sinfo)
-				data_sinfo = fs_info->data_sinfo;
-
 			goto again;
 		}
 
-- 
2.7.4

