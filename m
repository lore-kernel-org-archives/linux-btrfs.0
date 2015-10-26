Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:1221 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753872AbbJZKaI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Oct 2015 06:30:08 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9QATWje004088
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2015 18:29:33 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 5/5] btrfs-progs: use system's default path for math.h
Date: Mon, 26 Oct 2015 18:28:22 +0800
Message-ID: <ff78b29bdd126b809e444d5ae9f384968b2a4a32.1445855131.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1445855131.git.zhaolei@cn.fujitsu.com>
References: <cover.1445855131.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Line of
 #include "math.h"
in extent-tree.c using quotas is history reason,
(we have cuseom math.h in source before)

Now it is better to use "<>" instead of quotas for this header file.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extent-tree.c b/extent-tree.c
index 0c8152a..0d605e1 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -19,6 +19,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <stdint.h>
+#include <math.h>
 #include "kerncompat.h"
 #include "radix-tree.h"
 #include "ctree.h"
@@ -28,7 +29,6 @@
 #include "crc32c.h"
 #include "volumes.h"
 #include "free-space-cache.h"
-#include "math.h"
 #include "utils.h"
 
 #define PENDING_EXTENT_INSERT 0
-- 
1.8.5.1

