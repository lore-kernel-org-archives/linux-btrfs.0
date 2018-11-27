Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51C0CC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:54:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1565920873
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:54:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1565920873
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbeK1GxA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 01:53:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:35222 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725764AbeK1Gw7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 01:52:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 76B08ABE6
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 19:53:59 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6935EDAC3A; Tue, 27 Nov 2018 20:53:43 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 2/9] btrfs: switch BTRFS_BLOCK_RSV_* to enums
Date:   Tue, 27 Nov 2018 20:53:43 +0100
Message-Id: <cc7de532fc2398392c2735c085f09d5ee07c3b9b.1543348078.git.dsterba@suse.com>
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
block reserve types.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f82ec5e41b0c..40c405d74a01 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -461,13 +461,18 @@ struct btrfs_space_info {
 	struct kobject *block_group_kobjs[BTRFS_NR_RAID_TYPES];
 };
 
-#define	BTRFS_BLOCK_RSV_GLOBAL		1
-#define	BTRFS_BLOCK_RSV_DELALLOC	2
-#define	BTRFS_BLOCK_RSV_TRANS		3
-#define	BTRFS_BLOCK_RSV_CHUNK		4
-#define	BTRFS_BLOCK_RSV_DELOPS		5
-#define	BTRFS_BLOCK_RSV_EMPTY		6
-#define	BTRFS_BLOCK_RSV_TEMP		7
+/*
+ * Types of block reserves
+ */
+enum {
+	BTRFS_BLOCK_RSV_GLOBAL,
+	BTRFS_BLOCK_RSV_DELALLOC,
+	BTRFS_BLOCK_RSV_TRANS,
+	BTRFS_BLOCK_RSV_CHUNK,
+	BTRFS_BLOCK_RSV_DELOPS,
+	BTRFS_BLOCK_RSV_EMPTY,
+	BTRFS_BLOCK_RSV_TEMP,
+};
 
 struct btrfs_block_rsv {
 	u64 size;
-- 
2.19.1

