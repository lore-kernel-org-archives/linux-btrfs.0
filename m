Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60148 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbaLRGKV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Dec 2014 01:10:21 -0500
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 1506B3EE0C1
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Dec 2014 15:10:20 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 28EACAC0809
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Dec 2014 15:10:19 +0900 (JST)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id CC338E08005
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Dec 2014 15:10:18 +0900 (JST)
Message-ID: <54926FB4.6050604@jp.fujitsu.com>
Date: Thu, 18 Dec 2014 15:09:56 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: naota <naota@elisp.net>
Subject: [PATCH 1/2] Fix wrong memory free on check_is_root
Content-Type: text/plain; charset="iso-2022-jp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Date: Thu, 18 Dec 2014 14:35:22 +0900

@tmp is freed even if its allocation fails.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

---
 cmds-property.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/cmds-property.c b/cmds-property.c
index a764293..a4bc127 100644
--- a/cmds-property.c
+++ b/cmds-property.c
@@ -140,31 +140,32 @@ static int check_is_root(const char *object)
 	if (ret < 0) {
 		fprintf(stderr, "ERROR: get_fsid for %s failed. %s\n", object,
 				strerror(-ret));
-		goto out;
+		goto free_tmp_out;
 	}
 
 	ret = get_fsid(tmp, fsid2, 1);
 	if (ret == -ENOTTY) {
 		ret = 0;
-		goto out;
+		goto free_tmp_out;
 	} else if (ret == -ENOTDIR) {
 		ret = 1;
-		goto out;
+		goto free_tmp_out;
 	} else if (ret < 0) {
 		fprintf(stderr, "ERROR: get_fsid for %s failed. %s\n", tmp,
 			strerror(-ret));
-		goto out;
+		goto free_tmp_out;
 	}
 
 	if (memcmp(fsid, fsid2, BTRFS_FSID_SIZE)) {
 		ret = 0;
-		goto out;
+		goto free_tmp_out;
 	}
 
 	ret = 1;
 
-out:
+free_tmp_out:
 	free(tmp);
+out:
 	return ret;
 }
 
-- 
1.9.3

