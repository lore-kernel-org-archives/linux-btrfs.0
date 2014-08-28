Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57221 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933108AbaH1C0Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Aug 2014 22:26:25 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s7S2QLbg012086
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Aug 2014 10:26:21 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 2/3] btrfs-progs: fix next_leaf in restore as it improperly skips some slots
Date: Thu, 28 Aug 2014 10:25:54 +0800
Message-ID: <1409192755-1826-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1409192755-1826-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1409192755-1826-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When entering the next level node, the @next_leaf in restore forgets to
start at the first slot. Just reset it to the first one.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-restore.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/cmds-restore.c b/cmds-restore.c
index e94592c..918f1fb 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -191,6 +191,7 @@ again:
 			level++;
 			if (level == BTRFS_MAX_LEVEL)
 				return 1;
+			offset = 1;
 			continue;
 		}
 
-- 
1.8.1.4

