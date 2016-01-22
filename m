Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:50458 "EHLO
	mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbcAVAO6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 19:14:58 -0500
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 35EA0AC04CF
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Jan 2016 09:14:55 +0900 (JST)
Received: from WIN-5MHF4RKU941.jp.fujitsu.com (unknown [10.124.102.163])
	by m3050.s.css.fujitsu.com (Postfix) with SMTP id 1951215B
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Jan 2016 09:14:55 +0900 (JST)
Message-Id: <201601220013.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Fri, 22 Jan 2016 09:13:25 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix error number in send.c
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

ENOTSUPP should not be returned to the user program.
 (cf. include/linux/errno.h)
Therefore, EOPNOTSUPP is used instead of ENOTSUPP.  

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 63a6152..b4229e8 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2576,7 +2576,7 @@ verbose_printk("btrfs: send_create_inode %llu\n", ino);
 	} else {
 		btrfs_warn(sctx->send_root->fs_info, "unexpected inode type %o",
 				(int)(mode & S_IFMT));
-		ret = -ENOTSUPP;
+		ret = -EOPNOTSUPP;
 		goto out;
 	}
 
-- 
2.6.4
