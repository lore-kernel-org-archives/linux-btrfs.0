Return-Path: <SRS0=9Rtw=NG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01283C46475
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 01:59:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4ECF52083E
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 01:59:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4ECF52083E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726003AbeJZKep (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Oct 2018 06:34:45 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:44906 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725834AbeJZKep (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Oct 2018 06:34:45 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="46746968"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 26 Oct 2018 09:59:41 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id E3CC54B714AA
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Oct 2018 09:59:38 +0800 (CST)
Received: from sarch.lan (10.167.226.155) by G08CNEXCHPEKD01.g08.fujitsu.local
 (10.167.33.89) with Microsoft SMTP Server id 14.3.408.0; Fri, 26 Oct 2018
 09:59:39 +0800
From:   Su Yanjun <suyj.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     Su Yanjun <suyj.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: fix gcc8 default build warning caused by '-Wformat-truncation'
Date:   Fri, 26 Oct 2018 09:58:50 +0800
Message-ID: <20181026015850.15579-1-suyj.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: E3CC54B714AA.AB7FA
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suyj.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When using gcc8 compiles utils.c, it complains as below:

utils.c:852:45: warning: '%s' directive output may be truncated writing
up to 4095 bytes into a region of size 4084 [-Wformat-truncation=]
   snprintf(path, sizeof(path), "/dev/mapper/%s", name);
                                             ^~   ~~~~
In file included from /usr/include/stdio.h:873,
                 from utils.c:20:
/usr/include/bits/stdio2.h:67:10: note: '__builtin___snprintf_chk'
output between 13 and 4108 bytes into a destination of size 4096
   return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        __bos (__s), __fmt, __va_arg_pack ());
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This isn't a type of warning we care about, particularly when PATH_MAX
is much less than either.

Using the GCC option -Wno-format-truncation to disable this for default
build.

Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
---
 Makefile.extrawarn | 1 +
 configure.ac       | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/Makefile.extrawarn b/Makefile.extrawarn
index 1f4bda94a167..ed76fb5b5554 100644
--- a/Makefile.extrawarn
+++ b/Makefile.extrawarn
@@ -47,6 +47,7 @@ warning-1 += -Wold-style-definition
 warning-1 += $(call cc-option, -Wmissing-include-dirs)
 warning-1 += $(call cc-option, -Wunused-but-set-variable)
 warning-1 += $(call cc-disable-warning, missing-field-initializers)
+warning-1 += $(call cc-option, -Wformat-truncation)
 
 warning-2 := -Waggregate-return
 warning-2 += -Wcast-align
diff --git a/configure.ac b/configure.ac
index df02f20655d9..c626beca8b77 100644
--- a/configure.ac
+++ b/configure.ac
@@ -12,7 +12,7 @@ LIBBTRFS_MAJOR=0
 LIBBTRFS_MINOR=1
 LIBBTRFS_PATCHLEVEL=2
 
-CFLAGS=${CFLAGS:-"-g -O1 -Wall -D_FORTIFY_SOURCE=2"}
+CFLAGS=${CFLAGS:-"-g -O1 -Wall -D_FORTIFY_SOURCE=2 -Wno-format-truncation"}
 AC_SUBST([CFLAGS])
 
 AC_PREREQ([2.60])
-- 
2.19.1



