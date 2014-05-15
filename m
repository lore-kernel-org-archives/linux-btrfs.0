Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56665 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752002AbaEOBdx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 21:33:53 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s4F1XpeM007585
	for <linux-btrfs@vger.kernel.org>; Thu, 15 May 2014 09:33:51 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 3/3] btrfs-progs: use check_argc_exact to check arg number of btrfs-rescue
Date: Thu, 15 May 2014 09:29:09 +0800
Message-ID: <1400117349-2851-3-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1400117349-2851-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1400117349-2851-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The btrfs-rescue accepts exactly one arg for both
chunk-recover & super-recover, use check_argc_exact clearly.
---
 cmds-rescue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-rescue.c b/cmds-rescue.c
index 9491d0c..3629141 100644
--- a/cmds-rescue.c
+++ b/cmds-rescue.c
@@ -85,7 +85,7 @@ int cmd_chunk_recover(int argc, char *argv[])
 	}
 
 	argc = argc - optind;
-	if (argc == 0)
+	if (check_argc_exact(argc, 1))
 		usage(cmd_chunk_recover_usage);
 
 	file = argv[optind];
@@ -141,7 +141,7 @@ int cmd_super_recover(int argc, char **argv)
 		}
 	}
 	argc = argc - optind;
-	if (argc != 1)
+	if (check_argc_exact(argc, 1))
 		usage(cmd_super_recover_usage);
 
 	dname = argv[optind];
-- 
1.8.1.4

