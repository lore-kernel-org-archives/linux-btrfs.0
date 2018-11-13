Return-Path: <SRS0=2H/g=NY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38E5BC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 06:09:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00B9621780
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 06:09:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00B9621780
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730182AbeKMQFw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Nov 2018 11:05:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:48534 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726535AbeKMQFw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Nov 2018 11:05:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 491AEB0AD
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Nov 2018 06:09:18 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: ctree.h: Deprecate unused limit flags
Date:   Tue, 13 Nov 2018 14:09:13 +0800
Message-Id: <20181113060914.27663-1-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

BTRFS_QGROUP_LIMIT_RSV_RFER/EXCL are never used by btrfs-progs.
And kernel only do the basic assignment but don't really make use of
them.

So deprecate these two flags in btrfs-progs.
Also, add some comment for all the used flags.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 ctree.h              | 12 ++++++------
 libbtrfsutil/btrfs.h | 12 ++++++------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/ctree.h b/ctree.h
index 5d9ba3c555f1..1bbc5a2e9dee 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1038,12 +1038,12 @@ struct btrfs_qgroup_info_item {
 } __attribute__ ((__packed__));
 
 /* flags definition for qgroup limits */
-#define BTRFS_QGROUP_LIMIT_MAX_RFER	(1ULL << 0)
-#define BTRFS_QGROUP_LIMIT_MAX_EXCL	(1ULL << 1)
-#define BTRFS_QGROUP_LIMIT_RSV_RFER	(1ULL << 2)
-#define BTRFS_QGROUP_LIMIT_RSV_EXCL	(1ULL << 3)
-#define BTRFS_QGROUP_LIMIT_RFER_CMPR	(1ULL << 4)
-#define BTRFS_QGROUP_LIMIT_EXCL_CMPR	(1ULL << 5)
+#define BTRFS_QGROUP_LIMIT_MAX_RFER	(1ULL << 0) /* reference (rfer) limit */
+#define BTRFS_QGROUP_LIMIT_MAX_EXCL	(1ULL << 1) /* exclusive (excl) limit */
+#define __BTRFS_QGROUP_LIMIT_RSV_RFER	(1ULL << 2) /* deprecated */
+#define __BTRFS_QGROUP_LIMIT_RSV_EXCL	(1ULL << 3) /* deprecated */
+#define BTRFS_QGROUP_LIMIT_RFER_CMPR	(1ULL << 4) /* compressed rfer limit */
+#define BTRFS_QGROUP_LIMIT_EXCL_CMPR	(1ULL << 5) /* compressed excl limit */
 
 struct btrfs_qgroup_limit_item {
 	__le64 flags;
diff --git a/libbtrfsutil/btrfs.h b/libbtrfsutil/btrfs.h
index 1893c5a2172e..4e58a3cd167b 100644
--- a/libbtrfsutil/btrfs.h
+++ b/libbtrfsutil/btrfs.h
@@ -54,12 +54,12 @@ struct btrfs_ioctl_vol_args {
  * struct btrfs_qgroup_limit.flags
  * struct btrfs_qgroup_limit_item.flags
  */
-#define BTRFS_QGROUP_LIMIT_MAX_RFER	(1ULL << 0)
-#define BTRFS_QGROUP_LIMIT_MAX_EXCL	(1ULL << 1)
-#define BTRFS_QGROUP_LIMIT_RSV_RFER	(1ULL << 2)
-#define BTRFS_QGROUP_LIMIT_RSV_EXCL	(1ULL << 3)
-#define BTRFS_QGROUP_LIMIT_RFER_CMPR	(1ULL << 4)
-#define BTRFS_QGROUP_LIMIT_EXCL_CMPR	(1ULL << 5)
+#define BTRFS_QGROUP_LIMIT_MAX_RFER	(1ULL << 0) /* reference (rfer) limit */
+#define BTRFS_QGROUP_LIMIT_MAX_EXCL	(1ULL << 1) /* exclusive (excl) limit */
+#define __BTRFS_QGROUP_LIMIT_RSV_RFER	(1ULL << 2) /* deprecated */
+#define __BTRFS_QGROUP_LIMIT_RSV_EXCL	(1ULL << 3) /* deprecated */
+#define BTRFS_QGROUP_LIMIT_RFER_CMPR	(1ULL << 4) /* compressed rfer limit */
+#define BTRFS_QGROUP_LIMIT_EXCL_CMPR	(1ULL << 5) /* compressed excl limit */
 
 struct btrfs_qgroup_limit {
 	__u64	flags;
-- 
2.19.1

