Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57071 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751483AbbBDHTt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Feb 2015 02:19:49 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t147IFGi020230
	for <linux-btrfs@vger.kernel.org>; Wed, 4 Feb 2015 15:18:15 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/7] btrfs-progs: Export write_tree_block() and allow it to do nocow write.
Date: Wed, 4 Feb 2015 15:16:48 +0800
Message-ID: <1423034213-14018-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1423034213-14018-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1423034213-14018-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Export write_tree_block() function, and allow it to write data to disk
without transaction.

This is useful for resetting tree block csum, where the reset is done
level by level, so btrfs_search_slot() is doing lowest_level search and
can't do cow (cow with lowest_level will screw up extent backref).

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 disk-io.c | 4 ++--
 disk-io.h | 3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 747ef15..755cb7c 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -371,7 +371,7 @@ int write_and_map_eb(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-static int write_tree_block(struct btrfs_trans_handle *trans,
+int write_tree_block(struct btrfs_trans_handle *trans,
 		     struct btrfs_root *root,
 		     struct extent_buffer *eb)
 {
@@ -380,7 +380,7 @@ static int write_tree_block(struct btrfs_trans_handle *trans,
 		BUG();
 	}
 
-	if (!btrfs_buffer_uptodate(eb, trans->transid))
+	if (trans && !btrfs_buffer_uptodate(eb, trans->transid))
 		BUG();
 
 	btrfs_set_header_flag(eb, BTRFS_HEADER_FLAG_WRITTEN);
diff --git a/disk-io.h b/disk-io.h
index c3eceaa..0cbe2dc 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -59,6 +59,9 @@ struct btrfs_device;
 int read_whole_eb(struct btrfs_fs_info *info, struct extent_buffer *eb, int mirror);
 struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 				      u32 blocksize, u64 parent_transid);
+int write_tree_block(struct btrfs_trans_handle *trans,
+		     struct btrfs_root *root,
+		     struct extent_buffer *eb);
 void readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 			  u64 parent_transid);
 struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
-- 
2.2.2

