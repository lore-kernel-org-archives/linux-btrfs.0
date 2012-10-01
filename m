Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48552 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab2JAJJE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Oct 2012 05:09:04 -0400
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id DC6E83EE0B6
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Oct 2012 18:09:02 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id BFD3D45DEBC
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Oct 2012 18:09:02 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 6753D45DEBA
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Oct 2012 18:09:00 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 581D21DB803B
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Oct 2012 18:09:00 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.240.81.134])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 0E3A81DB8038
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Oct 2012 18:09:00 +0900 (JST)
Message-Id: <201210010908.AA00013@FM-323941448.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Mon, 01 Oct 2012 18:08:37 +0900
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com
Subject: [PATCH] Btrfs: confirmation of value is added before trace_btrfs_get_extent() is called
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We should confirm the value of extent_map before calling
trace_btrfs_get_extent() because the value of extent_map has the
possibility of NULL.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index cad0c57..b8f53e8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6123,7 +6123,8 @@ insert:
 	write_unlock(&em_tree->lock);
 out:
 
-	trace_btrfs_get_extent(root, em);
+	if (em)
+		trace_btrfs_get_extent(root, em);
 
 	if (path)
 		btrfs_free_path(path);
-- 
1.7.11.4

