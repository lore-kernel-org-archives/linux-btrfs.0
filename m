Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41588 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756778AbaDIAT3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Apr 2014 20:19:29 -0400
Received: from m1.gw.fujitsu.co.jp (unknown [10.0.50.71])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 964EB3EE0B6
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Apr 2014 09:19:28 +0900 (JST)
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 8964A45DE55
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Apr 2014 09:19:28 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.nic.fujitsu.com [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 73D7345DE54
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Apr 2014 09:19:28 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 64C661DB8045
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Apr 2014 09:19:28 +0900 (JST)
Received: from m1001.s.css.fujitsu.com (m1001.s.css.fujitsu.com [10.240.81.139])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 16B201DB8042
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Apr 2014 09:19:28 +0900 (JST)
Message-Id: <201404090018.AA00003@WIN-R1VKH1IH438.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Wed, 09 Apr 2014 09:18:04 +0900
To: linux-btrfs@vger.kernel.org
Cc: alex@zadarastorage.com
Subject: [PATCH] Btrfs: fix possible memory leak in btrfs_create_tree()
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs_create_tree(), if btrfs_insert_root() fails, we should
free root->commit_root.

Reported-by: Alex Lyakas <alex@zadarastorage.com>
Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/disk-io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6d1ac7d..a35d7fb 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1374,6 +1374,7 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
 fail:
 	if (leaf) {
 		btrfs_tree_unlock(leaf);
+		free_extent_buffer(root->commit_root);
 		free_extent_buffer(leaf);
 	}
 	kfree(root);
-- 
1.8.5.5

