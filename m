Return-Path: <SRS0=kVkg=A3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F31A8C433E3
	for <linux-btrfs@archiver.kernel.org>; Thu, 16 Jul 2020 15:17:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8FBA2083B
	for <linux-btrfs@archiver.kernel.org>; Thu, 16 Jul 2020 15:17:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgGPPRW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 11:17:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:37358 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728412AbgGPPRW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Jul 2020 11:17:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D2735AC90;
        Thu, 16 Jul 2020 15:17:24 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Remove done label in writepage_delalloc
Date:   Thu, 16 Jul 2020 18:17:19 +0300
Message-Id: <20200716151719.3967-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Since there is not common cleanup run after the label it makes it somewhat
redundant.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a76b7da91aa6..e6d1d46ae384 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3445,8 +3445,7 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 			 * started, so we don't want to return > 0 unless
 			 * things are going well.
 			 */
-			ret = ret < 0 ? ret : -EIO;
-			goto done;
+			return ret < 0 ? ret : -EIO;
 		}
 		/*
 		 * delalloc_end is already one less than the total length, so
@@ -3478,10 +3477,7 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 		return 1;
 	}

-	ret = 0;
-
-done:
-	return ret;
+	return 0;
 }

 /*
--
2.17.1

