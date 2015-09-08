Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43279 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754608AbbIHNSc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Sep 2015 09:18:32 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t88DIHIr018028
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Sep 2015 21:18:17 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 2/3] btrfs-progs: Avoid uninitialized data in output of btrfs-convert
Date: Tue, 8 Sep 2015 21:16:50 +0800
Message-ID: <950a8539e7a587f55d34820049d6ed46aa4acdc8.1441718128.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1441718128.git.zhaolei@cn.fujitsu.com>
References: <cover.1441718128.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

sequence, transid and reserved field of inode was write to disk
with uninitizlized value, this patch fixed it.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 btrfs-convert.c | 4 ++++
 ctree.h         | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index f4fc650..934f4dc 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -1016,6 +1016,8 @@ static int copy_inode_item(struct btrfs_inode_item *dst,
 			   struct ext2_inode *src, u32 blocksize)
 {
 	btrfs_set_stack_inode_generation(dst, 1);
+	btrfs_set_stack_inode_sequence(dst, 0);
+	btrfs_set_stack_inode_transid(dst, 1);
 	btrfs_set_stack_inode_size(dst, src->i_size);
 	btrfs_set_stack_inode_nbytes(dst, 0);
 	btrfs_set_stack_inode_block_group(dst, 0);
@@ -1052,6 +1054,8 @@ static int copy_inode_item(struct btrfs_inode_item *dst,
 				new_decode_dev(src->i_block[1]));
 		}
 	}
+	memset(&dst->reserved, 0, sizeof(dst->reserved));
+
 	return 0;
 }
 
diff --git a/ctree.h b/ctree.h
index 2061e1e..c57f9ca 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1424,6 +1424,8 @@ BTRFS_SETGET_STACK_FUNCS(stack_inode_generation,
 			 struct btrfs_inode_item, generation, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_inode_sequence,
 			 struct btrfs_inode_item, sequence, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_transid,
+			 struct btrfs_inode_item, transid, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_inode_size,
 			 struct btrfs_inode_item, size, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_inode_nbytes,
-- 
1.8.5.1

