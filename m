Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D659FC43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 08:00:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F0A020868
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 08:00:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F0A020868
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389427AbeKPSMB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 13:12:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:46708 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727413AbeKPSMB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 13:12:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BBDCFAD9D
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Nov 2018 08:00:44 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v1.1 3/9] btrfs-progs: Makefile.extrawarn: Don't warn on sign compare
Date:   Fri, 16 Nov 2018 16:00:40 +0800
Message-Id: <20181116080040.5941-1-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181116075426.4142-4-wqu@suse.com>
References: <20181116075426.4142-4-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Under most case, we are just using 'int' for 'unsigned int', and doesn't
care about the sign.

The Wsign-compare is causing tons of false alerts.
Suppressing it would make W=1 less noisy.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
changelog:
v1.1:
   Use cc-disable-warning to provide much better compatibility against
   older compiler
---
 Makefile.extrawarn | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile.extrawarn b/Makefile.extrawarn
index bbb2d5173846..736bee82759f 100644
--- a/Makefile.extrawarn
+++ b/Makefile.extrawarn
@@ -54,6 +54,7 @@ warning-1 += $(call cc-option, -Wmissing-include-dirs)
 warning-1 += $(call cc-option, -Wunused-but-set-variable)
 warning-1 += $(call cc-disable-warning, missing-field-initializers)
 warning-1 += $(call cc-disable-warning, format-truncation)
+warning-1 += $(call cc-disable-warning, sign-compare)
 
 warning-2 := -Waggregate-return
 warning-2 += -Wcast-align
-- 
2.19.1

