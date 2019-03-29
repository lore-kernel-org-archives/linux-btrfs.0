Return-Path: <SRS0=qcGt=SA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4927BC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 07:13:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1ACD321773
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 07:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbfC2HNE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 29 Mar 2019 03:13:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:50432 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728800AbfC2HNE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Mar 2019 03:13:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 73E19AF6D
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2019 07:13:03 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: inode: Check if we get a valid inode before checking its mode.
Date:   Fri, 29 Mar 2019 15:12:59 +0800
Message-Id: <20190329071259.6447-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We should check the inode validation before checking the imode.

As btrfs_iget() could return ERR_PTR(), unlike previous path, we need to
verify the inode before checking the imode.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
To David:

Please fold this into 9944a5b5d26e ("btrfs: inode: Verify inode mode to avoid NULL pointer dereference") 
of misc-next branch.
---
 fs/btrfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3ee835cbb490..97f47dd295e8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5776,6 +5776,8 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 
 	if (location.type == BTRFS_INODE_ITEM_KEY) {
 		inode = btrfs_iget(dir->i_sb, &location, root, NULL);
+		if (IS_ERR(inode))
+			return inode;
 
 		/* Do extra check against inode mode with di_type */
 		if (btrfs_inode_type(inode) != di_type) {
-- 
2.21.0

