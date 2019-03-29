Return-Path: <SRS0=qcGt=SA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E656DC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 20:26:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD09F20657
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 20:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730112AbfC2U0u (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 29 Mar 2019 16:26:50 -0400
Received: from mga18.intel.com ([134.134.136.126]:59219 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730094AbfC2U0u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Mar 2019 16:26:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Mar 2019 13:26:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,285,1549958400"; 
   d="scan'208";a="157056981"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga004.fm.intel.com with ESMTP; 29 Mar 2019 13:26:47 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 0DA9712C; Fri, 29 Mar 2019 22:26:45 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        David Sterba <dsterba@suse.cz>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 1/2] uuid: Add a glue layer macros for raw buffers
Date:   Fri, 29 Mar 2019 23:26:43 +0300
Message-Id: <20190329202644.40058-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When the ID comes from or we would like to pass it to a raw buffer,
the casting is needed.

Instead of doing it each time, provide a helpful set of macros.

Suggested-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 include/linux/uuid.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/uuid.h b/include/linux/uuid.h
index d9c4a6cce3c2..917f1d4e5d44 100644
--- a/include/linux/uuid.h
+++ b/include/linux/uuid.h
@@ -51,11 +51,16 @@ static inline void guid_copy(guid_t *dst, const guid_t *src)
 	memcpy(dst, src, sizeof(guid_t));
 }
 
+#define guid_copy_from_raw(dst, src)	guid_copy(dst, (const guid_t *)src)
+#define guid_copy_to_raw(dst, src)	guid_copy((void *)dst, src)
+
 static inline bool guid_is_null(const guid_t *guid)
 {
 	return guid_equal(guid, &guid_null);
 }
 
+#define guid_is_null_raw(guid)		guid_is_null((const guid_t *)guid)
+
 static inline bool uuid_equal(const uuid_t *u1, const uuid_t *u2)
 {
 	return memcmp(u1, u2, sizeof(uuid_t)) == 0;
@@ -66,16 +71,24 @@ static inline void uuid_copy(uuid_t *dst, const uuid_t *src)
 	memcpy(dst, src, sizeof(uuid_t));
 }
 
+#define uuid_copy_from_raw(dst, src)	uuid_copy(dst, (const uuid_t *)src)
+#define uuid_copy_to_raw(dst, src)	uuid_copy((void *)dst, src)
+
 static inline bool uuid_is_null(const uuid_t *uuid)
 {
 	return uuid_equal(uuid, &uuid_null);
 }
 
+#define uuid_is_null_raw(uuid)		uuid_is_null((const uuid_t *)uuid)
+
 void generate_random_uuid(unsigned char uuid[16]);
 
 extern void guid_gen(guid_t *u);
 extern void uuid_gen(uuid_t *u);
 
+#define guid_gen_raw(guid)		guid_gen((guid_t *)guid)
+#define uuid_gen_raw(uuid)		uuid_gen((uuid_t *)uuid)
+
 bool __must_check uuid_is_valid(const char *uuid);
 
 extern const u8 guid_index[16];
-- 
2.20.1

