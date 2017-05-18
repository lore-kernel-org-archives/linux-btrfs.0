Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43366 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932200AbdERDj1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 23:39:27 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 21/32] btrfs-progs: Refactor sectorsize users in free-space-cache.c
Date: Thu, 18 May 2017 11:38:46 +0800
Message-ID: <20170518033857.15002-22-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
References: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 free-space-cache.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/free-space-cache.c b/free-space-cache.c
index a4196eb1..4bf4a6cb 100644
--- a/free-space-cache.c
+++ b/free-space-cache.c
@@ -54,7 +54,8 @@ static int io_ctl_init(struct io_ctl *io_ctl, u64 size, u64 ino,
 		       struct btrfs_root *root)
 {
 	memset(io_ctl, 0, sizeof(struct io_ctl));
-	io_ctl->num_pages = (size + root->sectorsize - 1) / root->sectorsize;
+	io_ctl->num_pages = (size + root->fs_info->sectorsize - 1) /
+				root->fs_info->sectorsize;
 	io_ctl->buffer = kzalloc(size, GFP_NOFS);
 	if (!io_ctl->buffer)
 		return -ENOMEM;
@@ -81,11 +82,12 @@ static void io_ctl_unmap_page(struct io_ctl *io_ctl)
 static void io_ctl_map_page(struct io_ctl *io_ctl, int clear)
 {
 	BUG_ON(io_ctl->index >= io_ctl->num_pages);
-	io_ctl->cur = io_ctl->buffer + (io_ctl->index++ * io_ctl->root->sectorsize);
+	io_ctl->cur = io_ctl->buffer + (io_ctl->index++ *
+					io_ctl->root->fs_info->sectorsize);
 	io_ctl->orig = io_ctl->cur;
-	io_ctl->size = io_ctl->root->sectorsize;
+	io_ctl->size = io_ctl->root->fs_info->sectorsize;
 	if (clear)
-		memset(io_ctl->cur, 0, io_ctl->root->sectorsize);
+		memset(io_ctl->cur, 0, io_ctl->root->fs_info->sectorsize);
 }
 
 static void io_ctl_drop_pages(struct io_ctl *io_ctl)
@@ -210,7 +212,8 @@ static int io_ctl_check_crc(struct io_ctl *io_ctl, int index)
 	val = *tmp;
 
 	io_ctl_map_page(io_ctl, 0);
-	crc = crc32c(crc, io_ctl->orig + offset, io_ctl->root->sectorsize - offset);
+	crc = crc32c(crc, io_ctl->orig + offset,
+			io_ctl->root->fs_info->sectorsize - offset);
 	btrfs_csum_final(crc, (u8 *)&crc);
 	if (val != crc) {
 		printk("btrfs: csum mismatch on free space cache\n");
@@ -257,7 +260,7 @@ static int io_ctl_read_bitmap(struct io_ctl *io_ctl,
 	if (ret)
 		return ret;
 
-	memcpy(entry->bitmap, io_ctl->cur, io_ctl->root->sectorsize);
+	memcpy(entry->bitmap, io_ctl->cur, io_ctl->root->fs_info->sectorsize);
 	io_ctl_unmap_page(io_ctl);
 
 	return 0;
-- 
2.13.0



