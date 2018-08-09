Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:41092 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbeHIGde (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Aug 2018 02:33:34 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 02C1DAC01A2
        for <linux-btrfs@vger.kernel.org>; Thu,  9 Aug 2018 13:10:38 +0900 (JST)
Received: from G01JPEXCHKW15.g01.fujitsu.local (G01JPEXCHKW15.g01.fujitsu.local [10.0.194.54])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 34898BD67EA
        for <linux-btrfs@vger.kernel.org>; Thu,  9 Aug 2018 13:10:36 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs: qgroup: Always remove all qgroup relation in
 btrfs_remove_qgroup()
References: <cover.1533787467.git.misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <3efcb82a-5fcb-4d20-1ab9-5d03bbc6b999@jp.fujitsu.com>
Date: Thu, 9 Aug 2018 13:10:33 +0900
MIME-Version: 1.0
In-Reply-To: <cover.1533787467.git.misono.tomohiro@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs_remove_qgroup(), each qgroup relation is removed by calling
__del_qgroup_relation(). However, __del_qgroup_relation() returns 1
if deletion of qgroup relation causes inconsistency and current code
exits immediately  in that case.

Therefore if there are several qgroup relations and removing first
relation causes inconsistency, remaining items will not be removed.

Fix this by continuing to remove items if return value of
__del_qgroup_relation() is 1.

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/qgroup.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 2ba29f0609d9..f18284253e77 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1428,12 +1428,21 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid)
 		goto out;
 
 	while (!list_empty(&qgroup->groups)) {
+		int ret2;
+
 		list = list_first_entry(&qgroup->groups,
 					struct btrfs_qgroup_list, next_group);
-		ret = __del_qgroup_relation(trans, qgroupid,
+		ret2 = __del_qgroup_relation(trans, qgroupid,
 					    list->group->qgroupid);
-		if (ret)
-			goto out;
+		if (ret2) {
+			ret = ret2;
+			/*
+			 * __del_qgroup_relation() returns 1 if qgroup becomes
+			 * inconsistent. Continue to remove items in that case.
+			 */
+			if (ret != 1)
+				goto out;
+		}
 	}
 
 	spin_lock(&fs_info->qgroup_lock);
-- 
2.14.4


