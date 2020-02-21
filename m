Return-Path: <SRS0=i4Ze=4J=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E96FDC35646
	for <linux-btrfs@archiver.kernel.org>; Fri, 21 Feb 2020 16:31:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE056208E4
	for <linux-btrfs@archiver.kernel.org>; Fri, 21 Feb 2020 16:31:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgBUQbX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 11:31:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:43688 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbgBUQbW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Feb 2020 11:31:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 48583AEEC;
        Fri, 21 Feb 2020 16:31:21 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id DF66EDA70E; Fri, 21 Feb 2020 17:31:03 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 02/11] btrfs: move mapping of block for discard to its caller
Date:   Fri, 21 Feb 2020 17:31:03 +0100
Message-Id: <32b32a9b68f956a3bfe216b72060001811a71d01.1582302545.git.dsterba@suse.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <cover.1582302545.git.dsterba@suse.com>
References: <cover.1582302545.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There's a simple forwarded call based on the operation that would better
fit the caller btrfs_map_block that's until now a trivial wrapper.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d8a88866aaa3..997f2c70cb6c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5953,10 +5953,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 	struct btrfs_io_geometry geom;
 
 	ASSERT(bbio_ret);
-
-	if (op == BTRFS_MAP_DISCARD)
-		return __btrfs_map_block_for_discard(fs_info, logical,
-						     length, bbio_ret);
+	ASSERT(op != BTRFS_MAP_DISCARD);
 
 	ret = btrfs_get_io_geometry(fs_info, op, logical, *length, &geom);
 	if (ret < 0)
@@ -6186,6 +6183,10 @@ int btrfs_map_block(struct btrfs_fs_info *fs_info, enum btrfs_map_op op,
 		      u64 logical, u64 *length,
 		      struct btrfs_bio **bbio_ret, int mirror_num)
 {
+	if (op == BTRFS_MAP_DISCARD)
+		return __btrfs_map_block_for_discard(fs_info, logical,
+						     length, bbio_ret);
+
 	return __btrfs_map_block(fs_info, op, logical, length, bbio_ret,
 				 mirror_num, 0);
 }
-- 
2.25.0

