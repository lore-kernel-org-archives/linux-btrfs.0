Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33733 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755225AbaFLCaX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Jun 2014 22:30:23 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5C2U9dx024485
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Jun 2014 10:30:09 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 2/3] btrfs-progs: fix max mirror number error for chunk-recover
Date: Thu, 12 Jun 2014 10:25:00 +0800
Message-ID: <1402539901-22779-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1402539901-22779-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1402539901-22779-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When run chunk-recover on a health btrfs(data profile raid0, with
plenty of data), the program has a chance to abort on the number
of mirrors of an extent.

According to the kernel code, the max mirror number of an extent
is 3 not 2:
	ctree.h: 		BTRFS_MAX_MIRRORS	3
	chunk-recover.c :	BTRFS_NUM_MIRRORS	2
just change BTRFS_NUM_MIRRORS to 3, and everything goes well.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 chunk-recover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index 9b46b0b..d5a688e 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -42,7 +42,7 @@
 #include "btrfsck.h"
 #include "commands.h"
 
-#define BTRFS_NUM_MIRRORS			2
+#define BTRFS_NUM_MIRRORS			3
 
 struct recover_control {
 	int verbose;
-- 
1.8.1.4

