Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:20501 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751577AbdC0AwZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 26 Mar 2017 20:52:25 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <coderight@gmail.com>
Subject: [PATCH] btrfs-progs: Cleanup kernel-shared dir when execute make clean
Date: Mon, 27 Mar 2017 08:52:09 +0800
Message-ID: <20170327005209.1138-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Reported-by: Chris <coderight@gmail.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index fdc63c3a..d1af4311 100644
--- a/Makefile
+++ b/Makefile
@@ -502,6 +502,7 @@ clean: $(CLEANDIRS)
 	@echo "Cleaning"
 	$(Q)$(RM) -f -- $(progs) *.o *.o.d \
 		kernel-lib/*.o kernel-lib/*.o.d \
+		kernel-shared/*.o kernel-shared/*.o.d \
 		image/*.o image/*.o.d \
 		convert/*.o convert/*.o.d \
 		mkfs/*.o mkfs/*.o.d \
-- 
2.12.1



