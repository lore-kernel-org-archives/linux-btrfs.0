Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:39372 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755298Ab2LRULF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Dec 2012 15:11:05 -0500
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id Yqdi69UiECf3OkeP (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 18 Dec 2012 13:11:04 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: set flushing if we're limited flushing
Date: Tue, 18 Dec 2012 15:17:23 -0500
Message-ID: <1355861843-6710-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We still need to say we're flushing if we're limit flushing to keep somebody
from coming in and stealing our reservation.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ad8786b..721efb8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4004,7 +4004,7 @@ again:
 	 * We make the other tasks wait for the flush only when we can flush
 	 * all things.
 	 */
-	if (ret && flush == BTRFS_RESERVE_FLUSH_ALL) {
+	if (ret && flush != BTRFS_RESERVE_NO_FLUSH) {
 		flushing = true;
 		space_info->flush = 1;
 	}
-- 
1.7.7.6

