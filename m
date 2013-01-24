Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:24096 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753863Ab3AXLyn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 06:54:43 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r0OBsewm026450
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Jan 2013 19:54:40 +0800
Message-ID: <510120C4.10406@cn.fujitsu.com>
Date: Thu, 24 Jan 2013 19:53:40 +0800
From: Chen Yang <chenyang.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-prog/send: fix wrong best-parent assignment in, find_good_parent()
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We use find_good_parent() to look for a suit snapshot in the clone source
snapshots as the parent, not the source subvolume of the snapshot which
is about to be sent. fix it

Signed-off-by: Cheng Yang <chenyang.fnst@cn.fujitsu.com>
---
 cmds-send.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/cmds-send.c b/cmds-send.c
index 9b47e70..3a88c54 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -150,7 +150,7 @@ static int find_good_parent(struct btrfs_send *s, u64 root_id, u64 *found)
 		if (tmp < 0)
 			tmp *= -1;
 		if (tmp < best_diff) {
-			best_parent = parent;
+			best_parent = parent2;
 			best_diff = tmp;
 		}
 	}
-- 
1.7.7.6

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
