Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44325 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbaIRI0K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 04:26:10 -0400
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 540423EE0BD
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 17:26:08 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 69ED2AC07B1
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 17:26:07 +0900 (JST)
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 19C501DB8032
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 17:26:07 +0900 (JST)
Received: from g01jpexchyt37.g01.fujitsu.local (unknown [10.128.193.4])
	by g01jpfmpwyt02.exch.g01.fujitsu.local (Postfix) with ESMTP id 1E35758431A
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 17:26:06 +0900 (JST)
Message-ID: <541A9717.5000003@jp.fujitsu.com>
Date: Thu, 18 Sep 2014 17:25:59 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/5] btrfs: nodatasum drop compress
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Naohiro Aota <naota@elisp.net>

We can enable both compress option and nodatasum option at the same time
with the following command.

===
$ sudo mount -o remount,compress,nodatasum /
$ mount | grep btrfs
/dev/vda2 on / type btrfs (rw,relatime,seclabel,nodatasum,compress=zlib,space_cache)
===

This behavior collides with Documentation/filesystems/btrfs.txt:

===
...
  If compression is enabled, nodatacow and nodatasum are disabled.
...
===

This patch drops the compress flags upon nodatasum flag.

Signed-off-by: Naohiro Aota <naota@elisp.net>
Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
 fs/btrfs/super.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index c4124de..d1c5b6d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -440,8 +440,15 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			 */
 			break;
 		case Opt_nodatasum:
-			btrfs_set_and_info(root, NODATASUM,
-					   "setting nodatasum");
+			if (!btrfs_test_opt(root, NODATASUM)) {
+				if (btrfs_test_opt(root, COMPRESS))
+					btrfs_info(root->fs_info, "setting nodatasum, compression disabled");
+				else
+					btrfs_info(root->fs_info, "setting nodatasum");
+			}
+			btrfs_clear_opt(info->mount_opt, COMPRESS);
+			btrfs_clear_opt(info->mount_opt, FORCE_COMPRESS);
+			btrfs_set_opt(info->mount_opt, NODATASUM);
 			break;
 		case Opt_datasum:
 			if (btrfs_test_opt(root, NODATASUM)) {
-- 1.8.3.1 

