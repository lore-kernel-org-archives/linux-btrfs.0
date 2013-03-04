Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33459 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115Ab3CDQ1V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Mar 2013 11:27:21 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r24GRKZv019217
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Mar 2013 16:27:20 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r24GRJKw009787
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Mar 2013 16:27:20 GMT
Received: from abhmt105.oracle.com (abhmt105.oracle.com [141.146.116.57])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r24GRJwN019192
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Mar 2013 10:27:19 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/6] Btrfs: free all recorded tree blocks on error
Date: Tue,  5 Mar 2013 00:25:38 +0800
Message-Id: <1362414341-17306-4-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1362414341-17306-1-git-send-email-bo.li.liu@oracle.com>
References: <1362414341-17306-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We've missed the 'free blocks' part on ENOMEM error.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/relocation.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 8608afb..8cae3d7 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2848,8 +2848,10 @@ int relocate_tree_blocks(struct btrfs_trans_handle *trans,
 	int err = 0;
 
 	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
+	if (!path) {
+		err = -ENOMEM;
+		goto out_path;
+	}
 
 	rb_node = rb_first(blocks);
 	while (rb_node) {
@@ -2888,10 +2890,11 @@ int relocate_tree_blocks(struct btrfs_trans_handle *trans,
 		rb_node = rb_next(rb_node);
 	}
 out:
-	free_block_list(blocks);
 	err = finish_pending_nodes(trans, rc, path, err);
 
 	btrfs_free_path(path);
+out_path:
+	free_block_list(blocks);
 	return err;
 }
 
-- 
1.7.7

