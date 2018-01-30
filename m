Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:42158 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751377AbeA3KU6 (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 30 Jan 2018 05:20:58 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH v2 2/2] btrfs: Refactor parameter of BTRFS_MAX_DEVS() from root to fs_info
Date: Tue, 30 Jan 2018 18:20:46 +0800
Message-Id: <20180130102046.10586-2-wqu@suse.com>
In-Reply-To: <20180130102046.10586-1-wqu@suse.com>
References: <20180130102046.10586-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
v2:
  Added tags.
---
 fs/btrfs/volumes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d818b1f9c625..215e85e22c8e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4581,7 +4581,7 @@ static void check_raid56_incompat_flag(struct btrfs_fs_info *info, u64 type)
 	btrfs_set_fs_incompat(info, RAID56);
 }
 
-#define BTRFS_MAX_DEVS(r) ((BTRFS_MAX_ITEM_SIZE(r->fs_info)		\
+#define BTRFS_MAX_DEVS(info) ((BTRFS_MAX_ITEM_SIZE(info)	\
 			- sizeof(struct btrfs_chunk))		\
 			/ sizeof(struct btrfs_stripe) + 1)
 
@@ -4638,7 +4638,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		max_stripe_size = SZ_1G;
 		max_chunk_size = 10 * max_stripe_size;
 		if (!devs_max)
-			devs_max = BTRFS_MAX_DEVS(info->chunk_root);
+			devs_max = BTRFS_MAX_DEVS(info);
 	} else if (type & BTRFS_BLOCK_GROUP_METADATA) {
 		/* for larger filesystems, use larger metadata chunks */
 		if (fs_devices->total_rw_bytes > 50ULL * SZ_1G)
@@ -4647,7 +4647,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 			max_stripe_size = SZ_256M;
 		max_chunk_size = max_stripe_size;
 		if (!devs_max)
-			devs_max = BTRFS_MAX_DEVS(info->chunk_root);
+			devs_max = BTRFS_MAX_DEVS(info);
 	} else if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
 		max_stripe_size = SZ_32M;
 		max_chunk_size = 2 * max_stripe_size;
-- 
2.16.1

