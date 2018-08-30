Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:40486 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbeH3F7J (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Aug 2018 01:59:09 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 4903FAC0065
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2018 10:59:20 +0900 (JST)
Received: from G01JPEXCHKW18.g01.fujitsu.local (G01JPEXCHKW18.g01.fujitsu.local [10.0.194.57])
        by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id 6E8CD692676
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2018 10:59:19 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs: extent-tree.c: Remove redundant variable from
 btrfs_cross_ref_exist()
References: <cover.1535593351.git.misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <90c3c33c-0f7d-7121-feb8-4a74e5e78b93@jp.fujitsu.com>
Date: Thu, 30 Aug 2018 10:59:16 +0900
MIME-Version: 1.0
In-Reply-To: <cover.1535593351.git.misono.tomohiro@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since commit d7df2c796d7e ("Btrfs attach delayed ref updates to
delayed ref heads"), check_delaed_ref() won't return -ENOENT.

In btrfs_cross_ref_exist(), two variable 'ret' and 'ret2' is
originally used to handle -ENOENT error case.

Since the code is not needed anymore, let's just remove 'ret2'.

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2d9074295d7f..0c87472d5719 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3139,7 +3139,6 @@ int btrfs_cross_ref_exist(struct btrfs_root *root, u64 objectid, u64 offset,
 {
 	struct btrfs_path *path;
 	int ret;
-	int ret2;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -3151,17 +3150,10 @@ int btrfs_cross_ref_exist(struct btrfs_root *root, u64 objectid, u64 offset,
 		if (ret && ret != -ENOENT)
 			goto out;
 
-		ret2 = check_delayed_ref(root, path, objectid,
+		ret = check_delayed_ref(root, path, objectid,
 					 offset, bytenr);
-	} while (ret2 == -EAGAIN);
+	} while (ret == -EAGAIN);
 
-	if (ret2 && ret2 != -ENOENT) {
-		ret = ret2;
-		goto out;
-	}
-
-	if (ret != -ENOENT || ret2 != -ENOENT)
-		ret = 0;
 out:
 	btrfs_free_path(path);
 	if (root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID)
-- 
2.17.1
