Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40346 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaLXFwO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Dec 2014 00:52:14 -0500
Received: from kw-mxoi1.gw.nic.fujitsu.com (unknown [10.0.237.133])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 080CC3EE188
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Dec 2014 14:52:13 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 0C1E0AC06CA
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Dec 2014 14:52:12 +0900 (JST)
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 6FD34E08001
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Dec 2014 14:52:11 +0900 (JST)
Received: from g01jpexchkw37.g01.fujitsu.local (unknown [10.0.193.4])
	by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id BA669BD646B
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Dec 2014 14:52:10 +0900 (JST)
Message-ID: <549A5484.9000202@jp.fujitsu.com>
Date: Wed, 24 Dec 2014 14:52:04 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] Btrfs: Remove unnecessary placeholder in btrfs_err_code
Content-Type: text/plain; charset="iso-2022-jp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

"notused" is not necessary. Set 1 to the first entry is enough.

Signed-off-by: Takeuchi Satoru <takeuchi_satoru@jp.fujitsu.com
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
I once submit the similar patch to btrfs-progs.
Then Gui Hecheng tell me fixing original code in kernel
is better.

http://permalink.gmane.org/gmane.comp.file-systems.btrfs/41679
---
 include/uapi/linux/btrfs.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 611e1c5..b6dec05 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -495,8 +495,7 @@ struct btrfs_ioctl_send_args {
 
 /* Error codes as returned by the kernel */
 enum btrfs_err_code {
-	notused,
-	BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET,
+	BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET = 1,
 	BTRFS_ERROR_DEV_RAID10_MIN_NOT_MET,
 	BTRFS_ERROR_DEV_RAID5_MIN_NOT_MET,
 	BTRFS_ERROR_DEV_RAID6_MIN_NOT_MET,
-- 
1.8.3.1

