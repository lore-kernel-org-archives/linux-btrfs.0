Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF49BC43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 07:54:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F459208E7
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 07:54:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F459208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbeKPSFs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 13:05:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:46132 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727380AbeKPSFs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 13:05:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CAAEEABDC
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Nov 2018 07:54:32 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/9] btrfs-progs: Makefile.extrawarn: Import cc-disable-warning
Date:   Fri, 16 Nov 2018 15:54:18 +0800
Message-Id: <20181116075426.4142-2-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181116075426.4142-1-wqu@suse.com>
References: <20181116075426.4142-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We imported cc-option but forgot to import cc-disable-warning.

Fixes: b556a992c3ad ("btrfs-progs: build: allow to build with various compiler warnings")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Makefile.extrawarn | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Makefile.extrawarn b/Makefile.extrawarn
index 1f4bda94a167..5849036fd166 100644
--- a/Makefile.extrawarn
+++ b/Makefile.extrawarn
@@ -19,6 +19,12 @@ try-run = $(shell set -e;               \
  cc-option = $(call try-run,\
          $(CC) $(CFLAGS) $(1) -c -x c /dev/null -o "$$TMP",$(1),$(2))
 
+# cc-disable-warning
+# Usage: cflags-y += $(call cc-disable-warning,unused-but-set-variable)
+cc-disable-warning = $(call try-run,\
+	$(CC) -Werror $(KBUILD_CPPFLAGS) $(CC_OPTION_CFLAGS) -W$(strip $(1)) -c -x c /dev/null -o "$$TMP",-Wno-$(strip $(1)))
+
+
 # From linux.git/scripts/Makefile.extrawarn
 # ==========================================================================
 #
-- 
2.19.1

