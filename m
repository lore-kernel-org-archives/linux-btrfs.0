Return-Path: <SRS0=M5aM=SM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08B2BC282CE
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 14:24:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6D7220850
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 14:24:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732725AbfDJOYt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Apr 2019 10:24:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:40172 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732717AbfDJOYs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Apr 2019 10:24:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F4045AF8F
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Apr 2019 14:24:46 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 5/6] btrfs: Always pass 0 bio_offset for btree_submit_bio_start
Date:   Wed, 10 Apr 2019 17:24:42 +0300
Message-Id: <20190410142443.6470-6-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190410142443.6470-1-nborisov@suse.com>
References: <20190410142443.6470-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The btree submit hook queues the async csum and forwards the bio_offset
parameter passed to btree_submit_bio_hook. This is redundant since
btree_submit_bio_start calls btree_csum_one_bio which doesn't use
the offset at all. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/disk-io.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2f535e9d816e..ee9e03b8aae3 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -913,8 +913,7 @@ static blk_status_t btree_submit_bio_hook(struct inode *inode, struct bio *bio,
 		 * checksumming can happen in parallel across all CPUs
 		 */
 		ret = btrfs_wq_submit_bio(fs_info, bio, mirror_num, 0,
-					  bio_offset, inode,
-					  btree_submit_bio_start);
+					  0, inode, btree_submit_bio_start);
 	}
 
 	if (ret)
-- 
2.17.1

