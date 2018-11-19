Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 838F3C04EBF
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 09:38:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5537A20871
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 09:38:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5537A20871
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbeKSUBm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 15:01:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:60176 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727449AbeKSUBl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 15:01:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F1925AF3E
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Nov 2018 09:38:35 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v2 4/5] btrfs: introduce EXPORT_FOR_TESTS macro
Date:   Mon, 19 Nov 2018 10:38:16 +0100
Message-Id: <20181119093817.9291-5-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20181119093817.9291-1-jthumshirn@suse.de>
References: <20181119093817.9291-1-jthumshirn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Depending on whether CONFIG_BTRFS_FS_RUN_SANITY_TESTS is set, some BTRFS
functions are either local to the file they are implemented in and thus
should be declared static or are called from within the test implementation
defined in a different file.

Introduce an EXPORT_FOR_TESTS macro which depending on
CONFIG_BTRFS_FS_RUN_SANITY_TESTS either adds the 'static' keyword to a
function or not.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 fs/btrfs/ctree.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e62824cae00a..5119dacab981 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3471,6 +3471,12 @@ static inline void assfail(const char *expr, const char *file, int line)
 #define ASSERT(expr)	((void)0)
 #endif
 
+#ifndef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+#define EXPORT_FOR_TESTS static
+#else
+#define EXPORT_FOR_TESTS
+#endif
+
 __cold
 static inline void btrfs_print_v0_err(struct btrfs_fs_info *fs_info)
 {
-- 
2.16.4

