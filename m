Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22220 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932212AbdERDjb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 23:39:31 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 25/32] btrfs-progs: Refactor sectorsize in convert/source-fs.c
Date: Thu, 18 May 2017 11:38:50 +0800
Message-ID: <20170518033857.15002-26-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
References: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 convert/source-fs.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/convert/source-fs.c b/convert/source-fs.c
index 80e4e418..59e36095 100644
--- a/convert/source-fs.c
+++ b/convert/source-fs.c
@@ -68,9 +68,10 @@ int block_iterate_proc(u64 disk_block, u64 file_block,
 	int do_barrier;
 	struct btrfs_root *root = idata->root;
 	struct btrfs_block_group_cache *cache;
-	u64 bytenr = disk_block * root->sectorsize;
+	u32 sectorsize = root->fs_info->sectorsize;
+	u64 bytenr = disk_block * sectorsize;
 
-	sb_region = intersect_with_sb(bytenr, root->sectorsize);
+	sb_region = intersect_with_sb(bytenr, sectorsize);
 	do_barrier = sb_region || disk_block >= idata->boundary;
 	if ((idata->num_blocks > 0 && do_barrier) ||
 	    (file_block > idata->first_block + idata->num_blocks) ||
@@ -102,7 +103,7 @@ int block_iterate_proc(u64 disk_block, u64 file_block,
 
 		idata->first_block = file_block;
 		idata->disk_block = disk_block;
-		idata->boundary = bytenr / root->sectorsize;
+		idata->boundary = bytenr / sectorsize;
 	}
 	idata->num_blocks++;
 fail:
@@ -195,9 +196,10 @@ int record_file_blocks(struct blk_iterate_data *data,
 	struct btrfs_root *root = data->root;
 	struct btrfs_root *convert_root = data->convert_root;
 	struct btrfs_path path;
-	u64 file_pos = file_block * root->sectorsize;
-	u64 old_disk_bytenr = disk_block * root->sectorsize;
-	u64 num_bytes = num_blocks * root->sectorsize;
+	u32 sectorsize = root->fs_info->sectorsize;
+	u64 file_pos = file_block * sectorsize;
+	u64 old_disk_bytenr = disk_block * sectorsize;
+	u64 num_bytes = num_blocks * sectorsize;
 	u64 cur_off = old_disk_bytenr;
 
 	/* Hole, pass it to record_file_extent directly */
-- 
2.13.0



