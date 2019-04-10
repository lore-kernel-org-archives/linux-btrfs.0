Return-Path: <SRS0=M5aM=SM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E91CC10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 14:24:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08FCB20850
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 14:24:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732731AbfDJOYx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Apr 2019 10:24:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:40166 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732698AbfDJOYr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Apr 2019 10:24:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AA3ECAF46
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Apr 2019 14:24:46 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 4/6] btrfs: Pass 0 for bio_offset to btrfs_wq_submit_bio
Date:   Wed, 10 Apr 2019 17:24:41 +0300
Message-Id: <20190410142443.6470-5-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190410142443.6470-1-nborisov@suse.com>
References: <20190410142443.6470-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Buffered writeback always calls btrfs_csum_one_bio with the last 2
arguments being 0 irrespective of what the bio_offset has been passed
to btrfs_submit_bio_start. Make this apparent by explicitly passing 0
for bio_offset when calling btrfs_wq_submit_bio from
btrfs_submit_bio_hook. This will allow for further simplifications down
the line. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 07cf7050c99f..6e5f1afa7407 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1991,8 +1991,7 @@ static blk_status_t btrfs_submit_bio_hook(struct inode *inode, struct bio *bio,
 			goto mapit;
 		/* we're doing a write, do the async checksumming */
 		ret = btrfs_wq_submit_bio(fs_info, bio, mirror_num, bio_flags,
-					  bio_offset, inode,
-					  btrfs_submit_bio_start);
+					  0, inode, btrfs_submit_bio_start);
 		goto out;
 	} else if (!skip_sum) {
 		ret = btrfs_csum_one_bio(inode, bio, 0, 0);
-- 
2.17.1

