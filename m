Return-Path: <SRS0=2H/g=NY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AB90C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 06:09:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CC5921780
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 06:09:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4CC5921780
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbeKMQFr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Nov 2018 11:05:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:48528 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726535AbeKMQFq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Nov 2018 11:05:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E8B14B0AD
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Nov 2018 06:09:12 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: qgroups: Prepare to deprecate BTRFS_QGROUP_LIMIT_RSV_RFER/EXCL flags
Date:   Tue, 13 Nov 2018 14:09:09 +0800
Message-Id: <20181113060909.27605-1-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

These two flags are only used to set btrfs_qgroup::rsv_rfer/excl number,
but then are never used.

Nor these flags are really used by btrfs-progs, so it's pretty safe just
to deprecate them in next kernel release.

This patch will mark these two flags deprecated and output warning
messages, but still handle them.

These two flags will be completely removed in next kernel release.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c          | 16 ++++++++++------
 include/uapi/linux/btrfs.h | 12 ++++++------
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 9afad8c14220..d4a52dbad044 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1385,21 +1385,25 @@ int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
 			qgroup->max_excl = limit->max_excl;
 		}
 	}
-	if (limit->flags & BTRFS_QGROUP_LIMIT_RSV_RFER) {
+	if (limit->flags & __BTRFS_QGROUP_LIMIT_RSV_RFER) {
 		if (limit->rsv_rfer == CLEAR_VALUE) {
-			qgroup->lim_flags &= ~BTRFS_QGROUP_LIMIT_RSV_RFER;
-			limit->flags &= ~BTRFS_QGROUP_LIMIT_RSV_RFER;
+			qgroup->lim_flags &= ~__BTRFS_QGROUP_LIMIT_RSV_RFER;
+			limit->flags &= ~__BTRFS_QGROUP_LIMIT_RSV_RFER;
 			qgroup->rsv_rfer = 0;
 		} else {
+			btrfs_warn_rl(fs_info,
+"BTRFS_QGROUP_LIMIT_RSV_RFER flag is deprecated, will not be supported in v5.1");
 			qgroup->rsv_rfer = limit->rsv_rfer;
 		}
 	}
-	if (limit->flags & BTRFS_QGROUP_LIMIT_RSV_EXCL) {
+	if (limit->flags & __BTRFS_QGROUP_LIMIT_RSV_EXCL) {
 		if (limit->rsv_excl == CLEAR_VALUE) {
-			qgroup->lim_flags &= ~BTRFS_QGROUP_LIMIT_RSV_EXCL;
-			limit->flags &= ~BTRFS_QGROUP_LIMIT_RSV_EXCL;
+			qgroup->lim_flags &= ~__BTRFS_QGROUP_LIMIT_RSV_EXCL;
+			limit->flags &= ~__BTRFS_QGROUP_LIMIT_RSV_EXCL;
 			qgroup->rsv_excl = 0;
 		} else {
+			btrfs_warn_rl(fs_info,
+"BTRFS_QGROUP_LIMIT_RSV_EXCL flag is deprecated, will not be supported in v5.1");
 			qgroup->rsv_excl = limit->rsv_excl;
 		}
 	}
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index db4c253f8011..ec79ab781ee0 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -53,12 +53,12 @@ struct btrfs_ioctl_vol_args {
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

