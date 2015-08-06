Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:65444 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754013AbbHFOSE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Aug 2015 10:18:04 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t76EG5I4020896
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Aug 2015 22:16:05 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 2/2] btrfs: Remove root argument in extent_data_ref_count()
Date: Thu, 6 Aug 2015 22:16:24 +0800
Message-ID: <e72cb2bc66daa77e655c0661ced65e59d47d3dfe.1438870557.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <ea1da7b70342496557bfc8f73fc25bdaf3729fa5.1438870557.git.zhaolei@cn.fujitsu.com>
References: <ea1da7b70342496557bfc8f73fc25bdaf3729fa5.1438870557.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Because it is never used.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 792247f..5f7cbd7 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1316,8 +1316,7 @@ static noinline int remove_extent_data_ref(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static noinline u32 extent_data_ref_count(struct btrfs_root *root,
-					  struct btrfs_path *path,
+static noinline u32 extent_data_ref_count(struct btrfs_path *path,
 					  struct btrfs_extent_inline_ref *iref)
 {
 	struct btrfs_key key;
@@ -6318,7 +6317,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 	} else {
 		if (found_extent) {
 			BUG_ON(is_data && refs_to_drop !=
-			       extent_data_ref_count(root, path, iref));
+			       extent_data_ref_count(path, iref));
 			if (iref) {
 				BUG_ON(path->slots[0] != extent_slot);
 			} else {
-- 
1.8.5.1

