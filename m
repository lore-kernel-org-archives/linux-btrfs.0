Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42129 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074AbaIRI2Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 04:28:25 -0400
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id C319B3EE1C9
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 17:28:23 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id D76FFAC07B1
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 17:28:22 +0900 (JST)
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 8A8071DB803A
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 17:28:22 +0900 (JST)
Received: from g01jpexchyt33.g01.fujitsu.local (unknown [10.128.193.4])
	by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id 5CDC146E499
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 17:28:21 +0900 (JST)
Message-ID: <541A979D.8060409@jp.fujitsu.com>
Date: Thu, 18 Sep 2014 17:28:13 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/5] btrfs: correct a message on setting nodatacow
References: <541A9717.5000003@jp.fujitsu.com>
In-Reply-To: <541A9717.5000003@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Naohiro Aota <naota@elisp.net>

If we set nodatacow mount option after compress-force option,
we don't get compression disabling message.

===
$ sudo mount -o remount,compress-force,nodatacow /; dmesg|tail -n 3
[ 3845.719047] BTRFS info (device vda2): force zlib compression
[ 3845.719052] BTRFS info (device vda2): setting nodatacow
[ 3845.719055] BTRFS info (device vda2): disk space caching is enabled
===

Signed-off-by: Naohiro Aota <naota@elisp.net>
Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
 fs/btrfs/super.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d1c5b6d..d131098 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -462,8 +462,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			break;
 		case Opt_nodatacow:
 			if (!btrfs_test_opt(root, NODATACOW)) {
-				if (!btrfs_test_opt(root, COMPRESS) ||
-				    !btrfs_test_opt(root, FORCE_COMPRESS)) {
+				if (btrfs_test_opt(root, COMPRESS)) {
 					btrfs_info(root->fs_info,
 						   "setting nodatacow, compression disabled");
 				} else {
-- 1.8.3.1 

