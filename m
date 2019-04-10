Return-Path: <SRS0=M5aM=SM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE6F2C10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 14:24:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83E1720850
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 14:24:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732716AbfDJOYr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Apr 2019 10:24:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:40154 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732698AbfDJOYq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Apr 2019 10:24:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B8D28AEFF
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Apr 2019 14:24:45 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/6] btrfs: Define submit_bio_hook's type directly
Date:   Wed, 10 Apr 2019 17:24:38 +0300
Message-Id: <20190410142443.6470-2-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190410142443.6470-1-nborisov@suse.com>
References: <20190410142443.6470-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There is no need to use a typedef to define the type of the function
and then use that to define the respective member in extent_io_ops.
Define struct's member directly. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index f7ca1516f70b..79bd20cf4226 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -95,9 +95,6 @@ struct btrfs_inode;
 struct btrfs_io_bio;
 struct io_failure_record;
 
-typedef	blk_status_t (extent_submit_bio_hook_t)(void *private_data, struct bio *bio,
-				       int mirror_num, unsigned long bio_flags,
-				       u64 bio_offset);
 
 typedef blk_status_t (extent_submit_bio_start_t)(void *private_data,
 		struct bio *bio, u64 bio_offset);
@@ -107,7 +104,9 @@ struct extent_io_ops {
 	 * The following callbacks must be always defined, the function
 	 * pointer will be called unconditionally.
 	 */
-	extent_submit_bio_hook_t *submit_bio_hook;
+	blk_status_t (*submit_bio_hook)(void *private_data, struct bio *bio,
+					int mirror_num, unsigned long bio_flags,
+					u64 bio_offset);
 	int (*readpage_end_io_hook)(struct btrfs_io_bio *io_bio, u64 phy_offset,
 				    struct page *page, u64 start, u64 end,
 				    int mirror);
-- 
2.17.1

