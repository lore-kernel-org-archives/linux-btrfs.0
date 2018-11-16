Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1315BC43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 07:54:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D075E208E7
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 07:54:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D075E208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727632AbeKPSFv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 13:05:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:46138 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727380AbeKPSFu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 13:05:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1B050ABDC;
        Fri, 16 Nov 2018 07:54:35 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Su Yanjun <suyj.fnst@cn.fujitsu.com>
Subject: [PATCH 2/9] btrfs-progs: fix gcc8 default build warning caused by '-Wformat-truncation'
Date:   Fri, 16 Nov 2018 15:54:19 +0800
Message-Id: <20181116075426.4142-3-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181116075426.4142-1-wqu@suse.com>
References: <20181116075426.4142-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Su Yanjun <suyj.fnst@cn.fujitsu.com>

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
[Use cc-disable-warning to fix the not working CFLAGS setting in configure.ac]
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Makefile           | 1 +
 Makefile.extrawarn | 1 +
 2 files changed, 2 insertions(+)

diff --git a/Makefile b/Makefile
index f4ab14ea74c8..252299f8869f 100644
--- a/Makefile
+++ b/Makefile
@@ -49,6 +49,7 @@ CSCOPE_CMD := cscope -u -b -c -q
 include Makefile.extrawarn
 
 EXTRA_CFLAGS :=
+EXTRA_CFLAGS += $(call cc-disable-warning, format-truncation)
 EXTRA_LDFLAGS :=
 
 DEBUG_CFLAGS_DEFAULT = -O0 -U_FORTIFY_SOURCE -ggdb3
diff --git a/Makefile.extrawarn b/Makefile.extrawarn
index 5849036fd166..bbb2d5173846 100644
--- a/Makefile.extrawarn
+++ b/Makefile.extrawarn
@@ -53,6 +53,7 @@ warning-1 += -Wold-style-definition
 warning-1 += $(call cc-option, -Wmissing-include-dirs)
 warning-1 += $(call cc-option, -Wunused-but-set-variable)
 warning-1 += $(call cc-disable-warning, missing-field-initializers)
+warning-1 += $(call cc-disable-warning, format-truncation)
 
 warning-2 := -Waggregate-return
 warning-2 += -Wcast-align
-- 
2.19.1

