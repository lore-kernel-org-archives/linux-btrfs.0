Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40966 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215AbaISJFV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Sep 2014 05:05:21 -0400
Received: from kw-mxoi1.gw.nic.fujitsu.com (unknown [10.0.237.133])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 412AA3EE0C2
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Sep 2014 18:05:20 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 4BD42AC0886
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Sep 2014 18:05:19 +0900 (JST)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id C7CB01DB803B
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Sep 2014 18:05:18 +0900 (JST)
Message-ID: <541BF1C4.1050000@jp.fujitsu.com>
Date: Fri, 19 Sep 2014 18:05:08 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: Chris Mason <clm@fb.com>, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 4/4] btrfs: Fix compression related ioctl to run atomic operations
 in one transaction
References: <541BED3D.5020803@jp.fujitsu.com> <541BEDF8.7010009@jp.fujitsu.com> <541BEEC1.9030606@jp.fujitsu.com>
In-Reply-To: <541BEEC1.9030606@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Naohiro Aota <naota@elisp.net>

Fix the following two problems in compression related ioctl code.

  a) Updating compression flags and updating inode attribute
     in two separated transaction. So, if something bad happens
     after the former, and before the latter, file system
     would become inconsistent state.

     This patch move them into one transaction.

  b) It updates compression flags here and calls btrfs_set_prop()
     after that. However flags are also updated in this function.

     This patch removes the duplicated code for updating flags
     from ioctl code and aggregates this work to __btrfs_set_prop()
     at all. 

Signed-off-by: Naohiro Aota <naota@elisp.net>
Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
 fs/btrfs/ioctl.c | 32 +++++++++++---------------------
 1 file changed, 11 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0ff2127..47ac6da 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -221,6 +221,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	u64 ip_oldflags;
 	unsigned int i_oldflags;
 	umode_t mode;
+	const char *comp;
 
 	if (!inode_owner_or_capable(inode))
 		return -EPERM;
@@ -310,40 +311,29 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	 * things smaller.
 	 */
 	if (flags & FS_NOCOMP_FL) {
-		ip->flags &= ~BTRFS_INODE_COMPRESS;
-		ip->flags |= BTRFS_INODE_NOCOMPRESS;
-
-		ret = btrfs_set_prop(inode, "btrfs.compression", NULL, 0, 0);
-		if (ret && ret != -ENODATA)
-			goto out_drop;
+		comp = "off";
 	} else if (flags & FS_COMPR_FL) {
-		const char *comp;
-
-		ip->flags |= BTRFS_INODE_COMPRESS;
-		ip->flags &= ~BTRFS_INODE_NOCOMPRESS;
-
 		if (root->fs_info->compress_type == BTRFS_COMPRESS_LZO)
 			comp = "lzo";
 		else
 			comp = "zlib";
-		ret = btrfs_set_prop(inode, "btrfs.compression",
-				     comp, strlen(comp), 0);
-		if (ret)
-			goto out_drop;
-
 	} else {
-		ret = btrfs_set_prop(inode, "btrfs.compression", NULL, 0, 0);
-		if (ret && ret != -ENODATA)
-			goto out_drop;
-		ip->flags &= ~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);
+		comp = "";
 	}
 
-	trans = btrfs_start_transaction(root, 1);
+	trans = btrfs_start_transaction(root, 2);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		goto out_drop;
 	}
 
+	ret = __btrfs_set_prop(trans, inode, "btrfs.compression", comp,
+			       strlen(comp), 0);
+	if (ret && ret != -ENODATA) {
+		btrfs_end_transaction(trans, root);
+		goto out_drop;
+	}
+
 	btrfs_update_iflags(inode);
 	inode_inc_iversion(inode);
 	inode->i_ctime = CURRENT_TIME;
-- 1.8.3.1 

