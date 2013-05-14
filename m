Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51672 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab3ENMNT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 May 2013 08:13:19 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r4ECDGCm003421
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 14 May 2013 12:13:17 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4ECDH0N022289
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Tue, 14 May 2013 12:13:17 GMT
Received: from abhmt115.oracle.com (abhmt115.oracle.com [141.146.116.67])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4ECDHsO024274
	for <linux-btrfs@vger.kernel.org>; Tue, 14 May 2013 12:13:17 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: remove unused code in btrfs_del_root
Date: Tue, 14 May 2013 20:12:58 +0800
Message-Id: <1368533578-19430-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

'leaf' and 'ri' is not used somehow.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/root-tree.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 5bf1ed5..4a5abda 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -368,8 +368,6 @@ int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 {
 	struct btrfs_path *path;
 	int ret;
-	struct btrfs_root_item *ri;
-	struct extent_buffer *leaf;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -379,8 +377,6 @@ int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		goto out;
 
 	BUG_ON(ret != 0);
-	leaf = path->nodes[0];
-	ri = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_root_item);
 
 	ret = btrfs_del_item(trans, root, path);
 out:
-- 
1.7.7.6

