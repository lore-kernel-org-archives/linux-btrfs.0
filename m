Return-Path: <SRS0=0DI8=CJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9325C433E2
	for <linux-btrfs@archiver.kernel.org>; Mon, 31 Aug 2020 11:54:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90E6C2098B
	for <linux-btrfs@archiver.kernel.org>; Mon, 31 Aug 2020 11:54:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgHaLxx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 07:53:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:37844 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726359AbgHaLxs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Aug 2020 07:53:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0375BB7D6;
        Mon, 31 Aug 2020 11:53:46 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 11/12] btrfs: Make btrfs_zero_range_check_range_boundary take btrfs_inode
Date:   Mon, 31 Aug 2020 14:42:48 +0300
Message-Id: <20200831114249.8360-12-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200831114249.8360-1-nborisov@suse.com>
References: <20200831114249.8360-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/file.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 09f21ea64ecb..2cacb4424cd4 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3072,15 +3072,15 @@ enum {
 	RANGE_BOUNDARY_HOLE,
 };
 
-static int btrfs_zero_range_check_range_boundary(struct inode *inode,
+static int btrfs_zero_range_check_range_boundary(struct btrfs_inode *inode,
 						 u64 offset)
 {
-	const u64 sectorsize = btrfs_inode_sectorsize(BTRFS_I(inode));
+	const u64 sectorsize = btrfs_inode_sectorsize(inode);
 	struct extent_map *em;
 	int ret;
 
 	offset = round_down(offset, sectorsize);
-	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, offset, sectorsize);
+	em = btrfs_get_extent(inode, NULL, 0, offset, sectorsize);
 	if (IS_ERR(em))
 		return PTR_ERR(em);
 
@@ -3195,7 +3195,8 @@ static int btrfs_zero_range(struct inode *inode,
 	 * to cover them.
 	 */
 	if (!IS_ALIGNED(offset, sectorsize)) {
-		ret = btrfs_zero_range_check_range_boundary(inode, offset);
+		ret = btrfs_zero_range_check_range_boundary(BTRFS_I(inode),
+							    offset);
 		if (ret < 0)
 			goto out;
 		if (ret == RANGE_BOUNDARY_HOLE) {
@@ -3211,7 +3212,7 @@ static int btrfs_zero_range(struct inode *inode,
 	}
 
 	if (!IS_ALIGNED(offset + len, sectorsize)) {
-		ret = btrfs_zero_range_check_range_boundary(inode,
+		ret = btrfs_zero_range_check_range_boundary(BTRFS_I(inode),
 							    offset + len);
 		if (ret < 0)
 			goto out;
-- 
2.17.1

