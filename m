Return-Path: <SRS0=hHgh=PT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9CE2C43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jan 2019 22:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80E1A2064C
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jan 2019 22:07:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbfAKWH6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 11 Jan 2019 17:07:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:39642 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725812AbfAKWH6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Jan 2019 17:07:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E96B0AF66
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Jan 2019 22:07:56 +0000 (UTC)
Received: from starscream.home.jeffm.io (starscream-1.home.jeffm.io [192.168.1.254])
        by mail.home.jeffm.io (Postfix) with ESMTPS id A5AF481AD3D9;
        Fri, 11 Jan 2019 17:06:15 -0500 (EST)
Received: by starscream.home.jeffm.io (Postfix, from userid 1000)
        id 907A124C0DE; Fri, 11 Jan 2019 17:07:55 -0500 (EST)
From:   jeffm@suse.com
To:     linux-btrfs@vger.kernel.org
Cc:     Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH] btrfs-progs: fix stray error message in check
Date:   Fri, 11 Jan 2019 17:07:49 -0500
Message-Id: <20190111220749.30053-1-jeffm@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Jeff Mahoney <jeffm@suse.com>

Commit e578b59bf61 (btrfs-progs: convert strerror to implicit %m) missed
adding braces after a conditional so we will see the following message
whenever a tree block needs repair, regardless of whether repair was
successful: "Failed to repair btree: Success"

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 check/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/check/main.c b/check/main.c
index db18827b..44bfac4e 100644
--- a/check/main.c
+++ b/check/main.c
@@ -3362,9 +3362,10 @@ skip_walking:
 			printf("Try to repair the btree for root %llu\n",
 			       root->root_key.objectid);
 			ret = repair_btree(root, &corrupt_blocks);
-			if (ret < 0)
+			if (ret < 0) {
 				errno = -ret;
 				fprintf(stderr, "Failed to repair btree: %m\n");
+			}
 			if (!ret)
 				printf("Btree for root %llu is fixed\n",
 				       root->root_key.objectid);
-- 
2.16.4

