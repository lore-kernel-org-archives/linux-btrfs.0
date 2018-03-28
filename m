Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:23544 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752027AbeC1GHv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Mar 2018 02:07:51 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 9569C4D0EFCD
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Mar 2018 14:07:47 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: build: modify cscope/ctags rules to include directories such as check
Date: Wed, 28 Mar 2018 14:07:38 +0800
Message-ID: <20180328060738.23896-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Modify cscope/ctags rule to include directories such as check/
libbtrfsutil/kernel-lib/kernel-shared.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 Makefile | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 6065522a615f..8afc8f6ed6a3 100644
--- a/Makefile
+++ b/Makefile
@@ -585,11 +585,15 @@ manpages:
 
 tags: FORCE
 	@echo "    [TAGS]   $(TAGS_CMD)"
-	$(Q)$(TAGS_CMD) *.[ch] image/*.[ch] convert/*.[ch] mkfs/*.[ch]
+	$(Q)$(TAGS_CMD) *.[ch] image/*.[ch] convert/*.[ch] mkfs/*.[ch] \
+		check/*.[ch] kernel-lib/*.[ch] kernel-shared/*.[ch] \
+		libbtrfsutil/*.[ch]
 
 cscope: FORCE
 	@echo "    [CSCOPE] $(CSCOPE_CMD)"
-	$(Q)ls -1 *.[ch] image/*.[ch] convert/*.[ch] mkfs/*.[ch] > cscope.files
+	$(Q)ls -1 *.[ch] image/*.[ch] convert/*.[ch] mkfs/*.[ch] check/*.[ch] \
+		kernel-lib/*.[ch] kernel-shared/*.[ch] libbtrfsutil/*.[ch] \
+		> cscope.files
 	$(Q)$(CSCOPE_CMD)
 
 clean-all: clean clean-doc clean-gen
-- 
2.16.2



