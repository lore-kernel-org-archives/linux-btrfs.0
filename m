Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41057 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab3EZNva (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 May 2013 09:51:30 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r4QDpSHR007304
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 26 May 2013 13:51:28 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4QDpSlv009957
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Sun, 26 May 2013 13:51:29 GMT
Received: from abhmt101.oracle.com (abhmt101.oracle.com [141.146.116.53])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4QDpS96006755
	for <linux-btrfs@vger.kernel.org>; Sun, 26 May 2013 13:51:28 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/5 RESEND] Btrfs: remove unused code in btrfs_del_root
Date: Sun, 26 May 2013 21:50:30 +0800
Message-Id: <1369576231-17836-5-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1369576231-17836-1-git-send-email-bo.li.liu@oracle.com>
References: <1369576231-17836-1-git-send-email-bo.li.liu@oracle.com>
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
1.7.7

