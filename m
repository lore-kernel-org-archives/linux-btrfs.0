Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:13248 "EHLO
	mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbcCIGTS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Mar 2016 01:19:18 -0500
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 6B4FEAC0126
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Mar 2016 15:19:09 +0900 (JST)
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: [PATCH v3] Btrfs: Show a warning message if one of objectid reaches
 its highest value
Message-ID: <56DFC051.1040409@jp.fujitsu.com>
Date: Wed, 9 Mar 2016 15:18:57 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's better to show a warning message for the exceptional case
that one of objectid (in most case, inode number) reaches its
highest value. For example, if inode cache is off and this event
happens, we can't create any file even if there are not so many files.
This message ease detecting such problem.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
This patch can be applied to 4.5-rc7

V3:
- Show this message every time when hitting this problem
  for simplicity (thanks to the comment from Goffredo).
- Reflect Naota's comment
  - Keep the error code as is.
V2:
 - Reflect Filipe's comment
   - Use btrfs_warn() instead of WARN_ONCE()
   - Print the id of the tree
---
 fs/btrfs/inode-map.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index e50316c..5d97ee7 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -556,6 +556,9 @@ int btrfs_find_free_objectid(struct btrfs_root *root, u64 *objectid)
 	mutex_lock(&root->objectid_mutex);

 	if (unlikely(root->highest_objectid >= BTRFS_LAST_FREE_OBJECTID)) {
+		btrfs_warn(root->fs_info,
+			   "The objectid of root %llu reaches its highest value.\n",
+			   root->root_key.objectid);
 		ret = -ENOSPC;
 		goto out;
 	}
-- 
2.5.0
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
