Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:33481 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab3KEQMy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Nov 2013 11:12:54 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 06FD79A06D5
	for <linux-btrfs@vger.kernel.org>; Tue,  5 Nov 2013 09:12:54 -0700 (MST)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx2.fusionio.com with ESMTP id 1RALEZBwyAWDxKnq (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 05 Nov 2013 09:12:53 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: don't BUG_ON() if we get an error walking backrefs
Date: Tue, 5 Nov 2013 11:12:48 -0500
Message-ID: <1383667968-6420-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can just return false for this so we stop doing the snapshot aware defrag
stuff.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f167ced..aa67387 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2129,7 +2129,8 @@ static noinline bool record_extent_backrefs(struct btrfs_path *path,
 						  old->extent_offset, fs_info,
 						  path, record_one_backref,
 						  old);
-		BUG_ON(ret < 0 && ret != -ENOENT);
+		if (ret < 0 && ret != -ENOENT)
+			return false;
 
 		/* no backref to be processed for this extent */
 		if (!old->count) {
-- 
1.8.3.1

