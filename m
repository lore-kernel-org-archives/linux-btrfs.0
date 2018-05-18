Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:17344 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751452AbeERKAd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 May 2018 06:00:33 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 918AB4B402E7
        for <linux-btrfs@vger.kernel.org>; Fri, 18 May 2018 18:00:29 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gu JinXiang <gujx@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: Add DEBUG_CFLAGS_INTERNAL for libbtrfsutil
Date: Fri, 18 May 2018 17:41:08 +0800
Message-ID: <1526636468-29840-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Gu JinXiang <gujx@cn.fujitsu.com>

Add DEBUG_CFLAGS_INTERNAL to LIBBTRFSUTIL_CFLAGS for libbtrfsutil's
build.

Signed-off-by: Gu JinXiang <gujx@cn.fujitsu.com>
---
 Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index cbd85533..1e38a56f 100644
--- a/Makefile
+++ b/Makefile
@@ -85,6 +85,7 @@ LIBBTRFSUTIL_CFLAGS = $(SUBST_CFLAGS) \
 		      -fvisibility=hidden \
 		      -I$(TOPDIR)/libbtrfsutil \
 		      $(EXTRAWARN_CFLAGS) \
+		      $(DEBUG_CFLAGS_INTERNAL) \
 		      $(EXTRA_CFLAGS)
 
 LDFLAGS = $(SUBST_LDFLAGS) \
-- 
2.17.0



