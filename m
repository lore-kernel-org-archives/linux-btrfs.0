Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:40456 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbaI2Jev (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Sep 2014 05:34:51 -0400
Received: by mail-pa0-f51.google.com with SMTP id lj1so2424504pab.10
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Sep 2014 02:34:51 -0700 (PDT)
Received: from localhost ([106.120.101.38])
        by mx.google.com with ESMTPSA id fn2sm11340746pdb.75.2014.09.29.02.34.49
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Mon, 29 Sep 2014 02:34:50 -0700 (PDT)
From: roy.qing.li@gmail.com
To: linux-btrfs@vger.kernel.org
Subject: [PATCH][v2] btrfs: fix a overflowing boundary writing in csum_tree_block
Date: Mon, 29 Sep 2014 17:34:49 +0800
Message-Id: <1411983289-26522-1-git-send-email-roy.qing.li@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Li RongQing <roy.qing.li@gmail.com>

It is impossible that csum_size is larger than sizeof(long), but the codes
still add the handler for this condition, like allocate new memory, for
extension. If it becomes true someday, copying csum_size size memory to local
32bit variable found and val will overflow these two variables.

Fix it by returning the max 4 byte checksum, and print the csum_size

Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
---
 fs/btrfs/disk-io.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a1d36e6..d9b52ac 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -295,14 +295,17 @@ static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 		if (memcmp_extent_buffer(buf, result, 0, csum_size)) {
 			u32 val;
 			u32 found = 0;
+
+			csum_size = min_t(u16, csum_size, sizeof(u32));
 			memcpy(&found, result, csum_size);
 
 			read_extent_buffer(buf, &val, 0, csum_size);
 			printk_ratelimited(KERN_INFO
 				"BTRFS: %s checksum verify failed on %llu wanted %X found %X "
-				"level %d\n",
+				"level %d checksum size %d\n",
 				root->fs_info->sb->s_id, buf->start,
-				val, found, btrfs_header_level(buf));
+				val, found, btrfs_header_level(buf), csum_size);
+
 			if (result != (char *)&inline_result)
 				kfree(result);
 			return 1;
-- 
1.7.10.4

