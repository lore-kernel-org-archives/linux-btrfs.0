Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17235 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1948802AbdEZWbQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 May 2017 18:31:16 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] fixup: btrfs: reduce arguments for decompress_bio ops
Date: Sat, 27 May 2017 06:36:33 +0800
Message-Id: <20170526223633.23575-1-anand.jain@oracle.com>
In-Reply-To: <20170526074500.20342-3-anand.jain@oracle.com>
References: <20170526074500.20342-3-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
Hi David,
 I note the original patch [1] is already queued so here I am sending
 a fix-up patch can you pls squash this to [1]
  [1]
   [PATCH 2/3 v2] btrfs: reduce arguments for decompress_bio ops

 This fixup patch, fixes issues reported by kbuild test robot which
 reported the build failure with ARCH=s390, looking at what was missed
 i.e to include refcount.h it puzzles me why there wasn't such an error
 on my default x86 build though. Thanks.

 fs/btrfs/lzo.c  | 1 +
 fs/btrfs/zlib.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 29b2e1319e6e..5995563ca56f 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -25,6 +25,7 @@
 #include <linux/pagemap.h>
 #include <linux/bio.h>
 #include <linux/lzo.h>
+#include <linux/refcount.h>
 #include "compression.h"
 
 #define LZO_LEN	4
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index c0f592406bb1..d5446e18bb59 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -30,6 +30,7 @@
 #include <linux/sched.h>
 #include <linux/pagemap.h>
 #include <linux/bio.h>
+#include <linux/refcount.h>
 #include "compression.h"
 
 struct workspace {
-- 
2.10.0

