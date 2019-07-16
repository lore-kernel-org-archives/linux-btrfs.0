Return-Path: <SRS0=DfO0=VN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 273F9C7618F
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Jul 2019 15:04:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 030CF20693
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Jul 2019 15:04:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387857AbfGPPEW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Jul 2019 11:04:22 -0400
Received: from mga05.intel.com ([192.55.52.43]:64284 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728513AbfGPPEW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Jul 2019 11:04:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jul 2019 08:04:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,498,1557212400"; 
   d="scan'208";a="342742570"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga005.jf.intel.com with ESMTP; 16 Jul 2019 08:04:19 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id AF899159; Tue, 16 Jul 2019 18:04:18 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 3/3] uuid: Remove no more needed macro
Date:   Tue, 16 Jul 2019 18:04:18 +0300
Message-Id: <20190716150418.84018-3-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190716150418.84018-1-andriy.shevchenko@linux.intel.com>
References: <20190716150418.84018-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

uuid_le_gen() is no used anymore, remove it for good.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 include/linux/uuid.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/uuid.h b/include/linux/uuid.h
index b8e431d65222..7efa86a1b588 100644
--- a/include/linux/uuid.h
+++ b/include/linux/uuid.h
@@ -117,7 +117,6 @@ int guid_parse(const char *uuid, guid_t *u);
 int uuid_parse(const char *uuid, uuid_t *u);
 
 /* backwards compatibility, don't use in new code */
-#define uuid_le_gen(u)		guid_gen(u)
 #define uuid_le_to_bin(guid, u)	guid_parse(guid, u)
 
 static inline int uuid_le_cmp(const guid_t u1, const guid_t u2)
-- 
2.20.1

