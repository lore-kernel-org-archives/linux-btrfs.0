Return-Path: <SRS0=42cL=CM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E864C433E9
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Sep 2020 14:42:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27FB8206EF
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Sep 2020 14:42:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729379AbgICOmW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Sep 2020 10:42:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:50938 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729387AbgICOh2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Sep 2020 10:37:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 28162AFCB;
        Thu,  3 Sep 2020 14:37:19 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: set ret to 0 in btrfs_get_extent
Date:   Thu,  3 Sep 2020 17:37:15 +0300
Message-Id: <20200903143715.14848-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When btrfs_get_extent is called for a range that has an overlapping
inline extent coupled with  with 'page' parameter being
NULL it will erroneously return an error instead of the populate
extent_mapping struct. Fix this by setting ret to 0 in case we don't
have an exact match for our range.

Fixes: 85b1eebdaf1d: "btrfs: remove err variable from btrfs_get_extent"
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3b63b858546e..a1081ec8e130 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6593,6 +6593,7 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 		if (path->slots[0] == 0)
 			goto not_found;
 		path->slots[0]--;
+		ret = 0;
 	}
 
 	leaf = path->nodes[0];
-- 
2.17.1

