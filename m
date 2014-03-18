Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:54557 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754601AbaCRMFE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Mar 2014 08:05:04 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s2IC4uSR001920
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Mar 2014 20:04:57 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/6] Btrfs-progs: fsck: fix possible memory leaks in run_next_block()
Date: Tue, 18 Mar 2014 20:02:43 +0800
Message-Id: <1395144167-775-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1395144167-775-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1395144167-775-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We still need free allocated cache memory in case error happens.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-check.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index c0b7f8c..b3f7e22 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -5909,6 +5909,9 @@ out:
 	free_block_group_tree(&block_group_cache);
 	free_device_extent_tree(&dev_extent_cache);
 	free_extent_cache_tree(&seen);
+	free_extent_cache_tree(&pending);
+	free_extent_cache_tree(&reada);
+	free_extent_cache_tree(&nodes);
 	return ret;
 }
 
-- 
1.9.0

