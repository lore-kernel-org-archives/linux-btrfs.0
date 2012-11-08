Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43405 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab2KHEr7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Nov 2012 23:47:59 -0500
Received: from m2.gw.fujitsu.co.jp (unknown [10.0.50.72])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id F2C283EE0AE
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Nov 2012 13:47:58 +0900 (JST)
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id DB2C845DE4D
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Nov 2012 13:47:58 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id C4B6D45DD74
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Nov 2012 13:47:58 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id B846A1DB803A
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Nov 2012 13:47:58 +0900 (JST)
Received: from m1001.s.css.fujitsu.com (m1001.s.css.fujitsu.com [10.240.81.139])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 709B91DB8043
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Nov 2012 13:47:58 +0900 (JST)
Message-Id: <201211080447.AA00016@FM-323941448.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Thu, 08 Nov 2012 13:47:33 +0900
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: set hole punching time properly
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Even if the hole punching is executed, the modification time of the
file is not updated.
So, current time is set to inode.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 110d3cb..15fecc1 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1964,6 +1964,9 @@ out_trans:
 	if (!trans)
 		goto out_free;
 
+	inode_inc_iversion(inode);
+	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+
 	trans->block_rsv = &root->fs_info->trans_block_rsv;
 	ret = btrfs_update_inode(trans, root, inode);
 	nr = trans->blocks_used;
-- 
1.7.12.2

