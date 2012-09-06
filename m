Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:24575 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757992Ab2IFKot (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Sep 2012 06:44:49 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q86A4uRj017660
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Sep 2012 18:04:57 +0800
Message-ID: <5048753C.2080106@cn.fujitsu.com>
Date: Thu, 06 Sep 2012 18:04:44 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V4 11/12] Btrfs: output more information when aborting a unused
 transaction handle
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <50487434.1010305@cn.fujitsu.com>

Though we dump the stack information when aborting a unused transaction
handle, we don't know the correct place where we decide to abort the
transaction handle if one function has several place where the transaction
abort function is invoked and jumps to the same place after this call.
And beside that we also don't know the reason why we jump to abort
the current handle. So I modify the transaction abort function and make
it output the function name, line and error information.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v4:
- new patch.
---
 fs/btrfs/super.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 48e53d6..b3d9f4b 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -223,7 +223,13 @@ void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
 	/* Nothing used. The other threads that have joined this
 	 * transaction may be able to continue. */
 	if (!trans->blocks_used) {
-		btrfs_printk(root->fs_info, "Aborting unused transaction.\n");
+		char nbuf[16];
+		const char *errstr;
+
+		errstr = btrfs_decode_error(root->fs_info, errno, nbuf);
+		btrfs_printk(root->fs_info,
+			     "%s:%d: Aborting unused transaction(%s).\n",
+			     function, line, errstr);
 		return;
 	}
 	trans->transaction->aborted = errno;
-- 
1.7.6.5
