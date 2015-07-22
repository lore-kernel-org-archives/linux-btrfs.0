Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8032 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752299AbbGVFQ1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jul 2015 01:16:27 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t6M5Ea7P014209
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2015 13:14:36 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 2/2] btrfs: Bypass unrelated items before accessing its contents in scrub
Date: Wed, 22 Jul 2015 13:14:48 +0800
Message-ID: <e9b044860bf662c8ddbdaa6d7c9d9ba367b46bf6.1437541968.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <e93ff56830016c5edcbb960584c885b3173090be.1437541968.git.zhaolei@cn.fujitsu.com>
References: <e93ff56830016c5edcbb960584c885b3173090be.1437541968.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

When we access extent_root in scrub_stripe() and
scrub_raid56_parity(), we need bypass unrelated tree item firstly
before using its contents to do other condition.

It is not a bug fix, only making code sequence in logic.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index d72e8e1..3e8b3fc 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2856,6 +2856,10 @@ static noinline_for_stack int scrub_raid56_parity(struct scrub_ctx *sctx,
 			}
 			btrfs_item_key_to_cpu(l, &key, slot);
 
+			if (key.type != BTRFS_EXTENT_ITEM_KEY &&
+			    key.type != BTRFS_METADATA_ITEM_KEY)
+				goto next;
+
 			if (key.type == BTRFS_METADATA_ITEM_KEY)
 				bytes = root->nodesize;
 			else
@@ -2864,10 +2868,6 @@ static noinline_for_stack int scrub_raid56_parity(struct scrub_ctx *sctx,
 			if (key.objectid + bytes <= logic_start)
 				goto next;
 
-			if (key.type != BTRFS_EXTENT_ITEM_KEY &&
-			    key.type != BTRFS_METADATA_ITEM_KEY)
-				goto next;
-
 			if (key.objectid >= logic_end) {
 				stop_loop = 1;
 				break;
@@ -3192,6 +3192,10 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 			}
 			btrfs_item_key_to_cpu(l, &key, slot);
 
+			if (key.type != BTRFS_EXTENT_ITEM_KEY &&
+			    key.type != BTRFS_METADATA_ITEM_KEY)
+				goto next;
+
 			if (key.type == BTRFS_METADATA_ITEM_KEY)
 				bytes = root->nodesize;
 			else
@@ -3200,10 +3204,6 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 			if (key.objectid + bytes <= logical)
 				goto next;
 
-			if (key.type != BTRFS_EXTENT_ITEM_KEY &&
-			    key.type != BTRFS_METADATA_ITEM_KEY)
-				goto next;
-
 			if (key.objectid >= logical + map->stripe_len) {
 				/* out of this device extent */
 				if (key.objectid >= logic_end)
-- 
1.8.5.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
