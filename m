Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51026 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751010AbdF1GdV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Jun 2017 02:33:21 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id C513247E9887
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Jun 2017 14:33:13 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: btrfs-progs: Replace number with a exsiting macro
Date: Wed, 28 Jun 2017 14:32:38 +0800
Message-ID: <20170628063239.8399-1-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use macro SZ_4K to replace number 4096 when define macro
BTRFS_SUPER_INFO_SIZE.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 disk-io.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/disk-io.h b/disk-io.h
index dfe4cf0..5c293eb 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -24,7 +24,7 @@
 #include "sizes.h"
 
 #define BTRFS_SUPER_INFO_OFFSET SZ_64K
-#define BTRFS_SUPER_INFO_SIZE 4096
+#define BTRFS_SUPER_INFO_SIZE SZ_4K
 
 #define BTRFS_SUPER_MIRROR_MAX	 3
 #define BTRFS_SUPER_MIRROR_SHIFT 12
-- 
2.9.4



