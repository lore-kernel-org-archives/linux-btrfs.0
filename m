Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:65369 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751617AbaIVBNO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Sep 2014 21:13:14 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <clm@fb.com>
Subject: [PATCH] btrfs: Fix the wrong condition judgment about subset extent map
Date: Mon, 22 Sep 2014 09:13:03 +0800
Message-ID: <1411348383-13587-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Previous commit: btrfs: Fix and enhance merge_extent_mapping() to insert
best fitted extent map
is using wrong condition to judgement whether the range is a subset of a
existing extent map.

This may cause bug in btrfs no-holes mode.

This patch will correct the judgment and fix the bug.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8039021..a99ee9d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6527,7 +6527,7 @@ insert:
 		 * extent causing the -EEXIST.
 		 */
 		if (start >= extent_map_end(existing) ||
-		    start + len <= existing->start) {
+		    start <= existing->start) {
 			/*
 			 * The existing extent map is the one nearest to
 			 * the [start, start + len) range which overlaps
-- 
2.1.0

