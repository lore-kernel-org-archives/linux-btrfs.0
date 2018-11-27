Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7834C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:54:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC0F020873
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:54:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC0F020873
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbeK1GxE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 01:53:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:35246 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725764AbeK1GxE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 01:53:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 26230AC3E
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 19:54:04 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1759ADAC3A; Tue, 27 Nov 2018 20:53:48 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 4/9] btrfs: switch BTRFS_ROOT_* to enums
Date:   Tue, 27 Nov 2018 20:53:48 +0100
Message-Id: <f78a535281ed0bd208db0c2f70aa0e43f18cb40c.1543348078.git.dsterba@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1543348078.git.dsterba@suse.com>
References: <cover.1543348078.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We can use simple enum for values that are not part of on-disk format:
root tree flags.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 7176b95b40e7..4bb0ac3050ff 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1180,22 +1180,23 @@ struct btrfs_subvolume_writers {
 /*
  * The state of btrfs root
  */
-/*
- * btrfs_record_root_in_trans is a multi-step process,
- * and it can race with the balancing code.   But the
- * race is very small, and only the first time the root
- * is added to each transaction.  So IN_TRANS_SETUP
- * is used to tell us when more checks are required
- */
-#define BTRFS_ROOT_IN_TRANS_SETUP	0
-#define BTRFS_ROOT_REF_COWS		1
-#define BTRFS_ROOT_TRACK_DIRTY		2
-#define BTRFS_ROOT_IN_RADIX		3
-#define BTRFS_ROOT_ORPHAN_ITEM_INSERTED	4
-#define BTRFS_ROOT_DEFRAG_RUNNING	5
-#define BTRFS_ROOT_FORCE_COW		6
-#define BTRFS_ROOT_MULTI_LOG_TASKS	7
-#define BTRFS_ROOT_DIRTY		8
+enum {
+	/*
+	 * btrfs_record_root_in_trans is a multi-step process, and it can race
+	 * with the balancing code.   But the race is very small, and only the
+	 * first time the root is added to each transaction.  So IN_TRANS_SETUP
+	 * is used to tell us when more checks are required
+	 */
+	BTRFS_ROOT_IN_TRANS_SETUP,
+	BTRFS_ROOT_REF_COWS,
+	BTRFS_ROOT_TRACK_DIRTY,
+	BTRFS_ROOT_IN_RADIX,
+	BTRFS_ROOT_ORPHAN_ITEM_INSERTED,
+	BTRFS_ROOT_DEFRAG_RUNNING,
+	BTRFS_ROOT_FORCE_COW,
+	BTRFS_ROOT_MULTI_LOG_TASKS,
+	BTRFS_ROOT_DIRTY,
+};
 
 /*
  * in ram representation of the tree.  extent_root is used for all allocations
-- 
2.19.1

