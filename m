Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45326 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213Ab3DRHLG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Apr 2013 03:11:06 -0400
Received: from m4.gw.fujitsu.co.jp (unknown [10.0.50.74])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id DF6A13EE0AE
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Apr 2013 16:11:02 +0900 (JST)
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id C4D3B45DE50
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Apr 2013 16:11:02 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id ABB9445DE4F
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Apr 2013 16:11:02 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 9BBBF1DB803E
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Apr 2013 16:11:02 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.240.81.134])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 4B043E08007
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Apr 2013 16:11:02 +0900 (JST)
Received: from ml14.css.fujitsu.com (ml14 [127.0.0.1])
	by ml14.s.css.fujitsu.com (Postfix) with ESMTP id 1D4389F7D15
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Apr 2013 16:11:02 +0900 (JST)
Received: from FM-323941448.jp.fujitsu.com (unknown [10.124.101.132])
	by ml14.s.css.fujitsu.com (Postfix) with SMTP id A95009F7D48
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Apr 2013 16:11:01 +0900 (JST)
Message-Id: <201304180710.AA00028@FM-323941448.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Thu, 18 Apr 2013 16:10:44 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: remove unused variable in __process_changed_new_xattr()
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Variable 'p' is not used any more. So, remove it.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/send.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index ed897dc..96a826a 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3479,7 +3479,6 @@ static int __process_changed_new_xattr(int num, struct btrfs_key *di_key,
 	struct send_ctx *sctx = ctx;
 	char *found_data = NULL;
 	int found_data_len  = 0;
-	struct fs_path *p = NULL;
 
 	ret = find_xattr(sctx, sctx->parent_root, sctx->right_path,
 			sctx->cmp_key, name, name_len, &found_data,
@@ -3498,7 +3497,6 @@ static int __process_changed_new_xattr(int num, struct btrfs_key *di_key,
 	}
 
 	kfree(found_data);
-	fs_path_free(sctx, p);
 	return ret;
 }
 

