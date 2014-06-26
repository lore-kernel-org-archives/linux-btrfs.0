Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26146 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757303AbaFZC6f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jun 2014 22:58:35 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5Q2wWkv027102
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Jun 2014 10:58:32 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 6/6] btrfs-progs: use BTRFS_SUPER_INFO_SIZE to replace raw 4096 in btrfs-image
Date: Thu, 26 Jun 2014 10:53:06 +0800
Message-ID: <1403751186-31559-6-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1403751186-31559-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1403751186-31559-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 btrfs-image.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index b13f236..ed0b6ec 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -1163,7 +1163,7 @@ static int copy_from_extent_tree(struct metadump_struct *metadump,
 	int ret;
 
 	extent_root = metadump->root->fs_info->extent_root;
-	bytenr = BTRFS_SUPER_INFO_OFFSET + 4096;
+	bytenr = BTRFS_SUPER_INFO_OFFSET + BTRFS_SUPER_INFO_SIZE;
 	key.objectid = bytenr;
 	key.type = BTRFS_EXTENT_ITEM_KEY;
 	key.offset = 0;
@@ -1278,7 +1278,8 @@ static int create_metadump(const char *input, FILE *out, int num_threads,
 		return ret;
 	}
 
-	ret = add_extent(BTRFS_SUPER_INFO_OFFSET, 4096, &metadump, 0);
+	ret = add_extent(BTRFS_SUPER_INFO_OFFSET, BTRFS_SUPER_INFO_SIZE,
+			&metadump, 0);
 	if (ret) {
 		fprintf(stderr, "Error adding metadata %d\n", ret);
 		err = ret;
@@ -1368,7 +1369,7 @@ static void update_super_old(u8 *buffer)
 	btrfs_set_stack_stripe_offset(&chunk->stripe, 0);
 	memcpy(chunk->stripe.dev_uuid, super->dev_item.uuid, BTRFS_UUID_SIZE);
 	btrfs_set_super_sys_array_size(super, sizeof(*key) + sizeof(*chunk));
-	csum_block(buffer, 4096);
+	csum_block(buffer, BTRFS_SUPER_INFO_SIZE);
 }
 
 static int update_super(u8 *buffer)
@@ -1422,7 +1423,7 @@ static int update_super(u8 *buffer)
 	}
 
 	btrfs_set_super_sys_array_size(super, new_array_size);
-	csum_block(buffer, 4096);
+	csum_block(buffer, BTRFS_SUPER_INFO_SIZE);
 
 	return 0;
 }
@@ -1569,12 +1570,12 @@ static void write_backup_supers(int fd, u8 *buf)
 
 	for (i = 1; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
-		if (bytenr + 4096 > size)
+		if (bytenr + BTRFS_SUPER_INFO_SIZE > size)
 			break;
 		btrfs_set_super_bytenr(super, bytenr);
-		csum_block(buf, 4096);
-		ret = pwrite64(fd, buf, 4096, bytenr);
-		if (ret < 4096) {
+		csum_block(buf, BTRFS_SUPER_INFO_SIZE);
+		ret = pwrite64(fd, buf, BTRFS_SUPER_INFO_SIZE, bytenr);
+		if (ret < BTRFS_SUPER_INFO_SIZE) {
 			if (ret < 0)
 				fprintf(stderr, "Problem writing out backup "
 					"super block %d, err %d\n", i, errno);
-- 
1.8.1.4

