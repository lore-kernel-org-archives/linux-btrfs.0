Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:28138 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab3EMPMa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 May 2013 11:12:30 -0400
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Miao Xie <miaox@cn.fujitsu.com>, Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH 4/5] Btrfs: don't steal the reserved space from the global reserve if their space type is different
Date: Mon, 13 May 2013 21:55:11 +0800
Message-Id: <1368453312-7027-4-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1368453312-7027-1-git-send-email-miaox@cn.fujitsu.com>
References: <1368453312-7027-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the type of the space we need is different with the global reserve, we
can not steal the space from the global reserve, because we can not allocate
the space from the free space cache that the global reserve points to.

Cc: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e34e268..c48e1bd 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6684,9 +6684,11 @@ try_reserve:
 		return block_rsv;
 	/*
 	 * If we couldn't reserve metadata bytes try and use some from
-	 * the global reserve.
+	 * the global reserve if its space type is the same as the global
+	 * reservation.
 	 */
-	if (block_rsv->type != BTRFS_BLOCK_RSV_GLOBAL) {
+	if (block_rsv->type != BTRFS_BLOCK_RSV_GLOBAL &&
+	    block_rsv->space_info == global_rsv->space_info) {
 		ret = block_rsv_use_bytes(global_rsv, blocksize);
 		if (!ret)
 			return global_rsv;
-- 
1.8.0.1

