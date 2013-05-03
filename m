Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:49559 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761757Ab3ECM45 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 May 2013 08:56:57 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 416DD7C041B
	for <linux-btrfs@vger.kernel.org>; Fri,  3 May 2013 06:56:57 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id RVGfx4pEADRL9sOE (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 03 May 2013 06:56:56 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: increase the max global reserve size to 1gig
Date: Fri, 3 May 2013 08:56:54 -0400
Message-ID: <1367585814-18076-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Apparently 512mb was too small, with a fs_mark command we could get so much
delayed work built up that we'd never trip the "lets commit the transaction"
logic until we'd gotten too much delayed refs built up.  Increasing this to 1
gig makes us much safer and we no longer abort with Dave's fs_mark tester.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7049bbc..f10ac46 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4516,7 +4516,7 @@ static void update_global_block_rsv(struct btrfs_fs_info *fs_info)
 	spin_lock(&sinfo->lock);
 	spin_lock(&block_rsv->lock);
 
-	block_rsv->size = min_t(u64, num_bytes, 512 * 1024 * 1024);
+	block_rsv->size = min_t(u64, num_bytes, 1024 * 1024 * 1024);
 
 	num_bytes = sinfo->bytes_used + sinfo->bytes_pinned +
 		    sinfo->bytes_reserved + sinfo->bytes_readonly +
-- 
1.7.7.6

