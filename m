Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30954 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432Ab3GKJwB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jul 2013 05:52:01 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r6B9pxR4031104
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jul 2013 09:52:00 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6B9pwMu008741
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jul 2013 09:51:59 GMT
Received: from abhmt108.oracle.com (abhmt108.oracle.com [141.146.116.60])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6B9pwq9008733
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jul 2013 09:51:58 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: make free space caching faster with many non-inline extent references
Date: Thu, 11 Jul 2013 17:51:15 +0800
Message-Id: <1373536275-15266-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So to cache free space, we iterate every extent item to gather free space info.

When we have say 10,000 non-inline extent refs(such as BTRFS_EXTENT_DATA_REF),
it takes quite a long time, and since inline extent refs and non-inline ones have
same objectid in their keys, we can just re-search the tree with the next address
to skip non-inline references.

(This is found by dedup feature because dedup extents can end up with many
non-inline extent refs.)

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0236de7..2796622 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -420,6 +420,7 @@ again:
 	/* need to make sure the commit_root doesn't disappear */
 	down_read(&fs_info->extent_commit_sem);
 
+next:
 	ret = btrfs_search_slot(NULL, extent_root, &key, path, 0, 0);
 	if (ret < 0)
 		goto err;
@@ -459,6 +460,16 @@ again:
 			continue;
 		}
 
+		if (key.objectid < last) {
+			key.objectid = last;
+			key.offset = 0;
+			key.type = BTRFS_EXTENT_ITEM_KEY;
+
+			caching_ctl->progress = last;
+			btrfs_release_path(path);
+			goto next;
+		}
+
 		if (key.objectid < block_group->key.objectid) {
 			path->slots[0]++;
 			continue;
-- 
1.7.7

