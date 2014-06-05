Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11405 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751591AbaFECH5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jun 2014 22:07:57 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5527tsP016994
	for <linux-btrfs@vger.kernel.org>; Thu, 5 Jun 2014 10:07:55 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: show meaningful msgs for replace cmd upon raid56
Date: Thu, 5 Jun 2014 10:02:52 +0800
Message-ID: <1401933772-23447-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1401933772-23447-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1401933772-23447-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This depends on the kernel patch:
	[PATCH] btrfs:replace EINVAL with EOPNOTSUPP for dev_replace

This catches the EOPNOTSUPP and output msg that says dev_replace raid56
is not currently supported. Note that the msg will only be shown when
run dev_replace not in background.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-replace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/cmds-replace.c b/cmds-replace.c
index 9eb981b..8b18110 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -301,6 +301,10 @@ static int cmd_start_replace(int argc, char **argv)
 				"ERROR: ioctl(DEV_REPLACE_START) failed on \"%s\": %s, %s\n",
 				path, strerror(errno),
 				replace_dev_result2string(start_args.result));
+
+			if (errno == EOPNOTSUPP)
+				fprintf(stderr, "WARNING: dev_replace cannot yet handle RAID5/RAID6\n");
+
 			goto leave_with_error;
 		}
 
-- 
1.8.1.4

