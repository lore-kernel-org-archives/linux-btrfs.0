Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:37720 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab3CZT0m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 15:26:42 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id CC15E9A0370
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 13:26:41 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id g6zG6ex2dq6sCkze (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 13:26:41 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: limit the global reserve to 512mb
Date: Tue, 26 Mar 2013 15:34:06 -0400
Message-ID: <1364326446-8584-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user reported a problem where he was getting early ENOSPC with hundreds of
gigs of free data space and 6 gigs of free metadata space.  This is because the
global block reserve was taking up the entire free metadata space.  This is
ridiculous, we have infrastructure in place to throttle if we start using too
much of the global reserve, so instead of letting it get this huge just limit it
to 512mb so that users can still get work done.  This allowed the user to
complete his rsync without issues.  Thanks

Cc: stable@vger.kernel.org
Reported-and-tested-by: Stefan Priebe <s.priebe@profihost.ag>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c08c7c8..5791da2 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4554,7 +4554,7 @@ static void update_global_block_rsv(struct btrfs_fs_info *fs_info)
 	spin_lock(&sinfo->lock);
 	spin_lock(&block_rsv->lock);
 
-	block_rsv->size = num_bytes;
+	block_rsv->size = min_t(u64, num_bytes, 512 * 1024 * 1024);
 
 	num_bytes = sinfo->bytes_used + sinfo->bytes_pinned +
 		    sinfo->bytes_reserved + sinfo->bytes_readonly +
-- 
1.7.7.6

