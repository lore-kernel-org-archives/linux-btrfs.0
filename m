Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:52151 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755978Ab3CDJoM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Mar 2013 04:44:12 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r249iA8Z022238
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Mar 2013 17:44:10 +0800
Message-ID: <51346D22.2080007@cn.fujitsu.com>
Date: Mon, 04 Mar 2013 17:45:06 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] Btrfs: fix unclosed transaction handler when the async
 transaction commitment fails
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the async transaction commitment failed, we need close the
current transaction handler, or the current transaction will be
blocked to commit because of this orphan handler.

We fix the problem by doing sync transaction commitment, that is
to invoke btrfs_commit_transaction().

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 94c0e42..3fdfabc 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -527,6 +527,8 @@ fail:
 	if (async_transid) {
 		*async_transid = trans->transid;
 		err = btrfs_commit_transaction_async(trans, root, 1);
+		if (err)
+			err = btrfs_commit_transaction(trans, root);
 	} else {
 		err = btrfs_commit_transaction(trans, root);
 	}
@@ -592,6 +594,8 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 		*async_transid = trans->transid;
 		ret = btrfs_commit_transaction_async(trans,
 				     root->fs_info->extent_root, 1);
+		if (ret)
+			ret = btrfs_commit_transaction(trans, root);
 	} else {
 		ret = btrfs_commit_transaction(trans,
 					       root->fs_info->extent_root);
-- 
1.6.5.2
