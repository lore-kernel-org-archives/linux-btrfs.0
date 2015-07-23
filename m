Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29728 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752431AbbGWJSZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jul 2015 05:18:25 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.com>
Subject: [PATCH 3/4] btrfs: extent-tree: Avoid allocating tree block that cross stripe boundary
Date: Thu, 23 Jul 2015 17:18:09 +0800
Message-ID: <1437643090-13920-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1437643090-13920-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1437643090-13920-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now find_free_extent() function won't return a metadata extent that
cross stripe boundary.

Reported-by: Chris Murphy <lists@colorremedies.com>
Reported-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 extent-tree.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/extent-tree.c b/extent-tree.c
index ac582e0..6f07e4b 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -2605,6 +2605,11 @@ check_failed:
 	}
 
 	if (!(data & BTRFS_BLOCK_GROUP_DATA)) {
+		if (check_crossing_stripes(ins->objectid, num_bytes)) {
+			search_start = round_down(ins->objectid + num_bytes,
+						  BTRFS_STRIPE_LEN);
+			goto new_group;
+		}
 		block_group = btrfs_lookup_block_group(info, ins->objectid);
 		if (block_group)
 			trans->block_group = block_group;
-- 
2.4.6

