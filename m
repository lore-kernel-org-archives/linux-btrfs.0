Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:28289 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750711AbeBHFJk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Feb 2018 00:09:40 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id B2D7B48AE766
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Feb 2018 13:09:34 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/3] btrfs-progs: add prerequisite mkfs.btrfs for test-cli
Date: Thu, 8 Feb 2018 13:08:56 +0800
Message-ID: <1518066538-16076-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since tests/cli-tests/002-balance-full-no-filters/test.sh need
the mkfs.btrfs for prerequisite.
So add the dependency in Makefile.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 00e2137..034c943 100644
--- a/Makefile
+++ b/Makefile
@@ -315,7 +315,7 @@ test-fuzz: btrfs
 	@echo "    [TEST]   fuzz-tests.sh"
 	$(Q)bash tests/fuzz-tests.sh
 
-test-cli: btrfs
+test-cli: btrfs mkfs.btrfs
 	@echo "    [TEST]   cli-tests.sh"
 	$(Q)bash tests/cli-tests.sh
 
-- 
1.9.1



