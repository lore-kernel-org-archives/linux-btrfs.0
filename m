Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:36557 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3ISPsN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Sep 2013 11:48:13 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 0B3F17C06AC
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Sep 2013 09:48:13 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
CC: <walken@google.com>, <linux-kernel@vger.kernel.org>, <mingo@elte.hu>,
        <peter@hurleysoftware.com>, <akpm@linux-foundation.org>
Subject: [PATCH 2/2] Btrfs: stop caching thread if extetn_commit_sem is contended
Date: Thu, 19 Sep 2013 11:48:08 -0400
Message-ID: <1379605688-987-2-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1379605688-987-1-git-send-email-jbacik@fusionio.com>
References: <1379605688-987-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can starve out the transaction commit with a bunch of caching threads all
running at the same time.  This is because we will only drop the
extent_commit_sem if we need_resched(), which isn't likely to happen since we
will be reading a lot from the disk so have already schedule()'ed plenty.  Alex
observed that he could starve out a transaction commit for up to a minute with
32 caching threads all running at once.  This will allow us to drop the
extent_commit_sem to allow the transaction commit to swap the commit_root out
and then all the cachers will start back up.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index cfb3cf7..cc074c34 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -442,7 +442,8 @@ next:
 			if (ret)
 				break;
 
-			if (need_resched()) {
+			if (need_resched() ||
+			    rwsem_is_contended(&fs_info->extent_commit_sem)) {
 				caching_ctl->progress = last;
 				btrfs_release_path(path);
 				up_read(&fs_info->extent_commit_sem);
-- 
1.8.3.1

