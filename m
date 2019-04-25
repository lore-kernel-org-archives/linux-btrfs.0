Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61B51C43219
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 14:33:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70CBF20717
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 14:33:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbfDYOdn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 10:33:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:59702 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726790AbfDYOdf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 10:33:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A09A3AEE8;
        Thu, 25 Apr 2019 14:33:33 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org, ast@fb.com, jbacik@fb.com
Cc:     linux-kernel@vger.kernel.org, kbuild test robot <lkp@intel.com>
Subject: [PATCH] error-injection: Include definitions for bool and true/false
Date:   Thu, 25 Apr 2019 22:33:27 +0800
Message-Id: <20190425143327.17574-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

If error injection user hasn't included definitions for bool and
true/false, kernel may not compile under certain case, just like:

  All errors (new ones prefixed by >>):

     In file included from fs//btrfs/tree-checker.c:18:
  >> include/linux/error-injection.h:15:15: error: unknown type name 'bool'
      static inline bool within_error_injection_list(unsigned long addr)
                    ^~~~
     include/linux/error-injection.h: In function 'within_error_injection_list':
  >> include/linux/error-injection.h:17:9: error: 'false' undeclared (first use in this function)
       return false;
              ^~~~~
     include/linux/error-injection.h:17:9: note: each undeclared identifier is reported only once for each function it appears in

Anyway the fix is straightforward, include <linux/types.h> for bool and
<linux/stddef.h> for true/false in error-injection.h to make it self
contained.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 include/linux/error-injection.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/error-injection.h b/include/linux/error-injection.h
index 280c61ecbf20..1a8e09978616 100644
--- a/include/linux/error-injection.h
+++ b/include/linux/error-injection.h
@@ -2,6 +2,8 @@
 #ifndef _LINUX_ERROR_INJECTION_H
 #define _LINUX_ERROR_INJECTION_H
 
+#include <linux/types.h>	/* for bool */
+#include <linux/stddef.h>	/* for true/false */
 #ifdef CONFIG_FUNCTION_ERROR_INJECTION
 
 #include <asm/error-injection.h>
-- 
2.21.0

