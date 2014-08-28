Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45205 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965641AbaH1C01 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Aug 2014 22:26:27 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s7S2QNxO012096
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Aug 2014 10:26:23 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 3/3] btrfs-progs: remove meaningless debug info for restore
Date: Thu, 28 Aug 2014 10:25:55 +0800
Message-ID: <1409192755-1826-3-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1409192755-1826-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1409192755-1826-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The printf of @offset enlightens the user little.
And the restore cmd is not a debugging tool, so just
remove the debug-info-like printf.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-restore.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 918f1fb..648fbc9 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -310,8 +310,6 @@ static int copy_one_extent(struct btrfs_root *root, int fd,
 	if (compress == BTRFS_COMPRESS_NONE)
 		bytenr += offset;
 
-	if (offset)
-		printf("offset is %Lu\n", offset);
 	/* we found a hole */
 	if (disk_size == 0)
 		return 0;
-- 
1.8.1.4

