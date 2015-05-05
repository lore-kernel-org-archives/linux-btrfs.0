Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23855 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753213AbbEEGSv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 May 2015 02:18:51 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t456HWn5008346
	for <linux-btrfs@vger.kernel.org>; Tue, 5 May 2015 14:17:32 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/8] btrfs-progs: Export write_tree_block().
Date: Tue, 5 May 2015 14:16:40 +0800
Message-ID: <1430806606-3226-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1430806606-3226-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1430806606-3226-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Export wirte_tree_block() function and allow it write extent without
transaction.

This provides the basis for later uuid change function.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 disk-io.c | 4 ++--
 disk-io.h | 3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 8a91345..4f3d1de 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -372,7 +372,7 @@ int write_and_map_eb(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-static int write_tree_block(struct btrfs_trans_handle *trans,
+int write_tree_block(struct btrfs_trans_handle *trans,
 		     struct btrfs_root *root,
 		     struct extent_buffer *eb)
 {
@@ -381,7 +381,7 @@ static int write_tree_block(struct btrfs_trans_handle *trans,
 		BUG();
 	}
 
-	if (!btrfs_buffer_uptodate(eb, trans->transid))
+	if (trans && !btrfs_buffer_uptodate(eb, trans->transid))
 		BUG();
 
 	btrfs_set_header_flag(eb, BTRFS_HEADER_FLAG_WRITTEN);
diff --git a/disk-io.h b/disk-io.h
index 83cbe47..dd5bb8a 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -127,6 +127,9 @@ int csum_tree_block_size(struct extent_buffer *buf, u16 csum_sectorsize,
 			 int verify);
 int verify_tree_block_csum_silent(struct extent_buffer *buf, u16 csum_size);
 int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid);
+int write_tree_block(struct btrfs_trans_handle *trans,
+		     struct btrfs_root *root,
+		     struct extent_buffer *eb);
 int write_and_map_eb(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		     struct extent_buffer *eb);
 
-- 
2.3.7

