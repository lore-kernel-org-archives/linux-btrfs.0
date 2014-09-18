Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33025 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbaIRIbA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 04:31:00 -0400
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 3D8313EE0CD
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 17:30:59 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 8E3D9AC07B6
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 17:30:57 +0900 (JST)
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 00110E38001
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 17:30:56 +0900 (JST)
Received: from g01jpexchyt36.g01.fujitsu.local (unknown [10.128.193.4])
	by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id 35BF746E499
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 17:30:55 +0900 (JST)
Message-ID: <541A983A.4000102@jp.fujitsu.com>
Date: Thu, 18 Sep 2014 17:30:50 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/5] btrfs: notice nodatasum is also enabled with nodatacow
References: <541A9717.5000003@jp.fujitsu.com>
In-Reply-To: <541A9717.5000003@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Naohiro Aota <naota@elisp.net>

Documentation/filesystems/btrfs.txt states the following:

===
...
  Nodatacow implies nodatasum, and disables all compression.
...
===

However the current message only mentions nodatacow. It's better to
also mention nodatasum.

Signed-off-by: Naohiro Aota <naota@elisp.net>
Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
 fs/btrfs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d131098..7ad4293 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -464,9 +464,9 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			if (!btrfs_test_opt(root, NODATACOW)) {
 				if (btrfs_test_opt(root, COMPRESS)) {
 					btrfs_info(root->fs_info,
-						   "setting nodatacow, compression disabled");
+						   "setting nodatacow and nodatasum, compression disabled");
 				} else {
-					btrfs_info(root->fs_info, "setting nodatacow");
+					btrfs_info(root->fs_info, "setting nodatacow and nodatasum");
 				}
 			}
 			btrfs_clear_opt(info->mount_opt, COMPRESS);
-- 1.8.3.1 

