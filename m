Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8959EC04EBF
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 06:40:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A0262082B
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 06:40:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A0262082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbeLEGk2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 01:40:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:49704 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726037AbeLEGk2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 01:40:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6BE34AEB4;
        Wed,  5 Dec 2018 06:40:26 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Su Yanjun <suyj.fnst@cn.fujitsu.com>
Subject: [PATCH v2 02/13] btrfs-progs: fix gcc8 default build warning caused by '-Wformat-truncation'
Date:   Wed,  5 Dec 2018 14:40:07 +0800
Message-Id: <20181205064018.27755-3-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181205064018.27755-1-wqu@suse.com>
References: <20181205064018.27755-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Su Yanjun <suyj.fnst@cn.fujitsu.com>

When using gcc8 + glibc 2.28.5 compiles utils.c, it complains as below:

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

This isn't a type of warning we care about, particularly when calling
snprintf() we expect string to be truncated.

Using the GCC option -Wno-format-truncation to disable this for default
build and W=1 build, while still keep it for W=2/W=3 build.

Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
[Use cc-disable-warning to fix the not working CFLAGS setting in configure.ac]
[Keep the warning in W=2/W=3 build]
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Makefile           | 5 +++++
 Makefile.extrawarn | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/Makefile b/Makefile
index f4ab14ea74c8..a9e57fecb6e6 100644
--- a/Makefile
+++ b/Makefile
@@ -62,6 +62,10 @@ DEBUG_LDFLAGS :=
 ABSTOPDIR = $(shell pwd)
 TOPDIR := .
 
+# Disable certain GCC 8 + glibc 2.28 warning for snprintf()
+# where string truncation for snprintf() is expected.
+DISABLE_WARNING_FLAGS := $(call cc-disable-warning, format-truncation)
+
 # Common build flags
 CFLAGS = $(SUBST_CFLAGS) \
 	 $(CSTD) \
@@ -73,6 +77,7 @@ CFLAGS = $(SUBST_CFLAGS) \
 	 -I$(TOPDIR) \
 	 -I$(TOPDIR)/kernel-lib \
 	 -I$(TOPDIR)/libbtrfsutil \
+	 $(DISABLE_WARNING_FLAGS) \
 	 $(EXTRAWARN_CFLAGS) \
 	 $(DEBUG_CFLAGS_INTERNAL) \
 	 $(EXTRA_CFLAGS)
diff --git a/Makefile.extrawarn b/Makefile.extrawarn
index 18a3a860053e..0c11f2450802 100644
--- a/Makefile.extrawarn
+++ b/Makefile.extrawarn
@@ -53,6 +53,7 @@ warning-1 += -Wold-style-definition
 warning-1 += $(call cc-option, -Wmissing-include-dirs)
 warning-1 += $(call cc-option, -Wunused-but-set-variable)
 warning-1 += $(call cc-disable-warning, missing-field-initializers)
+warning-1 += $(call cc-disable-warning, format-truncation)
 
 warning-2 := -Waggregate-return
 warning-2 += -Wcast-align
@@ -61,6 +62,7 @@ warning-2 += -Wnested-externs
 warning-2 += -Wshadow
 warning-2 += $(call cc-option, -Wlogical-op)
 warning-2 += $(call cc-option, -Wmissing-field-initializers)
+warning-2 += $(call cc-option, -Wformat-truncation)
 
 warning-3 := -Wbad-function-cast
 warning-3 += -Wcast-qual
-- 
2.19.2

