Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:8995 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752456AbaBTCwo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Feb 2014 21:52:44 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1K2qdxc013316
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Feb 2014 10:52:42 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 2/4] btrfs-progs: fix segment fault when exec btrfs-debug-tree as non-root
Date: Thu, 20 Feb 2014 10:49:04 +0800
Message-Id: <1392864546-545-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1392864546-545-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1392864546-545-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When exec btrfs-debug-tree as non-root user, we get a segment fault.
Because the btrfs_scan_block_devices return a success 0 when we fail
to open a device. Now we just return the errno if this case happens.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 utils.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index 97e23d5..1878abc 100644
--- a/utils.c
+++ b/utils.c
@@ -1517,7 +1517,8 @@ scan_again:
 		scans++;
 		goto scan_again;
 	}
-	return 0;
+
+	return errno ? -errno : 0;
 }
 
 u64 parse_size(char *s)
-- 
1.8.1.4

