Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:13232 "EHLO
	mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636AbcCDChZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Mar 2016 21:37:25 -0500
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id B52E9AC0A39
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Mar 2016 11:37:15 +0900 (JST)
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: [PATCH] Show a warning message if one of highest objectid reaches its
 max value
Message-ID: <56D8F4CF.20604@jp.fujitsu.com>
Date: Fri, 4 Mar 2016 11:37:03 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

- It's better to show a warning message for the exceptional case
  that one of highest objectid (in most case, inode number)
  reaches its max value, BTRFS_LAST_FREE_OBJECTID. Show this
  message only once to avoid filling dmesg with it.
- EOVERFLOW is more proper return value for this case.
  ENOSPC is for "No space left on device" case and objectid isn't
  related to any device.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
This patch can be applied to v4.5-rc6
---
 fs/btrfs/inode-map.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index e50316c..a4860fd 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -555,8 +555,10 @@ int btrfs_find_free_objectid(struct btrfs_root *root, u64 *objectid)
 	int ret;
 	mutex_lock(&root->objectid_mutex);

-	if (unlikely(root->highest_objectid >= BTRFS_LAST_FREE_OBJECTID)) {
-		ret = -ENOSPC;
+	if (WARN_ONCE(root->highest_objectid >= BTRFS_LAST_FREE_OBJECTID,
+		      "BTRFS: The highest objectid reaches its max value %llu.\n",
+		      BTRFS_LAST_FREE_OBJECTID)) {
+		ret = -EOVERFLOW;
 		goto out;
 	}

-- 
2.5.0
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
