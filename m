Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:61609 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752971Ab3KDPMo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Nov 2013 10:12:44 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rA4FCVoC031736
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Nov 2013 23:12:31 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/7] Btrfs: fix the confusion between delalloc bytes and metadata bytes
Date: Mon, 4 Nov 2013 23:13:23 +0800
Message-Id: <1383578006-22691-5-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1383578006-22691-1-git-send-email-miaox@cn.fujitsu.com>
References: <1383578006-22691-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In shrink_delalloc(), what we need reclaim is the metadata space, so
flushing pages by to_reclaim is not reasonable, it is very likely that
the pages we flush are not enough. And then we had to invoke the flush
function for several times, at the worst, we need call flush_space for
several times. It wasted time.

We improve this problem by converting the metadata space size we need
reserve to the delalloc bytes, By this way, we can flush the pages
by a reasonable number.

(Now we use a fixed number to do conversion, it is not flexible, maybe
 we can find a good way to improve it in the future.)

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 32dcf80..c48fde1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4016,6 +4016,8 @@ static inline int calc_reclaim_items_nr(struct btrfs_root *root, u64 to_reclaim)
 	return nr;
 }
 
+#define EXTENT_SIZE_PER_ITEM	(256 * 1024)
+
 /*
  * shrink metadata reservation for delalloc
  */
@@ -4032,6 +4034,10 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
 	int loops;
 	enum btrfs_reserve_flush_enum flush;
 
+	/* Calc the number of the pages we need flush for space reservation */
+	to_reclaim = calc_reclaim_items_nr(root, to_reclaim);
+	to_reclaim *= EXTENT_SIZE_PER_ITEM;
+
 	trans = (struct btrfs_trans_handle *)current->journal_info;
 	block_rsv = &root->fs_info->delalloc_block_rsv;
 	space_info = block_rsv->space_info;
-- 
1.8.1.4

