Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20804 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbcERAUG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 20:20:06 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u4I0K4xe012784
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 18 May 2016 00:20:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by userv0022.oracle.com (8.14.4/8.13.8) with ESMTP id u4I0K4DP013980
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 18 May 2016 00:20:04 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
	by userv0121.oracle.com (8.13.8/8.13.8) with ESMTP id u4I0K3LG003309
	for <linux-btrfs@vger.kernel.org>; Wed, 18 May 2016 00:20:04 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix unexpected return value of fiemap
Date: Tue, 17 May 2016 17:21:48 -0700
Message-Id: <1463530908-23545-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs's fiemap is supposed to return 0 on success and
 return < 0 on error, however, ret becomes 1 after looking
up the last file extent, and if the offset is beyond EOF,
we can return 1.

This may confuse applications using ioctl(FIEL_IOC_FIEMAP).

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d247fc0..16ece52 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4379,8 +4379,12 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	if (ret < 0) {
 		btrfs_free_path(path);
 		return ret;
+	} else {
+		WARN_ON(!ret);
+		if (ret == 1)
+			ret = 0;
 	}
-	WARN_ON(!ret);
+
 	path->slots[0]--;
 	btrfs_item_key_to_cpu(path->nodes[0], &found_key, path->slots[0]);
 	found_type = found_key.type;
-- 
2.5.5

