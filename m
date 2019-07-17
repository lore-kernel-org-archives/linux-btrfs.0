Return-Path: <SRS0=CHLg=VO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 969CEC76186
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Jul 2019 11:36:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F09920880
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Jul 2019 11:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730422AbfGQLgh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Jul 2019 07:36:37 -0400
Received: from mga14.intel.com ([192.55.52.115]:1951 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbfGQLgh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Jul 2019 07:36:37 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jul 2019 04:36:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,274,1559545200"; 
   d="scan'208";a="195219130"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 17 Jul 2019 04:36:35 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 54E2316A; Wed, 17 Jul 2019 14:36:34 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH v3 1/4] uuid: Add inline helpers to import / export UUIDs
Date:   Wed, 17 Jul 2019 14:36:30 +0300
Message-Id: <20190717113633.25922-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Sometimes we may need to import UUID from or export to the raw buffer,
which is provided outside of kernel and can't be declared as UUID type.
With current API this operation will require an explicit casting
to one of UUID types and length, that is always a constant derived as sizeof
the certain UUID type.

Provide a helpful set of inline helpers to minimize developer's effort
in the cases when raw buffers are involved.

Suggested-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 include/linux/uuid.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/uuid.h b/include/linux/uuid.h
index 0c631e2a73b6..8e4a5000da03 100644
--- a/include/linux/uuid.h
+++ b/include/linux/uuid.h
@@ -43,6 +43,16 @@ static inline void guid_copy(guid_t *dst, const guid_t *src)
 	memcpy(dst, src, sizeof(guid_t));
 }
 
+static inline void import_guid(guid_t *dst, const __u8 *src)
+{
+	memcpy(dst, src, sizeof(guid_t));
+}
+
+static inline void export_guid(__u8 *dst, const guid_t *src)
+{
+	memcpy(dst, src, sizeof(guid_t));
+}
+
 static inline bool guid_is_null(const guid_t *guid)
 {
 	return guid_equal(guid, &guid_null);
@@ -58,6 +68,16 @@ static inline void uuid_copy(uuid_t *dst, const uuid_t *src)
 	memcpy(dst, src, sizeof(uuid_t));
 }
 
+static inline void import_uuid(uuid_t *dst, const __u8 *src)
+{
+	memcpy(dst, src, sizeof(uuid_t));
+}
+
+static inline void export_uuid(__u8 *dst, const uuid_t *src)
+{
+	memcpy(dst, src, sizeof(uuid_t));
+}
+
 static inline bool uuid_is_null(const uuid_t *uuid)
 {
 	return uuid_equal(uuid, &uuid_null);
-- 
2.20.1

