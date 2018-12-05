Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 902A4C04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 06:40:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 608532082B
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 06:40:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 608532082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbeLEGka (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 01:40:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:49712 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726037AbeLEGk3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 01:40:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 30073AEDA
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Dec 2018 06:40:28 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 03/13] btrfs-progs: Makefile.extrawarn: Don't warn on sign compare
Date:   Wed,  5 Dec 2018 14:40:08 +0800
Message-Id: <20181205064018.27755-4-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181205064018.27755-1-wqu@suse.com>
References: <20181205064018.27755-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Under most case, we are just using 'int' for 'unsigned int', and doesn't
care about the sign.

The Wsign-compare is causing tons of false alerts.
Suppressing it would make W=1 less noisy so we can focus on real
problem, while still allow it in W=3 build.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Makefile.extrawarn | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Makefile.extrawarn b/Makefile.extrawarn
index 0c11f2450802..9b4cace01ce4 100644
--- a/Makefile.extrawarn
+++ b/Makefile.extrawarn
@@ -54,6 +54,7 @@ warning-1 += $(call cc-option, -Wmissing-include-dirs)
 warning-1 += $(call cc-option, -Wunused-but-set-variable)
 warning-1 += $(call cc-disable-warning, missing-field-initializers)
 warning-1 += $(call cc-disable-warning, format-truncation)
+warning-1 += $(call cc-disable-warning, sign-compare)
 
 warning-2 := -Waggregate-return
 warning-2 += -Wcast-align
@@ -74,6 +75,7 @@ warning-3 += -Wredundant-decls
 warning-3 += -Wswitch-default
 warning-3 += $(call cc-option, -Wpacked-bitfield-compat)
 warning-3 += $(call cc-option, -Wvla)
+warning-3 += $(call cc-option, -Wsign-compare)
 
 warning := $(warning-$(findstring 1, $(BUILD_ENABLE_EXTRA_GCC_CHECKS)))
 warning += $(warning-$(findstring 2, $(BUILD_ENABLE_EXTRA_GCC_CHECKS)))
-- 
2.19.2

