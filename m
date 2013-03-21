Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47806 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab3CUEcw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 00:32:52 -0400
Received: from m1.gw.fujitsu.co.jp (unknown [10.0.50.71])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 37EC53EE0BB
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Mar 2013 13:32:51 +0900 (JST)
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 1FF5E45DE55
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Mar 2013 13:32:51 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 0B2B945DE54
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Mar 2013 13:32:51 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id F3C24E08001
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Mar 2013 13:32:50 +0900 (JST)
Received: from m1000.s.css.fujitsu.com (m1000.s.css.fujitsu.com [10.240.81.136])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id ACF221DB803F
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Mar 2013 13:32:50 +0900 (JST)
Received: from m1000.css.fujitsu.com (m1000 [127.0.0.1])
	by m1000.s.css.fujitsu.com (Postfix) with ESMTP id 8661F614E3
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Mar 2013 13:32:50 +0900 (JST)
Received: from FM-323941448.jp.fujitsu.com (unknown [10.124.101.132])
	by m1000.s.css.fujitsu.com (Postfix) with SMTP id 4E010611C5
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Mar 2013 13:32:50 +0900 (JST)
Message-Id: <201303210432.AA00023@FM-323941448.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Thu, 21 Mar 2013 13:32:32 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix memory leak in btrfs_create_tree()
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We should free leaf and root before returning from the error
handling code.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/disk-io.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7d84651..b1b5baa 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1291,6 +1291,7 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
 				      0, objectid, NULL, 0, 0, 0);
 	if (IS_ERR(leaf)) {
 		ret = PTR_ERR(leaf);
+		leaf = NULL;
 		goto fail;
 	}
 
@@ -1334,11 +1335,16 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
 
 	btrfs_tree_unlock(leaf);
 
+	return root;
+
 fail:
-	if (ret)
-		return ERR_PTR(ret);
+	if (leaf) {
+		btrfs_tree_unlock(leaf);
+		free_extent_buffer(leaf);
+	}
+	kfree(root);
 
-	return root;
+	return ERR_PTR(ret);
 }
 
 static struct btrfs_root *alloc_log_tree(struct btrfs_trans_handle *trans,

