Return-Path: <SRS0=qeAP=BN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FD52C433E1
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Aug 2020 09:43:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 492082075A
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Aug 2020 09:43:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgHCJnV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Aug 2020 05:43:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:36130 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbgHCJnU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Aug 2020 05:43:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 445E6AB7A;
        Mon,  3 Aug 2020 09:43:34 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Remove spurious BUG_ON in btrfs_get_extent
Date:   Mon,  3 Aug 2020 12:43:18 +0300
Message-Id: <20200803094318.776-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

That BUG_ON cannot ever trigger because as the comment there states -
'err' is always set. Simply remove it as it brings no value.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 14aed0d3cb51..0df881e39f57 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6740,7 +6740,6 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 		free_extent_map(em);
 		return ERR_PTR(err);
 	}
-	BUG_ON(!em); /* Error is always set */
 	return em;
 }
 
-- 
2.17.1

