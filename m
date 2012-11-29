Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59757 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab2K2FJD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Nov 2012 00:09:03 -0500
Received: from m4.gw.fujitsu.co.jp (unknown [10.0.50.74])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 02C103EE0BC
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2012 14:09:01 +0900 (JST)
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 8477345DE4D
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2012 14:09:00 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 6D4A145DE4F
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2012 14:09:00 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 5E8711DB803F
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2012 14:09:00 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.240.81.134])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 0171A1DB802F
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2012 14:09:00 +0900 (JST)
Message-Id: <201211290508.AA00017@FM-323941448.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Thu, 29 Nov 2012 14:08:26 +0900
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com
Subject: [PATCH] Btrfs: add fiemap's flag check
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When the flag not supported is specified, it is necessary to return the error
to the caller.
So, we add the validity check of the fiemap's flag.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5fc0990..1e09991 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6582,9 +6582,17 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 		   btrfs_submit_direct, 0);
 }
 
+#define BTRFS_FIEMAP_FLAGS	(FIEMAP_FLAG_SYNC)
+
 static int btrfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		__u64 start, __u64 len)
 {
+	int	ret;
+
+	ret = fiemap_check_flags(fieinfo, BTRFS_FIEMAP_FLAGS);
+	if (ret)
+		return ret;
+
 	return extent_fiemap(inode, fieinfo, start, len, btrfs_get_extent_fiemap);
 }
 

