Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:50796 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752462AbeBVGro (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 22 Feb 2018 01:47:44 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH v3 1/9] btrfs-progs: Refactor parameter of BTRFS_MAX_DEVS() from root to fs_info
Date: Thu, 22 Feb 2018 14:47:25 +0800
Message-Id: <20180222064733.12126-2-wqu@suse.com>
In-Reply-To: <20180222064733.12126-1-wqu@suse.com>
References: <20180222064733.12126-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 volumes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/volumes.c b/volumes.c
index edad367b593c..677d085de96c 100644
--- a/volumes.c
+++ b/volumes.c
@@ -826,7 +826,7 @@ error:
 	return ret;
 }
 
-#define BTRFS_MAX_DEVS(r) ((BTRFS_LEAF_DATA_SIZE(r->fs_info)	\
+#define BTRFS_MAX_DEVS(info) ((BTRFS_LEAF_DATA_SIZE(info)	\
 			- sizeof(struct btrfs_item)		\
 			- sizeof(struct btrfs_chunk))		\
 			/ sizeof(struct btrfs_stripe) + 1)
@@ -882,12 +882,12 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 			calc_size = SZ_1G;
 			max_chunk_size = 10 * calc_size;
 			min_stripe_size = SZ_64M;
-			max_stripes = BTRFS_MAX_DEVS(chunk_root);
+			max_stripes = BTRFS_MAX_DEVS(info);
 		} else if (type & BTRFS_BLOCK_GROUP_METADATA) {
 			calc_size = SZ_1G;
 			max_chunk_size = 4 * calc_size;
 			min_stripe_size = SZ_32M;
-			max_stripes = BTRFS_MAX_DEVS(chunk_root);
+			max_stripes = BTRFS_MAX_DEVS(info);
 		}
 	}
 	if (type & BTRFS_BLOCK_GROUP_RAID1) {
-- 
2.16.2

