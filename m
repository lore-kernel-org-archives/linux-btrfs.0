Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33879 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbaLVKbb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 05:31:31 -0500
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 572973EE188
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 19:31:30 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 6C140AC05A9
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 19:31:29 +0900 (JST)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 16377E08005
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 19:31:29 +0900 (JST)
Received: from G01JPEXCHKW15.g01.fujitsu.local (G01JPEXCHKW15.g01.fujitsu.local [10.0.194.54])
	by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id 5ED2369271A
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 19:31:28 +0900 (JST)
Message-ID: <5497F2EE.1010906@jp.fujitsu.com>
Date: Mon, 22 Dec 2014 19:31:10 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] Remove unnecessary placeholder in btrfs_err_code
Content-Type: text/plain; charset="iso-2022-jp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

"notused" is not necessary. Set 1 to the first entry is enough.

---
 ioctl.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/ioctl.h b/ioctl.h
index 2c2c7c1..c377b96 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -474,8 +474,7 @@ struct btrfs_ioctl_qgroup_create_args {
 
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

