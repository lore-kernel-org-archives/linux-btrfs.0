Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46227 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab2LQGjJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Dec 2012 01:39:09 -0500
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 847373EE0C0
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2012 15:39:07 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 617BB45DEB5
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2012 15:39:07 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 20A4545DEF6
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2012 15:39:06 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 112031DB8047
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2012 15:39:06 +0900 (JST)
Received: from m1001.s.css.fujitsu.com (m1001.s.css.fujitsu.com [10.240.81.139])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id B9AD31DB8043
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2012 15:39:05 +0900 (JST)
Message-Id: <201212170638.AA00018@FM-323941448.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Mon, 17 Dec 2012 15:38:51 +0900
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com
Subject: [PATCH] Btrfs: fix memory leak in name_cache_insert()
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We should free name_cache_entry before returning from the
error handling code.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/send.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 5445454..321b7fb 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1814,8 +1814,10 @@ static int name_cache_insert(struct send_ctx *sctx,
 			(unsigned long)nce->ino);
 	if (!nce_head) {
 		nce_head = kmalloc(sizeof(*nce_head), GFP_NOFS);
-		if (!nce_head)
+		if (!nce_head) {
+			kfree(nce);
 			return -ENOMEM;
+		}
 		INIT_LIST_HEAD(nce_head);
 
 		ret = radix_tree_insert(&sctx->name_cache, nce->ino, nce_head);
-- 
1.7.12.2

