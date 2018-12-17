Return-Path: <SRS0=1mW1=O2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C232FC43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 08:36:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E2FD2084D
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 08:36:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731832AbeLQIgH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Dec 2018 03:36:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:56818 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731823AbeLQIgG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Dec 2018 03:36:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5EB1DACD2
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2018 08:36:05 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/4] btrfs: Consolidate retval checking of core btree functions
Date:   Mon, 17 Dec 2018 10:36:00 +0200
Message-Id: <20181217083602.10166-3-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20181217083602.10166-1-nborisov@suse.com>
References: <20181217083602.10166-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Core btree functions in btrfs generally return 0 for error and 1 in case
the sought item cannot be found. Consolidate the checks for those
conditions in one 'if () {} else if () {}' struct rather than 2 separate
'if () {}' statements. This emphasizes that the handling code pertains
to a single function. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index fe25f66a98d9..511d3b314af2 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6801,9 +6801,7 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 	if (ret < 0) {
 		err = ret;
 		goto out;
-	}
-
-	if (ret != 0) {
+	} else if (ret > 0) {
 		if (path->slots[0] == 0)
 			goto not_found;
 		path->slots[0]--;
@@ -6853,8 +6851,7 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 			if (ret < 0) {
 				err = ret;
 				goto out;
-			}
-			if (ret > 0)
+			} else if (ret > 0)
 				goto not_found;
 			leaf = path->nodes[0];
 		}
-- 
2.17.1

