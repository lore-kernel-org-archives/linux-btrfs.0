Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:63784 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750795AbdLNI2O (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Dec 2017 03:28:14 -0500
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 96290AC0091
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Dec 2017 17:28:10 +0900 (JST)
Received: from g01jpexchkw35.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id DA20932884E
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Dec 2017 17:28:09 +0900 (JST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs: cleanup unnecessary string dup in
 btrfs_parse_options()
Message-ID: <0530ed22-f85e-ad17-58f3-9f4d147f8430@jp.fujitsu.com>
Date: Thu, 14 Dec 2017 17:28:00 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Long ago, commit edf24abe51493 ("btrfs: sanity mount option parsing and
early mount code") split the btrfs_parse_options() into two parts
(btrfs_parse_early_options() and btrfs_parse_options()). As a result,
btrfs_parse_optins no longer gets called twice and is the last one to parse
mount option string. Therefore there is no need to dup it.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/super.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 7da78cb8a946..69c1ed398513 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -411,7 +411,7 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			unsigned long new_flags)
 {
 	substring_t args[MAX_OPT_ARGS];
-	char *p, *num, *orig = NULL;
+	char *p, *num;
 	u64 cache_gen;
 	int intarg;
 	int ret = 0;
@@ -434,16 +434,6 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 	if (!options)
 		goto check;
 
-	/*
-	 * strsep changes the string, duplicate it because parse_options
-	 * gets called twice
-	 */
-	options = kstrdup(options, GFP_KERNEL);
-	if (!options)
-		return -ENOMEM;
-
-	orig = options;
-
 	while ((p = strsep(&options, ",")) != NULL) {
 		int token;
 		if (!*p)
@@ -884,7 +874,6 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 		btrfs_info(info, "disk space caching is enabled");
 	if (!ret && btrfs_test_opt(info, FREE_SPACE_TREE))
 		btrfs_info(info, "using free space tree");
-	kfree(orig);
 	return ret;
 }
 
-- 
2.13.6

