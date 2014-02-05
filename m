Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:2231 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753741AbaBEVT1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Feb 2014 16:19:27 -0500
Received: from pps.filterd (m0004060 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s15LG3GY009463
	for <linux-btrfs@vger.kernel.org>; Wed, 5 Feb 2014 13:19:26 -0800
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1hukyfsyss-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 05 Feb 2014 13:19:26 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix assert screwup for the pending move stuff
Date: Wed, 5 Feb 2014 16:19:21 -0500
Message-ID: <1391635161-3983-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wang noticed that he was failing btrfs/030 even though me and Filipe couldn't
reproduce.  Turns out this is because Wang didn't have CONFIG_BTRFS_ASSERT set,
which meant that a key part of Filipe's original patch was not being built in.
This appears to be a mess up with merging Filipe's patch as it does not exist in
his original patch.  Fix this by changing how we make sure del_waiting_dir_move
asserts that it did not error and take the function out of the ifdef check.
This makes btrfs/030 pass with the assert on or off.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/send.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index f71fcbc..afb145d 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2734,8 +2734,6 @@ static int add_waiting_dir_move(struct send_ctx *sctx, u64 ino)
 	return 0;
 }
 
-#ifdef CONFIG_BTRFS_ASSERT
-
 static int del_waiting_dir_move(struct send_ctx *sctx, u64 ino)
 {
 	struct rb_node *n = sctx->waiting_dir_moves.rb_node;
@@ -2756,8 +2754,6 @@ static int del_waiting_dir_move(struct send_ctx *sctx, u64 ino)
 	return -ENOENT;
 }
 
-#endif
-
 static int add_pending_dir_move(struct send_ctx *sctx, u64 parent_ino)
 {
 	struct rb_node **p = &sctx->pending_dir_moves.rb_node;
@@ -2862,7 +2858,9 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
 	}
 
 	sctx->send_progress = sctx->cur_ino + 1;
-	ASSERT(del_waiting_dir_move(sctx, pm->ino) == 0);
+	ret = del_waiting_dir_move(sctx, pm->ino);
+	ASSERT(ret == 0);
+
 	ret = get_cur_path(sctx, pm->ino, pm->gen, to_path);
 	if (ret < 0)
 		goto out;
-- 
1.8.3.1

