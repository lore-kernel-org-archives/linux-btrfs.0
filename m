Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57860 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752506AbaBTCws (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Feb 2014 21:52:48 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1K2qTLY013292
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Feb 2014 10:52:44 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 4/4] btrfs-progs: clean the unnecessary error msg of btrfs-file-show
Date: Thu, 20 Feb 2014 10:49:06 +0800
Message-Id: <1392864546-545-4-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1392864546-545-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1392864546-545-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the new version of btrfs-file-show fails, it will try to use the
old version. But before that, an error msg of the failed ioctl
shows up which causes xfstests case btrfs/006 to get a mismatch output.
I think we can just remove the error msg since the btrfs-file-show
still works with right outputs. Showing an error msg together with
the right result is really awkward.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 utils.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/utils.c b/utils.c
index 12ed2f4..9408885 100644
--- a/utils.c
+++ b/utils.c
@@ -2206,8 +2206,6 @@ again:
 		free(fsargs);
 		goto again;
 	} else if (ret < 0) {
-		printf("ERROR: scan_fsid ioctl failed - %s\n",
-			strerror(e));
 		ret = -e;
 		goto out;
 	}
-- 
1.8.1.4

