Return-Path: <SRS0=0wlt=2B=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D56EC43603
	for <linux-btrfs@archiver.kernel.org>; Wed, 11 Dec 2019 10:40:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35854208C3
	for <linux-btrfs@archiver.kernel.org>; Wed, 11 Dec 2019 10:40:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728944AbfLKKkk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 11 Dec 2019 05:40:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:58638 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728030AbfLKKkk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Dec 2019 05:40:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 689CFB1C1;
        Wed, 11 Dec 2019 10:40:38 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] fstests: common: Use more accurate kernel config for _require_fail_make_request
Date:   Wed, 11 Dec 2019 18:40:27 +0800
Message-Id: <20191211104029.25541-2-wqu@suse.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191211104029.25541-1-wqu@suse.com>
References: <20191211104029.25541-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Just enabling CONFIG_FAIL_MAKE_REQUEST will not fulfill
_require_fail_make_request.

It's CONFIG_FAULT_INJECTION_DEBUG_FS.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 common/rc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/common/rc b/common/rc
index 5cdd829b..2d72f158 100644
--- a/common/rc
+++ b/common/rc
@@ -2357,7 +2357,7 @@ _require_fail_make_request()
 {
     [ -f "$DEBUGFS_MNT/fail_make_request/probability" ] \
 	|| _notrun "$DEBUGFS_MNT/fail_make_request \
- not found. Seems that CONFIG_FAIL_MAKE_REQUEST kernel config option not enabled"
+ not found. Seems that CONFIG_FAULT_INJECTION_DEBUG_FS kernel config option not enabled"
 }
 
 # Disable extent zeroing for ext4 on the given device
-- 
2.23.0

