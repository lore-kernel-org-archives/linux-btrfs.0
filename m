Return-Path: <SRS0=nVQC=RK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E12F1C10F03
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 14:54:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B895520835
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 14:54:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbfCGOy2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Mar 2019 09:54:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:44000 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726286AbfCGOy1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Mar 2019 09:54:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 84433AAD0;
        Thu,  7 Mar 2019 14:54:26 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 81599DA83C; Thu,  7 Mar 2019 15:55:41 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>,
        LimeTech <tomm@lime-technology.com>, stable@vger.kernel.org
Subject: [PATCH] btrfs: don't report readahead errors and don't update statistics
Date:   Thu,  7 Mar 2019 15:55:27 +0100
Message-Id: <20190307145527.31223-1-dsterba@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

As readahead is an optimization, all errors are usually filtered out,
but still properly handled when the real read call is done. The commit
5e9d398240b2 added REQ_RAHEAD to readpages() because that's only used
for readahead (despite what one would expect from the callback name).

This causes a flood of messages and inflated read error stats, so skip
reporting in case it's readahead.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=202403
Reported-by: LimeTech <tomm@lime-technology.com>
Fixes: 5e9d398240b2 ("btrfs: readpages() should submit IO as read-ahead")
CC: stable@vger.kernel.org # 4.19+
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9024eee889b9..db934ceae9c1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6407,7 +6407,7 @@ static void btrfs_end_bio(struct bio *bio)
 				if (bio_op(bio) == REQ_OP_WRITE)
 					btrfs_dev_stat_inc_and_print(dev,
 						BTRFS_DEV_STAT_WRITE_ERRS);
-				else
+				else if (!(bio->bi_opf & REQ_RAHEAD))
 					btrfs_dev_stat_inc_and_print(dev,
 						BTRFS_DEV_STAT_READ_ERRS);
 				if (bio->bi_opf & REQ_PREFLUSH)
-- 
2.20.1

