Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23003 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751569AbaIABsR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 31 Aug 2014 21:48:17 -0400
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: move debug info to verbose mode for restore
Date: Mon, 1 Sep 2014 09:47:33 +0800
Message-ID: <1409536053-10457-1-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <20140829144937.GE31801@twin.jikos.cz>
References: <20140829144937.GE31801@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The restore tool should only print info of the restoring process
in verbose mode with -v option specified.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-restore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index e9ec472..f909429 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -310,7 +310,7 @@ static int copy_one_extent(struct btrfs_root *root, int fd,
 	if (compress == BTRFS_COMPRESS_NONE)
 		bytenr += offset;
 
-	if (offset)
+	if (verbose && offset)
 		printf("offset is %Lu\n", offset);
 	/* we found a hole */
 	if (disk_size == 0)
-- 
1.8.1.4

