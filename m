Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:55305 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750711AbeBHFJj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Feb 2018 00:09:39 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 440A448AE767
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Feb 2018 13:09:35 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/3] btrfs-progs: add prerequisite btrfs-image for test-fuzz
Date: Thu, 8 Feb 2018 13:08:57 +0800
Message-ID: <1518066538-16076-2-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1518066538-16076-1-git-send-email-gujx@cn.fujitsu.com>
References: <1518066538-16076-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

    Since tests/fuzz-tests/002-simple-image/test.sh need
    the btrfs-image for prerequisite.
    So add the dependency in Makefile.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 034c943..9299411 100644
--- a/Makefile
+++ b/Makefile
@@ -311,7 +311,7 @@ test-mkfs: btrfs mkfs.btrfs
 	@echo "    [TEST]   mkfs-tests.sh"
 	$(Q)bash tests/mkfs-tests.sh
 
-test-fuzz: btrfs
+test-fuzz: btrfs btrfs-image
 	@echo "    [TEST]   fuzz-tests.sh"
 	$(Q)bash tests/fuzz-tests.sh
 
-- 
1.9.1



