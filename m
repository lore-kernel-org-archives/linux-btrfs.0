Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4AB8C04EBC
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 07:54:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6894208E7
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 07:54:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A6894208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389345AbeKPSFw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 13:05:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:46150 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727380AbeKPSFw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 13:05:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EFD95AD56
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Nov 2018 07:54:36 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 3/9] btrfs-progs: Makefile.extrawarn: Don't warn on sign compare
Date:   Fri, 16 Nov 2018 15:54:20 +0800
Message-Id: <20181116075426.4142-4-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181116075426.4142-1-wqu@suse.com>
References: <20181116075426.4142-1-wqu@suse.com>
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
 Makefile.extrawarn | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.extrawarn b/Makefile.extrawarn
index bbb2d5173846..c108e98ee7ec 100644
--- a/Makefile.extrawarn
+++ b/Makefile.extrawarn
@@ -45,7 +45,7 @@ endif
 ifdef BUILD_ENABLE_EXTRA_GCC_CHECKS
 warning-  := $(empty)
 
-warning-1 := -Wextra -Wunused -Wno-unused-parameter
+warning-1 := -Wextra -Wunused -Wno-unused-parameter -Wno-sign-compare
 warning-1 += -Wmissing-declarations
 warning-1 += -Wmissing-format-attribute
 warning-1 += $(call cc-option, -Wmissing-prototypes)
-- 
2.19.1

