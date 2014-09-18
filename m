Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33347 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbaIRIco (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 04:32:44 -0400
Received: from kw-mxoi1.gw.nic.fujitsu.com (unknown [10.0.237.133])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 713AF3EE174
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 17:32:43 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 82BF6AC019C
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 17:32:42 +0900 (JST)
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 240081DB803B
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 17:32:42 +0900 (JST)
Received: from g01jpexchyt37.g01.fujitsu.local (unknown [10.128.193.4])
	by g01jpfmpwyt02.exch.g01.fujitsu.local (Postfix) with ESMTP id 2AE2258428B
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 17:32:41 +0900 (JST)
Message-ID: <541A98A4.9000000@jp.fujitsu.com>
Date: Thu, 18 Sep 2014 17:32:36 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/5] btrfs: suppress a verbose message about enabling space
 cache on remounting
References: <541A9717.5000003@jp.fujitsu.com>
In-Reply-To: <541A9717.5000003@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Naohiro Aota <naota@elisp.net>

Remount operation always tells you it enabled space cache.
I consider it's a bit verbose and is better not to show
this message on remounting.

Signed-off-by: Naohiro Aota <naota@elisp.net>
Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
 fs/btrfs/super.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 7ad4293..03131c5 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -404,7 +404,8 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 
 	cache_gen = btrfs_super_cache_generation(root->fs_info->super_copy);
 	if (cache_gen)
-		btrfs_set_opt(info->mount_opt, SPACE_CACHE);
+		btrfs_set_and_info(root, SPACE_CACHE,
+				   "disk space caching is enabled");
 
 	if (!options)
 		goto out;
@@ -758,8 +759,6 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		}
 	}
 out:
-	if (!ret && btrfs_test_opt(root, SPACE_CACHE))
-		btrfs_info(root->fs_info, "disk space caching is enabled");
 	kfree(orig);
 	return ret;
 }
-- 1.8.3.1 

