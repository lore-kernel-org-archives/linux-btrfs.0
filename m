From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] btrfs: check return value of btrfs_start_ioctl_transaction()
 properly
Date: Mon, 24 Jan 2011 09:57:10 +0900
Message-ID: <4D3CCE66.5000008@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: Chris Mason <chris.mason@oracle.com>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_start_ioctl_transaction() returns ERR_PTR(), not NULL.
So, it is necessary to use IS_ERR() to check the return value.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -urNp linux-2.6.38-rc1/fs/btrfs/ioctl.c linux-2.6.38-rc1.new/fs/btrfs/ioctl.c
--- linux-2.6.38-rc1/fs/btrfs/ioctl.c	2011-01-19 08:14:02.000000000 +0900
+++ linux-2.6.38-rc1.new/fs/btrfs/ioctl.c	2011-01-24 09:27:12.000000000 +0900
@@ -2082,7 +2082,7 @@ static long btrfs_ioctl_trans_start(stru
 
 	ret = -ENOMEM;
 	trans = btrfs_start_ioctl_transaction(root, 0);
-	if (!trans)
+	if (IS_ERR(trans))
 		goto out_drop;
 
 	file->private_data = trans;


