Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58414 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab2IFJJc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Sep 2012 05:09:32 -0400
Received: from m4.gw.fujitsu.co.jp (unknown [10.0.50.74])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id CF5A23EE0BC
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Sep 2012 18:09:30 +0900 (JST)
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id B93F145DE52
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Sep 2012 18:09:30 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 9DEDA45DE51
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Sep 2012 18:09:30 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 517DBE08003
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Sep 2012 18:09:30 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.240.81.134])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 043F81DB803E
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Sep 2012 18:09:30 +0900 (JST)
Message-Id: <201209060908.AA00005@FM-323941448.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Thu, 06 Sep 2012 18:08:59 +0900
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix error handling in delete_block_group_cache()
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_iget() never return NULL.
So, NULL check is unnecessary.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/relocation.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index c5dbd91..738e869 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3270,8 +3270,8 @@ static int delete_block_group_cache(struct btrfs_fs_info *fs_info,
 	key.offset = 0;
 
 	inode = btrfs_iget(fs_info->sb, &key, root, NULL);
-	if (IS_ERR_OR_NULL(inode) || is_bad_inode(inode)) {
-		if (inode && !IS_ERR(inode))
+	if (IS_ERR(inode) || is_bad_inode(inode)) {
+		if (!IS_ERR(inode))
 			iput(inode);
 		return -ENOENT;
 	}

