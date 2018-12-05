Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12123C04EBF
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 06:40:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D504A2082B
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 06:40:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D504A2082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbeLEGkZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 01:40:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:49698 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726037AbeLEGkZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 01:40:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F2E55AEDA
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Dec 2018 06:40:23 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 01/13] btrfs-progs: Makefile.extrawarn: Import cc-disable-warning
Date:   Wed,  5 Dec 2018 14:40:06 +0800
Message-Id: <20181205064018.27755-2-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181205064018.27755-1-wqu@suse.com>
References: <20181205064018.27755-1-wqu@suse.com>
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
index 1f4bda94a167..18a3a860053e 100644
--- a/Makefile.extrawarn
+++ b/Makefile.extrawarn
@@ -19,6 +19,12 @@ try-run = $(shell set -e;               \
  cc-option = $(call try-run,\
          $(CC) $(CFLAGS) $(1) -c -x c /dev/null -o "$$TMP",$(1),$(2))
 
+# cc-disable-warning
+# Usage: cflags-y += $(call cc-disable-warning,unused-but-set-variable)
+cc-disable-warning = $(call try-run,\
+	$(CC) -Werror $(CFLAGS) -W$(strip $(1)) -c -x c /dev/null -o "$$TMP",-Wno-$(strip $(1)))
+
+
 # From linux.git/scripts/Makefile.extrawarn
 # ==========================================================================
 #
-- 
2.19.2

