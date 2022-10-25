Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC8DC38A2D
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Oct 2022 08:28:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbiJYI2n (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 04:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232199AbiJYI2m (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Oct 2022 04:28:42 -0400
Received: from mail.nfschina.com (mail.nfschina.com [124.16.136.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 43EDAE984F;
        Tue, 25 Oct 2022 01:28:41 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id BA2AB1E80C8E;
        Tue, 25 Oct 2022 16:27:18 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Uuw8E96Tt7r7; Tue, 25 Oct 2022 16:27:16 +0800 (CST)
Received: from localhost.localdomain (unknown [219.141.250.2])
        (Authenticated sender: zeming@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 300B21E80C82;
        Tue, 25 Oct 2022 16:27:16 +0800 (CST)
From:   Li zeming <zeming@nfschina.com>
To:     clm@fb.com, josef@toxicpanda.com, dsterba@suse.com
Cc:     linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li zeming <zeming@nfschina.com>
Subject: [PATCH] btrfs: volumes: Increase bioc pointer check
Date:   Tue, 25 Oct 2022 16:28:35 +0800
Message-Id: <20221025082835.3751-1-zeming@nfschina.com>
X-Mailer: git-send-email 2.18.2
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

If kzalloc fails to allocate the bioc pointer, NULL is returned
directly.

Signed-off-by: Li zeming <zeming@nfschina.com>
---
 fs/btrfs/volumes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 064ab2a79c80..f9cb815fe23d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5892,6 +5892,8 @@ static struct btrfs_io_context *alloc_btrfs_io_context(struct btrfs_fs_info *fs_
 		 */
 		sizeof(u64) * (total_stripes),
 		GFP_NOFS|__GFP_NOFAIL);
+	if (!bioc)
+		return NULL;
 
 	atomic_set(&bioc->error, 0);
 	refcount_set(&bioc->refs, 1);
-- 
2.18.2

