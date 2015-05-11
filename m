Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64834 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752302AbbEKIJC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 04:09:02 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t4B87d7K028757
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2015 16:07:39 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 05/13] btrfs-progs: Export write_tree_block().
Date: Mon, 11 May 2015 16:08:46 +0800
Message-ID: <1431331734-11714-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1431331734-11714-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1431331734-11714-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Export write_tree_block() function and allow it write extent without
transaction.

This provides the basis for later uuid change function.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  None
---
 disk-io.c | 4 ++--
 disk-io.h | 3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 0edebfa..2ab2d2e 100644
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
index e1c2030..c1ab875 100644
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
2.4.0

