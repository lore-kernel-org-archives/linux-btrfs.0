Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33958 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758463AbaGXDff (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 23:35:35 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6O3ZWGr017390
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 11:35:32 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 03/10] Btrfs: fix wrong fsid check of scrub
Date: Thu, 24 Jul 2014 11:37:08 +0800
Message-ID: <1406173035-29478-3-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1406173035-29478-1-git-send-email-miaox@cn.fujitsu.com>
References: <1406173035-29478-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All the metadata in the seed devices has the same fsid as the fsid
of the seed filesystem which is on the seed device, so we should check
them by the current filesystem. Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 23d3f6e..9a81874e 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1361,6 +1361,16 @@ static void scrub_recheck_block(struct btrfs_fs_info *fs_info,
 	return;
 }
 
+static inline int scrub_check_fsid(u8 fsid[],
+				   struct scrub_page *spage)
+{
+	struct btrfs_fs_devices *fs_devices = spage->dev->fs_devices;
+	int ret;
+
+	ret = memcmp(fsid, fs_devices->fsid, BTRFS_UUID_SIZE);
+	return !ret;
+}
+
 static void scrub_recheck_block_checksum(struct btrfs_fs_info *fs_info,
 					 struct scrub_block *sblock,
 					 int is_metadata, int have_csum,
@@ -1380,7 +1390,7 @@ static void scrub_recheck_block_checksum(struct btrfs_fs_info *fs_info,
 		h = (struct btrfs_header *)mapped_buffer;
 
 		if (sblock->pagev[0]->logical != btrfs_stack_header_bytenr(h) ||
-		    memcmp(h->fsid, fs_info->fsid, BTRFS_UUID_SIZE) ||
+		    !scrub_check_fsid(h->fsid, sblock->pagev[0]) ||
 		    memcmp(h->chunk_tree_uuid, fs_info->chunk_tree_uuid,
 			   BTRFS_UUID_SIZE)) {
 			sblock->header_error = 1;
@@ -1750,7 +1760,7 @@ static int scrub_checksum_tree_block(struct scrub_block *sblock)
 	if (sblock->pagev[0]->generation != btrfs_stack_header_generation(h))
 		++fail;
 
-	if (memcmp(h->fsid, fs_info->fsid, BTRFS_UUID_SIZE))
+	if (!scrub_check_fsid(h->fsid, sblock->pagev[0]))
 		++fail;
 
 	if (memcmp(h->chunk_tree_uuid, fs_info->chunk_tree_uuid,
@@ -1790,8 +1800,6 @@ static int scrub_checksum_super(struct scrub_block *sblock)
 {
 	struct btrfs_super_block *s;
 	struct scrub_ctx *sctx = sblock->sctx;
-	struct btrfs_root *root = sctx->dev_root;
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	u8 calculated_csum[BTRFS_CSUM_SIZE];
 	u8 on_disk_csum[BTRFS_CSUM_SIZE];
 	struct page *page;
@@ -1816,7 +1824,7 @@ static int scrub_checksum_super(struct scrub_block *sblock)
 	if (sblock->pagev[0]->generation != btrfs_super_generation(s))
 		++fail_gen;
 
-	if (memcmp(s->fsid, fs_info->fsid, BTRFS_UUID_SIZE))
+	if (!scrub_check_fsid(s->fsid, sblock->pagev[0]))
 		++fail_cor;
 
 	len = BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE;
-- 
1.9.3

