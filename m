Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:55305 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750793AbeBHFJk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Feb 2018 00:09:40 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id D0B0848AE768
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Feb 2018 13:09:35 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/3] btrfs-progs: add prerequisite btrfs-convert for test-misc
Date: Thu, 8 Feb 2018 13:08:58 +0800
Message-ID: <1518066538-16076-3-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1518066538-16076-1-git-send-email-gujx@cn.fujitsu.com>
References: <1518066538-16076-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since tests/misc-tests/005-convert-progress-thread-crash/test.sh need
the btrfs-convert for prerequisite.
So add the dependency in Makefile.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 9299411..7ccba62 100644
--- a/Makefile
+++ b/Makefile
@@ -303,7 +303,7 @@ test-fsck: btrfs btrfs-image btrfs-corrupt-block mkfs.btrfs btrfstune
 	$(Q)bash tests/fsck-tests.sh
 
 test-misc: btrfs btrfs-image btrfs-corrupt-block mkfs.btrfs btrfstune fssum \
-		btrfs-zero-log btrfs-find-root btrfs-select-super
+		btrfs-zero-log btrfs-find-root btrfs-select-super btrfs-convert
 	@echo "    [TEST]   misc-tests.sh"
 	$(Q)bash tests/misc-tests.sh
 
-- 
1.9.1



