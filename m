Return-Path: <SRS0=hHgh=PT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A98EEC43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jan 2019 10:11:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B76E20872
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jan 2019 10:11:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731641AbfAKKLi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 11 Jan 2019 05:11:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:54122 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727653AbfAKKLi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Jan 2019 05:11:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 27ABDAFD8
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Jan 2019 10:11:37 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] btrfs-progs: provide etags make target
Date:   Fri, 11 Jan 2019 11:11:27 +0100
Message-Id: <20190111101127.15448-1-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Provide an 'etags' make target to create tags in the Emacs etags
format, similar to the 'tags' target for VIM's ctags.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 .gitignore | 1 +
 Makefile   | 9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/.gitignore b/.gitignore
index 82620f3cf603..c8a8bb702c9e 100644
--- a/.gitignore
+++ b/.gitignore
@@ -64,6 +64,7 @@
 /cscope.in.out
 /cscope.po.out
 .clang_complete
+/TAGS
 
 /Documentation/Makefile
 /Documentation/*.html
diff --git a/Makefile b/Makefile
index ee1fc13992df..3134a6379ce5 100644
--- a/Makefile
+++ b/Makefile
@@ -44,6 +44,7 @@ $(error Makefile.inc not generated, please configure first)
 endif
 
 TAGS_CMD := ctags
+ETAGS_CMD := etags
 CSCOPE_CMD := cscope -u -b -c -q
 
 include Makefile.extrawarn
@@ -597,6 +598,12 @@ tags: FORCE
 		check/*.[ch] kernel-lib/*.[ch] kernel-shared/*.[ch] \
 		libbtrfsutil/*.[ch]
 
+etags: FORCE
+	@echo "    [ETAGS]   $(ETAGS_CMD)"
+	$(Q)$(ETAGS_CMD) *.[ch] image/*.[ch] convert/*.[ch] mkfs/*.[ch] \
+		check/*.[ch] kernel-lib/*.[ch] kernel-shared/*.[ch] \
+		libbtrfsutil/*.[ch]
+
 cscope: FORCE
 	@echo "    [CSCOPE] $(CSCOPE_CMD)"
 	$(Q)ls -1 *.[ch] image/*.[ch] convert/*.[ch] mkfs/*.[ch] check/*.[ch] \
@@ -633,7 +640,7 @@ clean-gen:
 	@echo "Cleaning Generated Files"
 	$(Q)$(RM) -rf -- version.h config.status config.cache config.log \
 		configure.lineno config.status.lineno Makefile.inc \
-		Documentation/Makefile tags \
+		Documentation/Makefile tags TAGS \
 		cscope.files cscope.out cscope.in.out cscope.po.out \
 		config.log config.h config.h.in~ aclocal.m4 \
 		configure autom4te.cache/ config/
-- 
2.16.4

