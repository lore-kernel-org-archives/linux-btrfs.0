Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17311 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752015AbbHEKBx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Aug 2015 06:01:53 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t759xktY021983
	for <linux-btrfs@vger.kernel.org>; Wed, 5 Aug 2015 17:59:47 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 1/3] btrfs: Error handle for get_ref_objectid_v0() in relocate_block_group()
Date: Wed, 5 Aug 2015 18:00:02 +0800
Message-ID: <f6eb7359bee352cc27f91d26bcffa6c6f8b1a5fe.1438768766.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need error checking code for get_ref_objectid_v0() in
relocate_block_group(), to avoid unpredictable result, especially
for accessing uninitialized value(when function failed) after
this line.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/relocation.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 52fe55a..1659c94 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3976,6 +3976,10 @@ restart:
 			       sizeof(struct btrfs_extent_item_v0));
 			ret = get_ref_objectid_v0(rc, path, &key, &ref_owner,
 						  &path_change);
+			if (ret < 0) {
+				err = ret;
+				break;
+			}
 			if (ref_owner < BTRFS_FIRST_FREE_OBJECTID)
 				flags = BTRFS_EXTENT_FLAG_TREE_BLOCK;
 			else
-- 
1.8.5.1

