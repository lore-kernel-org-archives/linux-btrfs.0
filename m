Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48526 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462Ab2FZDZl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 23:25:41 -0400
Received: from m2.gw.fujitsu.co.jp (unknown [10.0.50.72])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id E2E613EE0B6
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2012 12:25:40 +0900 (JST)
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id C889845DE53
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2012 12:25:40 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id B321345DD78
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2012 12:25:40 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id A71621DB803C
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2012 12:25:40 +0900 (JST)
Received: from m1000.s.css.fujitsu.com (m1000.s.css.fujitsu.com [10.240.81.136])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 5BAC71DB803A
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2012 12:25:40 +0900 (JST)
Message-Id: <201206260325.AA00003@FM-323941448.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Tue, 26 Jun 2012 12:25:22 +0900
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: return error of btrfs_update_inode() to caller
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We didn't check error of btrfs_update_inode(), but that error looks
easy to bubble back up.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/inode.c    |    2 +-
 fs/btrfs/tree-log.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4a4f2d5..7a5d42e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2833,7 +2833,7 @@ err:
 	inode_inc_iversion(inode);
 	inode_inc_iversion(dir);
 	inode->i_ctime = dir->i_mtime = dir->i_ctime = CURRENT_TIME;
-	btrfs_update_inode(trans, root, dir);
+	ret = btrfs_update_inode(trans, root, dir);
 out:
 	return ret;
 }
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 2017d0f..6551ed4 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -637,7 +637,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 	}
 
 	inode_set_bytes(inode, saved_nbytes);
-	btrfs_update_inode(trans, root, inode);
+	ret = btrfs_update_inode(trans, root, inode);
 out:
 	if (inode)
 		iput(inode);
@@ -1130,7 +1130,7 @@ static noinline int link_to_fixup_dir(struct btrfs_trans_handle *trans,
 	btrfs_release_path(path);
 	if (ret == 0) {
 		btrfs_inc_nlink(inode);
-		btrfs_update_inode(trans, root, inode);
+		ret = btrfs_update_inode(trans, root, inode);
 	} else if (ret == -EEXIST) {
 		ret = 0;
 	} else {

