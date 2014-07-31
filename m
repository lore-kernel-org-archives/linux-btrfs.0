Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42243 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756138AbaGaD3o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 23:29:44 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6V3TfGb008708
	for <linux-btrfs@vger.kernel.org>; Thu, 31 Jul 2014 11:29:41 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 2/3] btrfs-progs: remove unnecessary return value check in btrfs-property
Date: Thu, 31 Jul 2014 11:23:43 +0800
Message-ID: <1406777024-7647-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1406777024-7647-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1406777024-7647-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function @parse_prop() returns either -1 or 0, no need to check
for other values. Just return the unnecessary check.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-property.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/cmds-property.c b/cmds-property.c
index 90c7603..a764293 100644
--- a/cmds-property.c
+++ b/cmds-property.c
@@ -276,10 +276,6 @@ static int setget_prop(int types, const char *object,
 		fprintf(stderr, "ERROR: property is unknown\n");
 		ret = 40;
 		goto out;
-	} else if (ret) {
-		fprintf(stderr, "ERROR: parse_prop reported unknown error\n");
-		ret = 42;
-		goto out;
 	}
 
 	types &= prop->types;
-- 
1.8.1.4

