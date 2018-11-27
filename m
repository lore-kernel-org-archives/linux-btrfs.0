Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E637C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:54:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4599620663
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:54:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4599620663
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbeK1GxO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 01:53:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:35306 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725764AbeK1GxO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 01:53:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 95B95ABE7
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 19:54:13 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7E04BDAC3A; Tue, 27 Nov 2018 20:53:57 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 8/9] btrfs: switch BTRFS_ORDERED_* to enums
Date:   Tue, 27 Nov 2018 20:53:57 +0100
Message-Id: <15902ae1f53ef52d36fb4371fa2ec3428ca7158a.1543348078.git.dsterba@suse.com>
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
ordered extent flags.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ordered-data.h | 45 +++++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index b10e6765d88f..fb9a161f0215 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -37,26 +37,31 @@ struct btrfs_ordered_sum {
  * rbtree, just before waking any waiters.  It is used to indicate the
  * IO is done and any metadata is inserted into the tree.
  */
-#define BTRFS_ORDERED_IO_DONE 0 /* set when all the pages are written */
-
-#define BTRFS_ORDERED_COMPLETE 1 /* set when removed from the tree */
-
-#define BTRFS_ORDERED_NOCOW 2 /* set when we want to write in place */
-
-#define BTRFS_ORDERED_COMPRESSED 3 /* writing a zlib compressed extent */
-
-#define BTRFS_ORDERED_PREALLOC 4 /* set when writing to preallocated extent */
-
-#define BTRFS_ORDERED_DIRECT 5 /* set when we're doing DIO with this extent */
-
-#define BTRFS_ORDERED_IOERR 6 /* We had an io error when writing this out */
-
-#define BTRFS_ORDERED_UPDATED_ISIZE 7 /* indicates whether this ordered extent
-				       * has done its due diligence in updating
-				       * the isize. */
-#define BTRFS_ORDERED_TRUNCATED 8 /* Set when we have to truncate an extent */
-
-#define BTRFS_ORDERED_REGULAR 10 /* Regular IO for COW */
+enum {
+	/* set when all the pages are written */
+	BTRFS_ORDERED_IO_DONE,
+	/* set when removed from the tree */
+	BTRFS_ORDERED_COMPLETE,
+	/* set when we want to write in place */
+	BTRFS_ORDERED_NOCOW,
+	/* writing a zlib compressed extent */
+	BTRFS_ORDERED_COMPRESSED,
+	/* set when writing to preallocated extent */
+	BTRFS_ORDERED_PREALLOC,
+	/* set when we're doing DIO with this extent */
+	BTRFS_ORDERED_DIRECT,
+	/* We had an io error when writing this out */
+	BTRFS_ORDERED_IOERR,
+	/*
+	 * indicates whether this ordered extent has done its due diligence in
+	 * updating the isize
+	 */
+	BTRFS_ORDERED_UPDATED_ISIZE,
+	/* Set when we have to truncate an extent */
+	BTRFS_ORDERED_TRUNCATED,
+	/* Regular IO for COW */
+	BTRFS_ORDERED_REGULAR,
+};
 
 struct btrfs_ordered_extent {
 	/* logical offset in the file */
-- 
2.19.1

