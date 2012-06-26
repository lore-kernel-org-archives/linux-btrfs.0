Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48459 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873Ab2FZDWt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 23:22:49 -0400
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 3D2553EE0BC
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2012 12:22:48 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 2568C45DEAD
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2012 12:22:48 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 0CA6145DE7E
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2012 12:22:48 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 012B11DB803E
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2012 12:22:48 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.240.81.134])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id AF9D31DB803B
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2012 12:22:47 +0900 (JST)
Message-Id: <201206260322.AA00002@FM-323941448.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Tue, 26 Jun 2012 12:22:10 +0900
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: check return value of btrfs_set_extent_delalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_set_extent_delalloc() has the possibility of returning the error.
So I add the code in which the return value of btrfs_set_extent_delalloc()
is checked.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/ioctl.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0e92e57..95e27d6 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1016,13 +1016,16 @@ again:
 	}
 
 
-	btrfs_set_extent_delalloc(inode, page_start, page_end - 1,
-				  &cached_state);
+	ret = btrfs_set_extent_delalloc(inode, page_start, page_end - 1,
+					&cached_state);
 
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree,
 			     page_start, page_end - 1, &cached_state,
 			     GFP_NOFS);
 
+	if (ret)
+		goto out;
+
 	for (i = 0; i < i_done; i++) {
 		clear_page_dirty_for_io(pages[i]);
 		ClearPageChecked(pages[i]);

