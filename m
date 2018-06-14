Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:61125 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S935733AbeFNCef (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Jun 2018 22:34:35 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id E45F24B41EC6
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Jun 2018 10:34:27 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: print bytenr of tree block in print_tree_block_error()
Date: Thu, 14 Jun 2018 10:40:39 +0800
Message-ID: <20180614024039.18229-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For easier debug, let print_tree_block_error() print bytenr of
tree block.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 disk-io.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/disk-io.c b/disk-io.c
index 4a609a892be7..6ee65190f251 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -94,6 +94,9 @@ static void print_tree_block_error(struct btrfs_fs_info *fs_info,
 	char found_uuid[BTRFS_UUID_UNPARSED_SIZE] = {'\0'};
 	u8 buf[BTRFS_UUID_SIZE];
 
+	if (!err)
+		return;
+	fprintf(stderr, "bad tree block %llu, ", eb->start);
 	switch (err) {
 	case BTRFS_BAD_FSID:
 		read_extent_buffer(eb, buf, btrfs_header_fsid(),
-- 
2.17.1



