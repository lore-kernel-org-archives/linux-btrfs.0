Return-Path: <SRS0=RPoL=3J=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AFE9C33CAA
	for <linux-btrfs@archiver.kernel.org>; Mon, 20 Jan 2020 14:09:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA76122314
	for <linux-btrfs@archiver.kernel.org>; Mon, 20 Jan 2020 14:09:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbgATOJ0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 20 Jan 2020 09:09:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:49108 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728709AbgATOJY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Jan 2020 09:09:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3D0BFB1AA;
        Mon, 20 Jan 2020 14:09:22 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 08/11] btrfs: Pass trans handle to write_pinned_extent_entries
Date:   Mon, 20 Jan 2020 16:09:15 +0200
Message-Id: <20200120140918.15647-9-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200120140918.15647-1-nborisov@suse.com>
References: <20200120140918.15647-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Preparation for refactoring pinned extents tracking.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/free-space-cache.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 0598fd3c6e3f..9d6372139547 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1067,6 +1067,7 @@ update_cache_item(struct btrfs_trans_handle *trans,
 }

 static noinline_for_stack int write_pinned_extent_entries(
+			    struct btrfs_trans_handle *trans,
 			    struct btrfs_block_group *block_group,
 			    struct btrfs_io_ctl *io_ctl,
 			    int *entries)
@@ -1317,7 +1318,7 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 	 * If this changes while we are working we'll get added back to
 	 * the dirty list and redo it.  No locking needed
 	 */
-	ret = write_pinned_extent_entries(block_group, io_ctl, &entries);
+	ret = write_pinned_extent_entries(trans, block_group, io_ctl, &entries);
 	if (ret)
 		goto out_nospc_locked;

--
2.17.1

