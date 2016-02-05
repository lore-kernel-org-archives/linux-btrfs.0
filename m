Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:28543 "EHLO
	mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbcBEIJR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Feb 2016 03:09:17 -0500
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
	by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id E22D9AC0248
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Feb 2016 17:09:07 +0900 (JST)
Received: from G01JPEXCHKW18.g01.fujitsu.local (G01JPEXCHKW18.g01.fujitsu.local [10.0.194.57])
	by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id E3782692587
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Feb 2016 17:07:34 +0900 (JST)
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: write down the meaning of BTRFS_ARG_BLKDEV
Message-ID: <56B45846.7070401@jp.fujitsu.com>
Date: Fri, 5 Feb 2016 17:07:34 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although BTRFS_ARG_BLKDEV can be returned from check_arg_type(),
it's not explained the meaning.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
 utils.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/utils.c b/utils.c
index 3df8b42..eabc36d 100644
--- a/utils.c
+++ b/utils.c
@@ -1007,6 +1007,7 @@ static int is_reg_file(const char *path)
  * return BTRFS_ARG_UUID:	given input is uuid
  * return BTRFS_ARG_MNTPOINT:	given input is path
  * return BTRFS_ARG_REG:	given input is regular file
+ * return BTRFS_ARG_BLKDEV:	given input is block device
  */
 int check_arg_type(const char *input)
 {
-- 
2.5.0


