Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:50848 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab2G3IPt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Jul 2012 04:15:49 -0400
Date: Mon, 30 Jul 2012 11:15:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chris Mason <chris.mason@fusionio.com>, Arne Jansen <sensille@gmx.net>
Cc: linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 1/2] Btrfs: checking for NULL instead of IS_ERR
Message-ID: <20120730081542.GC15702@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

add_qgroup_rb() never returns NULL, only error pointers.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Applies to linux-next.

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index bc424ae..b650155 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1364,8 +1364,10 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 	spin_lock(&fs_info->qgroup_lock);
 
 	dstgroup = add_qgroup_rb(fs_info, objectid);
-	if (!dstgroup)
+	if (IS_ERR(dstgroup)) {
+		ret = PTR_ERR(dstgroup);
 		goto unlock;
+	}
 
 	if (srcid) {
 		srcgroup = find_qgroup_rb(fs_info, srcid);
