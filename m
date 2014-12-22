Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40536 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbaLVKjS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 05:39:18 -0500
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id D324D3EE0B6
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 19:39:17 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id D1DE1AC0601
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 19:39:16 +0900 (JST)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 863FBE08002
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 19:39:16 +0900 (JST)
Received: from G01JPEXCHKW13.g01.fujitsu.local (G01JPEXCHKW13.g01.fujitsu.local [10.0.194.52])
	by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id A89BA3288B5
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 19:39:15 +0900 (JST)
Message-ID: <5497F4CD.4010301@jp.fujitsu.com>
Date: Mon, 22 Dec 2014 19:39:09 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] Remove unnecessary placeholder in btrfs_err_code
References: <5497F2EE.1010906@jp.fujitsu.com>
In-Reply-To: <5497F2EE.1010906@jp.fujitsu.com>
Content-Type: text/plain; charset="iso-2022-jp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry, I forgot to add Signed-off-by line.

---
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

"notused" is not necessary. Set 1 to the first entry is enough.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

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
-- 1.8.3.1 -- To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in the body of a message to majordomo@vger.kernel.org More majordomo info at http://vger.kernel.org/majordomo-info.html 

