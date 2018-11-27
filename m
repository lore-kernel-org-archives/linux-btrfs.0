Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14760C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:54:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF62120873
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:53:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF62120873
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbeK1Gw5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 01:52:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:35216 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725764AbeK1Gw5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 01:52:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2CFDCABE6
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 19:53:57 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1E47DDAC3A; Tue, 27 Nov 2018 20:53:41 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 1/9] btrfs: switch BTRFS_FS_STATE_* to enums
Date:   Tue, 27 Nov 2018 20:53:41 +0100
Message-Id: <4365d4183bf65240273c8602faa0a75e88906d38.1543348078.git.dsterba@suse.com>
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
global filesystem states.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a98507fa9192..f82ec5e41b0c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -109,13 +109,26 @@ static inline unsigned long btrfs_chunk_item_size(int num_stripes)
 }
 
 /*
- * File system states
+ * Runtime (in-memory) states of filesystem
  */
-#define BTRFS_FS_STATE_ERROR		0
-#define BTRFS_FS_STATE_REMOUNTING	1
-#define BTRFS_FS_STATE_TRANS_ABORTED	2
-#define BTRFS_FS_STATE_DEV_REPLACING	3
-#define BTRFS_FS_STATE_DUMMY_FS_INFO	4
+enum {
+	/* Global indicator of serious filesysystem errors */
+	BTRFS_FS_STATE_ERROR,
+	/*
+	 * Filesystem is being remounted, allow to skip some operations, like
+	 * defrag
+	 */
+	BTRFS_FS_STATE_REMOUNTING,
+	/* Track if the transaction abort has been reported */
+	BTRFS_FS_STATE_TRANS_ABORTED,
+	/*
+	 * Indicate that replace source or target device state is changed and
+	 * allow to block bio operations
+	 */
+	BTRFS_FS_STATE_DEV_REPLACING,
+	/* The btrfs_fs_info created for self-tests */
+	BTRFS_FS_STATE_DUMMY_FS_INFO,
+};
 
 #define BTRFS_BACKREF_REV_MAX		256
 #define BTRFS_BACKREF_REV_SHIFT		56
-- 
2.19.1

